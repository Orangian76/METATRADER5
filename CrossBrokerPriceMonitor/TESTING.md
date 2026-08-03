# Testing Guide

This document defines the validation steps required before publishing a release of Cross-Broker Price Monitor.

## 1. Coordinator build test

From `CrossBrokerPriceMonitor/Coordinator` run:

```bat
build.bat
```

Expected result:

- `CrossBrokerPriceMonitor.exe` is created.
- No C# compiler errors are reported.
- The application opens without an unhandled exception.

## 2. Demo-mode test

1. Start the coordinator.
2. Enable Demo mode.
3. Confirm that Agent A and Agent B simulated quotes update.
4. Confirm that the executable-edge fields change over time.
5. Confirm that warning and alert colors respond to threshold changes.
6. Confirm that CSV files are created under `Coordinator/logs`.

Pass criteria:

- UI remains responsive for at least 10 minutes.
- No unhandled exception appears.
- Both `raw_quotes` and `comparisons` logs contain valid rows.

## 3. MQL5 compile test

Open `MQL5/CrossBrokerTickAgent.mq5` in MetaEditor and compile it.

Pass criteria:

- 0 errors.
- No trade-related warning is introduced.
- The generated `.ex5` file is not committed to Git.

## 4. Single-agent connection test

1. Run the coordinator with server port `19090`.
2. Attach Agent A to the watched symbol.
3. Confirm that the coordinator shows Agent A as connected.
4. Confirm that Bid, Ask, symbol and timestamp update.
5. Stop Agent A and confirm that the coordinator eventually marks it stale or disconnected.

## 5. Dual-agent live test

1. Start two MT5 terminals on the same Windows machine or VPS.
2. Configure one agent as `A` and the other as `B`.
3. Use the correct symbol in each terminal.
4. Confirm that both feeds are connected simultaneously.
5. Confirm the following calculations:

```text
Buy A / Sell B = Bid(B) - Ask(A)
Buy B / Sell A = Bid(A) - Ask(B)
Mid gap = Mid(B) - Mid(A)
```

6. Confirm that stale detection works independently for each agent.
7. Confirm that both MT5-side and coordinator-side CSV files are written.

## 6. Reconnect test

1. Disconnect one MT5 terminal from the network or remove the EA.
2. Wait until stale/disconnected status appears.
3. Restore the terminal or reattach the EA.
4. Confirm automatic reconnection without restarting the coordinator.

## 7. Symbol-mapping test

Test brokers that expose different names, for example:

```text
Broker A: BTCUSD
Broker B: BTCUSDm
```

Confirm that the coordinator still compares the two feeds and displays both original symbol names.

## 8. CSV validation

Open all generated CSV files and verify:

- Header exists exactly once.
- Decimal values use a dot.
- Timestamps are parseable.
- Agent IDs are correct.
- No private account credentials are written.

## 9. Security validation

- Coordinator listener remains bound to `127.0.0.1` by default.
- No password, account number, token or broker credential exists in committed files.
- No trade request is sent by the MQL5 agent.
- No executable build artifact is committed.

## Release approval checklist

- [ ] Coordinator builds successfully on Windows.
- [ ] Demo mode passes.
- [ ] MQL5 agent compiles with 0 errors.
- [ ] Agent A live connection passes.
- [ ] Agent B live connection passes.
- [ ] Dual-agent comparison passes.
- [ ] Reconnect test passes.
- [ ] CSV validation passes.
- [ ] Security validation passes.
- [ ] Real screenshots are captured.
- [ ] Release notes are reviewed.
