# Release Manifest — CrossBrokerPriceMonitor v1.0.0

This manifest defines the source files, documentation, optional binaries, and manual verification required for the first public release.

## Source files

- `MQL5/CrossBrokerTickAgent.mq5`
- `Coordinator/Coordinator.cs`
- `Coordinator/build.bat`
- `Coordinator/run.bat`
- `Coordinator/config.ini.example`
- `MQL5/Agent_A_Example.txt`
- `MQL5/Agent_B_Example.txt`

## Core documentation

- `README.md`
- `README_FA.md`
- `TESTING.md`
- `RELEASE_NOTES_v1.0.0.md`
- `MANUAL_FINISH_GUIDE_FA.md`
- `docs/protocol.md`
- `docs/csv-format.md`
- `docs/FAQ.md`
- `docs/architecture.svg`

## Project governance

- `LICENSE`
- `CHANGELOG.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `CODE_OF_CONDUCT.md`
- `.gitignore`

## Sample data

- `samples/raw_quotes_sample.csv`
- `samples/comparisons_sample.csv`

## Optional release assets

These files should be attached to the GitHub Release only after local Windows verification:

- `CrossBrokerPriceMonitor.exe`
- `CrossBrokerTickAgent.mq5`
- `config.ini.example`

Do not include credentials, account numbers, private broker logs, or machine-specific configuration.

## Required manual verification

- [ ] Coordinator builds successfully on Windows
- [ ] Demo mode starts and displays two simulated feeds
- [ ] Agent A connects from MT5 terminal A
- [ ] Agent B connects from MT5 terminal B
- [ ] Both Quote streams update independently
- [ ] Stale detection works
- [ ] Automatic reconnect works
- [ ] Agent CSV files are produced
- [ ] Coordinator raw quote CSV is produced
- [ ] Coordinator comparison CSV is produced
- [ ] No order placement, modification, or closing occurs
- [ ] Screenshots contain no private account data

## Expected screenshots

- `docs/screenshots/coordinator-demo-mode.png`
- `docs/screenshots/coordinator-two-agents-connected.png`
- `docs/screenshots/mt5-agent-a.png`
- `docs/screenshots/mt5-agent-b.png`
- `docs/screenshots/crossbroker-demo.gif`

## Release procedure

1. Complete all checks in `TESTING.md`.
2. Add verified screenshots and GIF.
3. Confirm the GitHub Actions workflow is green.
4. Create tag `v1.0.0` from the verified commit.
5. Create the GitHub Release using `RELEASE_NOTES_v1.0.0.md`.
6. Attach only verified optional release assets.
7. Close the Windows completion issue after publication.
