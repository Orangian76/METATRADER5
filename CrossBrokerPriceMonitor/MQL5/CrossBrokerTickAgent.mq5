//+------------------------------------------------------------------+
//| CrossBrokerTickAgent.mq5                                         |
//| Quote-only agent for CrossBrokerPriceMonitor                     |
//| It never sends trading orders.                                   |
//+------------------------------------------------------------------+
#property strict
#property version   "1.00"
#property description "Streams Bid/Ask ticks to a local C# coordinator and saves a local CSV log."

input group "Agent identity"
input string InpAgentId             = "A";
input string InpBrokerLabel         = "Exness";
input string InpSymbolToWatch       = "";       // blank = current chart symbol

input group "Coordinator TCP"
input string InpCoordinatorHost     = "127.0.0.1";
input int    InpCoordinatorPort     = 19090;
input int    InpConnectTimeoutMs    = 500;
input int    InpSocketSendTimeoutMs = 100;
input int    InpReconnectSeconds    = 2;
input int    InpHeartbeatSeconds    = 2;

input group "Tick transmission"
input bool   InpSendEveryTick       = true;
input int    InpMinimumIntervalMs   = 0;
input bool   InpPrintConnectionLog  = true;

input group "Local CSV"
input bool   InpSaveLocalCsv        = true;
input string InpCsvFilePrefix       = "CrossBrokerTicks";
input int    InpCsvFlushEveryRows   = 100;

int      g_socket             = INVALID_HANDLE;
int      g_csv                = INVALID_HANDLE;
string   g_symbol             = "";
uint     g_lastConnectAttempt = 0;
uint     g_lastHeartbeat      = 0;
uint     g_lastSendTick       = 0;
ulong    g_rowsSinceFlush     = 0;
double   g_lastBid            = 0.0;
double   g_lastAsk            = 0.0;

string CleanField(string value)
{
   StringReplace(value, "|", "_");
   StringReplace(value, "\r", " ");
   StringReplace(value, "\n", " ");
   return value;
}

string AgentId()
{
   string value = CleanField(InpAgentId);
   if(StringLen(value) == 0)
      value = "A";
   return value;
}

string BrokerLabel()
{
   string value = CleanField(InpBrokerLabel);
   if(StringLen(value) == 0)
      value = AccountInfoString(ACCOUNT_SERVER);
   return value;
}

void CloseSocket()
{
   if(g_socket != INVALID_HANDLE)
   {
      SocketClose(g_socket);
      g_socket = INVALID_HANDLE;
   }
}

bool IsSocketReady()
{
   return g_socket != INVALID_HANDLE && SocketIsConnected(g_socket);
}

bool SendText(const string text)
{
   if(!IsSocketReady())
      return false;

   uchar data[];
   int bytes = StringToCharArray(text, data, 0, -1, CP_UTF8) - 1;
   if(bytes <= 0)
      return false;

   int sent = SocketSend(g_socket, data, (uint)bytes);
   if(sent != bytes)
   {
      if(InpPrintConnectionLog)
         PrintFormat("SocketSend failed/partial. sent=%d expected=%d error=%d", sent, bytes, GetLastError());
      CloseSocket();
      return false;
   }

   return true;
}

bool SendHello()
{
   int digits = (int)SymbolInfoInteger(g_symbol, SYMBOL_DIGITS);
   double point = SymbolInfoDouble(g_symbol, SYMBOL_POINT);
   double contract = SymbolInfoDouble(g_symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   string server = CleanField(AccountInfoString(ACCOUNT_SERVER));

   string line = StringFormat(
      "HELLO|%s|%s|%s|%d|%s|%s|%s\n",
      AgentId(), BrokerLabel(), CleanField(g_symbol), digits,
      DoubleToString(point, 10), DoubleToString(contract, 8), server
   );

   return SendText(line);
}

bool ConnectCoordinator()
{
   if(IsSocketReady())
      return true;

   uint now = GetTickCount();
   if(now - g_lastConnectAttempt < (uint)(MathMax(1, InpReconnectSeconds) * 1000))
      return false;

   g_lastConnectAttempt = now;
   CloseSocket();

   g_socket = SocketCreate();
   if(g_socket == INVALID_HANDLE)
   {
      if(InpPrintConnectionLog)
         PrintFormat("SocketCreate failed. error=%d", GetLastError());
      return false;
   }

   SocketTimeouts(g_socket,
      (uint)MathMax(10, InpSocketSendTimeoutMs),
      (uint)MathMax(10, InpConnectTimeoutMs));

   if(!SocketConnect(g_socket, InpCoordinatorHost, (uint)InpCoordinatorPort,
         (uint)MathMax(50, InpConnectTimeoutMs)))
   {
      if(InpPrintConnectionLog)
         PrintFormat("Cannot connect to %s:%d. error=%d", InpCoordinatorHost, InpCoordinatorPort, GetLastError());
      CloseSocket();
      return false;
   }

   if(!SendHello())
   {
      CloseSocket();
      return false;
   }

   if(InpPrintConnectionLog)
      PrintFormat("Connected to coordinator %s:%d as agent %s", InpCoordinatorHost, InpCoordinatorPort, AgentId());

   return true;
}

string CsvFileName()
{
   MqlDateTime dt;
   TimeToStruct(TimeLocal(), dt);
   return StringFormat("%s_%s_%s_%04d%02d%02d.csv",
      CleanField(InpCsvFilePrefix), AgentId(), CleanField(g_symbol),
      dt.year, dt.mon, dt.day);
}

bool OpenCsv()
{
   if(!InpSaveLocalCsv)
      return true;
   if(g_csv != INVALID_HANDLE)
      return true;

   string name = CsvFileName();
   g_csv = FileOpen(name,
      FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_SHARE_READ | FILE_SHARE_WRITE,
      ',');

   if(g_csv == INVALID_HANDLE)
   {
      PrintFormat("FileOpen failed for %s. error=%d", name, GetLastError());
      return false;
   }

   if(FileSize(g_csv) == 0)
   {
      FileWrite(g_csv, "local_time", "source_time_msc", "agent_id", "broker", "symbol",
         "bid", "ask", "spread", "spread_points", "connected");
      FileFlush(g_csv);
   }

   FileSeek(g_csv, 0, SEEK_END);
   return true;
}

void WriteCsv(const MqlTick &tick, const bool connected)
{
   if(!InpSaveLocalCsv || !OpenCsv())
      return;

   int digits = (int)SymbolInfoInteger(g_symbol, SYMBOL_DIGITS);
   double point = SymbolInfoDouble(g_symbol, SYMBOL_POINT);
   double spread = tick.ask - tick.bid;
   double spread_points = point > 0.0 ? spread / point : 0.0;

   FileWrite(g_csv,
      TimeToString(TimeLocal(), TIME_DATE | TIME_SECONDS),
      (long)tick.time_msc,
      AgentId(), BrokerLabel(), g_symbol,
      DoubleToString(tick.bid, digits),
      DoubleToString(tick.ask, digits),
      DoubleToString(spread, digits),
      DoubleToString(spread_points, 2),
      connected ? 1 : 0);

   g_rowsSinceFlush++;
   if(g_rowsSinceFlush >= (ulong)MathMax(1, InpCsvFlushEveryRows))
   {
      FileFlush(g_csv);
      g_rowsSinceFlush = 0;
   }
}

bool SendTick(const MqlTick &tick)
{
   int digits = (int)SymbolInfoInteger(g_symbol, SYMBOL_DIGITS);
   double spread = tick.ask - tick.bid;
   uint localTick = GetTickCount();

   string line = StringFormat(
      "TICK|%s|%s|%s|%I64d|%s|%s|%s|%u\n",
      AgentId(), BrokerLabel(), CleanField(g_symbol),
      (long)tick.time_msc,
      DoubleToString(tick.bid, digits),
      DoubleToString(tick.ask, digits),
      DoubleToString(spread, digits), localTick);

   return SendText(line);
}

void ProcessCurrentTick()
{
   MqlTick tick;
   if(!SymbolInfoTick(g_symbol, tick))
      return;
   if(tick.bid <= 0.0 || tick.ask <= 0.0 || tick.ask < tick.bid)
      return;

   bool changed = tick.bid != g_lastBid || tick.ask != g_lastAsk;
   if(!changed)
      return;

   uint now = GetTickCount();
   if(!InpSendEveryTick && InpMinimumIntervalMs > 0)
      if(now - g_lastSendTick < (uint)InpMinimumIntervalMs)
         return;

   bool connected = ConnectCoordinator();
   bool sent = connected && SendTick(tick);
   WriteCsv(tick, sent && IsSocketReady());

   g_lastBid = tick.bid;
   g_lastAsk = tick.ask;
   g_lastSendTick = now;
}

void SendHeartbeat()
{
   if(!ConnectCoordinator())
      return;

   uint now = GetTickCount();
   if(now - g_lastHeartbeat < (uint)(MathMax(1, InpHeartbeatSeconds) * 1000))
      return;

   g_lastHeartbeat = now;
   SendText(StringFormat("HEARTBEAT|%s|%u\n", AgentId(), now));
}

int OnInit()
{
   g_symbol = InpSymbolToWatch;
   if(StringLen(g_symbol) == 0)
      g_symbol = _Symbol;

   if(!SymbolSelect(g_symbol, true))
   {
      PrintFormat("Cannot select symbol %s", g_symbol);
      return INIT_FAILED;
   }

   if(g_symbol != _Symbol)
      PrintFormat("Warning: attach this EA to the %s chart for every-tick accuracy. Current chart is %s.", g_symbol, _Symbol);

   OpenCsv();
   EventSetTimer(1);
   ConnectCoordinator();
   ProcessCurrentTick();

   Print("CrossBrokerTickAgent is quote-only. It contains no order functions.");
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   if(g_csv != INVALID_HANDLE)
   {
      FileFlush(g_csv);
      FileClose(g_csv);
      g_csv = INVALID_HANDLE;
   }
   CloseSocket();
}

void OnTick()
{
   ProcessCurrentTick();
}

void OnTimer()
{
   SendHeartbeat();
   if(g_symbol != _Symbol)
      ProcessCurrentTick();
}
//+------------------------------------------------------------------+
