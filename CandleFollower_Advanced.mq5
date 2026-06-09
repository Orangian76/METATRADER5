//+------------------------------------------------------------------+
//|                                              CandleBodyRangeEA.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--- Enum for Stop Loss Mode
enum ENUM_SL_MODE
{
   SL_MODE_CANDLE = 0,        // Based on Previous Candle (Body/Range)
   SL_MODE_ENTRY_PERCENT = 1, // Percent of Entry Price
   SL_MODE_ENTRY_FIXED = 2    // Fixed Price Distance
};

//--- Enum for Stop Loss Type (used only in Candle mode)
enum ENUM_SL_TYPE
{
   SL_TYPE_BODY = 0,    // Based on Body Size
   SL_TYPE_RANGE = 1    // Based on Range Size
};

//--- Enum for Trading Session
enum ENUM_TRADING_SESSION
{
   SESSION_NEW_YORK_ONLY = 0,        // New York Only
   SESSION_LONDON_NEW_YORK = 1,      // London + New York
   SESSION_ASIA_LONDON_NY = 2,       // Asia + London + New York
   SESSION_ALL_TIMES = 3             // All Trading Times
};

//--- Input parameters
input ENUM_TIMEFRAMES InpTimeframe = PERIOD_M5;              // Timeframe (Default: 5 minutes)
input double InpMinBodyPercent = 0.5;                       // Minimum Body Size (% of opening price)
input double InpMinRangePercent = 1.0;                      // Minimum Range Size (% of opening price)
input double InpMaxBodyPercent = 5.0;                       // Maximum Body Size (% of opening price)
input double InpMaxRangePercent = 10.0;                     // Maximum Range Size (% of opening price)
input double InpBodyToRangePercent = 60.0;                  // Minimum Body to Range Ratio (%)
input double InpMinLotSize = 0.01;                          // Minimum Lot Size
input double InpEquityRiskPercent = 0.0;                    // Equity Risk % for Lot Calculation (0 = Fixed Lot)

//--- Stop Loss Settings
input ENUM_SL_MODE InpStopLossMode = SL_MODE_CANDLE;        // Stop Loss Mode
input ENUM_SL_TYPE InpStopLossType = SL_TYPE_RANGE;         // Candle Mode: Body or Range
input double InpStopLossPercent = 100.0;                    // Candle Mode: % of Body/Range (e.g. 60 = 60%)
input double InpStopLossEntryPercent = 0.1;                 // Entry % Mode: % of entry price
input double InpStopLossFixedAmount = 130.0;                // Fixed Mode: price distance

//--- Direction Settings
input bool InpUpsideDown = false;                           // Upside Down Mode (Reverse Trade Direction)

//--- Take Profit Settings
input double InpTakeProfitPercent = 0.0;                    // Take Profit % (0 = Close at End of Candle)

//--- Position Management Settings
input int InpMaxOpenPositions = 1;                          // Maximum Open Positions Simultaneously

//--- Expert Settings
input ulong InpMagicNumber = 123456;                        // Magic Number (Unique Identifier)

//--- Trading Session Filter
input ENUM_TRADING_SESSION InpTradingSession = SESSION_ALL_TIMES;  // Trading Session Filter

//--- RSI Filter Settings
input bool InpUseRSIFilter = false;                         // Use RSI Filter
input int InpRSIPeriod = 14;                                // RSI Period
input double InpRSIUpperLevel = 80.0;                       // RSI Upper Level (No BUY above this)
input double InpRSILowerLevel = 20.0;                       // RSI Lower Level (No SELL below this)

//--- Breakeven Settings
input bool InpUseBreakeven = false;                         // Use Breakeven (Move SL to Entry + Profit)
input double InpBreakevenTriggerPercent = 1.0;              // Breakeven Trigger: Profit % to Activate
input double InpBreakevenProfitPercent = 0.5;               // Breakeven SL: Move SL to Entry + This % Profit

//--- ATR Filter Settings
input bool InpUseATRFilter = false;                         // Use ATR Filter
input int InpATRPeriod = 40;                                // ATR Period
input double InpATRMultiplier = 1.0;                        // ATR Multiplier (Candle Range × This > ATR)

//--- ADX Filter Settings
input bool InpUseADXFilter = false;                         // Use ADX Filter
input int InpADXPeriod = 14;                                // ADX Period
input double InpADXLevel = 25.0;                            // ADX Level (Open Position if ADX >= This)

//--- ATR MA Slope Filter Settings
input bool InpUseATRMASlopeFilter = false;                  // Use ATR MA Slope Filter
input int InpATRMAPeriod = 5;                               // ATR Moving Average Period (Recommended: 5-10)
input double InpATRMASlopeBuyPercent = 0.5;                 // ATR MA Slope % for BUY (Recommended: 0.3-1.0)
input double InpATRMASlopeSellPercent = 0.5;                // ATR MA Slope % for SELL (Recommended: 0.3-1.0)

//--- MACD Filter Settings
input bool InpUseMACDFilter = false;                        // Use MACD Filter
input int InpMACDFastPeriod = 12;                           // MACD Fast EMA Period (Recommended: 12)
input int InpMACDSlowPeriod = 26;                           // MACD Slow EMA Period (Recommended: 26)
input int InpMACDSignalPeriod = 9;                          // MACD Signal SMA Period (Recommended: 9)
input bool InpMACDRequireAboveZeroBuy = false;              // BUY: Require MACD > 0 (in addition to MACD > Signal)
input bool InpMACDRequireBelowZeroSell = false;             // SELL: Require MACD < 0 (in addition to MACD < Signal)

//--- New Inputs (Added)
//--- Low Volatility Filter (ATR) Settings
input bool InpUseLowVolATRFilter = false;                   // Use Low Volatility Filter (ATR)
input int InpLowVolATRPeriod = 40;                          // Low Volatility ATR Period
input double InpLowVolATRMinPercent = 0.2;                  // Min ATR % of price to allow trade

//--- EMA Filter Settings
input bool InpUseEMAFilter = false;                         // Use EMA Filter
input int InpEMAPeriod = 14;                                // EMA Period
input ENUM_MA_METHOD InpEMAMethod = MODE_EMA;               // EMA Method
input ENUM_APPLIED_PRICE InpEMAPrice = PRICE_CLOSE;         // EMA Applied Price

//--- Higher Timeframe EMA Filter Settings
input bool InpUseHigherTFEMA = false;                       // Use Higher TF EMA
input ENUM_TIMEFRAMES InpHigherTF = PERIOD_M15;             // Higher Timeframe
input int InpHigherTFEMAPeriod = 32;                        // Higher TF EMA Period
input ENUM_MA_METHOD InpHigherTFEMAMethod = MODE_EMA;       // Higher TF EMA Method

//--- Min Body ATR Filter
input bool InpUseMinBodyATR = false;                        // Use Min Body ATR Filter
input double InpMinBodyATRMult = 0.16;                      // Min Body ATR Multiplier

//--- Breakout Volume Filter
input bool InpUseBreakoutVolumeFilter = false;              // Use Breakout Volume Filter
input int InpVolumeLookbackBuy = 14;                        // Volume Lookback Buy
input double InpVolumeMultiplierBuy = 0.5;                  // Volume Multiplier Buy
input int InpVolumeLookbackSell = 39;                       // Volume Lookback Sell
input double InpVolumeMultiplierSell = 0.7;                 // Volume Multiplier Sell
input double InpAdaptiveVolumeFactor = 1.0;                 // Adaptive Volume Factor

//--- Trailing Stop (USD)
input bool InpUseTrailingStopUSD = false;                   // Use Trailing Stop (USD)
input double InpTrailingStopUSD = 1000.0;                   // Trailing Stop USD

//--- Breakeven (USD)
input bool InpUseBreakevenUSD = false;                      // Use Breakeven (USD)
input double InpBreakevenUSD = 500.0;                       // Breakeven Trigger USD
input double InpBreakevenOffsetUSD = 100.0;                 // Breakeven Offset USD

//--- Range Filter (ATR + Slope)
input bool InpUseRangeFilter = false;                       // Use Range Filter
input int InpLongATRPeriodBuy = 91;                         // Long ATR Period Buy
input double InpATRMultiplierBuy = 0.6;                     // ATR Multiplier Buy
input double InpSlopeMultiplierBuy = 0.2;                   // ATR Slope % Buy
input int InpLongATRPeriodSell = 32;                        // Long ATR Period Sell
input double InpATRMultiplierSell = 0.56;                   // ATR Multiplier Sell
input double InpSlopeMultiplierSell = 0.08;                 // ATR Slope % Sell

//--- Momentum Filter
input bool InpUseMomentumFilter = false;                    // Use Momentum Filter
input int InpMomentumLookback = 65;                         // Momentum Lookback
input double InpMinMomentumATR = 0.42;                      // Min Momentum in ATR

//--- Volatility Expansion Filter
input bool InpUseVolatilityExpansion = false;               // Use Volatility Expansion
input int InpVolatilityLookbackBuy = 433;                   // Volatility Lookback Buy
input double InpMinVolatilityMultBuy = 0.52;                // Min Volatility Mult Buy
input int InpVolatilityLookbackSell = 261;                  // Volatility Lookback Sell
input double InpMinVolatilityMultSell = 0.36;               // Min Volatility Mult Sell

//--- Stochastic Filter
input bool InpUseStochasticFilter = false;                  // Use Stochastic Filter
input int InpStochKPeriod = 32;                             // Stochastic K Period
input int InpStochDPeriod = 3;                              // Stochastic D Period
input int InpStochSlowing = 1;                              // Stochastic Slowing
input ENUM_MA_METHOD InpStochMAMethod = MODE_EMA;           // Stochastic MA Method
input ENUM_STO_PRICE InpStochPriceField = STO_LOWHIGH;      // Stochastic Price Field
input double InpStochBuyLevel = 20.0;                       // Stochastic Buy Level
input double InpStochSellLevel = 80.0;                      // Stochastic Sell Level

//--- Doji Filter
input bool InpUseDojiFilter = false;                        // Use Doji Filter
input double InpDojiBodyPercent = 90.0;                     // Doji Body % of Range (max)
input double InpDojiUpperShadowPercent = 70.0;              // Doji Upper Shadow % of Range (min)
input double InpDojiLowerShadowPercent = 60.0;              // Doji Lower Shadow % of Range (min)
input double InpDojiMinRangePercent = 0.1;                  // Doji Min Range % of Open

//--- ATR Average Filter
input bool InpUseATRAverageFilter = false;                  // Use ATR Average Filter
input int InpATRAveragePeriod = 199;                        // ATR Average Period
input double InpATRAverageMultiplier = 0.47;                // ATR Average Multiplier

//--- Re-Entry Delay
input int InpReEntrySeconds = 0;                            // Re-Entry Delay (seconds)

//--- Multi-Timeframe Confirmation
input bool InpUseMTFConfirm = false;                        // Use Multi-Timeframe Confirmation
input ENUM_TIMEFRAMES InpMTFTimeframe = PERIOD_M15;         // Confirmation Timeframe
input int InpMTFConfirmShift = 1;                           // Confirmation Candle Shift (1 = last closed)

//--- Breakout Filter
input bool InpUseBreakoutFilter = false;                    // Use Breakout Filter
input int InpBreakoutLookbackBars = 5;                      // Lookback Bars for Breakout
input double InpBreakoutBufferPoints = 0.0;                 // Breakout Buffer (points)

//--- MA Distance Filter
input bool InpUseMADistanceFilter = false;                  // Use MA Distance Filter
input int InpMAPeriod = 50;                                 // MA Period
input ENUM_MA_METHOD InpMAMethod = MODE_EMA;                // MA Method
input ENUM_APPLIED_PRICE InpMAPrice = PRICE_CLOSE;          // MA Applied Price

//--- Advanced Quality Filters (Optional)
// 1) Context filter: only trade near 24h extremes
input bool InpUseContextExtremeFilter = false;              // Use Context Extreme Filter (24h range)
input int  InpContextLookbackMinutes = 1440;                // Context Lookback (minutes)
input double InpContextBuyZonePct = 30.0;                   // BUY allowed only in lowest X% of 24h range
input double InpContextSellZonePct = 30.0;                  // SELL allowed only in highest X% of 24h range

// 2) Impulse -> Pause -> Entry filter (delays entry by one candle)
input bool InpUseImpulsePauseFilter = false;                // Use Impulse->Pause->Entry Filter
input double InpPauseMaxBodyToRangePct = 40.0;              // Pause: max Body/Range % (smaller = more pause)
input double InpPauseMaxRangePercent = 0.0;                 // Pause: max Range % of Open (0 = disabled)
input bool InpPauseRequireInsideBar = true;                 // Pause: require inside bar vs impulse range

// 3) Range Regime filter (trade only in expansion after compression)
input bool InpUseRangeRegimeFilter = false;                 // Use Range Regime Filter (ATR expansion)
input int  InpRangeRegimeShortATR = 20;                     // Short ATR Period
input int  InpRangeRegimeLongATR = 100;                     // Long ATR Period
input double InpRangeRegimeExpansionMult = 1.05;            // Require ShortATR >= LongATR * this

// 4) Daily Bias filter (trade only with daily bias)
enum ENUM_DAILY_BIAS_MODE
{
   DAILY_BIAS_OFF = 0,
   DAILY_BIAS_DAILY_OPEN = 1
};
input ENUM_DAILY_BIAS_MODE InpDailyBiasMode = DAILY_BIAS_OFF;// Daily Bias Mode
input double InpDailyBiasBufferPct = 0.0;                   // Bias buffer % around reference (0 = no buffer)

// 5) One-shot per direction per swing (blocks repeated entries)
input bool InpUseOneShotSwingFilter = false;                // Use One-Shot Per Swing Filter
input int  InpSwingLookbackBars = 300;                      // Swing search lookback (bars)
input int  InpSwingPivot = 3;                               // Swing pivot (bars left/right)
input double InpMinMADistancePercent = 0.1;                 // Min Distance from MA (% of price)
input double InpMaxMADistancePercent = 0.0;                 // Max Distance from MA (0 = no max)

//--- False Breakout Filter
input bool InpUseFalseBreakoutFilter = false;               // Use False Breakout Filter
input int InpFalseBreakoutLookbackBars = 5;                 // Lookback Bars for False Breakout

//--- Tick Volume Filter
input bool InpUseTickVolumeFilter = false;                  // Use Tick Volume Filter
input int InpTickVolumeMAPeriod = 20;                       // Tick Volume MA Period
input double InpTickVolumeMultiplier = 1.0;                 // Min Volume = MA × Multiplier

//--- Global variables
datetime lastBarTime = 0;                                   // Last bar time we checked
int rsiHandle = INVALID_HANDLE;                             // RSI indicator handle
int atrHandle = INVALID_HANDLE;                             // ATR indicator handle
int lowVolAtrHandle = INVALID_HANDLE;                       // Low Vol ATR indicator handle
int adxHandle = INVALID_HANDLE;                             // ADX indicator handle
int atrMAHandle = INVALID_HANDLE;                           // ATR MA indicator handle
int macdHandle = INVALID_HANDLE;                            // MACD indicator handle
int maHandle = INVALID_HANDLE;                              // MA indicator handle
int emaHandle = INVALID_HANDLE;                             // EMA indicator handle
int higherTFEmaHandle = INVALID_HANDLE;                     // Higher TF EMA handle
int stochHandle = INVALID_HANDLE;                           // Stochastic handle
int longAtrBuyHandle = INVALID_HANDLE;                      // Long ATR Buy handle
int longAtrSellHandle = INVALID_HANDLE;                     // Long ATR Sell handle
int atrAverageHandle = INVALID_HANDLE;                      // ATR Average handle
datetime lastTradeTime = 0;                                 // Last trade time for re-entry delay
datetime lastBuyTradeTime = 0;                              // For one-shot swing filter
datetime lastSellTradeTime = 0;                             // For one-shot swing filter

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Initialize variables
   lastBarTime = 0;
   rsiHandle = INVALID_HANDLE;
   atrHandle = INVALID_HANDLE;
   lowVolAtrHandle = INVALID_HANDLE;
   adxHandle = INVALID_HANDLE;
   atrMAHandle = INVALID_HANDLE;
   macdHandle = INVALID_HANDLE;
   maHandle = INVALID_HANDLE;
   emaHandle = INVALID_HANDLE;
   higherTFEmaHandle = INVALID_HANDLE;
   stochHandle = INVALID_HANDLE;
   longAtrBuyHandle = INVALID_HANDLE;
   longAtrSellHandle = INVALID_HANDLE;
   atrAverageHandle = INVALID_HANDLE;
   lastTradeTime = 0;
   
   //--- Initialize RSI indicator if filter is enabled
   if(InpUseRSIFilter)
   {
      rsiHandle = iRSI(_Symbol, InpTimeframe, InpRSIPeriod, PRICE_CLOSE);
      if(rsiHandle == INVALID_HANDLE)
      {
         Print("Error creating RSI indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize ATR indicator if any ATR-based filter is enabled
   if(InpUseATRFilter || InpUseATRMASlopeFilter || InpUseMinBodyATR || InpUseMomentumFilter || InpUseVolatilityExpansion)
   {
      atrHandle = iATR(_Symbol, InpTimeframe, InpATRPeriod);
      if(atrHandle == INVALID_HANDLE)
      {
         Print("Error creating ATR indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize Low Volatility ATR indicator if enabled
   if(InpUseLowVolATRFilter)
   {
      lowVolAtrHandle = iATR(_Symbol, InpTimeframe, InpLowVolATRPeriod);
      if(lowVolAtrHandle == INVALID_HANDLE)
      {
         Print("Error creating Low Vol ATR indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize ADX indicator if filter is enabled
   if(InpUseADXFilter)
   {
      adxHandle = iADX(_Symbol, InpTimeframe, InpADXPeriod);
      if(adxHandle == INVALID_HANDLE)
      {
         Print("Error creating ADX indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize MACD indicator if filter is enabled
   if(InpUseMACDFilter)
   {
      macdHandle = iMACD(_Symbol, InpTimeframe, InpMACDFastPeriod, InpMACDSlowPeriod, InpMACDSignalPeriod, PRICE_CLOSE);
      if(macdHandle == INVALID_HANDLE)
      {
         Print("Error creating MACD indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize MA indicator if MA Distance filter is enabled
   if(InpUseMADistanceFilter)
   {
      maHandle = iMA(_Symbol, InpTimeframe, InpMAPeriod, 0, InpMAMethod, InpMAPrice);
      if(maHandle == INVALID_HANDLE)
      {
         Print("Error creating MA indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize EMA indicator if EMA filter is enabled
   if(InpUseEMAFilter)
   {
      emaHandle = iMA(_Symbol, InpTimeframe, InpEMAPeriod, 0, InpEMAMethod, InpEMAPrice);
      if(emaHandle == INVALID_HANDLE)
      {
         Print("Error creating EMA indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize Higher TF EMA if enabled
   if(InpUseHigherTFEMA)
   {
      higherTFEmaHandle = iMA(_Symbol, InpHigherTF, InpHigherTFEMAPeriod, 0, InpHigherTFEMAMethod, InpEMAPrice);
      if(higherTFEmaHandle == INVALID_HANDLE)
      {
         Print("Error creating Higher TF EMA indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize Stochastic if enabled
   if(InpUseStochasticFilter)
   {
      stochHandle = iStochastic(_Symbol, InpTimeframe, InpStochKPeriod, InpStochDPeriod, InpStochSlowing, InpStochMAMethod, InpStochPriceField);
      if(stochHandle == INVALID_HANDLE)
      {
         Print("Error creating Stochastic indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize Long ATR handles for Range filter
   if(InpUseRangeFilter)
   {
      longAtrBuyHandle = iATR(_Symbol, InpTimeframe, InpLongATRPeriodBuy);
      if(longAtrBuyHandle == INVALID_HANDLE)
      {
         Print("Error creating Long ATR Buy indicator: ", GetLastError());
         return(INIT_FAILED);
      }
      
      longAtrSellHandle = iATR(_Symbol, InpTimeframe, InpLongATRPeriodSell);
      if(longAtrSellHandle == INVALID_HANDLE)
      {
         Print("Error creating Long ATR Sell indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize ATR Average handle
   if(InpUseATRAverageFilter)
   {
      atrAverageHandle = iATR(_Symbol, InpTimeframe, InpATRAveragePeriod);
      if(atrAverageHandle == INVALID_HANDLE)
      {
         Print("Error creating ATR Average indicator: ", GetLastError());
         return(INIT_FAILED);
      }
   }
   
   Print("CandleBodyRangeEA initialized successfully");
   Print("Timeframe: ", EnumToString(InpTimeframe));
   Print("Min Body: ", InpMinBodyPercent, "% | Max Body: ", InpMaxBodyPercent, "%");
   Print("Min Range: ", InpMinRangePercent, "% | Max Range: ", InpMaxRangePercent, "%");
   Print("Body to Range Ratio: ", InpBodyToRangePercent, "%");
   Print("Min Lot Size: ", InpMinLotSize, " | Equity Risk: ", InpEquityRiskPercent, "% (0 = Fixed)");
   string slModeStr = "";
   switch(InpStopLossMode)
   {
      case SL_MODE_CANDLE:
         slModeStr = "Candle (" + string(InpStopLossType == SL_TYPE_BODY ? "Body" : "Range") + ", " + DoubleToString(InpStopLossPercent, 2) + "%)";
         break;
      case SL_MODE_ENTRY_PERCENT:
         slModeStr = "Entry Percent (" + DoubleToString(InpStopLossEntryPercent, 4) + "%)";
         break;
      case SL_MODE_ENTRY_FIXED:
         slModeStr = "Fixed Distance (" + DoubleToString(InpStopLossFixedAmount, _Digits) + ")";
         break;
   }
   Print("Stop Loss Mode: ", slModeStr);
   Print("Upside Down Mode: ", (InpUpsideDown ? "ON (Reversed)" : "OFF (Normal)"));
   Print("Take Profit: ", (InpTakeProfitPercent == 0.0 ? "Close at End of Candle" : DoubleToString(InpTakeProfitPercent, 2) + "%"));
   Print("Max Open Positions: ", InpMaxOpenPositions);
   Print("Magic Number: ", InpMagicNumber);
   
   //--- Print session filter
   string sessionStr = "";
   switch(InpTradingSession)
   {
      case SESSION_NEW_YORK_ONLY: sessionStr = "New York Only"; break;
      case SESSION_LONDON_NEW_YORK: sessionStr = "London + New York"; break;
      case SESSION_ASIA_LONDON_NY: sessionStr = "Asia + London + New York"; break;
      case SESSION_ALL_TIMES: sessionStr = "All Trading Times"; break;
   }
   Print("Trading Session: ", sessionStr);
   
   //--- Print RSI filter
   if(InpUseRSIFilter)
   {
      Print("RSI Filter: ON | Period: ", InpRSIPeriod, " | Upper: ", InpRSIUpperLevel, " (No BUY) | Lower: ", InpRSILowerLevel, " (No SELL)");
   }
   else
   {
      Print("RSI Filter: OFF");
   }
   
   //--- Print Breakeven settings
   if(InpUseBreakeven)
   {
      Print("Breakeven: ON | Trigger at: ", InpBreakevenTriggerPercent, "% profit | Move SL to Entry + ", InpBreakevenProfitPercent, "%");
   }
   else
   {
      Print("Breakeven: OFF");
   }
   
   //--- Print ATR filter settings
   if(InpUseATRFilter)
   {
      Print("ATR Filter: ON | Period: ", InpATRPeriod, " | Multiplier: ", InpATRMultiplier, " (Candle Range × Multiplier > ATR)");
   }
   else
   {
      Print("ATR Filter: OFF");
   }
   
   //--- Print Low Volatility filter settings
   if(InpUseLowVolATRFilter)
   {
      Print("Low Volatility Filter: ON | ATR Period: ", InpLowVolATRPeriod, 
            " | Min ATR %: ", InpLowVolATRMinPercent);
   }
   else
   {
      Print("Low Volatility Filter: OFF");
   }
   
   //--- Print ADX filter settings
   if(InpUseADXFilter)
   {
      Print("ADX Filter: ON | Period: ", InpADXPeriod, " | Level: ", InpADXLevel, " (Open Position if ADX >= Level)");
   }
   else
   {
      Print("ADX Filter: OFF");
   }
   
   //--- Print ATR MA Slope filter settings
   if(InpUseATRMASlopeFilter)
   {
      Print("ATR MA Slope Filter: ON | MA Period: ", InpATRMAPeriod, " | BUY Slope: ", InpATRMASlopeBuyPercent, "% | SELL Slope: ", InpATRMASlopeSellPercent, "%");
   }
   else
   {
      Print("ATR MA Slope Filter: OFF");
   }
   
   //--- Print MACD filter settings
   if(InpUseMACDFilter)
   {
      Print("MACD Filter: ON | Fast: ", InpMACDFastPeriod, " | Slow: ", InpMACDSlowPeriod, " | Signal: ", InpMACDSignalPeriod);
      Print("  BUY: MACD > Signal", (InpMACDRequireAboveZeroBuy ? " AND MACD > 0" : ""));
      Print("  SELL: MACD < Signal", (InpMACDRequireBelowZeroSell ? " AND MACD < 0" : ""));
   }
   else
   {
      Print("MACD Filter: OFF");
   }
   
   //--- Print EMA filter settings
   if(InpUseEMAFilter)
   {
      Print("EMA Filter: ON | Period: ", InpEMAPeriod);
   }
   else
   {
      Print("EMA Filter: OFF");
   }
   
   //--- Print Higher TF EMA filter settings
   if(InpUseHigherTFEMA)
   {
      Print("Higher TF EMA: ON | TF: ", EnumToString(InpHigherTF),
            " | Period: ", InpHigherTFEMAPeriod);
   }
   else
   {
      Print("Higher TF EMA: OFF");
   }
   
   //--- Print Min Body ATR filter settings
   if(InpUseMinBodyATR)
   {
      Print("Min Body ATR: ON | Mult: ", InpMinBodyATRMult);
   }
   else
   {
      Print("Min Body ATR: OFF");
   }
   
   //--- Print Breakout Volume filter settings
   if(InpUseBreakoutVolumeFilter)
   {
      Print("Breakout Volume Filter: ON | Buy Lookback: ", InpVolumeLookbackBuy,
            " | Buy Mult: ", InpVolumeMultiplierBuy,
            " | Sell Lookback: ", InpVolumeLookbackSell,
            " | Sell Mult: ", InpVolumeMultiplierSell,
            " | Adaptive: ", InpAdaptiveVolumeFactor);
   }
   else
   {
      Print("Breakout Volume Filter: OFF");
   }
   
   //--- Print Trailing Stop USD settings
   if(InpUseTrailingStopUSD)
   {
      Print("Trailing Stop USD: ON | Distance: ", InpTrailingStopUSD);
   }
   else
   {
      Print("Trailing Stop USD: OFF");
   }
   
   //--- Print Breakeven USD settings
   if(InpUseBreakevenUSD)
   {
      Print("Breakeven USD: ON | Trigger: ", InpBreakevenUSD, " | Offset: ", InpBreakevenOffsetUSD);
   }
   else
   {
      Print("Breakeven USD: OFF");
   }
   
   //--- Print Range filter settings
   if(InpUseRangeFilter)
   {
      Print("Range Filter: ON | Buy ATR: ", InpLongATRPeriodBuy, " Mult: ", InpATRMultiplierBuy,
            " Slope%: ", InpSlopeMultiplierBuy,
            " | Sell ATR: ", InpLongATRPeriodSell, " Mult: ", InpATRMultiplierSell,
            " Slope%: ", InpSlopeMultiplierSell);
   }
   else
   {
      Print("Range Filter: OFF");
   }
   
   //--- Print Momentum filter settings
   if(InpUseMomentumFilter)
   {
      Print("Momentum Filter: ON | Lookback: ", InpMomentumLookback, " | Min ATR: ", InpMinMomentumATR);
   }
   else
   {
      Print("Momentum Filter: OFF");
   }
   
   //--- Print Volatility Expansion settings
   if(InpUseVolatilityExpansion)
   {
      Print("Volatility Expansion: ON | Buy Lookback: ", InpVolatilityLookbackBuy,
            " Min Mult: ", InpMinVolatilityMultBuy,
            " | Sell Lookback: ", InpVolatilityLookbackSell,
            " Min Mult: ", InpMinVolatilityMultSell);
   }
   else
   {
      Print("Volatility Expansion: OFF");
   }
   
   //--- Print Stochastic filter settings
   if(InpUseStochasticFilter)
   {
      Print("Stochastic Filter: ON | K: ", InpStochKPeriod,
            " D: ", InpStochDPeriod, " Slowing: ", InpStochSlowing,
            " | Buy Level: ", InpStochBuyLevel, " Sell Level: ", InpStochSellLevel);
   }
   else
   {
      Print("Stochastic Filter: OFF");
   }
   
   //--- Print Doji filter settings
   if(InpUseDojiFilter)
   {
      Print("Doji Filter: ON | Body%: ", InpDojiBodyPercent,
            " Upper%: ", InpDojiUpperShadowPercent,
            " Lower%: ", InpDojiLowerShadowPercent,
            " Min Range%: ", InpDojiMinRangePercent);
   }
   else
   {
      Print("Doji Filter: OFF");
   }
   
   //--- Print ATR Average filter settings
   if(InpUseATRAverageFilter)
   {
      Print("ATR Average Filter: ON | Period: ", InpATRAveragePeriod,
            " Mult: ", InpATRAverageMultiplier);
   }
   else
   {
      Print("ATR Average Filter: OFF");
   }
   
   //--- Print Re-entry delay
   if(InpReEntrySeconds > 0)
   {
      Print("Re-Entry Delay: ", InpReEntrySeconds, " seconds");
   }
   
   //--- Print MTF confirmation settings
   if(InpUseMTFConfirm)
   {
      Print("MTF Confirm: ON | Timeframe: ", EnumToString(InpMTFTimeframe),
            " | Shift: ", InpMTFConfirmShift);
   }
   else
   {
      Print("MTF Confirm: OFF");
   }
   
   //--- Print Breakout filter settings
   if(InpUseBreakoutFilter)
   {
      Print("Breakout Filter: ON | Lookback: ", InpBreakoutLookbackBars,
            " | Buffer (points): ", InpBreakoutBufferPoints);
   }
   else
   {
      Print("Breakout Filter: OFF");
   }
   
   //--- Print MA Distance filter settings
   if(InpUseMADistanceFilter)
   {
      Print("MA Distance Filter: ON | Period: ", InpMAPeriod,
            " | Min %: ", InpMinMADistancePercent,
            " | Max %: ", (InpMaxMADistancePercent > 0.0 ? DoubleToString(InpMaxMADistancePercent, 2) : "OFF"));
   }
   else
   {
      Print("MA Distance Filter: OFF");
   }
   
   //--- Print False Breakout filter settings
   if(InpUseFalseBreakoutFilter)
   {
      Print("False Breakout Filter: ON | Lookback: ", InpFalseBreakoutLookbackBars);
   }
   else
   {
      Print("False Breakout Filter: OFF");
   }
   
   //--- Print Tick Volume filter settings
   if(InpUseTickVolumeFilter)
   {
      Print("Tick Volume Filter: ON | MA Period: ", InpTickVolumeMAPeriod,
            " | Multiplier: ", InpTickVolumeMultiplier);
   }
   else
   {
      Print("Tick Volume Filter: OFF");
   }
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release RSI indicator handle
   if(rsiHandle != INVALID_HANDLE)
   {
      IndicatorRelease(rsiHandle);
   }
   
   //--- Release ATR indicator handle
   if(atrHandle != INVALID_HANDLE)
   {
      IndicatorRelease(atrHandle);
   }
   
   //--- Release Low Vol ATR indicator handle
   if(lowVolAtrHandle != INVALID_HANDLE)
   {
      IndicatorRelease(lowVolAtrHandle);
   }
   
   //--- Release ADX indicator handle
   if(adxHandle != INVALID_HANDLE)
   {
      IndicatorRelease(adxHandle);
   }
   
   //--- Release MACD indicator handle
   if(macdHandle != INVALID_HANDLE)
   {
      IndicatorRelease(macdHandle);
   }
   
   //--- Release MA indicator handle
   if(maHandle != INVALID_HANDLE)
   {
      IndicatorRelease(maHandle);
   }
   
   //--- Release EMA indicator handle
   if(emaHandle != INVALID_HANDLE)
   {
      IndicatorRelease(emaHandle);
   }
   
   //--- Release Higher TF EMA indicator handle
   if(higherTFEmaHandle != INVALID_HANDLE)
   {
      IndicatorRelease(higherTFEmaHandle);
   }
   
   //--- Release Stochastic indicator handle
   if(stochHandle != INVALID_HANDLE)
   {
      IndicatorRelease(stochHandle);
   }
   
   //--- Release Long ATR handles
   if(longAtrBuyHandle != INVALID_HANDLE)
   {
      IndicatorRelease(longAtrBuyHandle);
   }
   if(longAtrSellHandle != INVALID_HANDLE)
   {
      IndicatorRelease(longAtrSellHandle);
   }
   
   //--- Release ATR Average handle
   if(atrAverageHandle != INVALID_HANDLE)
   {
      IndicatorRelease(atrAverageHandle);
   }
   
   Print("CandleBodyRangeEA deinitialized");
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check breakeven on every tick (if enabled)
   if(InpUseBreakeven)
   {
      CheckBreakeven();
   }
   
   //--- Check breakeven USD on every tick (if enabled)
   if(InpUseBreakevenUSD)
   {
      CheckBreakevenUSD();
   }
   
   //--- Check trailing stop USD on every tick (if enabled)
   if(InpUseTrailingStopUSD)
   {
      CheckTrailingStopUSD();
   }
   
   //--- Check if new bar formed
   datetime currentBarTime = iTime(_Symbol, InpTimeframe, 0);
   bool isNewBar = (currentBarTime != lastBarTime);
   
   if(isNewBar)
   {
      //--- When new bar forms, first check if positions need to be closed (for TP=0 mode)
      CheckPositionStatus();
      
      lastBarTime = currentBarTime;
      
      //--- Check candle conditions from previous closed candle (index 1)
      CheckCandleAndTrade();
   }
}

//+------------------------------------------------------------------+
//| Check Breakeven - Move SL to Entry + Profit after trigger       |
//+------------------------------------------------------------------+
void CheckBreakeven()
{
   //--- Check all open positions
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(!PositionSelectByTicket(ticket))
         continue;
      
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)
         continue;
      
      if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber)
         continue;
      
      //--- Get position data
      double entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double currentSL = PositionGetDouble(POSITION_SL);
      ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
      //--- Get current price
      double currentPrice = 0.0;
      if(posType == POSITION_TYPE_BUY)
      {
         currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      }
      else
      {
         currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      }
      
      //--- Calculate profit percentage
      double profitPercent = 0.0;
      if(posType == POSITION_TYPE_BUY)
      {
         profitPercent = ((currentPrice - entryPrice) / entryPrice) * 100.0;
      }
      else
      {
         profitPercent = ((entryPrice - currentPrice) / entryPrice) * 100.0;
      }
      
      //--- Check if profit exceeds trigger level
      if(profitPercent >= InpBreakevenTriggerPercent)
      {
         //--- Calculate new SL (Entry + BreakevenProfitPercent)
         double newSL = 0.0;
         if(posType == POSITION_TYPE_BUY)
         {
            //--- BUY: New SL = Entry * (1 + BreakevenProfitPercent / 100)
            newSL = entryPrice * (1.0 + InpBreakevenProfitPercent / 100.0);
            
            //--- Only move SL if it's higher than current SL
            if(newSL > currentSL)
            {
               ModifyPositionSL(ticket, newSL, entryPrice, profitPercent);
            }
         }
         else
         {
            //--- SELL: New SL = Entry * (1 - BreakevenProfitPercent / 100)
            newSL = entryPrice * (1.0 - InpBreakevenProfitPercent / 100.0);
            
            //--- Only move SL if it's lower than current SL (or SL is 0)
            if(currentSL == 0 || newSL < currentSL)
            {
               ModifyPositionSL(ticket, newSL, entryPrice, profitPercent);
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Convert USD to price distance                                    |
//+------------------------------------------------------------------+
double ConvertUSDToPriceDistance(double usdAmount, double volume)
{
   if(usdAmount <= 0.0 || volume <= 0.0)
      return 0.0;
   
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   if(tickValue <= 0 || tickSize <= 0)
      return 0.0;
   
   double moneyPerTick = tickValue * volume;
   if(moneyPerTick <= 0)
      return 0.0;
   
   double ticks = usdAmount / moneyPerTick;
   return ticks * tickSize;
}

//+------------------------------------------------------------------+
//| Check Breakeven - USD based                                      |
//+------------------------------------------------------------------+
void CheckBreakevenUSD()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(!PositionSelectByTicket(ticket))
         continue;
      
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)
         continue;
      
      if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber)
         continue;
      
      double profit = PositionGetDouble(POSITION_PROFIT);
      if(profit < InpBreakevenUSD)
         continue;
      
      double entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double currentSL = PositionGetDouble(POSITION_SL);
      double volume = PositionGetDouble(POSITION_VOLUME);
      ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
      double offsetDistance = ConvertUSDToPriceDistance(InpBreakevenOffsetUSD, volume);
      if(offsetDistance <= 0.0)
         continue;
      
      double newSL = 0.0;
      if(posType == POSITION_TYPE_BUY)
      {
         newSL = entryPrice + offsetDistance;
         if(newSL > currentSL)
         {
            double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            double profitPercent = ((currentPrice - entryPrice) / entryPrice) * 100.0;
            ModifyPositionSL(ticket, newSL, entryPrice, profitPercent);
         }
      }
      else
      {
         newSL = entryPrice - offsetDistance;
         if(currentSL == 0 || newSL < currentSL)
         {
            double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            double profitPercent = ((entryPrice - currentPrice) / entryPrice) * 100.0;
            ModifyPositionSL(ticket, newSL, entryPrice, profitPercent);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Check Trailing Stop - USD based                                  |
//+------------------------------------------------------------------+
void CheckTrailingStopUSD()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(!PositionSelectByTicket(ticket))
         continue;
      
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)
         continue;
      
      if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber)
         continue;
      
      double entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      double currentSL = PositionGetDouble(POSITION_SL);
      double volume = PositionGetDouble(POSITION_VOLUME);
      ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      
      double trailDistance = ConvertUSDToPriceDistance(InpTrailingStopUSD, volume);
      if(trailDistance <= 0.0)
         continue;
      
      if(posType == POSITION_TYPE_BUY)
      {
         double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double newSL = currentPrice - trailDistance;
         if(newSL > currentSL)
         {
            double profitPercent = ((currentPrice - entryPrice) / entryPrice) * 100.0;
            ModifyPositionSL(ticket, newSL, entryPrice, profitPercent);
         }
      }
      else
      {
         double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         double newSL = currentPrice + trailDistance;
         if(currentSL == 0 || newSL < currentSL)
         {
            double profitPercent = ((entryPrice - currentPrice) / entryPrice) * 100.0;
            ModifyPositionSL(ticket, newSL, entryPrice, profitPercent);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Modify position Stop Loss                                        |
//+------------------------------------------------------------------+
void ModifyPositionSL(ulong ticket, double newSL, double entryPrice, double profitPercent)
{
   if(!PositionSelectByTicket(ticket))
      return;
   
   double currentSL = PositionGetDouble(POSITION_SL);
   double currentTP = PositionGetDouble(POSITION_TP);
   
   //--- Normalize SL
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   long stopLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double minStopDistance = stopLevel * point;
   
   newSL = NormalizeDouble(newSL, digits);
   
   //--- Validate SL distance
   ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   double currentPrice = 0.0;
   
   if(posType == POSITION_TYPE_BUY)
   {
      currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      if(stopLevel > 0 && (currentPrice - newSL) < minStopDistance)
      {
         newSL = NormalizeDouble(currentPrice - minStopDistance, digits);
      }
   }
   else
   {
      currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      if(stopLevel > 0 && (newSL - currentPrice) < minStopDistance)
      {
         newSL = NormalizeDouble(currentPrice + minStopDistance, digits);
      }
   }
   
   //--- Prepare modify request
   MqlTradeRequest request = {};
   MqlTradeResult  result = {};
   
   request.action = TRADE_ACTION_SLTP;
   request.position = ticket;
   request.symbol = _Symbol;
   request.sl = newSL;
   request.tp = currentTP;
   
   if(!OrderSend(request, result))
   {
      Print("Error modifying SL for breakeven: ", GetLastError());
   }
   else
   {
      Print("Breakeven activated: Ticket ", ticket, 
            " | Entry: ", entryPrice, 
            " | Profit: ", DoubleToString(profitPercent, 2), "%",
            " | New SL: ", newSL);
   }
}

//+------------------------------------------------------------------+
//| Check if current time is within allowed trading session         |
//+------------------------------------------------------------------+
bool IsTradingSessionAllowed()
{
   //--- If all times allowed, return true
   if(InpTradingSession == SESSION_ALL_TIMES)
      return true;
   
   //--- Get current UTC time
   MqlDateTime dt;
   TimeToStruct(TimeGMT(), dt);
   int currentHour = dt.hour;
   
   //--- Define session hours in UTC
   // Asia (Tokyo): 00:00 - 09:00 UTC
   // London: 08:00 - 17:00 UTC
   // New York: 13:00 - 22:00 UTC (8:00-17:00 EST, UTC-5)
   
   bool inAsiaSession = (currentHour >= 0 && currentHour < 9);
   bool inLondonSession = (currentHour >= 8 && currentHour < 17);
   bool inNewYorkSession = (currentHour >= 13 && currentHour < 22);
   
   switch(InpTradingSession)
   {
      case SESSION_NEW_YORK_ONLY:
         return inNewYorkSession;
      
      case SESSION_LONDON_NEW_YORK:
         return (inLondonSession || inNewYorkSession);
      
      case SESSION_ASIA_LONDON_NY:
         return (inAsiaSession || inLondonSession || inNewYorkSession);
      
      case SESSION_ALL_TIMES:
      default:
         return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Get current RSI value                                            |
//+------------------------------------------------------------------+
double GetRSIValue()
{
   if(rsiHandle == INVALID_HANDLE)
      return -1;
   
   double rsiBuffer[1];
   ArraySetAsSeries(rsiBuffer, true);
   
   if(CopyBuffer(rsiHandle, 0, 0, 1, rsiBuffer) <= 0)
   {
      Print("Error copying RSI buffer: ", GetLastError());
      return -1;
   }
   
   return rsiBuffer[0];
}

//+------------------------------------------------------------------+
//| Get current ATR value                                            |
//+------------------------------------------------------------------+
double GetATRValue()
{
   if(atrHandle == INVALID_HANDLE)
      return -1;
   
   double atrBuffer[1];
   ArraySetAsSeries(atrBuffer, true);
   
   if(CopyBuffer(atrHandle, 0, 0, 1, atrBuffer) <= 0)
   {
      Print("Error copying ATR buffer: ", GetLastError());
      return -1;
   }
   
   return atrBuffer[0];
}

//+------------------------------------------------------------------+
//| Check ATR Filter - Candle Range × Multiplier > ATR               |
//+------------------------------------------------------------------+
bool CheckATRFilter(double candleRange)
{
   if(!InpUseATRFilter)
      return true; // Filter disabled, allow trade
   
   double atrValue = GetATRValue();
   if(atrValue <= 0)
   {
      Print("ATR Filter: Error getting ATR value, allowing trade");
      return true;
   }
   
   //--- Calculate: Candle Range × Multiplier
   double candleRangeMultiplied = candleRange * InpATRMultiplier;
   
   //--- Check if Candle Range × Multiplier > ATR
   if(candleRangeMultiplied > atrValue)
   {
      Print("ATR Filter PASSED: Candle Range (", DoubleToString(candleRange, _Digits), 
            ") × Multiplier (", InpATRMultiplier, 
            ") = ", DoubleToString(candleRangeMultiplied, _Digits),
            " > ATR (", DoubleToString(atrValue, _Digits), ")");
      return true;
   }
   else
   {
      Print("ATR Filter BLOCKED: Candle Range (", DoubleToString(candleRange, _Digits), 
            ") × Multiplier (", InpATRMultiplier, 
            ") = ", DoubleToString(candleRangeMultiplied, _Digits),
            " <= ATR (", DoubleToString(atrValue, _Digits), ")");
      return false;
   }
}

//+------------------------------------------------------------------+
//| Get current ADX value (Main line)                                |
//+------------------------------------------------------------------+
double GetADXValue()
{
   if(adxHandle == INVALID_HANDLE)
      return -1;
   
   //--- ADX has 3 buffers: 0 = Main ADX line, 1 = +DI, 2 = -DI
   double adxBuffer[1];
   ArraySetAsSeries(adxBuffer, true);
   
   //--- Get Main ADX line (buffer 0)
   if(CopyBuffer(adxHandle, 0, 0, 1, adxBuffer) <= 0)
   {
      Print("Error copying ADX buffer: ", GetLastError());
      return -1;
   }
   
   return adxBuffer[0];
}

//+------------------------------------------------------------------+
//| Check ADX Filter - ADX >= Level to open position                 |
//+------------------------------------------------------------------+
bool CheckADXFilter()
{
   if(!InpUseADXFilter)
      return true; // Filter disabled, allow trade
   
   double adxValue = GetADXValue();
   if(adxValue < 0)
   {
      Print("ADX Filter: Error getting ADX value, allowing trade");
      return true;
   }
   
   //--- Check if ADX >= Level
   if(adxValue >= InpADXLevel)
   {
      Print("ADX Filter PASSED: ADX (", DoubleToString(adxValue, 2), 
            ") >= Level (", InpADXLevel, ")");
      return true;
   }
   else
   {
      Print("ADX Filter BLOCKED: ADX (", DoubleToString(adxValue, 2), 
            ") < Level (", InpADXLevel, ")");
      return false;
   }
}

//+------------------------------------------------------------------+
//| Calculate ATR Moving Average                                     |
//+------------------------------------------------------------------+
double GetATRMAValue()
{
   if(atrHandle == INVALID_HANDLE)
      return -1;
   
   //--- Get ATR values for MA calculation
   double atrBuffer[];
   ArraySetAsSeries(atrBuffer, true);
   int copied = CopyBuffer(atrHandle, 0, 0, InpATRMAPeriod, atrBuffer);
   
   if(copied < InpATRMAPeriod)
   {
      Print("Error getting enough ATR values for MA calculation");
      return -1;
   }
   
   //--- Calculate Simple Moving Average of ATR
   double sum = 0.0;
   for(int i = 0; i < InpATRMAPeriod; i++)
   {
      sum += atrBuffer[i];
   }
   
   return sum / InpATRMAPeriod;
}

//+------------------------------------------------------------------+
//| Get ATR MA Slope - Percentage change from previous bar           |
//+------------------------------------------------------------------+
double GetATRMASlope()
{
   if(atrHandle == INVALID_HANDLE)
      return -999;
   
   //--- Get current ATR MA
   double currentMA = GetATRMAValue();
   if(currentMA <= 0)
      return -999;
   
   //--- Get previous ATR MA (shift by 1 bar)
   double atrBuffer[];
   ArraySetAsSeries(atrBuffer, true);
   int copied = CopyBuffer(atrHandle, 0, 1, InpATRMAPeriod, atrBuffer); // Start from index 1
   
   if(copied < InpATRMAPeriod)
      return -999;
   
   //--- Calculate previous ATR MA
   double sum = 0.0;
   for(int i = 0; i < InpATRMAPeriod; i++)
   {
      sum += atrBuffer[i];
   }
   double previousMA = sum / InpATRMAPeriod;
   
   if(previousMA <= 0)
      return -999;
   
   //--- Calculate slope as percentage: (Current - Previous) / Previous * 100
   double slope = ((currentMA - previousMA) / previousMA) * 100.0;
   
   return slope;
}

//+------------------------------------------------------------------+
//| Check ATR MA Slope Filter for BUY                                |
//+------------------------------------------------------------------+
bool CheckATRMASlopeForBuy()
{
   if(!InpUseATRMASlopeFilter)
      return true; // Filter disabled, allow trade
   
   double slope = GetATRMASlope();
   if(slope == -999)
   {
      Print("ATR MA Slope Filter: Error calculating slope, allowing trade");
      return true;
   }
   
   //--- BUY: Slope must be positive (upward) and >= threshold
   if(slope >= InpATRMASlopeBuyPercent)
   {
      Print("ATR MA Slope Filter PASSED for BUY: Slope (", DoubleToString(slope, 3), 
            "%) >= Threshold (", InpATRMASlopeBuyPercent, "%)");
      return true;
   }
   else
   {
      Print("ATR MA Slope Filter BLOCKED for BUY: Slope (", DoubleToString(slope, 3), 
            "%) < Threshold (", InpATRMASlopeBuyPercent, "%)");
      return false;
   }
}

//+------------------------------------------------------------------+
//| Check ATR MA Slope Filter for SELL                               |
//+------------------------------------------------------------------+
bool CheckATRMASlopeForSell()
{
   if(!InpUseATRMASlopeFilter)
      return true; // Filter disabled, allow trade
   
   double slope = GetATRMASlope();
   if(slope == -999)
   {
      Print("ATR MA Slope Filter: Error calculating slope, allowing trade");
      return true;
   }
   
   //--- SELL: Slope must be positive (upward) and >= threshold
   if(slope >= InpATRMASlopeSellPercent)
   {
      Print("ATR MA Slope Filter PASSED for SELL: Slope (", DoubleToString(slope, 3), 
            "%) >= Threshold (", InpATRMASlopeSellPercent, "%)");
      return true;
   }
   else
   {
      Print("ATR MA Slope Filter BLOCKED for SELL: Slope (", DoubleToString(slope, 3), 
            "%) < Threshold (", InpATRMASlopeSellPercent, "%)");
      return false;
   }
}

//+------------------------------------------------------------------+
//| Get MACD values (Main line and Signal line)                      |
//+------------------------------------------------------------------+
bool GetMACDValues(double &macdMain, double &macdSignal)
{
   if(macdHandle == INVALID_HANDLE)
      return false;
   
   //--- MACD has 3 buffers: 0 = Main MACD line, 1 = Signal line, 2 = Histogram
   double macdMainBuffer[1];
   double macdSignalBuffer[1];
   ArraySetAsSeries(macdMainBuffer, true);
   ArraySetAsSeries(macdSignalBuffer, true);
   
   //--- Get Main MACD line (buffer 0)
   if(CopyBuffer(macdHandle, 0, 0, 1, macdMainBuffer) <= 0)
   {
      Print("Error copying MACD Main buffer: ", GetLastError());
      return false;
   }
   
   //--- Get Signal line (buffer 1)
   if(CopyBuffer(macdHandle, 1, 0, 1, macdSignalBuffer) <= 0)
   {
      Print("Error copying MACD Signal buffer: ", GetLastError());
      return false;
   }
   
   macdMain = macdMainBuffer[0];
   macdSignal = macdSignalBuffer[0];
   
   return true;
}

//+------------------------------------------------------------------+
//| Check MACD Filter for BUY                                        |
//+------------------------------------------------------------------+
bool CheckMACDFilterForBuy()
{
   if(!InpUseMACDFilter)
      return true; // Filter disabled, allow trade
   
   double macdMain = 0.0;
   double macdSignal = 0.0;
   
   if(!GetMACDValues(macdMain, macdSignal))
   {
      Print("MACD Filter: Error getting MACD values, allowing trade");
      return true;
   }
   
   //--- BUY Condition 1: MACD > Signal
   if(macdMain <= macdSignal)
   {
      Print("MACD Filter BLOCKED for BUY: MACD (", DoubleToString(macdMain, 5), 
            ") <= Signal (", DoubleToString(macdSignal, 5), ")");
      return false;
   }
   
   //--- BUY Condition 2: MACD > 0 (if required)
   if(InpMACDRequireAboveZeroBuy && macdMain <= 0)
   {
      Print("MACD Filter BLOCKED for BUY: MACD (", DoubleToString(macdMain, 5), 
            ") <= 0 (required above zero)");
      return false;
   }
   
   Print("MACD Filter PASSED for BUY: MACD (", DoubleToString(macdMain, 5), 
         ") > Signal (", DoubleToString(macdSignal, 5), ")", 
         (InpMACDRequireAboveZeroBuy ? " AND MACD > 0" : ""));
   return true;
}

//+------------------------------------------------------------------+
//| Check MACD Filter for SELL                                       |
//+------------------------------------------------------------------+
bool CheckMACDFilterForSell()
{
   if(!InpUseMACDFilter)
      return true; // Filter disabled, allow trade
   
   double macdMain = 0.0;
   double macdSignal = 0.0;
   
   if(!GetMACDValues(macdMain, macdSignal))
   {
      Print("MACD Filter: Error getting MACD values, allowing trade");
      return true;
   }
   
   //--- SELL Condition 1: MACD < Signal
   if(macdMain >= macdSignal)
   {
      Print("MACD Filter BLOCKED for SELL: MACD (", DoubleToString(macdMain, 5), 
            ") >= Signal (", DoubleToString(macdSignal, 5), ")");
      return false;
   }
   
   //--- SELL Condition 2: MACD < 0 (if required)
   if(InpMACDRequireBelowZeroSell && macdMain >= 0)
   {
      Print("MACD Filter BLOCKED for SELL: MACD (", DoubleToString(macdMain, 5), 
            ") >= 0 (required below zero)");
      return false;
   }
   
   Print("MACD Filter PASSED for SELL: MACD (", DoubleToString(macdMain, 5), 
         ") < Signal (", DoubleToString(macdSignal, 5), ")", 
         (InpMACDRequireBelowZeroSell ? " AND MACD < 0" : ""));
   return true;
}

//+------------------------------------------------------------------+
//| Get current MA value                                             |
//+------------------------------------------------------------------+
double GetMAValue()
{
   if(maHandle == INVALID_HANDLE)
      return -1;
   
   double maBuffer[1];
   ArraySetAsSeries(maBuffer, true);
   
   if(CopyBuffer(maHandle, 0, 0, 1, maBuffer) <= 0)
   {
      Print("Error copying MA buffer: ", GetLastError());
      return -1;
   }
   
   return maBuffer[0];
}

//+------------------------------------------------------------------+
//| Check MA Distance Filter                                         |
//+------------------------------------------------------------------+
bool CheckMADistanceFilter(bool shouldBuy, bool shouldSell, double price)
{
   if(!InpUseMADistanceFilter)
      return true;
   
   if(price <= 0)
      return true;
   
   double maValue = GetMAValue();
   if(maValue <= 0)
   {
      Print("MA Distance Filter: Error getting MA value, allowing trade");
      return true;
   }
   
   if(shouldBuy && price < maValue)
   {
      Print("MA Distance Filter BLOCKED: BUY price below MA");
      return false;
   }
   if(shouldSell && price > maValue)
   {
      Print("MA Distance Filter BLOCKED: SELL price above MA");
      return false;
   }
   
   double distancePercent = (MathAbs(price - maValue) / price) * 100.0;
   if(distancePercent < InpMinMADistancePercent)
   {
      Print("MA Distance Filter BLOCKED: Distance (", DoubleToString(distancePercent, 3),
            "%) < Min (", InpMinMADistancePercent, "%)");
      return false;
   }
   
   if(InpMaxMADistancePercent > 0.0 && distancePercent > InpMaxMADistancePercent)
   {
      Print("MA Distance Filter BLOCKED: Distance (", DoubleToString(distancePercent, 3),
            "%) > Max (", InpMaxMADistancePercent, "%)");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Multi-Timeframe Confirmation                               |
//+------------------------------------------------------------------+
bool CheckMTFConfirm(bool shouldBuy, bool shouldSell)
{
   if(!InpUseMTFConfirm)
      return true;
   
   if(InpMTFConfirmShift < 1)
      return true;
   
   double mtfOpen = iOpen(_Symbol, InpMTFTimeframe, InpMTFConfirmShift);
   double mtfClose = iClose(_Symbol, InpMTFTimeframe, InpMTFConfirmShift);
   
   if(mtfOpen == 0 || mtfClose == 0)
   {
      Print("MTF Confirm: Error getting candle data, allowing trade");
      return true;
   }
   
   bool mtfBullish = (mtfClose > mtfOpen);
   bool mtfBearish = (mtfClose < mtfOpen);
   
   if(shouldBuy && !mtfBullish)
   {
      Print("MTF Confirm BLOCKED: Higher TF candle not bullish");
      return false;
   }
   if(shouldSell && !mtfBearish)
   {
      Print("MTF Confirm BLOCKED: Higher TF candle not bearish");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Breakout Filter                                            |
//+------------------------------------------------------------------+
bool CheckBreakoutFilter(bool shouldBuy, bool shouldSell, double currentAsk, double currentBid)
{
   if(!InpUseBreakoutFilter)
      return true;
   
   if(InpBreakoutLookbackBars < 1)
      return true;
   
   double highestHigh = 0.0;
   double lowestLow = 0.0;
   
   for(int i = 1; i <= InpBreakoutLookbackBars; i++)
   {
      double h = iHigh(_Symbol, InpTimeframe, i);
      double l = iLow(_Symbol, InpTimeframe, i);
      if(h == 0 || l == 0)
         continue;
      if(highestHigh == 0 || h > highestHigh)
         highestHigh = h;
      if(lowestLow == 0 || l < lowestLow)
         lowestLow = l;
   }
   
   if(highestHigh == 0 || lowestLow == 0)
      return true;
   
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double buffer = InpBreakoutBufferPoints * point;
   
   if(shouldBuy && currentAsk < (highestHigh + buffer))
   {
      Print("Breakout Filter BLOCKED: BUY price not above highest high");
      return false;
   }
   if(shouldSell && currentBid > (lowestLow - buffer))
   {
      Print("Breakout Filter BLOCKED: SELL price not below lowest low");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check False Breakout Filter                                      |
//+------------------------------------------------------------------+
bool CheckFalseBreakoutFilter(bool isBullish, bool isBearish, double high1, double low1, double close1)
{
   if(!InpUseFalseBreakoutFilter)
      return true;
   
   if(InpFalseBreakoutLookbackBars < 1)
      return true;
   
   double highestHigh = 0.0;
   double lowestLow = 0.0;
   
   for(int i = 2; i <= InpFalseBreakoutLookbackBars + 1; i++)
   {
      double h = iHigh(_Symbol, InpTimeframe, i);
      double l = iLow(_Symbol, InpTimeframe, i);
      if(h == 0 || l == 0)
         continue;
      if(highestHigh == 0 || h > highestHigh)
         highestHigh = h;
      if(lowestLow == 0 || l < lowestLow)
         lowestLow = l;
   }
   
   if(highestHigh == 0 || lowestLow == 0)
      return true;
   
   if(isBullish && high1 > highestHigh && close1 <= highestHigh)
   {
      Print("False Breakout Filter BLOCKED: Bullish candle failed to close above breakout");
      return false;
   }
   if(isBearish && low1 < lowestLow && close1 >= lowestLow)
   {
      Print("False Breakout Filter BLOCKED: Bearish candle failed to close below breakout");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Tick Volume Filter                                         |
//+------------------------------------------------------------------+
bool CheckTickVolumeFilter()
{
   if(!InpUseTickVolumeFilter)
      return true;
   
   if(InpTickVolumeMAPeriod < 1)
      return true;
   
   long signalVolume = iVolume(_Symbol, InpTimeframe, 1);
   if(signalVolume <= 0)
      return true;
   
   double sum = 0.0;
   int count = 0;
   for(int i = 2; i <= InpTickVolumeMAPeriod + 1; i++)
   {
      long v = iVolume(_Symbol, InpTimeframe, i);
      if(v <= 0)
         continue;
      sum += (double)v;
      count++;
   }
   
   if(count == 0)
      return true;
   
   double avg = sum / count;
   if(signalVolume < avg * InpTickVolumeMultiplier)
   {
      Print("Tick Volume Filter BLOCKED: Volume (", signalVolume,
            ") < MA (", DoubleToString(avg, 0), ") × ", InpTickVolumeMultiplier);
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Low Volatility ATR Filter                                  |
//+------------------------------------------------------------------+
bool CheckLowVolATRFilter(double price)
{
   if(!InpUseLowVolATRFilter)
      return true;
   
   if(price <= 0)
      return true;
   
   if(lowVolAtrHandle == INVALID_HANDLE)
      return true;
   
   double atrBuffer[1];
   ArraySetAsSeries(atrBuffer, true);
   
   if(CopyBuffer(lowVolAtrHandle, 0, 0, 1, atrBuffer) <= 0)
   {
      Print("Low Vol ATR Filter: Error getting ATR value, allowing trade");
      return true;
   }
   
   double atrValue = atrBuffer[0];
   if(atrValue <= 0)
      return true;
   
   double atrPercent = (atrValue / price) * 100.0;
   if(atrPercent < InpLowVolATRMinPercent)
   {
      Print("Low Vol ATR Filter BLOCKED: ATR % (", DoubleToString(atrPercent, 3),
            "%) < Min (", InpLowVolATRMinPercent, "%)");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Get EMA value                                                    |
//+------------------------------------------------------------------+
double GetEMAValue(int handle, int shift)
{
   if(handle == INVALID_HANDLE)
      return -1;
   
   double buffer[1];
   ArraySetAsSeries(buffer, true);
   
   if(CopyBuffer(handle, 0, shift, 1, buffer) <= 0)
   {
      Print("Error copying EMA buffer: ", GetLastError());
      return -1;
   }
   
   return buffer[0];
}

//+------------------------------------------------------------------+
//| Check EMA Filter                                                 |
//+------------------------------------------------------------------+
bool CheckEMAFilter(bool shouldBuy, bool shouldSell)
{
   if(!InpUseEMAFilter)
      return true;
   
   double emaValue = GetEMAValue(emaHandle, 1);
   if(emaValue <= 0)
   {
      Print("EMA Filter: Error getting EMA value, allowing trade");
      return true;
   }
   
   double close1 = iClose(_Symbol, InpTimeframe, 1);
   if(close1 == 0)
      return true;
   
   if(shouldBuy && close1 < emaValue)
   {
      Print("EMA Filter BLOCKED: Close below EMA");
      return false;
   }
   if(shouldSell && close1 > emaValue)
   {
      Print("EMA Filter BLOCKED: Close above EMA");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Higher TF EMA Filter                                       |
//+------------------------------------------------------------------+
bool CheckHigherTFEMAFilter(bool shouldBuy, bool shouldSell)
{
   if(!InpUseHigherTFEMA)
      return true;
   
   double emaValue = GetEMAValue(higherTFEmaHandle, 1);
   if(emaValue <= 0)
   {
      Print("Higher TF EMA: Error getting EMA value, allowing trade");
      return true;
   }
   
   double htClose = iClose(_Symbol, InpHigherTF, 1);
   if(htClose == 0)
      return true;
   
   if(shouldBuy && htClose < emaValue)
   {
      Print("Higher TF EMA BLOCKED: Close below EMA");
      return false;
   }
   if(shouldSell && htClose > emaValue)
   {
      Print("Higher TF EMA BLOCKED: Close above EMA");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Min Body ATR Filter                                        |
//+------------------------------------------------------------------+
bool CheckMinBodyATRFilter(double bodySize)
{
   if(!InpUseMinBodyATR)
      return true;
   
   if(atrHandle == INVALID_HANDLE)
      return true;
   
   double atrBuffer[1];
   ArraySetAsSeries(atrBuffer, true);
   if(CopyBuffer(atrHandle, 0, 1, 1, atrBuffer) <= 0)
   {
      Print("Min Body ATR: Error getting ATR, allowing trade");
      return true;
   }
   
   double atrValue = atrBuffer[0];
   if(atrValue <= 0)
      return true;
   
   if(bodySize < atrValue * InpMinBodyATRMult)
   {
      Print("Min Body ATR BLOCKED: Body (", DoubleToString(bodySize, _Digits),
            ") < ATR (", DoubleToString(atrValue, _Digits), ") × ", InpMinBodyATRMult);
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Breakout Volume Filter                                     |
//+------------------------------------------------------------------+
bool CheckBreakoutVolumeFilter(bool shouldBuy, bool shouldSell)
{
   if(!InpUseBreakoutVolumeFilter)
      return true;
   
   long signalVolume = iVolume(_Symbol, InpTimeframe, 1);
   if(signalVolume <= 0)
      return true;
   
   int lookback = shouldBuy ? InpVolumeLookbackBuy : InpVolumeLookbackSell;
   double mult = shouldBuy ? InpVolumeMultiplierBuy : InpVolumeMultiplierSell;
   if(lookback < 1)
      return true;
   
   double sum = 0.0;
   int count = 0;
   for(int i = 2; i <= lookback + 1; i++)
   {
      long v = iVolume(_Symbol, InpTimeframe, i);
      if(v <= 0)
         continue;
      sum += (double)v;
      count++;
   }
   
   if(count == 0)
      return true;
   
   double avg = sum / count;
   double required = avg * mult * InpAdaptiveVolumeFactor;
   
   if(signalVolume < required)
   {
      Print("Breakout Volume BLOCKED: Volume (", signalVolume,
            ") < Required (", DoubleToString(required, 0), ")");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Range Filter (ATR + Slope)                                 |
//+------------------------------------------------------------------+
bool CheckRangeFilter(bool shouldBuy, bool shouldSell, double rangeSize)
{
   if(!InpUseRangeFilter)
      return true;
   
   if(shouldBuy && longAtrBuyHandle != INVALID_HANDLE)
   {
      double atrBuf[2];
      ArraySetAsSeries(atrBuf, true);
      if(CopyBuffer(longAtrBuyHandle, 0, 1, 2, atrBuf) > 0 && atrBuf[1] > 0)
      {
         double atrCurrent = atrBuf[0];
         double atrPrev = atrBuf[1];
         double slopePercent = ((atrCurrent - atrPrev) / atrPrev) * 100.0;
         
         if(rangeSize < atrCurrent * InpATRMultiplierBuy)
         {
            Print("Range Filter BLOCKED (BUY): Range < ATR × Mult");
            return false;
         }
         if(slopePercent < InpSlopeMultiplierBuy)
         {
            Print("Range Filter BLOCKED (BUY): ATR slope < threshold");
            return false;
         }
      }
   }
   
   if(shouldSell && longAtrSellHandle != INVALID_HANDLE)
   {
      double atrBuf[2];
      ArraySetAsSeries(atrBuf, true);
      if(CopyBuffer(longAtrSellHandle, 0, 1, 2, atrBuf) > 0 && atrBuf[1] > 0)
      {
         double atrCurrent = atrBuf[0];
         double atrPrev = atrBuf[1];
         double slopePercent = ((atrCurrent - atrPrev) / atrPrev) * 100.0;
         
         if(rangeSize < atrCurrent * InpATRMultiplierSell)
         {
            Print("Range Filter BLOCKED (SELL): Range < ATR × Mult");
            return false;
         }
         if(slopePercent < InpSlopeMultiplierSell)
         {
            Print("Range Filter BLOCKED (SELL): ATR slope < threshold");
            return false;
         }
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Momentum Filter                                            |
//+------------------------------------------------------------------+
bool CheckMomentumFilter()
{
   if(!InpUseMomentumFilter)
      return true;
   
   if(InpMomentumLookback < 1)
      return true;
   
   double closeNow = iClose(_Symbol, InpTimeframe, 1);
   double closePast = iClose(_Symbol, InpTimeframe, InpMomentumLookback);
   if(closeNow == 0 || closePast == 0)
      return true;
   
   if(atrHandle == INVALID_HANDLE)
      return true;
   
   double atrBuf[1];
   ArraySetAsSeries(atrBuf, true);
   if(CopyBuffer(atrHandle, 0, 1, 1, atrBuf) <= 0)
      return true;
   
   double atrValue = atrBuf[0];
   if(atrValue <= 0)
      return true;
   
   double momentumAtr = MathAbs(closeNow - closePast) / atrValue;
   if(momentumAtr < InpMinMomentumATR)
   {
      Print("Momentum Filter BLOCKED: Momentum ATR (", DoubleToString(momentumAtr, 3),
            ") < Min (", InpMinMomentumATR, ")");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Volatility Expansion Filter                                |
//+------------------------------------------------------------------+
bool CheckVolatilityExpansion(bool shouldBuy, bool shouldSell)
{
   if(!InpUseVolatilityExpansion)
      return true;
   
   if(atrHandle == INVALID_HANDLE)
      return true;
   
   double atrBuf[1];
   ArraySetAsSeries(atrBuf, true);
   if(CopyBuffer(atrHandle, 0, 1, 1, atrBuf) <= 0)
      return true;
   
   double atrCurrent = atrBuf[0];
   if(atrCurrent <= 0)
      return true;
   
   int lookback = shouldBuy ? InpVolatilityLookbackBuy : InpVolatilityLookbackSell;
   double mult = shouldBuy ? InpMinVolatilityMultBuy : InpMinVolatilityMultSell;
   if(lookback < 2)
      return true;
   
   double sum = 0.0;
   int count = 0;
   for(int i = 2; i <= lookback + 1; i++)
   {
      double buf[1];
      ArraySetAsSeries(buf, true);
      if(CopyBuffer(atrHandle, 0, i, 1, buf) <= 0)
         continue;
      if(buf[0] <= 0)
         continue;
      sum += buf[0];
      count++;
   }
   
   if(count == 0)
      return true;
   
   double avg = sum / count;
   if(atrCurrent < avg * mult)
   {
      Print("Volatility Expansion BLOCKED: ATR < Avg × Mult");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Stochastic Filter                                          |
//+------------------------------------------------------------------+
bool CheckStochasticFilter(bool shouldBuy, bool shouldSell)
{
   if(!InpUseStochasticFilter)
      return true;
   
   if(stochHandle == INVALID_HANDLE)
      return true;
   
   double kBuf[1];
   ArraySetAsSeries(kBuf, true);
   if(CopyBuffer(stochHandle, 0, 1, 1, kBuf) <= 0)
      return true;
   
   double kValue = kBuf[0];
   if(shouldBuy && kValue > InpStochBuyLevel)
   {
      Print("Stochastic Filter BLOCKED: K > Buy Level");
      return false;
   }
   if(shouldSell && kValue < InpStochSellLevel)
   {
      Print("Stochastic Filter BLOCKED: K < Sell Level");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Doji Filter                                                |
//+------------------------------------------------------------------+
bool CheckDojiFilter(double open1, double close1, double high1, double low1, double rangePercent, double bodyToRangePercent)
{
   if(!InpUseDojiFilter)
      return true;
   
   if(rangePercent < InpDojiMinRangePercent)
      return true;
   
   double rangeSize = high1 - low1;
   if(rangeSize <= 0)
      return true;
   
   double upperShadow = high1 - MathMax(open1, close1);
   double lowerShadow = MathMin(open1, close1) - low1;
   
   double upperPercent = (upperShadow / rangeSize) * 100.0;
   double lowerPercent = (lowerShadow / rangeSize) * 100.0;
   
   if(bodyToRangePercent <= InpDojiBodyPercent &&
      upperPercent >= InpDojiUpperShadowPercent &&
      lowerPercent >= InpDojiLowerShadowPercent)
   {
      Print("Doji Filter BLOCKED: Candle resembles doji");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check ATR Average Filter                                         |
//+------------------------------------------------------------------+
bool CheckATRAverageFilter()
{
   if(!InpUseATRAverageFilter)
      return true;
   
   if(atrAverageHandle == INVALID_HANDLE)
      return true;
   
   double atrCurrentBuf[1];
   ArraySetAsSeries(atrCurrentBuf, true);
   if(CopyBuffer(atrAverageHandle, 0, 1, 1, atrCurrentBuf) <= 0)
      return true;
   
   double atrCurrent = atrCurrentBuf[0];
   if(atrCurrent <= 0)
      return true;
   
   double sum = 0.0;
   int count = 0;
   for(int i = 2; i <= InpATRAveragePeriod + 1; i++)
   {
      double buf[1];
      ArraySetAsSeries(buf, true);
      if(CopyBuffer(atrAverageHandle, 0, i, 1, buf) <= 0)
         continue;
      if(buf[0] <= 0)
         continue;
      sum += buf[0];
      count++;
   }
   
   if(count == 0)
      return true;
   
   double avg = sum / count;
   if(atrCurrent < avg * InpATRAverageMultiplier)
   {
      Print("ATR Average Filter BLOCKED: ATR < Avg × Mult");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Advanced Quality Filters                                         |
//+------------------------------------------------------------------+

//--- Helper: read OHLC for a given shift on InpTimeframe
bool GetCandleOHLC(const int shift, double &o, double &c, double &h, double &l)
{
   o = iOpen(_Symbol, InpTimeframe, shift);
   c = iClose(_Symbol, InpTimeframe, shift);
   h = iHigh(_Symbol, InpTimeframe, shift);
   l = iLow(_Symbol, InpTimeframe, shift);
   return (o != 0.0 && c != 0.0 && h != 0.0 && l != 0.0);
}

// 1) Context Extreme Filter: only trade near 24h extremes
bool CheckContextExtremeFilter(const bool shouldBuy, const bool shouldSell, const double priceRef)
{
   if(!InpUseContextExtremeFilter)
      return true;

   int tfSec = (int)PeriodSeconds(InpTimeframe);
   if(tfSec <= 0)
      return true;

   int barsNeeded = (InpContextLookbackMinutes * 60) / tfSec;
   if(barsNeeded < 10)
      barsNeeded = 10;

   // Use shift=1 .. barsNeeded (closed bars only)
   double hh = -DBL_MAX;
   double ll = DBL_MAX;
   for(int i = 1; i <= barsNeeded; i++)
   {
      double hi = iHigh(_Symbol, InpTimeframe, i);
      double lo = iLow(_Symbol, InpTimeframe, i);
      if(hi == 0.0 || lo == 0.0)
         continue;
      if(hi > hh) hh = hi;
      if(lo < ll) ll = lo;
   }

   if(hh <= ll || hh == -DBL_MAX || ll == DBL_MAX)
      return true;

   double rng = hh - ll;
   double buyZoneTop  = ll + rng * (InpContextBuyZonePct  / 100.0);
   double sellZoneBot = hh - rng * (InpContextSellZonePct / 100.0);

   if(shouldBuy && priceRef > buyZoneTop)
   {
      Print("Context Extreme BLOCKED: BUY not in bottom zone. Price=", priceRef,
            " ZoneTop=", buyZoneTop, " 24hLow=", ll, " 24hHigh=", hh);
      return false;
   }
   if(shouldSell && priceRef < sellZoneBot)
   {
      Print("Context Extreme BLOCKED: SELL not in top zone. Price=", priceRef,
            " ZoneBot=", sellZoneBot, " 24hLow=", ll, " 24hHigh=", hh);
      return false;
   }
   return true;
}

// 2) Impulse -> Pause -> Entry Filter
//    Uses impulse candle at shift=2, pause candle at shift=1. Entry happens at shift=0.
bool CheckImpulsePauseFilter(double impulseHigh, double impulseLow)
{
   if(!InpUseImpulsePauseFilter)
      return true;

   double o1,c1,h1,l1;
   if(!GetCandleOHLC(1, o1,c1,h1,l1))
      return false;

   double range1 = h1 - l1;
   if(range1 <= 0.0)
      return false;

   double body1 = MathAbs(c1 - o1);
   double bodyToRange1 = (body1 / range1) * 100.0;

   if(bodyToRange1 > InpPauseMaxBodyToRangePct)
   {
      Print("Impulse->Pause BLOCKED: Pause candle too strong (Body/Range=", DoubleToString(bodyToRange1,2),
            " > ", InpPauseMaxBodyToRangePct, ")");
      return false;
   }

   if(InpPauseMaxRangePercent > 0.0 && o1 > 0.0)
   {
      double rangePercent1 = (range1 / o1) * 100.0;
      if(rangePercent1 > InpPauseMaxRangePercent)
      {
         Print("Impulse->Pause BLOCKED: Pause range% too large (", DoubleToString(rangePercent1,2),
               " > ", InpPauseMaxRangePercent, ")");
         return false;
      }
   }

   if(InpPauseRequireInsideBar)
   {
      if(h1 > impulseHigh || l1 < impulseLow)
      {
         Print("Impulse->Pause BLOCKED: Pause is not inside impulse range");
         return false;
      }
   }

   return true;
}

// 3) Range Regime Filter: trade only in expansion after compression
bool CheckRangeRegimeFilter()
{
   if(!InpUseRangeRegimeFilter)
      return true;

   // Use built-in ATR on the trading symbol/timeframe
   int atrSHandle = iATR(_Symbol, InpTimeframe, InpRangeRegimeShortATR);
   int atrLHandle = iATR(_Symbol, InpTimeframe, InpRangeRegimeLongATR);
   if(atrSHandle == INVALID_HANDLE || atrLHandle == INVALID_HANDLE)
      return true;

   double sBuf[1], lBuf[1];
   ArraySetAsSeries(sBuf, true);
   ArraySetAsSeries(lBuf, true);
   bool okS = (CopyBuffer(atrSHandle, 0, 1, 1, sBuf) > 0);
   bool okL = (CopyBuffer(atrLHandle, 0, 1, 1, lBuf) > 0);
   IndicatorRelease(atrSHandle);
   IndicatorRelease(atrLHandle);
   if(!okS || !okL)
      return true;

   double atrS = sBuf[0];
   double atrL = lBuf[0];
   if(atrS <= 0.0 || atrL <= 0.0)
      return true;

   if(atrS < atrL * InpRangeRegimeExpansionMult)
   {
      Print("Range Regime BLOCKED: ShortATR < LongATR * Mult (", DoubleToString(atrS, _Digits),
            " < ", DoubleToString(atrL*InpRangeRegimeExpansionMult, _Digits), ")");
      return false;
   }

   return true;
}

// 4) Daily Bias Filter
bool CheckDailyBiasFilter(bool &shouldBuy, bool &shouldSell, const double priceRef)
{
   if(InpDailyBiasMode == DAILY_BIAS_OFF)
      return true;

   if(InpDailyBiasMode == DAILY_BIAS_DAILY_OPEN)
   {
      double dayOpen = iOpen(_Symbol, PERIOD_D1, 0);
      if(dayOpen <= 0.0)
         return true;

      double buffer = 0.0;
      if(InpDailyBiasBufferPct > 0.0)
         buffer = dayOpen * (InpDailyBiasBufferPct / 100.0);

      if(priceRef > dayOpen + buffer)
      {
         // Bias = up
         if(shouldSell)
         {
            Print("Daily Bias BLOCKED: Price above Daily Open -> SELL blocked");
            shouldSell = false;
         }
      }
      else if(priceRef < dayOpen - buffer)
      {
         // Bias = down
         if(shouldBuy)
         {
            Print("Daily Bias BLOCKED: Price below Daily Open -> BUY blocked");
            shouldBuy = false;
         }
      }
      // Inside buffer zone: no bias restriction
   }

   // If both directions became false, block the trade
   if(!shouldBuy && !shouldSell)
      return false;

   return true;
}

//--- Helper: find latest confirmed swing low/high time
datetime FindLatestSwingLowTime(const int lookbackBars, const int pivot)
{
   int maxBars = MathMax(lookbackBars, pivot*2 + 5);
   for(int i = pivot + 2; i <= maxBars - pivot; i++)
   {
      double center = iLow(_Symbol, InpTimeframe, i);
      if(center == 0.0)
         continue;
      bool isLow = true;
      for(int k = 1; k <= pivot; k++)
      {
         double left = iLow(_Symbol, InpTimeframe, i + k);
         double right = iLow(_Symbol, InpTimeframe, i - k);
         if(left == 0.0 || right == 0.0)
            continue;
         if(center >= left || center >= right)
         {
            isLow = false;
            break;
         }
      }
      if(isLow)
         return iTime(_Symbol, InpTimeframe, i);
   }
   return 0;
}

datetime FindLatestSwingHighTime(const int lookbackBars, const int pivot)
{
   int maxBars = MathMax(lookbackBars, pivot*2 + 5);
   for(int i = pivot + 2; i <= maxBars - pivot; i++)
   {
      double center = iHigh(_Symbol, InpTimeframe, i);
      if(center == 0.0)
         continue;
      bool isHigh = true;
      for(int k = 1; k <= pivot; k++)
      {
         double left = iHigh(_Symbol, InpTimeframe, i + k);
         double right = iHigh(_Symbol, InpTimeframe, i - k);
         if(left == 0.0 || right == 0.0)
            continue;
         if(center <= left || center <= right)
         {
            isHigh = false;
            break;
         }
      }
      if(isHigh)
         return iTime(_Symbol, InpTimeframe, i);
   }
   return 0;
}

// 5) One-shot per direction per swing
bool CheckOneShotSwingFilter(const bool shouldBuy, const bool shouldSell)
{
   if(!InpUseOneShotSwingFilter)
      return true;

   if(shouldBuy)
   {
      datetime latestSwingLow = FindLatestSwingLowTime(InpSwingLookbackBars, InpSwingPivot);
      if(lastBuyTradeTime > 0 && (latestSwingLow == 0 || latestSwingLow <= lastBuyTradeTime))
      {
         Print("One-Shot Swing BLOCKED: BUY already taken in current swing");
         return false;
      }
   }
   if(shouldSell)
   {
      datetime latestSwingHigh = FindLatestSwingHighTime(InpSwingLookbackBars, InpSwingPivot);
      if(lastSellTradeTime > 0 && (latestSwingHigh == 0 || latestSwingHigh <= lastSellTradeTime))
      {
         Print("One-Shot Swing BLOCKED: SELL already taken in current swing");
         return false;
      }
   }
   return true;
}

//+------------------------------------------------------------------+
//| Check candle conditions and open position if valid              |
//+------------------------------------------------------------------+
void CheckCandleAndTrade()
{
   //--- Signal candle selection
   // If Impulse->Pause filter is enabled, the impulse candle is shift=2 and the pause candle is shift=1.
   int signalShift = (InpUseImpulsePauseFilter ? 2 : 1);

   //--- Get signal candle (closed)
   double open1, close1, high1, low1;
   if(!GetCandleOHLC(signalShift, open1, close1, high1, low1))
   {
      Print("Error: Could not get signal candle data (shift=", signalShift, ")");
      return;
   }
   
   //--- Calculate body and range sizes
   double bodySize = MathAbs(close1 - open1);
   double rangeSize = high1 - low1;
   
   //--- Convert to percentage of opening price
   double bodyPercent = (open1 > 0) ? (bodySize / open1) * 100.0 : 0.0;
   double rangePercent = (open1 > 0) ? (rangeSize / open1) * 100.0 : 0.0;
   
   //--- Calculate body to range ratio (as percentage)
   double bodyToRangeRatio = (rangeSize > 0) ? (bodySize / rangeSize) * 100.0 : 0.0;
   
   Print("Signal Candle Analysis (shift=", signalShift, "):");
   Print("  Open: ", open1, " | Close: ", close1, " | High: ", high1, " | Low: ", low1);
   Print("  Body: ", DoubleToString(bodyPercent, 2), "% | Range: ", DoubleToString(rangePercent, 2), "%");
   Print("  Body to Range Ratio: ", DoubleToString(bodyToRangeRatio, 2), "%");
   
   //--- Check conditions
   bool isValidCandle = true;
   
   //--- Condition 1: Minimum body size
   if(bodyPercent < InpMinBodyPercent)
   {
      Print("Candle REJECTED: Body size (", DoubleToString(bodyPercent, 2), "%) is less than minimum (", InpMinBodyPercent, "%)");
      isValidCandle = false;
   }
   
   //--- Condition 2: Maximum body size
   if(isValidCandle && bodyPercent > InpMaxBodyPercent)
   {
      Print("Candle REJECTED: Body size (", DoubleToString(bodyPercent, 2), "%) is greater than maximum (", InpMaxBodyPercent, "%)");
      isValidCandle = false;
   }
   
   //--- Condition 3: Minimum range size
   if(isValidCandle && rangePercent < InpMinRangePercent)
   {
      Print("Candle REJECTED: Range size (", DoubleToString(rangePercent, 2), "%) is less than minimum (", InpMinRangePercent, "%)");
      isValidCandle = false;
   }
   
   //--- Condition 4: Maximum range size
   if(isValidCandle && rangePercent > InpMaxRangePercent)
   {
      Print("Candle REJECTED: Range size (", DoubleToString(rangePercent, 2), "%) is greater than maximum (", InpMaxRangePercent, "%)");
      isValidCandle = false;
   }
   
   //--- Condition 5: Body to Range ratio
   if(isValidCandle && bodyToRangeRatio < InpBodyToRangePercent)
   {
      Print("Candle REJECTED: Body to Range ratio (", DoubleToString(bodyToRangeRatio, 2), "%) is less than minimum (", InpBodyToRangePercent, "%)");
      isValidCandle = false;
   }
   
   if(!isValidCandle)
   {
      Print("Candle is INVALID - No position will be opened");
      return;
   }
   
   Print("Candle is VALID - Checking for trade signal...");

   //--- If Impulse->Pause filter is enabled, validate the pause candle at shift=1
   if(!CheckImpulsePauseFilter(high1, low1))
   {
      return;
   }
   
   //--- Check Doji filter
   if(!CheckDojiFilter(open1, close1, high1, low1, rangePercent, bodyToRangeRatio))
   {
      return;
   }
   
   //--- Check Min Body ATR filter
   if(!CheckMinBodyATRFilter(bodySize))
   {
      return;
   }
   
   //--- Check ATR filter
   if(!CheckATRFilter(rangeSize))
   {
      Print("ATR Filter: Candle range is NOT strong enough - No position will be opened");
      return;
   }

   //--- Check Range Regime filter (expansion after compression)
   if(!CheckRangeRegimeFilter())
   {
      return;
   }
   
   //--- Check ADX filter
   if(!CheckADXFilter())
   {
      Print("ADX Filter: ADX is below required level - No position will be opened");
      return;
   }
   
   //--- Check trading session filter
   if(!IsTradingSessionAllowed())
   {
      Print("Trading session filter: Current time is NOT in allowed trading session - No position will be opened");
      return;
   }
   
   //--- Check if we can open new position (max positions limit)
   int openPositionsCount = CountOpenPositions();
   if(openPositionsCount >= InpMaxOpenPositions)
   {
      Print("Maximum open positions (", InpMaxOpenPositions, ") reached. Current: ", openPositionsCount, " - No new position will be opened");
      return;
   }
   
   //--- Check re-entry delay
   if(InpReEntrySeconds > 0 && (TimeCurrent() - lastTradeTime) < InpReEntrySeconds)
   {
      Print("Re-entry delay active (", InpReEntrySeconds, "s) - No position will be opened");
      return;
   }
   
   //--- Determine candle direction
   bool isBullish = (close1 > open1);
   bool isBearish = (close1 < open1);
   
   if(!isBullish && !isBearish)
   {
      Print("Candle is DOJI (no direction) - No position will be opened");
      return;
   }
   
   //--- Get current price for calculating stop loss
   double currentAsk = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double currentBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   //--- Determine trade direction (considering Upside Down mode)
   bool shouldBuy = isBullish;
   bool shouldSell = isBearish;
   
   //--- If Upside Down mode is enabled, reverse the direction
   if(InpUpsideDown)
   {
      shouldBuy = isBearish;  // After bearish candle -> BUY
      shouldSell = isBullish; // After bullish candle -> SELL
   }

   //--- Daily Bias filter (may disable one side)
   double biasPriceRef = (shouldBuy ? currentAsk : currentBid);
   if(!CheckDailyBiasFilter(shouldBuy, shouldSell, biasPriceRef))
   {
      Print("Daily Bias: Both directions blocked - No position will be opened");
      return;
   }

   //--- One-shot per direction per swing
   if(!CheckOneShotSwingFilter(shouldBuy, shouldSell))
   {
      return;
   }

   //--- Check EMA filter
   if(!CheckEMAFilter(shouldBuy, shouldSell))
   {
      return;
   }
   
   //--- Check Higher TF EMA filter
   if(!CheckHigherTFEMAFilter(shouldBuy, shouldSell))
   {
      return;
   }
   
   //--- Check Range filter (ATR + Slope)
   if(!CheckRangeFilter(shouldBuy, shouldSell, rangeSize))
   {
      return;
   }
   
   //--- Check Momentum filter
   if(!CheckMomentumFilter())
   {
      return;
   }
   
   //--- Check Volatility Expansion filter
   if(!CheckVolatilityExpansion(shouldBuy, shouldSell))
   {
      return;
   }
   
   //--- Check Stochastic filter
   if(!CheckStochasticFilter(shouldBuy, shouldSell))
   {
      return;
   }
   
   //--- Check ATR Average filter
   if(!CheckATRAverageFilter())
   {
      return;
   }
   
   //--- Check ATR MA Slope filter
   if(shouldBuy && !CheckATRMASlopeForBuy())
   {
      Print("ATR MA Slope Filter: Slope condition not met for BUY - No position will be opened");
      return;
   }
   
   if(shouldSell && !CheckATRMASlopeForSell())
   {
      Print("ATR MA Slope Filter: Slope condition not met for SELL - No position will be opened");
      return;
   }
   
   //--- Check MACD filter
   if(shouldBuy && !CheckMACDFilterForBuy())
   {
      Print("MACD Filter: MACD condition not met for BUY - No position will be opened");
      return;
   }
   
   if(shouldSell && !CheckMACDFilterForSell())
   {
      Print("MACD Filter: MACD condition not met for SELL - No position will be opened");
      return;
   }
   
   //--- Check RSI filter
   if(InpUseRSIFilter)
   {
      double rsiValue = GetRSIValue();
      if(rsiValue != -1) // -1 means error
      {
         if(shouldBuy && rsiValue >= InpRSIUpperLevel)
         {
            Print("RSI Filter: RSI (", DoubleToString(rsiValue, 2), ") >= Upper Level (", InpRSIUpperLevel, ") - BUY blocked");
            return;
         }
         if(shouldSell && rsiValue <= InpRSILowerLevel)
         {
            Print("RSI Filter: RSI (", DoubleToString(rsiValue, 2), ") <= Lower Level (", InpRSILowerLevel, ") - SELL blocked");
            return;
         }
      }
   }
   
   //--- Check Breakout Volume filter
   if(!CheckBreakoutVolumeFilter(shouldBuy, shouldSell))
   {
      return;
   }
   
   //--- Check MTF confirmation
   if(!CheckMTFConfirm(shouldBuy, shouldSell))
   {
      return;
   }
   
   //--- Check Breakout filter
   if(!CheckBreakoutFilter(shouldBuy, shouldSell, currentAsk, currentBid))
   {
      return;
   }
   
   //--- Check False Breakout filter (uses previous candle data)
   if(!CheckFalseBreakoutFilter(isBullish, isBearish, high1, low1, close1))
   {
      return;
   }
   
   //--- Check Tick Volume filter
   if(!CheckTickVolumeFilter())
   {
      return;
   }
   
   //--- Determine entry price based on direction
   double entryPrice = 0.0;
   if(shouldBuy)
      entryPrice = currentAsk;
   else if(shouldSell)
      entryPrice = currentBid;

   //--- Context Extreme filter (24h range position)
   if(!CheckContextExtremeFilter(shouldBuy, shouldSell, entryPrice))
   {
      return;
   }

   //--- Context Extreme filter (24h range position)
   if(!CheckContextExtremeFilter(shouldBuy, shouldSell, entryPrice))
   {
      return;
   }

   //--- Context Extreme filter (24h range position)
   if(!CheckContextExtremeFilter(shouldBuy, shouldSell, entryPrice))
   {
      return;
   }

   //--- Daily Bias filter (may disable one side)
   if(!CheckDailyBiasFilter(shouldBuy, shouldSell, entryPrice))
   {
      return;
   }

   // If Daily Bias turned off one direction, recompute entry price
   if(shouldBuy)
      entryPrice = currentAsk;
   else if(shouldSell)
      entryPrice = currentBid;
   
   //--- Check MA distance filter
   if(!CheckMADistanceFilter(shouldBuy, shouldSell, entryPrice))
   {
      return;
   }
   
   //--- Check Low Volatility ATR filter
   if(!CheckLowVolATRFilter(entryPrice))
   {
      return;
   }
   
   //--- Calculate Stop Loss distance based on settings
   double stopLossDistance = 0.0;
   switch(InpStopLossMode)
   {
      case SL_MODE_CANDLE:
         if(InpStopLossType == SL_TYPE_BODY)
            stopLossDistance = bodySize * (InpStopLossPercent / 100.0);
         else
            stopLossDistance = rangeSize * (InpStopLossPercent / 100.0);
         break;
      case SL_MODE_ENTRY_PERCENT:
         stopLossDistance = entryPrice * (InpStopLossEntryPercent / 100.0);
         break;
      case SL_MODE_ENTRY_FIXED:
         stopLossDistance = InpStopLossFixedAmount;
         break;
   }
   
   if(stopLossDistance <= 0.0)
   {
      Print("Stop Loss distance is invalid (", stopLossDistance, ") - No position will be opened");
      return;
   }
   
   //--- Open position at the beginning of current candle
   double stopLoss = 0.0;
   
   if(shouldBuy)
   {
      //--- BUY position: Stop loss below entry price
      stopLoss = entryPrice - stopLossDistance;
      Print(InpUpsideDown ? "Upside Down Mode: " : "", "Opening BUY position | SL Distance: ", DoubleToString(stopLossDistance, _Digits));
      OpenPosition(ORDER_TYPE_BUY, stopLoss);
   }
   else if(shouldSell)
   {
      //--- SELL position: Stop loss above entry price
      stopLoss = entryPrice + stopLossDistance;
      Print(InpUpsideDown ? "Upside Down Mode: " : "", "Opening SELL position | SL Distance: ", DoubleToString(stopLossDistance, _Digits));
      OpenPosition(ORDER_TYPE_SELL, stopLoss);
   }
}

//+------------------------------------------------------------------+
//| Calculate lot size based on equity risk and stop loss            |
//+------------------------------------------------------------------+
double CalculateLotSize(double entryPrice, double stopLoss, ENUM_ORDER_TYPE orderType)
{
   //--- If equity risk is 0, use fixed lot size
   if(InpEquityRiskPercent <= 0)
   {
      return InpMinLotSize;
   }
   
   //--- Get equity
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   if(equity <= 0)
   {
      Print("Error: Invalid equity, using minimum lot size");
      return InpMinLotSize;
   }
   
   //--- Calculate risk amount in account currency
   double riskAmount = equity * (InpEquityRiskPercent / 100.0);
   
   //--- Calculate stop loss distance in price
   double stopLossDistance = 0.0;
   if(orderType == ORDER_TYPE_BUY)
   {
      stopLossDistance = MathAbs(entryPrice - stopLoss);
   }
   else
   {
      stopLossDistance = MathAbs(stopLoss - entryPrice);
   }
   
   if(stopLossDistance <= 0)
   {
      Print("Error: Invalid stop loss distance, using minimum lot size");
      return InpMinLotSize;
   }
   
   //--- Get contract size and tick value
   double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   if(contractSize <= 0 || tickValue <= 0 || tickSize <= 0)
   {
      Print("Error: Invalid symbol parameters, using minimum lot size");
      return InpMinLotSize;
   }
   
   //--- Calculate lot size: Risk Amount / (Stop Loss Distance / Tick Size * Tick Value)
   double ticks = stopLossDistance / tickSize;
   double moneyPerLot = ticks * tickValue;
   
   if(moneyPerLot <= 0)
   {
      Print("Error: Invalid money per lot calculation, using minimum lot size");
      return InpMinLotSize;
   }
   
   double calculatedLot = riskAmount / moneyPerLot;
   
   //--- Ensure minimum lot size
   calculatedLot = MathMax(calculatedLot, InpMinLotSize);
   
   //--- Normalize lot size
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   
   calculatedLot = MathFloor(calculatedLot / lotStep) * lotStep;
   calculatedLot = MathMax(minLot, MathMin(maxLot, calculatedLot));
   
   return calculatedLot;
}

//+------------------------------------------------------------------+
//| Open a position                                                  |
//+------------------------------------------------------------------+
void OpenPosition(ENUM_ORDER_TYPE orderType, double stopLoss)
{
   //--- Get entry price
   double entryPrice = 0.0;
   if(orderType == ORDER_TYPE_BUY)
   {
      entryPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   }
   else
   {
      entryPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   }
   
   //--- Calculate lot size
   double lotSize = CalculateLotSize(entryPrice, stopLoss, orderType);
   
   //--- Normalize and validate stop loss
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   long stopLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double minStopDistance = stopLevel * point;
   
   double normalizedSL = NormalizeDouble(stopLoss, digits);
   
   //--- Ensure stop loss is at valid distance
   if(orderType == ORDER_TYPE_BUY)
   {
      if(stopLevel > 0 && (entryPrice - normalizedSL) < minStopDistance)
      {
         normalizedSL = NormalizeDouble(entryPrice - minStopDistance, digits);
      }
   }
   else
   {
      if(stopLevel > 0 && (normalizedSL - entryPrice) < minStopDistance)
      {
         normalizedSL = NormalizeDouble(entryPrice + minStopDistance, digits);
      }
   }
   
   //--- Calculate Take Profit if specified
   double takeProfit = 0.0;
   if(InpTakeProfitPercent > 0.0)
   {
      if(orderType == ORDER_TYPE_BUY)
      {
         //--- BUY: TP = Entry * (1 + TP%/100)
         takeProfit = entryPrice * (1.0 + InpTakeProfitPercent / 100.0);
      }
      else
      {
         //--- SELL: TP = Entry * (1 - TP%/100)
         takeProfit = entryPrice * (1.0 - InpTakeProfitPercent / 100.0);
      }
      takeProfit = NormalizeDouble(takeProfit, digits);
      
      //--- Validate TP distance
      if(orderType == ORDER_TYPE_BUY)
      {
         if(stopLevel > 0 && (takeProfit - entryPrice) < minStopDistance)
         {
            takeProfit = NormalizeDouble(entryPrice + minStopDistance, digits);
         }
      }
      else
      {
         if(stopLevel > 0 && (entryPrice - takeProfit) < minStopDistance)
         {
            takeProfit = NormalizeDouble(entryPrice - minStopDistance, digits);
         }
      }
   }
   
   //--- Prepare trade request
   MqlTradeRequest request = {};
   MqlTradeResult  result = {};
   
   //--- Get current bar time to store in comment (for closing at end of candle)
   datetime currentBarTime = iTime(_Symbol, InpTimeframe, 0);
   string commentText = "CandleBodyRangeEA_" + TimeToString(currentBarTime, TIME_DATE|TIME_MINUTES);
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lotSize;
   request.type = orderType;
   request.deviation = 10;
   request.magic = InpMagicNumber;
   request.comment = commentText;
   
   //--- Set price
   request.price = entryPrice;
   
   //--- Set stop loss
   request.sl = normalizedSL;
   
   //--- Set take profit (if specified)
   if(takeProfit > 0.0)
   {
      request.tp = takeProfit;
   }
   
   //--- Send order
   if(!OrderSend(request, result))
   {
      Print("Error opening position: ", GetLastError());
      return;
   }
   
   if(result.retcode == TRADE_RETCODE_DONE)
   {
      lastTradeTime = TimeCurrent();
      if(orderType == ORDER_TYPE_BUY)
         lastBuyTradeTime = lastTradeTime;
      else if(orderType == ORDER_TYPE_SELL)
         lastSellTradeTime = lastTradeTime;
      Print("Position opened: ", EnumToString(orderType), 
            " Volume: ", lotSize, 
            " Entry: ", entryPrice, 
            " SL: ", normalizedSL);
      if(takeProfit > 0.0)
      {
         Print("  TP: ", takeProfit);
      }
      else
      {
         Print("  TP: Close at End of Candle");
      }
      Print("  Ticket: ", result.order, " | Open Positions: ", CountOpenPositions(), "/", InpMaxOpenPositions);
   }
   else
   {
      Print("Order failed: ", result.retcode, " - ", result.comment);
   }
}

//+------------------------------------------------------------------+
//| Check position status                                            |
//+------------------------------------------------------------------+
void CheckPositionStatus()
{
   //--- Only check if Take Profit is 0 (need to close at end of candle)
   if(InpTakeProfitPercent != 0.0)
   {
      return; // Positions with TP will be closed automatically by broker
   }
   
   //--- Get current bar time
   datetime currentBarTime = iTime(_Symbol, InpTimeframe, 0);
   
   //--- This function is only called when a new bar has formed (from OnTick)
   //--- So we can safely check positions to close
   
   //--- Check all open positions
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(!PositionSelectByTicket(ticket))
         continue;
      
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)
         continue;
      
      if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber)
         continue;
      
      //--- Get position open time from position properties
      datetime positionOpenTime = (datetime)PositionGetInteger(POSITION_TIME);
      datetime positionBarTime = 0;
      
      //--- Find the bar that contains the open time using history
      if(positionOpenTime > 0)
      {
         //--- Get the bar index for the position open time
         int barShift = iBarShift(_Symbol, InpTimeframe, positionOpenTime);
         if(barShift >= 0)
         {
            //--- Get the bar time
            positionBarTime = iTime(_Symbol, InpTimeframe, barShift);
         }
      }
      
      //--- If we still couldn't get it, try parsing from comment
      if(positionBarTime == 0)
      {
         string comment = PositionGetString(POSITION_COMMENT);
         //--- Parse comment to get bar time (format: "CandleBodyRangeEA_YYYY.MM.DD HH:MM")
         if(StringFind(comment, "CandleBodyRangeEA_") >= 0)
         {
            string timeStr = StringSubstr(comment, StringLen("CandleBodyRangeEA_"));
            positionBarTime = StringToTime(timeStr);
         }
      }
      
      //--- If still couldn't get it, calculate from open time
      if(positionBarTime == 0 && positionOpenTime > 0)
      {
         //--- Round position open time to the start of the bar
         long periodSeconds = PeriodSeconds(InpTimeframe);
         positionBarTime = positionOpenTime - (positionOpenTime % periodSeconds);
      }
      
      //--- Calculate the next bar time after position bar
      long periodSeconds = PeriodSeconds(InpTimeframe);
      datetime nextBarAfterPosition = positionBarTime + periodSeconds;
      
      //--- Close position only if we're in a new bar that started AFTER the position's bar ended
      //--- This means: currentBarTime > positionBarTime (we're in a future bar)
      if(positionBarTime > 0 && currentBarTime >= nextBarAfterPosition)
      {
         Print("End of candle reached - Closing position (Take Profit = 0) | Ticket: ", ticket, 
               " | Position opened in bar: ", TimeToString(positionBarTime), 
               " | Current bar: ", TimeToString(currentBarTime));
         ClosePosition(ticket);
      }
   }
}

//+------------------------------------------------------------------+
//| Close position                                                   |
//+------------------------------------------------------------------+
void ClosePosition(ulong ticket)
{
   if(!PositionSelectByTicket(ticket))
   {
      return;
   }
   
   //--- Get profit before closing
   double profit = PositionGetDouble(POSITION_PROFIT);
   
   MqlTradeRequest request = {};
   MqlTradeResult  result = {};
   
   request.action = TRADE_ACTION_DEAL;
   request.position = ticket;
   request.symbol = _Symbol;
   request.volume = PositionGetDouble(POSITION_VOLUME);
   request.deviation = 10;
   request.magic = InpMagicNumber;
   request.comment = PositionGetString(POSITION_COMMENT);
   
   if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
   {
      request.type = ORDER_TYPE_SELL;
      request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   }
   else
   {
      request.type = ORDER_TYPE_BUY;
      request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   }
   
   if(!OrderSend(request, result))
   {
      Print("Error closing position: ", GetLastError());
   }
   else
   {
      Print("Position closed: Ticket ", ticket, " Profit: ", profit, " | Remaining Open Positions: ", CountOpenPositions());
   }
}

//+------------------------------------------------------------------+
//| Count open positions with our magic number                      |
//+------------------------------------------------------------------+
int CountOpenPositions()
{
   int count = 0;
   
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
      
      if(!PositionSelectByTicket(ticket))
         continue;
      
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)
         continue;
      
      if(PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
      {
         count++;
      }
   }
   
   return count;
}

//+------------------------------------------------------------------+

