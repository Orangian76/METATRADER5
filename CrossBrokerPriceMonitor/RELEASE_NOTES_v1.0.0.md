# Cross-Broker Price Monitor v1.0.0

Initial public release of a local, quote-only monitoring system for comparing live Bid/Ask feeds from two MetaTrader 5 terminals.

## Highlights

- MQL5 quote agent for each MT5 terminal
- Windows C# coordinator
- Local TCP transport over `127.0.0.1`
- Live display of both broker feeds
- Executable-edge calculations in both directions
- Mid-price comparison
- Stale-quote detection
- Warning and alert thresholds
- Automatic reconnect support
- Demo mode without MT5
- MT5-side and coordinator-side CSV logging
- English and Persian documentation
- Windows build script
- GitHub Actions structure and documentation checks

## Executable-edge calculations

```text
Buy A / Sell B = Bid(B) - Ask(A)
Buy B / Sell A = Bid(A) - Ask(B)
```

These values are raw quote differences. They do not include commission, slippage, latency, financing, rejected orders or fill risk.

## Safety scope

Version 1.0.0 is intentionally monitoring-only:

- It does not open trades.
- It does not modify trades.
- It does not close trades.
- It does not contain automated arbitrage execution.

## Included documentation

- English README
- Persian README
- TCP protocol reference
- CSV format reference
- FAQ and troubleshooting guide
- Windows and MT5 testing guide
- Security policy
- Contribution guide
- Architecture diagram

## Requirements

- Windows or Windows Server
- Two MetaTrader 5 terminals for live dual-broker monitoring
- MetaEditor for compiling the MQL5 agent
- .NET Framework 4.8 compatible C# compiler

## Known limitations

- All components are designed to run on the same Windows machine or VPS.
- The TCP protocol has no encryption or authentication because the listener is loopback-only.
- Market-feed timestamps and symbol specifications may differ between brokers.
- A positive quote edge is not evidence that an executable arbitrage profit exists.
- Real screenshots and live dual-terminal verification must be completed before the final GitHub Release is published.

## Upgrade notes

This is the first release; no migration is required.
