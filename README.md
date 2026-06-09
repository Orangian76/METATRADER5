# CandleFollower Advanced EA

An advanced MetaTrader 5 Expert Advisor written in MQL5.

## Overview

`CandleFollower_Advanced.mq5` is a candle-based trading Expert Advisor with configurable filters and risk-management options.

Main capabilities include:

- Candle body/range signal detection
- Configurable timeframe
- Fixed lot or equity-risk based lot calculation
- Multiple stop-loss modes
- Optional take-profit or candle-close exit logic
- Trading session filters
- RSI, ATR, ADX and volume-related filters
- Breakeven management
- Magic number support for separating trades

## File

```text
CandleFollower_Advanced.mq5
```

## How to use

1. Open MetaTrader 5.
2. Go to `File > Open Data Folder`.
3. Copy `CandleFollower_Advanced.mq5` into:

```text
MQL5/Experts/
```

4. Open MetaEditor.
5. Compile the file.
6. Attach the EA to a chart and configure the inputs.

## Important note

This EA is provided for research, backtesting and educational purposes.  
Always test thoroughly in Strategy Tester and on a demo account before using it on a live account.

## Risk warning

Algorithmic trading involves significant financial risk.  
Past backtest performance does not guarantee future results.
