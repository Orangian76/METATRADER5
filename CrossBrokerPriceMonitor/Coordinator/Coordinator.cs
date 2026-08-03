using System;
using System.Collections.Concurrent;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CrossBrokerPriceMonitor
{
    internal static class Program
    {
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MonitorForm());
        }
    }

    internal sealed class AppConfig
    {
        public int Port = 19090;
        public string AgentA = "A";
        public string AgentB = "B";
        public double WarningUsd = 10.0;
        public double AlertUsd = 25.0;
        public int StaleMilliseconds = 1500;
        public string LogDirectory = "logs";
        public bool AutoStart = true;

        public static AppConfig Load(string path)
        {
            AppConfig c = new AppConfig();
            if (!File.Exists(path)) return c;
            foreach (string raw in File.ReadAllLines(path, Encoding.UTF8))
            {
                string line = raw.Trim();
                if (line.Length == 0 || line.StartsWith("#") || line.StartsWith(";")) continue;
                int p = line.IndexOf('=');
                if (p < 1) continue;
                string key = line.Substring(0, p).Trim();
                string value = line.Substring(p + 1).Trim();
                int i; double d; bool b;
                if (key.Equals("Port", StringComparison.OrdinalIgnoreCase) && int.TryParse(value, out i)) c.Port = i;
                else if (key.Equals("AgentA", StringComparison.OrdinalIgnoreCase)) c.AgentA = value;
                else if (key.Equals("AgentB", StringComparison.OrdinalIgnoreCase)) c.AgentB = value;
                else if (key.Equals("WarningUsd", StringComparison.OrdinalIgnoreCase) && double.TryParse(value, NumberStyles.Float, CultureInfo.InvariantCulture, out d)) c.WarningUsd = d;
                else if (key.Equals("AlertUsd", StringComparison.OrdinalIgnoreCase) && double.TryParse(value, NumberStyles.Float, CultureInfo.InvariantCulture, out d)) c.AlertUsd = d;
                else if (key.Equals("StaleMilliseconds", StringComparison.OrdinalIgnoreCase) && int.TryParse(value, out i)) c.StaleMilliseconds = i;
                else if (key.Equals("LogDirectory", StringComparison.OrdinalIgnoreCase)) c.LogDirectory = value;
                else if (key.Equals("AutoStart", StringComparison.OrdinalIgnoreCase) && bool.TryParse(value, out b)) c.AutoStart = b;
            }
            return c;
        }
    }

    internal sealed class QuoteState
    {
        public string AgentId = "";
        public string Broker = "";
        public string Symbol = "";
        public long SourceTimeMsc;
        public double Bid;
        public double Ask;
        public DateTime ReceivedUtc;
        public bool Connected;
        public string Remote = "";
        public double Mid { get { return (Bid + Ask) * 0.5; } }
        public double Spread { get { return Ask - Bid; } }
        public QuoteState Clone() { return (QuoteState)MemberwiseClone(); }
    }

    internal sealed class QuoteServer : IDisposable
    {
        private readonly ConcurrentDictionary<string, QuoteState> _quotes = new ConcurrentDictionary<string, QuoteState>(StringComparer.OrdinalIgnoreCase);
        private readonly object _logLock = new object();
        private TcpListener _listener;
        private CancellationTokenSource _cts;
        private string _rawLogPath;

        public event Action<string> StatusMessage;
        public event Action QuotesChanged;
        public bool IsRunning { get { return _listener != null; } }

        public void Start(int port, string logDirectory)
        {
            if (IsRunning) return;
            Directory.CreateDirectory(logDirectory);
            _rawLogPath = Path.Combine(logDirectory, "raw_quotes_" + DateTime.UtcNow.ToString("yyyyMMdd") + ".csv");
            EnsureHeader(_rawLogPath, "received_utc,agent_id,broker,symbol,source_time_msc,bid,ask,spread,remote\r\n");
            _cts = new CancellationTokenSource();
            _listener = new TcpListener(IPAddress.Loopback, port);
            _listener.Server.NoDelay = true;
            _listener.Start(20);
            RaiseStatus("Listening on 127.0.0.1:" + port);
            Task.Run(() => AcceptLoop(_cts.Token));
        }

        public void Stop()
        {
            try { if (_cts != null) _cts.Cancel(); } catch { }
            try { if (_listener != null) _listener.Stop(); } catch { }
            _cts = null;
            _listener = null;
            foreach (QuoteState q in _quotes.Values) q.Connected = false;
            RaiseStatus("Server stopped");
            RaiseChanged();
        }

        public QuoteState GetQuote(string id)
        {
            QuoteState q;
            return _quotes.TryGetValue(id, out q) ? q.Clone() : null;
        }

        public void InjectDemoQuote(string id, string broker, string symbol, double bid, double ask)
        {
            QuoteState q = _quotes.GetOrAdd(id, _ => new QuoteState());
            q.AgentId = id; q.Broker = broker; q.Symbol = symbol;
            q.Bid = bid; q.Ask = ask; q.SourceTimeMsc = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            q.ReceivedUtc = DateTime.UtcNow; q.Connected = true; q.Remote = "DEMO";
            AppendRaw(q); RaiseChanged();
        }

        private async Task AcceptLoop(CancellationToken token)
        {
            while (!token.IsCancellationRequested)
            {
                try
                {
                    TcpClient client = await _listener.AcceptTcpClientAsync().ConfigureAwait(false);
                    client.NoDelay = true;
                    Task.Run(() => HandleClient(client, token));
                }
                catch (ObjectDisposedException) { break; }
                catch (Exception ex) { if (!token.IsCancellationRequested) RaiseStatus("Accept error: " + ex.Message); }
            }
        }

        private async Task HandleClient(TcpClient client, CancellationToken token)
        {
            string connectedId = "";
            string remote = client.Client.RemoteEndPoint == null ? "unknown" : client.Client.RemoteEndPoint.ToString();
            RaiseStatus("Client connected: " + remote);
            try
            {
                using (client)
                using (NetworkStream stream = client.GetStream())
                using (StreamReader reader = new StreamReader(stream, new UTF8Encoding(false), false, 8192))
                {
                    while (!token.IsCancellationRequested)
                    {
                        string line = await reader.ReadLineAsync().ConfigureAwait(false);
                        if (line == null) break;
                        if (line.Length > 4096) continue;
                        string id = ProcessLine(line, remote);
                        if (id.Length > 0) connectedId = id;
                    }
                }
            }
            catch { }
            finally
            {
                QuoteState q;
                if (connectedId.Length > 0 && _quotes.TryGetValue(connectedId, out q)) q.Connected = false;
                RaiseStatus("Client disconnected: " + remote);
                RaiseChanged();
            }
        }

        private string ProcessLine(string line, string remote)
        {
            string[] p = line.Split('|');
            if (p.Length == 0) return "";
            if (p[0].Equals("HELLO", StringComparison.OrdinalIgnoreCase) && p.Length >= 8)
            {
                string id = p[1].Trim(); if (id.Length == 0) return "";
                QuoteState q = _quotes.GetOrAdd(id, _ => new QuoteState());
                q.AgentId = id; q.Broker = p[2]; q.Symbol = p[3]; q.Remote = remote;
                q.ReceivedUtc = DateTime.UtcNow; q.Connected = true;
                RaiseStatus("HELLO " + id + " / " + q.Broker + " / " + q.Symbol);
                RaiseChanged(); return id;
            }
            if (p[0].Equals("TICK", StringComparison.OrdinalIgnoreCase) && p.Length >= 9)
            {
                long source; double bid, ask; string id = p[1].Trim();
                if (id.Length == 0 || !long.TryParse(p[4], out source) ||
                    !double.TryParse(p[5], NumberStyles.Float, CultureInfo.InvariantCulture, out bid) ||
                    !double.TryParse(p[6], NumberStyles.Float, CultureInfo.InvariantCulture, out ask) || bid <= 0 || ask < bid) return "";
                QuoteState q = _quotes.GetOrAdd(id, _ => new QuoteState());
                q.AgentId = id; q.Broker = p[2]; q.Symbol = p[3]; q.SourceTimeMsc = source;
                q.Bid = bid; q.Ask = ask; q.ReceivedUtc = DateTime.UtcNow; q.Remote = remote; q.Connected = true;
                AppendRaw(q); RaiseChanged(); return id;
            }
            if (p[0].Equals("HEARTBEAT", StringComparison.OrdinalIgnoreCase) && p.Length >= 2)
            {
                QuoteState q; string id = p[1].Trim();
                if (_quotes.TryGetValue(id, out q)) { q.ReceivedUtc = DateTime.UtcNow; q.Connected = true; }
                RaiseChanged(); return id;
            }
            return "";
        }

        private void AppendRaw(QuoteState q)
        {
            string line = string.Join(",", new[] {
                Csv(q.ReceivedUtc.ToString("O", CultureInfo.InvariantCulture)), Csv(q.AgentId), Csv(q.Broker), Csv(q.Symbol),
                q.SourceTimeMsc.ToString(CultureInfo.InvariantCulture), q.Bid.ToString("0.##########", CultureInfo.InvariantCulture),
                q.Ask.ToString("0.##########", CultureInfo.InvariantCulture), q.Spread.ToString("0.##########", CultureInfo.InvariantCulture), Csv(q.Remote)
            }) + "\r\n";
            lock (_logLock) File.AppendAllText(_rawLogPath, line, new UTF8Encoding(false));
        }

        private static string Csv(string s)
        {
            if (s == null) return "";
            return s.IndexOfAny(new[] { ',', '"', '\r', '\n' }) >= 0 ? "\"" + s.Replace("\"", "\"\"") + "\"" : s;
        }

        private static void EnsureHeader(string path, string header)
        {
            if (!File.Exists(path) || new FileInfo(path).Length == 0) File.AppendAllText(path, header, new UTF8Encoding(false));
        }

        private void RaiseStatus(string s) { var h = StatusMessage; if (h != null) h(DateTime.Now.ToString("HH:mm:ss.fff") + "  " + s); }
        private void RaiseChanged() { var h = QuotesChanged; if (h != null) h(); }
        public void Dispose() { Stop(); }
    }

    internal sealed class MonitorForm : Form
    {
        private readonly AppConfig _config;
        private readonly QuoteServer _server = new QuoteServer();
        private readonly Timer _timer = new Timer();
        private readonly Timer _demoTimer = new Timer();
        private readonly Random _random = new Random();
        private Label _a, _b, _edgeAB, _edgeBA, _midGap, _status;
        private ListBox _events;
        private CheckBox _demo;
        private NumericUpDown _warning, _alert, _stale, _port;
        private double _demoBase = 65000;

        public MonitorForm()
        {
            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            _config = AppConfig.Load(Path.Combine(baseDir, "config.ini"));
            Text = "Cross Broker Price Monitor";
            Size = new Size(1000, 700);
            StartPosition = FormStartPosition.CenterScreen;
            Font = new Font("Segoe UI", 9F);
            BuildUi();
            _server.StatusMessage += s => BeginInvoke((Action)(() => { _events.Items.Insert(0, s); if (_events.Items.Count > 200) _events.Items.RemoveAt(200); }));
            _server.QuotesChanged += () => { };
            _timer.Interval = 100; _timer.Tick += (s, e) => RefreshView(); _timer.Start();
            _demoTimer.Interval = 100; _demoTimer.Tick += (s, e) => DemoTick(); _demoTimer.Start();
            Shown += (s, e) => { if (_config.AutoStart) StartServer(); };
            FormClosing += (s, e) => _server.Dispose();
        }

        private void BuildUi()
        {
            TableLayoutPanel root = new TableLayoutPanel { Dock = DockStyle.Fill, Padding = new Padding(12), RowCount = 5, ColumnCount = 1 };
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 70));
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 110));
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 190));
            root.RowStyles.Add(new RowStyle(SizeType.Percent, 100));
            root.RowStyles.Add(new RowStyle(SizeType.Absolute, 28));

            FlowLayoutPanel bar = new FlowLayoutPanel { Dock = DockStyle.Fill };
            _port = Num(1024, 65535, _config.Port); _warning = Num(0, 100000, (decimal)_config.WarningUsd);
            _alert = Num(0, 100000, (decimal)_config.AlertUsd); _stale = Num(100, 60000, _config.StaleMilliseconds);
            Button start = new Button { Text = "Start server", AutoSize = true }; start.Click += (s, e) => StartServer();
            Button stop = new Button { Text = "Stop", AutoSize = true }; stop.Click += (s, e) => _server.Stop();
            _demo = new CheckBox { Text = "Demo mode", AutoSize = true, Padding = new Padding(8, 7, 0, 0) };
            Add(bar, "Port", _port); Add(bar, "Warning $", _warning); Add(bar, "Alert $", _alert); Add(bar, "Stale ms", _stale);
            bar.Controls.Add(start); bar.Controls.Add(stop); bar.Controls.Add(_demo); root.Controls.Add(bar, 0, 0);

            TableLayoutPanel feeds = new TableLayoutPanel { Dock = DockStyle.Fill, ColumnCount = 2 };
            feeds.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50)); feeds.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            _a = FeedLabel("Broker A / Agent " + _config.AgentA); _b = FeedLabel("Broker B / Agent " + _config.AgentB);
            feeds.Controls.Add(_a, 0, 0); feeds.Controls.Add(_b, 1, 0); root.Controls.Add(feeds, 0, 1);

            Panel panel = new Panel { Dock = DockStyle.Fill, BackColor = Color.LightGray, Padding = new Padding(15) };
            TableLayoutPanel metrics = new TableLayoutPanel { Dock = DockStyle.Fill, RowCount = 4, ColumnCount = 2 };
            metrics.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50)); metrics.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50));
            _status = Metric(metrics, 0, "Status"); _edgeAB = Metric(metrics, 1, "Buy A / Sell B");
            _edgeBA = Metric(metrics, 2, "Buy B / Sell A"); _midGap = Metric(metrics, 3, "Mid(B) - Mid(A)");
            panel.Controls.Add(metrics); root.Controls.Add(panel, 0, 2);

            _events = new ListBox { Dock = DockStyle.Fill, Font = new Font("Consolas", 9F) }; root.Controls.Add(_events, 0, 3);
            root.Controls.Add(new Label { Dock = DockStyle.Fill, Text = "Monitor only — this version never sends trading orders.", ForeColor = Color.DimGray }, 0, 4);
            Controls.Add(root);
        }

        private void StartServer()
        {
            if (_server.IsRunning) return;
            string dir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, _config.LogDirectory);
            _server.Start((int)_port.Value, dir);
        }

        private void DemoTick()
        {
            if (!_demo.Checked) return;
            _demoBase += (_random.NextDouble() - 0.5) * 4.0;
            double wave = Math.Sin(Environment.TickCount / 2500.0) * 18.0;
            _server.InjectDemoQuote(_config.AgentA, "Demo A", "BTCUSD", _demoBase - 5, _demoBase + 5);
            _server.InjectDemoQuote(_config.AgentB, "Demo B", "BTCUSDm", _demoBase + wave - 6, _demoBase + wave + 6);
        }

        private void RefreshView()
        {
            QuoteState a = _server.GetQuote(_config.AgentA), b = _server.GetQuote(_config.AgentB);
            _a.Text = Format(a); _b.Text = Format(b);
            if (a == null || b == null) { _status.Text = "Waiting for two brokers"; return; }
            double ageA = (DateTime.UtcNow - a.ReceivedUtc).TotalMilliseconds;
            double ageB = (DateTime.UtcNow - b.ReceivedUtc).TotalMilliseconds;
            bool stale = ageA > (double)_stale.Value || ageB > (double)_stale.Value || !a.Connected || !b.Connected;
            double ab = b.Bid - a.Ask, ba = a.Bid - b.Ask, mid = b.Mid - a.Mid;
            _edgeAB.Text = ab.ToString("+0.00;-0.00;0.00", CultureInfo.InvariantCulture) + " USD";
            _edgeBA.Text = ba.ToString("+0.00;-0.00;0.00", CultureInfo.InvariantCulture) + " USD";
            _midGap.Text = mid.ToString("+0.00;-0.00;0.00", CultureInfo.InvariantCulture) + " USD";
            double best = Math.Max(ab, ba);
            _status.Text = stale ? "STALE / DISCONNECTED" : best >= (double)_alert.Value ? "ALERT" : best >= (double)_warning.Value ? "WARNING" : "NORMAL";
            BackColor = stale ? Color.Gainsboro : best >= (double)_alert.Value ? Color.MistyRose : best >= (double)_warning.Value ? Color.LemonChiffon : Color.Honeydew;
        }

        private static string Format(QuoteState q)
        {
            if (q == null) return "Waiting...";
            double age = (DateTime.UtcNow - q.ReceivedUtc).TotalMilliseconds;
            return string.Format(CultureInfo.InvariantCulture, "{0}\n{1}\nBid: {2:0.########}\nAsk: {3:0.########}\nSpread: {4:0.########}\nAge: {5:0} ms\n{6}", q.Broker, q.Symbol, q.Bid, q.Ask, q.Spread, age, q.Connected ? "Connected" : "Disconnected");
        }

        private static NumericUpDown Num(decimal min, decimal max, decimal value)
        {
            return new NumericUpDown { Minimum = min, Maximum = max, Value = Math.Max(min, Math.Min(max, value)), DecimalPlaces = 0, Width = 90 };
        }

        private static void Add(Control bar, string name, Control c)
        {
            bar.Controls.Add(new Label { Text = name, AutoSize = true, Padding = new Padding(4, 8, 2, 0) }); bar.Controls.Add(c);
        }

        private static Label FeedLabel(string title)
        {
            return new Label { Dock = DockStyle.Fill, BorderStyle = BorderStyle.FixedSingle, Text = title + "\nWaiting...", TextAlign = ContentAlignment.MiddleCenter, Font = new Font("Consolas", 11F) };
        }

        private static Label Metric(TableLayoutPanel t, int row, string name)
        {
            t.RowStyles.Add(new RowStyle(SizeType.Percent, 25));
            t.Controls.Add(new Label { Text = name, Dock = DockStyle.Fill, TextAlign = ContentAlignment.MiddleLeft, Font = new Font("Segoe UI", 11F, FontStyle.Bold) }, 0, row);
            Label v = new Label { Text = "--", Dock = DockStyle.Fill, TextAlign = ContentAlignment.MiddleRight, Font = new Font("Consolas", 14F, FontStyle.Bold) };
            t.Controls.Add(v, 1, row); return v;
        }
    }
}
