# Cross-Broker Price Monitor

[![Project Check](https://github.com/Orangian76/METATRADER5/actions/workflows/crossbroker-docs-check.yml/badge.svg)](https://github.com/Orangian76/METATRADER5/actions/workflows/crossbroker-docs-check.yml)
![Platform](https://img.shields.io/badge/platform-Windows-0078D6)
![MetaTrader](https://img.shields.io/badge/MetaTrader-5-1C75BC)
![Language](https://img.shields.io/badge/languages-MQL5%20%7C%20C%23-512BD4)
![License](https://img.shields.io/badge/license-MIT-green)
![Version](https://img.shields.io/badge/version-1.0.0-blue)

[راهنمای فارسی](README_FA.md)

A local, quote-only monitoring system for comparing live Bid/Ask prices from two MetaTrader 5 terminals. It consists of an MQL5 tick agent installed in each terminal and a Windows C# coordinator that receives quotes over TCP, displays both feeds, calculates executable cross-broker edges, detects stale data, and writes CSV logs.

> This project never opens, modifies, or closes trades. It is a monitoring and research tool, not an arbitrage execution bot.

## Architecture

```text
MT5 Broker A ── CrossBrokerTickAgent.mq5 ──┐
                                            ├── TCP 127.0.0.1:19090 ── C# Coordinator ── UI + CSV
MT5 Broker B ── CrossBrokerTickAgent.mq5 ──┘
```

See the full diagram in [`docs/architecture.svg`](docs/architecture.svg).

## Metrics

- **Buy A / Sell B:** `Bid(B) - Ask(A)`
- **Buy B / Sell A:** `Bid(A) - Ask(B)`
- **Mid gap:** `Mid(B) - Mid(A)`

The first two values are raw executable quote differences before commission, slippage, latency, financing, and fill risk. A positive value is not a guaranteed profit.

## Features

- Streams Bid/Ask ticks from two MT5 terminals
- Local TCP protocol with HELLO, TICK, and HEARTBEAT messages
- Automatic reconnect after disconnects
- Per-agent and coordinator-side CSV logging
- Quote freshness/stale detection
- Warning and alert thresholds
- Demo mode for testing without MT5
- Loopback-only listener for a reduced attack surface
- Supports different broker symbol names such as `BTCUSD` and `BTCUSDm`
- Windows CI build and required-file validation through GitHub Actions

## Project structure

```text
CrossBrokerPriceMonitor/
├── README.md
├── README_FA.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CODE_OF_CONDUCT.md
├── Coordinator/
│   ├── Coordinator.cs
│   ├── build.bat
│   ├── run.bat
│   └── config.ini.example
├── MQL5/
│   ├── CrossBrokerTickAgent.mq5
│   ├── Agent_A_Example.txt
│   └── Agent_B_Example.txt
├── docs/
│   ├── architecture.svg
│   ├── protocol.md
│   ├── csv-format.md
│   └── FAQ.md
└── samples/
    ├── raw_quotes_sample.csv
    └── comparisons_sample.csv
```

## Requirements

- Windows or Windows Server
- Two MetaTrader 5 terminals on the same machine/VPS
- .NET Framework 4.8 or Visual Studio Build Tools
- MetaEditor for compiling the MQL5 agent

## Build the coordinator

Open `Coordinator` and run:

```bat
build.bat
```

Then run:

```bat
run.bat
```

The default server listens only on `127.0.0.1:19090`.

## Configure MT5 Agent A

1. Copy `MQL5/CrossBrokerTickAgent.mq5` to `MQL5/Experts` in terminal A.
2. Compile it in MetaEditor.
3. In MT5, add `127.0.0.1` to the allowed addresses under Expert Advisors.
4. Attach the EA to the watched symbol's chart.
5. Use values similar to:

```text
InpAgentId=A
InpBrokerLabel=Broker A
InpCoordinatorHost=127.0.0.1
InpCoordinatorPort=19090
```

Repeat for terminal B using `InpAgentId=B`.

## Logs

MT5 creates files similar to:

```text
MQL5/Files/CrossBrokerTicks_A_BTCUSD_YYYYMMDD.csv
```

The coordinator creates:

```text
Coordinator/logs/raw_quotes_YYYYMMDD.csv
Coordinator/logs/comparisons_YYYYMMDD.csv
```

Example datasets are included in:

- [`samples/raw_quotes_sample.csv`](samples/raw_quotes_sample.csv)
- [`samples/comparisons_sample.csv`](samples/comparisons_sample.csv)

See [`docs/csv-format.md`](docs/csv-format.md) for the complete schema.

## Suggested initial thresholds

```text
WarningUsd=10
AlertUsd=25
StaleMilliseconds=1500
ColorMetric=ExecutableEdge
```

Thresholds should be calibrated from collected data rather than treated as trading signals.

## Documentation

- [TCP protocol](docs/protocol.md)
- [CSV formats](docs/csv-format.md)
- [FAQ and troubleshooting](docs/FAQ.md)
- [Security policy](SECURITY.md)
- [Contributing guide](CONTRIBUTING.md)

## Security and limitations

- The coordinator binds only to loopback; all components must run on the same machine.
- The protocol is intentionally lightweight and has no encryption or authentication because it is local-only.
- Tick timing, broker feeds, symbol specifications, spreads, and execution quality may differ materially.
- Attach each agent to the watched symbol for complete `OnTick` capture.
- Real arbitrage execution requires independent order routing, synchronized risk controls, cost modeling, and fill verification; those functions are outside this project.

## License

MIT. See [LICENSE](LICENSE).
