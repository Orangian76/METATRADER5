# FAQ and Troubleshooting

## Does this project place trades?

No. The current version only reads quotes, sends them to a local coordinator, displays comparisons, and writes CSV logs.

## Is this an arbitrage bot?

No. It is a monitoring and research system. Real arbitrage execution requires independent order routing, synchronized risk controls, transaction-cost modeling, and fill verification.

## Can the two brokers use different symbol names?

Yes. Agent A and Agent B may use different broker-specific symbols, for example `BTCUSD` and `BTCUSDm`. The coordinator compares the two feeds by agent identity, not by requiring identical symbol strings.

## Why does an agent remain disconnected?

Check the following:

1. The coordinator server is running.
2. The port matches in the coordinator and both agents.
3. `127.0.0.1` is allowed in MT5 Expert Advisor settings.
4. Algo Trading is enabled.
5. The EA is attached successfully to a chart.
6. Windows Firewall is not blocking the local process.
7. The Coordinator log shows no bind error.

## Why is the status STALE?

A quote becomes stale when its age exceeds `StaleMilliseconds`.

Common causes:

- The market is closed.
- The watched symbol is inactive.
- The EA is attached to the wrong chart.
- The broker sends sparse ticks.
- The terminal lost its market-data connection.
- The stale threshold is too strict for the instrument.

## Why do the displayed prices differ from the chart?

Possible reasons include:

- Different broker symbol suffixes.
- Different price precision.
- Different account type or price feed.
- UI refresh interval.
- Network and processing latency.
- Comparing Bid on one side with Ask on the other.

## Why is a positive edge not necessarily profitable?

The raw edge excludes:

- Trading commission
- Slippage
- Execution latency
- Rejected or partial fills
- Funding and swap
- Withdrawal and transfer constraints
- Different contract specifications

## What should I use for WarningUsd and AlertUsd?

Start with conservative placeholder values and collect data first. Analyze the distribution of executable edges, quote age, and persistence duration before choosing thresholds.

## Can I run the coordinator without MT5?

Yes. Enable Demo mode to test the interface, colors, stale detection, and CSV writing with synthetic quote streams.

## Where are the logs stored?

Agent logs are stored under each terminal's `MQL5/Files` directory. Coordinator logs are stored under `Coordinator/logs` relative to the executable unless the application configuration changes that path.

## Why does build.bat fail?

Check that one of the following is installed:

- .NET Framework 4.8 Developer Pack
- Visual Studio Build Tools
- Visual Studio with .NET desktop development tools

Also verify that `Coordinator.cs` exists beside `build.bat` and that the script can locate `csc.exe`.

## Why does run.bat report that the executable is missing?

Run `build.bat` first. If compilation failed, read the compiler output and confirm that Windows Forms and Drawing assemblies are available.

## Can the coordinator listen on a remote IP?

The documented and recommended configuration is loopback-only (`127.0.0.1`). Exposing the plaintext protocol to a network requires authentication, encryption, firewall rules, and additional security review.

## Can I use more than two agents?

The current UI and comparison logic are designed for two primary agents, `A` and `B`. The protocol can be extended, but multi-agent routing and pair selection require additional coordinator logic.

## What happens after a disconnect?

The agents attempt to reconnect automatically. The coordinator retains state, marks the feed stale or disconnected, and resumes updates after a valid `HELLO` and new ticks arrive.

## How do I report a bug?

Open a GitHub issue with:

- Windows version
- MT5 build number
- Broker symbol names
- Coordinator configuration
- Relevant Experts, Journal, and coordinator log excerpts
- Reproduction steps

Remove account numbers, server credentials, personal data, and broker secrets before posting logs.
