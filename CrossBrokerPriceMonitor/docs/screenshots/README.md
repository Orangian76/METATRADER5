# Screenshots and Demo Assets

Only screenshots captured from the real application should be added to this folder. Do not use fabricated UI images as evidence of functionality.

## Required files before v1.0.0 release

```text
coordinator-demo-mode.png
coordinator-two-agents-connected.png
mt5-agent-a.png
mt5-agent-b.png
crossbroker-demo.gif
```

## Capture checklist

### Coordinator demo mode

Show:

- application title
- server status
- simulated Agent A and Agent B quotes
- executable-edge values
- warning or alert coloring

### Coordinator with two live agents

Show:

- both agents connected
- broker labels
- original symbol names
- Bid and Ask values
- quote ages below the stale threshold

Redact or crop:

- account numbers
- user names
- server IPs other than loopback
- broker credentials
- personal folders and desktop content

### MT5 Agent A and Agent B

Capture each chart with:

- Expert Advisor name visible
- correct Agent ID
- broker label
- watched symbol
- successful connection message in Experts or Journal

Do not expose account numbers or balances unless intentionally public.

## GIF recommendation

Record a 10–15 second GIF showing:

1. Coordinator starts.
2. Agent A connects.
3. Agent B connects.
4. Quotes update.
5. Executable-edge values and colors change.

Recommended output width: 1000–1400 pixels.
Recommended frame rate: 8–12 FPS.
Keep the file reasonably small for fast GitHub rendering.

## README placement

After the real assets are uploaded, add the following section to the main README:

```markdown
## Screenshots

![Coordinator with two connected agents](docs/screenshots/coordinator-two-agents-connected.png)

![Demo](docs/screenshots/crossbroker-demo.gif)
```
