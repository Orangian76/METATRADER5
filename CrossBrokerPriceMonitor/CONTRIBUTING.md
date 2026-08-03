# Contributing

Contributions are welcome when they improve reliability, documentation, portability, observability, or testability without turning this monitoring project into an unsafe trading system.

## Before opening a change

1. Search existing issues and pull requests.
2. Keep changes focused and small.
3. Do not include broker credentials, account numbers, API keys, private logs, or proprietary strategy settings.
4. Preserve loopback-only networking as the secure default.
5. Do not add automatic trade execution without a separate design and security review.

## Development areas

- `MQL5/`: MetaTrader 5 quote agent
- `Coordinator/`: Windows C# coordinator
- `docs/`: protocol, architecture, troubleshooting, and examples

## Coding guidelines

### MQL5

- Compile with zero errors and preferably zero warnings.
- Check socket return codes and log actionable errors.
- Avoid blocking operations in `OnTick`.
- Keep all trading functions out of the monitoring agent.
- Use invariant numeric formatting for protocol messages.

### C#

- Keep the listener bound to `IPAddress.Loopback` by default.
- Use `InvariantCulture` for parsing and formatting protocol numbers.
- Dispose sockets, streams, writers, timers, and cancellation tokens correctly.
- Keep UI updates thread-safe.
- Validate malformed or incomplete input without crashing the coordinator.

## Testing checklist

Before submitting a pull request:

- Build the coordinator with `Coordinator/build.bat`.
- Compile `MQL5/CrossBrokerTickAgent.mq5` in MetaEditor.
- Run Demo mode and confirm both synthetic feeds update.
- Confirm raw and comparison CSV files are created.
- Test disconnect and automatic reconnect behavior.
- Confirm stale detection works.
- Verify that no order functions were introduced.

## Commit messages

Use clear imperative messages, for example:

```text
Fix reconnect delay after socket failure
Add CSV schema documentation
Improve stale quote detection
```

## Pull requests

A pull request should include:

- What changed
- Why it changed
- How it was tested
- Screenshots for UI changes
- Compatibility notes for MT5 or .NET changes

By contributing, you agree that your contribution will be licensed under the MIT License.
