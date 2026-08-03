# Local TCP Protocol

The MT5 agents connect to the coordinator over TCP on `127.0.0.1:19090` by default. Messages are UTF-8, pipe-delimited, and terminated by `\n`.

## HELLO

Sent after a successful connection.

```text
HELLO|AgentId|BrokerLabel|Symbol|Digits|Point|ContractSize|Server
```

Example:

```text
HELLO|A|Broker A|BTCUSD|2|0.01|1.0|Broker-A-Live
```

## TICK

Sent whenever Bid or Ask changes, subject to the agent throttling settings.

```text
TICK|AgentId|BrokerLabel|Symbol|SourceTimeMsc|Bid|Ask|Spread|LocalTickCount
```

Example:

```text
TICK|A|Broker A|BTCUSD|1785751234567|64210.10|64220.30|10.20|431225
```

Validation rules used by the coordinator:

- Agent ID must not be empty.
- Source timestamp must be an integer.
- Bid and Ask must be positive numbers.
- Ask must be greater than or equal to Bid.
- Lines longer than 4096 characters are ignored.

## HEARTBEAT

Sent periodically when no reconnect is required.

```text
HEARTBEAT|AgentId|LocalTickCount
```

Example:

```text
HEARTBEAT|A|431900
```

## Connection lifecycle

1. Agent opens a TCP connection.
2. Agent sends `HELLO`.
3. Agent sends `TICK` messages as quotes change.
4. Agent sends periodic `HEARTBEAT` messages.
5. If sending fails, the agent closes the socket and retries after the configured reconnect interval.
6. When a client disconnects, the coordinator marks that agent as disconnected.

## Security model

The protocol intentionally has no encryption or authentication because the coordinator binds only to the loopback interface. Do not expose the listener publicly without adding authentication, encryption, input hardening, and rate limiting.

## Compatibility

New fields should be appended to the end of a message rather than inserted in the middle. Parsers should reject malformed critical fields and ignore unknown future message types.
