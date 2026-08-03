# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog and this project follows Semantic Versioning.

## [Unreleased]

### Planned
- Add screenshots and sample CSV output
- Add automated Windows build validation
- Add protocol test utility
- Add packaged release archive

## [1.0.0] - 2026-08-03

### Added
- Initial public release of Cross-Broker Price Monitor
- MQL5 quote agents for two MetaTrader 5 terminals
- Windows C# coordinator with TCP listener
- HELLO, TICK, and HEARTBEAT protocol
- Quote freshness and stale detection
- Executable edge calculations in both directions
- Mid-price gap calculation
- Warning and alert thresholds
- Demo mode
- Raw quote and comparison CSV logging
- English and Persian documentation
- MIT license

### Security
- Coordinator listens on loopback only by default
- No trade execution functionality is included

[Unreleased]: https://github.com/Orangian76/METATRADER5/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Orangian76/METATRADER5/releases/tag/v1.0.0
