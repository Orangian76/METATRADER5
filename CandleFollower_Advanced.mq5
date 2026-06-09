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
   SESSION_NEW_YORK_ONLY = 0,        // New York Only (16:30-23:00)
   SESSION_LONDON_NEW_YORK = 1,      // London + New York (09:00-23:00)
   SESSION_LONDON_OPEN_NY_CLOSE = 2, // London Open to NY Close (08:00-23:00)
   SESSION_ALL_TIMES = 3             // All Times (No Filter)
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

//--- Trading Direction Settings
input bool InpUpsideDown = false;                           // Upside Down Mode (Reverse Trade Direction)

//--- Take Profit Settings
input double InpTakeProfitPercent = 0.0;                    // Take Profit % (0 = Close at End of Candle)

//--- Position Management
input int InpMaxOpenPositions = 1;                          // Maximum Open Positions Simultaneously

//--- Magic Number
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
input double InpADXMinLevel = 25.0;                         // Minimum ADX Level
input bool InpUseADXDirection = false;                      // Use ADX Directional Filter (+DI/-DI)
input bool InpADXDirectionFollowTrend = true;               // Follow ADX Direction (true=trend, false=counter)

//--- Volume Filter Settings
input bool InpUseVolumeFilter = false;                      // Use Volume Filter
input int InpVolumePeriod = 20;                             // Volume Average Period
input double InpVolumeMultiplier = 1.5;                     // Volume Multiplier (Current > Avg × Multiplier)

//--- Moving Average Trend Filter Settings
input bool InpUseMAFilter = false;                          // Use MA Trend Filter
input int InpMAPeriod = 50;                                 // MA Period
input ENUM_MA_METHOD InpMAMethod = MODE_SMA;                // MA Method
input bool InpMAFollowTrend = true;                         // Follow MA Trend (true=trend, false=counter)

//--- Momentum Filter Settings
input bool InpUseMomentumFilter = false;                    // Use Momentum Filter
input int InpMomentumPeriod = 14;                           // Momentum Period
input double InpMomentumThreshold = 100.0;                  // Momentum Threshold (100 = neutral)

//--- Candle Pattern Filter Settings
input bool InpUseCandlePatternFilter = false;               // Use Candle Pattern Filter
input bool InpRequireEngulfing = false;                     // Require Engulfing Pattern
input bool InpRequirePinBar = false;                        // Require Pin Bar Pattern
input double InpPinBarWickRatio = 2.0;                      // Pin Bar Wick Ratio

//--- Time-Based Filters
input bool InpUseHourFilter = false;                        // Use Hour Filter
input int InpStartHour = 8;                                 // Start Hour (0-23)
input int InpEndHour = 20;                                  // End Hour (0-23)
input bool InpUseDayFilter = false;                         // Use Day Filter
input bool InpTradeMonday = true;                           // Trade Monday
input bool InpTradeTuesday = true;                          // Trade Tuesday
input bool InpTradeWednesday = true;                        // Trade Wednesday
input bool InpTradeThursday = true;                         // Trade Thursday
input bool InpTradeFriday = true;                           // Trade Friday
input bool InpTradeSaturday = false;                        // Trade Saturday
input bool InpTradeSunday = false;                          // Trade Sunday

//--- Volatility Filters
input bool InpUseVolatilityFilter = false;                  // Use Volatility Filter
input int InpVolatilityPeriod = 20;                         // Volatility Period
input double InpMinVolatilityPercent = 0.1;                 // Min Volatility %
input double InpMaxVolatilityPercent = 5.0;                 // Max Volatility %

//--- Spread Filter
input bool InpUseSpreadFilter = false;                      // Use Spread Filter
input double InpMaxSpreadPoints = 50.0;                     // Max Spread in Points

//--- Consecutive Candle Filter
input bool InpUseConsecutiveFilter = false;                 // Use Consecutive Candle Filter
input int InpConsecutiveCandles = 3;                        // Number of Consecutive Candles
input bool InpConsecutiveSameDirection = true;              // Same Direction (true) or Opposite (false)

//--- Support/Resistance Filter
input bool InpUseSRFilter = false;                          // Use Support/Resistance Filter
input int InpSRLookbackPeriod = 50;                         // SR Lookback Period
input double InpSRDistancePercent = 0.5;                    // Min Distance from SR %

//--- News Time Filter (Manual)
input bool InpUseNewsFilter = false;                        // Use News Time Filter
input int InpNewsStartHour = 12;                            // News Start Hour
input int InpNewsEndHour = 14;                              // News End Hour
input bool InpAvoidNewsTime = true;                         // Avoid News Time (true) or Only Trade News (false)

//--- Advanced Entry Filters
input bool InpUseClosePositionFilter = false;               // Use Close Position Filter
input double InpMinClosePosition = 70.0;                    // Min Close Position in Candle % (0=low, 100=high)
input bool InpUseGapFilter = false;                         // Use Gap Filter
input double InpMinGapPercent = 0.1;                        // Min Gap % from Previous Close

//--- Risk Management Filters
input bool InpUseDailyLossLimit = false;                    // Use Daily Loss Limit
input double InpMaxDailyLossPercent = 5.0;                  // Max Daily Loss %
input bool InpUseDailyProfitTarget = false;                 // Use Daily Profit Target
input double InpDailyProfitTargetPercent = 10.0;            // Daily Profit Target %
input bool InpUseMaxDrawdown = false;                       // Use Max Drawdown Limit
input double InpMaxDrawdownPercent = 20.0;                  // Max Drawdown %

//--- Global variables
datetime lastBarTime = 0;
ulong lastTicket = 0;
double lastCandleOpen = 0;
datetime lastPositionOpenTime = 0;
bool positionOpenedThisBar = false;

//--- Indicator handles
int rsiHandle = INVALID_HANDLE;
int atrHandle = INVALID_HANDLE;
int adxHandle = INVALID_HANDLE;
int maHandle = INVALID_HANDLE;
int momentumHandle = INVALID_HANDLE;

//--- Risk management variables
double dailyStartBalance = 0;
double maxBalance = 0;
datetime currentDay = 0;
bool dailyLimitReached = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Validate input parameters
   if(InpMinBodyPercent <= 0)
   {
      Print("Error: Minimum Body Percent must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpMinRangePercent <= 0)
   {
      Print("Error: Minimum Range Percent must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpMaxBodyPercent <= InpMinBodyPercent)
   {
      Print("Error: Maximum Body Percent must be greater than Minimum Body Percent");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpMaxRangePercent <= InpMinRangePercent)
   {
      Print("Error: Maximum Range Percent must be greater than Minimum Range Percent");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpBodyToRangePercent < 0 || InpBodyToRangePercent > 100)
   {
      Print("Error: Body to Range Percent must be between 0 and 100");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpMinLotSize <= 0)
   {
      Print("Error: Minimum Lot Size must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpEquityRiskPercent < 0 || InpEquityRiskPercent > 100)
   {
      Print("Error: Equity Risk Percent must be between 0 and 100");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpStopLossPercent <= 0)
   {
      Print("Error: Stop Loss Percent must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpStopLossEntryPercent <= 0)
   {
      Print("Error: Stop Loss Entry Percent must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpStopLossFixedAmount <= 0)
   {
      Print("Error: Stop Loss Fixed Amount must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpTakeProfitPercent < 0)
   {
      Print("Error: Take Profit Percent must be 0 or greater");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpMaxOpenPositions <= 0)
   {
      Print("Error: Maximum Open Positions must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpMagicNumber == 0)
   {
      Print("Error: Magic Number must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   //--- Validate RSI parameters
   if(InpUseRSIFilter)
   {
      if(InpRSIPeriod <= 0)
      {
         Print("Error: RSI Period must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
      if(InpRSIUpperLevel <= InpRSILowerLevel || InpRSIUpperLevel > 100 || InpRSILowerLevel < 0)
      {
         Print("Error: Invalid RSI levels");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate Breakeven parameters
   if(InpUseBreakeven)
   {
      if(InpBreakevenTriggerPercent <= 0)
      {
         Print("Error: Breakeven Trigger Percent must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
      if(InpBreakevenProfitPercent < 0)
      {
         Print("Error: Breakeven Profit Percent must be 0 or greater");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate ATR parameters
   if(InpUseATRFilter)
   {
      if(InpATRPeriod <= 0)
      {
         Print("Error: ATR Period must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
      if(InpATRMultiplier <= 0)
      {
         Print("Error: ATR Multiplier must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate ADX parameters
   if(InpUseADXFilter)
   {
      if(InpADXPeriod <= 0)
      {
         Print("Error: ADX Period must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
      if(InpADXMinLevel < 0 || InpADXMinLevel > 100)
      {
         Print("Error: ADX Min Level must be between 0 and 100");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate Volume parameters
   if(InpUseVolumeFilter)
   {
      if(InpVolumePeriod <= 0)
      {
         Print("Error: Volume Period must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
      if(InpVolumeMultiplier <= 0)
      {
         Print("Error: Volume Multiplier must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate MA parameters
   if(InpUseMAFilter)
   {
      if(InpMAPeriod <= 0)
      {
         Print("Error: MA Period must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate Momentum parameters
   if(InpUseMomentumFilter)
   {
      if(InpMomentumPeriod <= 0)
      {
         Print("Error: Momentum Period must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate time filters
   if(InpUseHourFilter)
   {
      if(InpStartHour < 0 || InpStartHour > 23 || InpEndHour < 0 || InpEndHour > 23)
      {
         Print("Error: Start and End hours must be between 0 and 23");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate volatility parameters
   if(InpUseVolatilityFilter)
   {
      if(InpVolatilityPeriod <= 0)
      {
         Print("Error: Volatility Period must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
      if(InpMinVolatilityPercent < 0 || InpMaxVolatilityPercent <= InpMinVolatilityPercent)
      {
         Print("Error: Invalid volatility percent range");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate spread filter
   if(InpUseSpreadFilter && InpMaxSpreadPoints <= 0)
   {
      Print("Error: Max Spread Points must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   //--- Validate consecutive filter
   if(InpUseConsecutiveFilter && InpConsecutiveCandles <= 0)
   {
      Print("Error: Consecutive Candles must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   //--- Validate SR filter
   if(InpUseSRFilter)
   {
      if(InpSRLookbackPeriod <= 0)
      {
         Print("Error: SR Lookback Period must be greater than 0");
         return(INIT_PARAMETERS_INCORRECT);
      }
      if(InpSRDistancePercent < 0)
      {
         Print("Error: SR Distance Percent must be 0 or greater");
         return(INIT_PARAMETERS_INCORRECT);
      }
   }
   
   //--- Validate close position filter
   if(InpUseClosePositionFilter && (InpMinClosePosition < 0 || InpMinClosePosition > 100))
   {
      Print("Error: Min Close Position must be between 0 and 100");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   //--- Validate gap filter
   if(InpUseGapFilter && InpMinGapPercent < 0)
   {
      Print("Error: Min Gap Percent must be 0 or greater");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   //--- Validate risk management
   if(InpUseDailyLossLimit && (InpMaxDailyLossPercent <= 0 || InpMaxDailyLossPercent > 100))
   {
      Print("Error: Max Daily Loss Percent must be between 0 and 100");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpUseDailyProfitTarget && InpDailyProfitTargetPercent <= 0)
   {
      Print("Error: Daily Profit Target Percent must be greater than 0");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   if(InpUseMaxDrawdown && (InpMaxDrawdownPercent <= 0 || InpMaxDrawdownPercent > 100))
   {
      Print("Error: Max Drawdown Percent must be between 0 and 100");
      return(INIT_PARAMETERS_INCORRECT);
   }
   
   //--- Initialize indicator handles
   if(InpUseRSIFilter)
   {
      rsiHandle = iRSI(_Symbol, InpTimeframe, InpRSIPeriod, PRICE_CLOSE);
      if(rsiHandle == INVALID_HANDLE)
      {
         Print("Error: Failed to create RSI indicator handle");
         return(INIT_FAILED);
      }
   }
   
   if(InpUseATRFilter)
   {
      atrHandle = iATR(_Symbol, InpTimeframe, InpATRPeriod);
      if(atrHandle == INVALID_HANDLE)
      {
         Print("Error: Failed to create ATR indicator handle");
         return(INIT_FAILED);
      }
   }
   
   if(InpUseADXFilter)
   {
      adxHandle = iADX(_Symbol, InpTimeframe, InpADXPeriod);
      if(adxHandle == INVALID_HANDLE)
      {
         Print("Error: Failed to create ADX indicator handle");
         return(INIT_FAILED);
      }
   }
   
   if(InpUseMAFilter)
   {
      maHandle = iMA(_Symbol, InpTimeframe, InpMAPeriod, 0, InpMAMethod, PRICE_CLOSE);
      if(maHandle == INVALID_HANDLE)
      {
         Print("Error: Failed to create MA indicator handle");
         return(INIT_FAILED);
      }
   }
   
   if(InpUseMomentumFilter)
   {
      momentumHandle = iMomentum(_Symbol, InpTimeframe, InpMomentumPeriod, PRICE_CLOSE);
      if(momentumHandle == INVALID_HANDLE)
      {
         Print("Error: Failed to create Momentum indicator handle");
         return(INIT_FAILED);
      }
   }
   
   //--- Initialize risk management
   dailyStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   maxBalance = dailyStartBalance;
   currentDay = GetCurrentDay();
   dailyLimitReached = false;
   
   //--- Reset global variables
   lastBarTime = 0;
   lastTicket = 0;
   positionOpenedThisBar = false;
   
   //--- Print initialization message
   Print("Candle Body/Range EA initialized successfully");
   Print("Timeframe: ", EnumToString(InpTimeframe));
   Print("Min Body: ", InpMinBodyPercent, "% | Min Range: ", InpMinRangePercent, "%");
   Print("Max Body: ", InpMaxBodyPercent, "% | Max Range: ", InpMaxRangePercent, "%");
   Print("Body/Range Ratio: ", InpBodyToRangePercent, "%");
   Print("Lot Size: ", InpMinLotSize, " | Equity Risk: ", InpEquityRiskPercent, "%");
   Print("Stop Loss Mode: ", EnumToString(InpStopLossMode));
   if(InpStopLossMode == SL_MODE_CANDLE)
   {
      Print("SL Type: ", EnumToString(InpStopLossType), " | SL Percent: ", InpStopLossPercent, "%");
   }
   else if(InpStopLossMode == SL_MODE_ENTRY_PERCENT)
   {
      Print("SL Entry Percent: ", InpStopLossEntryPercent, "%");
   }
   else
   {
      Print("SL Fixed Amount: ", InpStopLossFixedAmount);
   }
   Print("Take Profit: ", InpTakeProfitPercent, "% (0 = Close at End of Candle)");
   Print("Max Open Positions: ", InpMaxOpenPositions);
   Print("Magic Number: ", InpMagicNumber);
   Print("Trading Session: ", EnumToString(InpTradingSession));
   Print("Upside Down Mode: ", InpUpsideDown ? "ON" : "OFF");
   Print("RSI Filter: ", InpUseRSIFilter ? "ON" : "OFF");
   Print("Breakeven: ", InpUseBreakeven ? "ON" : "OFF");
   Print("ATR Filter: ", InpUseATRFilter ? "ON" : "OFF");
   Print("ADX Filter: ", InpUseADXFilter ? "ON" : "OFF");
   Print("Volume Filter: ", InpUseVolumeFilter ? "ON" : "OFF");
   Print("MA Filter: ", InpUseMAFilter ? "ON" : "OFF");
   Print("Momentum Filter: ", InpUseMomentumFilter ? "ON" : "OFF");
   Print("Candle Pattern Filter: ", InpUseCandlePatternFilter ? "ON" : "OFF");
   Print("Hour Filter: ", InpUseHourFilter ? "ON" : "OFF");
   Print("Day Filter: ", InpUseDayFilter ? "ON" : "OFF");
   Print("Volatility Filter: ", InpUseVolatilityFilter ? "ON" : "OFF");
   Print("Spread Filter: ", InpUseSpreadFilter ? "ON" : "OFF");
   Print("Consecutive Filter: ", InpUseConsecutiveFilter ? "ON" : "OFF");
   Print("SR Filter: ", InpUseSRFilter ? "ON" : "OFF");
   Print("News Filter: ", InpUseNewsFilter ? "ON" : "OFF");
   Print("Close Position Filter: ", InpUseClosePositionFilter ? "ON" : "OFF");
   Print("Gap Filter: ", InpUseGapFilter ? "ON" : "OFF");
   Print("Daily Loss Limit: ", InpUseDailyLossLimit ? "ON" : "OFF");
   Print("Daily Profit Target: ", InpUseDailyProfitTarget ? "ON" : "OFF");
   Print("Max Drawdown: ", InpUseMaxDrawdown ? "ON" : "OFF");
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- Release indicator handles
   if(rsiHandle != INVALID_HANDLE)
      IndicatorRelease(rsiHandle);
   if(atrHandle != INVALID_HANDLE)
      IndicatorRelease(atrHandle);
   if(adxHandle != INVALID_HANDLE)
      IndicatorRelease(adxHandle);
   if(maHandle != INVALID_HANDLE)
      IndicatorRelease(maHandle);
   if(momentumHandle != INVALID_HANDLE)
      IndicatorRelease(momentumHandle);
   
   Print("Candle Body/Range EA deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check and reset daily limits
   CheckDailyReset();
   
   //--- Check risk management limits
   if(!CheckRiskManagement())
      return;
   
   //--- Manage breakeven for open positions
   if(InpUseBreakeven)
      ManageBreakeven();
   
   //--- Check if new bar has formed
   datetime currentBarTime = iTime(_Symbol, InpTimeframe, 0);
   
   if(currentBarTime != lastBarTime)
   {
      // New bar formed
      lastBarTime = currentBarTime;
      positionOpenedThisBar = false;
      
      // Close positions at end of candle if TP is 0
      if(InpTakeProfitPercent == 0.0)
      {
         ClosePositionsAtEndOfCandle();
      }
      
      // Check for trading signal on the previous completed candle
      CheckTradingSignal();
   }
}

//+------------------------------------------------------------------+
//| Check for trading signal based on candle body and range          |
//+------------------------------------------------------------------+
void CheckTradingSignal()
{
   //--- Don't open if position already opened this bar
   if(positionOpenedThisBar)
      return;
   
   //--- Check maximum open positions
   if(GetOpenPositionsCount() >= InpMaxOpenPositions)
   {
      Print("Maximum open positions reached: ", InpMaxOpenPositions);
      return;
   }
   
   //--- Check trading session filter
   if(!IsWithinTradingSession())
   {
      Print("Outside trading session - no trade");
      return;
   }
   
   //--- Check time-based filters
   if(!CheckTimeFilters())
      return;
   
   //--- Check spread filter
   if(!CheckSpreadFilter())
      return;
   
   //--- Get previous candle data (index 1 = last completed candle)
   double open = iOpen(_Symbol, InpTimeframe, 1);
   double high = iHigh(_Symbol, InpTimeframe, 1);
   double low = iLow(_Symbol, InpTimeframe, 1);
   double close = iClose(_Symbol, InpTimeframe, 1);
   
   //--- Validate candle data
   if(open == 0 || high == 0 || low == 0 || close == 0)
   {
      Print("Invalid candle data");
      return;
   }
   
   //--- Calculate body and range
   double bodySize = MathAbs(close - open);
   double rangeSize = high - low;
   
   //--- Avoid division by zero
   if(open == 0 || rangeSize == 0)
      return;
   
   //--- Calculate percentages based on opening price
   double bodyPercent = (bodySize / open) * 100.0;
   double rangePercent = (rangeSize / open) * 100.0;
   double bodyToRangeRatio = (bodySize / rangeSize) * 100.0;
   
   //--- Check if candle meets basic criteria
   if(bodyPercent < InpMinBodyPercent)
   {
      Print("Body too small: ", DoubleToString(bodyPercent, 4), "% < ", InpMinBodyPercent, "%");
      return;
   }
   
   if(bodyPercent > InpMaxBodyPercent)
   {
      Print("Body too large: ", DoubleToString(bodyPercent, 4), "% > ", InpMaxBodyPercent, "%");
      return;
   }
   
   if(rangePercent < InpMinRangePercent)
   {
      Print("Range too small: ", DoubleToString(rangePercent, 4), "% < ", InpMinRangePercent, "%");
      return;
   }
   
   if(rangePercent > InpMaxRangePercent)
   {
      Print("Range too large: ", DoubleToString(rangePercent, 4), "% > ", InpMaxRangePercent, "%");
      return;
   }
   
   if(bodyToRangeRatio < InpBodyToRangePercent)
   {
      Print("Body/Range ratio too small: ", DoubleToString(bodyToRangeRatio, 2), "% < ", InpBodyToRangePercent, "%");
      return;
   }
   
   //--- Check all advanced filters
   if(!CheckAllAdvancedFilters(open, high, low, close, bodySize, rangeSize, bodyPercent, rangePercent))
      return;
   
   //--- Determine trade direction
   bool isBullish = close > open;
   bool isBearish = close < open;
   
   if(!isBullish && !isBearish)
   {
      Print("Doji candle - no trade");
      return;
   }
   
   //--- Print signal information
   Print("Signal detected: ", isBullish ? "Bullish" : "Bearish", 
         " | Body: ", DoubleToString(bodyPercent, 4), "%",
         " | Range: ", DoubleToString(rangePercent, 4), "%",
         " | Body/Range: ", DoubleToString(bodyToRangeRatio, 2), "%");
   
   //--- Open position based on candle direction (with Upside Down option)
   if(isBullish)
   {
      if(InpUpsideDown)
         OpenSellPosition(open, high, low, close, bodySize, rangeSize);  // Reverse: Sell on bullish
      else
         OpenBuyPosition(open, high, low, close, bodySize, rangeSize);   // Normal: Buy on bullish
   }
   else if(isBearish)
   {
      if(InpUpsideDown)
         OpenBuyPosition(open, high, low, close, bodySize, rangeSize);   // Reverse: Buy on bearish
      else
         OpenSellPosition(open, high, low, close, bodySize, rangeSize);  // Normal: Sell on bearish
   }
}

//+------------------------------------------------------------------+
//| Open Buy Position                                                |
//+------------------------------------------------------------------+
void OpenBuyPosition(double candleOpen, double candleHigh, double candleLow, double candleClose, double bodySize, double rangeSize)
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   if(ask == 0 || bid == 0)
   {
      Print("Invalid price data for Buy order");
      return;
   }
   
   //--- Calculate stop loss based on selected mode
   double stopLoss = CalculateStopLoss(true, ask, candleOpen, candleHigh, candleLow, candleClose, bodySize, rangeSize);
   
   //--- Calculate lot size based on risk management
   double lotSize = CalculateLotSize(stopLoss, ask, true);
   
   //--- Calculate take profit
   double takeProfit = 0;
   if(InpTakeProfitPercent > 0)
   {
      takeProfit = ask * (1.0 + InpTakeProfitPercent / 100.0);
   }
   
   //--- Normalize prices
   stopLoss = NormalizeDouble(stopLoss, _Digits);
   if(takeProfit > 0)
      takeProfit = NormalizeDouble(takeProfit, _Digits);
   
   //--- Validate stop loss and take profit
   if(!ValidateStopLossTakeProfit(true, ask, stopLoss, takeProfit))
   {
      Print("Invalid SL/TP for Buy order");
      return;
   }
   
   //--- Open buy position
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lotSize;
   request.type = ORDER_TYPE_BUY;
   request.price = ask;
   request.sl = stopLoss;
   request.tp = takeProfit;
   request.deviation = 10;
   request.magic = InpMagicNumber;
   request.comment = "CandleBodyRangeEA_Buy";
   
   if(OrderSend(request, result))
   {
      if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
      {
         lastTicket = result.order;
         lastCandleOpen = candleOpen;
         lastPositionOpenTime = TimeCurrent();
         positionOpenedThisBar = true;
         Print("Buy position opened successfully. Ticket: ", result.order, 
               " | Lot: ", lotSize,
               " | Entry: ", ask, 
               " | SL: ", stopLoss,
               " | TP: ", takeProfit > 0 ? DoubleToString(takeProfit, _Digits) : "None");
      }
      else
      {
         Print("Buy order failed. Retcode: ", result.retcode, " | Comment: ", result.comment);
      }
   }
   else
   {
      Print("OrderSend failed for Buy. Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Open Sell Position                                               |
//+------------------------------------------------------------------+
void OpenSellPosition(double candleOpen, double candleHigh, double candleLow, double candleClose, double bodySize, double rangeSize)
{
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   if(ask == 0 || bid == 0)
   {
      Print("Invalid price data for Sell order");
      return;
   }
   
   //--- Calculate stop loss based on selected mode
   double stopLoss = CalculateStopLoss(false, bid, candleOpen, candleHigh, candleLow, candleClose, bodySize, rangeSize);
   
   //--- Calculate lot size based on risk management
   double lotSize = CalculateLotSize(stopLoss, bid, false);
   
   //--- Calculate take profit
   double takeProfit = 0;
   if(InpTakeProfitPercent > 0)
   {
      takeProfit = bid * (1.0 - InpTakeProfitPercent / 100.0);
   }
   
   //--- Normalize prices
   stopLoss = NormalizeDouble(stopLoss, _Digits);
   if(takeProfit > 0)
      takeProfit = NormalizeDouble(takeProfit, _Digits);
   
   //--- Validate stop loss and take profit
   if(!ValidateStopLossTakeProfit(false, bid, stopLoss, takeProfit))
   {
      Print("Invalid SL/TP for Sell order");
      return;
   }
   
   //--- Open sell position
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lotSize;
   request.type = ORDER_TYPE_SELL;
   request.price = bid;
   request.sl = stopLoss;
   request.tp = takeProfit;
   request.deviation = 10;
   request.magic = InpMagicNumber;
   request.comment = "CandleBodyRangeEA_Sell";
   
   if(OrderSend(request, result))
   {
      if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)
      {
         lastTicket = result.order;
         lastCandleOpen = candleOpen;
         lastPositionOpenTime = TimeCurrent();
         positionOpenedThisBar = true;
         Print("Sell position opened successfully. Ticket: ", result.order,
               " | Lot: ", lotSize,
               " | Entry: ", bid,
               " | SL: ", stopLoss,
               " | TP: ", takeProfit > 0 ? DoubleToString(takeProfit, _Digits) : "None");
      }
      else
      {
         Print("Sell order failed. Retcode: ", result.retcode, " | Comment: ", result.comment);
      }
   }
   else
   {
      Print("OrderSend failed for Sell. Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Calculate Stop Loss based on selected mode                       |
//+------------------------------------------------------------------+
double CalculateStopLoss(bool isBuy, double entryPrice, double candleOpen, double candleHigh, double candleLow, double candleClose, double bodySize, double rangeSize)
{
   double stopLoss = 0;
   
   switch(InpStopLossMode)
   {
      case SL_MODE_CANDLE:
      {
         double slDistance = 0;
         if(InpStopLossType == SL_TYPE_BODY)
            slDistance = bodySize * (InpStopLossPercent / 100.0);
         else // SL_TYPE_RANGE
            slDistance = rangeSize * (InpStopLossPercent / 100.0);
         
         if(isBuy)
            stopLoss = entryPrice - slDistance;
         else
            stopLoss = entryPrice + slDistance;
         break;
      }
      
      case SL_MODE_ENTRY_PERCENT:
      {
         double slDistance = entryPrice * (InpStopLossEntryPercent / 100.0);
         if(isBuy)
            stopLoss = entryPrice - slDistance;
         else
            stopLoss = entryPrice + slDistance;
         break;
      }
      
      case SL_MODE_ENTRY_FIXED:
      {
         if(isBuy)
            stopLoss = entryPrice - InpStopLossFixedAmount;
         else
            stopLoss = entryPrice + InpStopLossFixedAmount;
         break;
      }
   }
   
   return stopLoss;
}

//+------------------------------------------------------------------+
//| Calculate Lot Size based on risk management                      |
//+------------------------------------------------------------------+
double CalculateLotSize(double stopLoss, double entryPrice, bool isBuy)
{
   //--- If equity risk is 0, use fixed lot size
   if(InpEquityRiskPercent <= 0)
   {
      return NormalizeLotSize(InpMinLotSize);
   }
   
   //--- Calculate risk amount based on equity
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double riskAmount = equity * (InpEquityRiskPercent / 100.0);
   
   //--- Calculate stop loss distance
   double slDistance = MathAbs(entryPrice - stopLoss);
   
   if(slDistance <= 0)
   {
      Print("Invalid SL distance, using minimum lot size");
      return NormalizeLotSize(InpMinLotSize);
   }
   
   //--- Get symbol properties
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);
   
   if(tickValue <= 0 || tickSize <= 0)
   {
      Print("Invalid tick value/size, using minimum lot size");
      return NormalizeLotSize(InpMinLotSize);
   }
   
   //--- Calculate risk per lot
   double riskPerLot = (slDistance / tickSize) * tickValue;
   
   if(riskPerLot <= 0)
   {
      Print("Invalid risk per lot, using minimum lot size");
      return NormalizeLotSize(InpMinLotSize);
   }
   
   //--- Calculate lot size
   double lotSize = riskAmount / riskPerLot;
   
   //--- Ensure minimum lot size
   if(lotSize < InpMinLotSize)
      lotSize = InpMinLotSize;
   
   Print("Risk Calculation: Equity=", equity, " | Risk%=", InpEquityRiskPercent, 
         " | Risk Amount=", riskAmount, " | SL Distance=", slDistance,
         " | Risk Per Lot=", riskPerLot, " | Lot Size=", lotSize);
   
   return NormalizeLotSize(lotSize);
}

//+------------------------------------------------------------------+
//| Normalize lot size according to symbol specifications            |
//+------------------------------------------------------------------+
double NormalizeLotSize(double lotSize)
{
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   
   if(minLot <= 0)
      minLot = 0.01;
   if(maxLot <= 0)
      maxLot = 100.0;
   if(lotStep <= 0)
      lotStep = 0.01;
   
   //--- Ensure within limits
   if(lotSize < minLot)
      lotSize = minLot;
   if(lotSize > maxLot)
      lotSize = maxLot;
   
   //--- Normalize to lot step
   lotSize = MathFloor(lotSize / lotStep) * lotStep;
   
   //--- Normalize decimal places
   int digits = 2;
   if(lotStep == 0.001)
      digits = 3;
   else if(lotStep == 0.01)
      digits = 2;
   else if(lotStep == 0.1)
      digits = 1;
   
   return NormalizeDouble(lotSize, digits);
}

//+------------------------------------------------------------------+
//| Validate Stop Loss and Take Profit                              |
//+------------------------------------------------------------------+
bool ValidateStopLossTakeProfit(bool isBuy, double entryPrice, double stopLoss, double takeProfit)
{
   double minStopLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
   double freezeLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_FREEZE_LEVEL) * _Point;
   double minDistance = MathMax(minStopLevel, freezeLevel);
   
   if(isBuy)
   {
      if(stopLoss >= entryPrice)
      {
         Print("Invalid Buy SL: SL must be below entry price");
         return false;
      }
      
      if((entryPrice - stopLoss) < minDistance)
      {
         Print("Buy SL too close to entry. Distance: ", entryPrice - stopLoss, " | Required: ", minDistance);
         return false;
      }
      
      if(takeProfit > 0)
      {
         if(takeProfit <= entryPrice)
         {
            Print("Invalid Buy TP: TP must be above entry price");
            return false;
         }
         
         if((takeProfit - entryPrice) < minDistance)
         {
            Print("Buy TP too close to entry. Distance: ", takeProfit - entryPrice, " | Required: ", minDistance);
            return false;
         }
      }
   }
   else // Sell
   {
      if(stopLoss <= entryPrice)
      {
         Print("Invalid Sell SL: SL must be above entry price");
         return false;
      }
      
      if((stopLoss - entryPrice) < minDistance)
      {
         Print("Sell SL too close to entry. Distance: ", stopLoss - entryPrice, " | Required: ", minDistance);
         return false;
      }
      
      if(takeProfit > 0)
      {
         if(takeProfit >= entryPrice)
         {
            Print("Invalid Sell TP: TP must be below entry price");
            return false;
         }
         
         if((entryPrice - takeProfit) < minDistance)
         {
            Print("Sell TP too close to entry. Distance: ", entryPrice - takeProfit, " | Required: ", minDistance);
            return false;
         }
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check if current time is within trading session                  |
//+------------------------------------------------------------------+
bool IsWithinTradingSession()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int currentHour = dt.hour;
   int currentMinute = dt.min;
   int currentTimeMinutes = currentHour * 60 + currentMinute;
   
   switch(InpTradingSession)
   {
      case SESSION_ALL_TIMES:
         return true;
      
      case SESSION_NEW_YORK_ONLY:
         // New York session: 16:30-23:00 (server time - adjust as needed)
         return (currentTimeMinutes >= 16 * 60 + 30 && currentTimeMinutes <= 23 * 60);
      
      case SESSION_LONDON_NEW_YORK:
         // London + New York: 09:00-23:00 (server time - adjust as needed)
         return (currentTimeMinutes >= 9 * 60 && currentTimeMinutes <= 23 * 60);
      
      case SESSION_LONDON_OPEN_NY_CLOSE:
         // London Open to NY Close: 08:00-23:00 (server time - adjust as needed)
         return (currentTimeMinutes >= 8 * 60 && currentTimeMinutes <= 23 * 60);
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Close positions at end of candle                                |
//+------------------------------------------------------------------+
void ClosePositionsAtEndOfCandle()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(PositionSelectByTicket(ticket))
         {
            string symbol = PositionGetString(POSITION_SYMBOL);
            ulong magic = PositionGetInteger(POSITION_MAGIC);
            
            //--- Only close positions opened by this EA
            if(symbol == _Symbol && magic == InpMagicNumber)
            {
               datetime openTime = (datetime)PositionGetInteger(POSITION_TIME);
               
               //--- Close if position was opened in previous bar or earlier
               if(openTime < lastBarTime)
               {
                  ClosePosition(ticket);
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Close a specific position                                        |
//+------------------------------------------------------------------+
void ClosePosition(ulong ticket)
{
   if(!PositionSelectByTicket(ticket))
   {
      Print("Failed to select position: ", ticket);
      return;
   }
   
   string symbol = PositionGetString(POSITION_SYMBOL);
   double volume = PositionGetDouble(POSITION_VOLUME);
   ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   request.action = TRADE_ACTION_DEAL;
   request.position = ticket;
   request.symbol = symbol;
   request.volume = volume;
   request.deviation = 10;
   request.magic = InpMagicNumber;
   
   if(positionType == POSITION_TYPE_BUY)
   {
      request.type = ORDER_TYPE_SELL;
      request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
   }
   else
   {
      request.type = ORDER_TYPE_BUY;
      request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
   }
   
   request.comment = "CandleBodyRangeEA_Close";
   
   if(OrderSend(request, result))
   {
      if(result.retcode == TRADE_RETCODE_DONE)
      {
         Print("Position closed successfully. Ticket: ", ticket, " | Profit: ", PositionGetDouble(POSITION_PROFIT));
      }
      else
      {
         Print("Failed to close position. Ticket: ", ticket, " | Retcode: ", result.retcode, " | Comment: ", result.comment);
      }
   }
   else
   {
      Print("OrderSend failed for close. Ticket: ", ticket, " | Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Get count of open positions for this EA                         |
//+------------------------------------------------------------------+
int GetOpenPositionsCount()
{
   int count = 0;
   
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(PositionSelectByTicket(ticket))
         {
            string symbol = PositionGetString(POSITION_SYMBOL);
            ulong magic = PositionGetInteger(POSITION_MAGIC);
            
            if(symbol == _Symbol && magic == InpMagicNumber)
               count++;
         }
      }
   }
   
   return count;
}

//+------------------------------------------------------------------+
//| Check RSI Filter                                                |
//+------------------------------------------------------------------+
bool CheckRSIFilter(bool isBullish)
{
   if(!InpUseRSIFilter || rsiHandle == INVALID_HANDLE)
      return true;
   
   double rsiBuffer[];
   ArraySetAsSeries(rsiBuffer, true);
   
   if(CopyBuffer(rsiHandle, 0, 1, 1, rsiBuffer) <= 0)
   {
      Print("Failed to get RSI data");
      return false;
   }
   
   double rsiValue = rsiBuffer[0];
   
   //--- For buy signals: don't buy if RSI is above upper level
   if(isBullish && rsiValue > InpRSIUpperLevel)
   {
      Print("RSI filter blocked Buy: RSI=", DoubleToString(rsiValue, 2), " > ", InpRSIUpperLevel);
      return false;
   }
   
   //--- For sell signals: don't sell if RSI is below lower level
   if(!isBullish && rsiValue < InpRSILowerLevel)
   {
      Print("RSI filter blocked Sell: RSI=", DoubleToString(rsiValue, 2), " < ", InpRSILowerLevel);
      return false;
   }
   
   Print("RSI filter passed: RSI=", DoubleToString(rsiValue, 2));
   return true;
}

//+------------------------------------------------------------------+
//| Manage Breakeven for open positions                             |
//+------------------------------------------------------------------+
void ManageBreakeven()
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(PositionSelectByTicket(ticket))
         {
            string symbol = PositionGetString(POSITION_SYMBOL);
            ulong magic = PositionGetInteger(POSITION_MAGIC);
            
            //--- Only manage positions opened by this EA
            if(symbol == _Symbol && magic == InpMagicNumber)
            {
               ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
               double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
               double currentSL = PositionGetDouble(POSITION_SL);
               double currentTP = PositionGetDouble(POSITION_TP);
               double currentPrice = (positionType == POSITION_TYPE_BUY) ? 
                                    SymbolInfoDouble(symbol, SYMBOL_BID) : 
                                    SymbolInfoDouble(symbol, SYMBOL_ASK);
               
               //--- Calculate profit percentage
               double profitPercent = 0;
               if(positionType == POSITION_TYPE_BUY)
                  profitPercent = ((currentPrice - openPrice) / openPrice) * 100.0;
               else
                  profitPercent = ((openPrice - currentPrice) / openPrice) * 100.0;
               
               //--- Check if breakeven trigger reached
               if(profitPercent >= InpBreakevenTriggerPercent)
               {
                  double newSL = 0;
                  
                  if(positionType == POSITION_TYPE_BUY)
                  {
                     newSL = openPrice * (1.0 + InpBreakevenProfitPercent / 100.0);
                     //--- Only move SL if it's higher than current SL
                     if(newSL > currentSL)
                     {
                        ModifyPositionSL(ticket, newSL, currentTP);
                     }
                  }
                  else
                  {
                     newSL = openPrice * (1.0 - InpBreakevenProfitPercent / 100.0);
                     //--- Only move SL if it's lower than current SL (or current SL is 0)
                     if(newSL < currentSL || currentSL == 0)
                     {
                        ModifyPositionSL(ticket, newSL, currentTP);
                     }
                  }
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Modify Position Stop Loss                                       |
//+------------------------------------------------------------------+
void ModifyPositionSL(ulong ticket, double newSL, double currentTP)
{
   if(!PositionSelectByTicket(ticket))
      return;
   
   string symbol = PositionGetString(POSITION_SYMBOL);
   ENUM_POSITION_TYPE positionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   double currentPrice = (positionType == POSITION_TYPE_BUY) ? 
                        SymbolInfoDouble(symbol, SYMBOL_BID) : 
                        SymbolInfoDouble(symbol, SYMBOL_ASK);
   
   newSL = NormalizeDouble(newSL, _Digits);
   
   //--- Validate new SL
   double minStopLevel = SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
   double freezeLevel = SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL) * _Point;
   double minDistance = MathMax(minStopLevel, freezeLevel);
   
   if(positionType == POSITION_TYPE_BUY)
   {
      if(newSL >= currentPrice || (currentPrice - newSL) < minDistance)
         return;
   }
   else
   {
      if(newSL <= currentPrice || (newSL - currentPrice) < minDistance)
         return;
   }
   
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   request.action = TRADE_ACTION_SLTP;
   request.position = ticket;
   request.symbol = symbol;
   request.sl = newSL;
   request.tp = currentTP;
   
   if(OrderSend(request, result))
   {
      if(result.retcode == TRADE_RETCODE_DONE)
      {
         Print("Breakeven SL updated. Ticket: ", ticket, " | New SL: ", newSL);
      }
      else
      {
         Print("Failed to update SL. Ticket: ", ticket, " | Retcode: ", result.retcode);
      }
   }
   else
   {
      Print("OrderSend failed for SL modification. Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Check all advanced filters                                      |
//+------------------------------------------------------------------+
bool CheckAllAdvancedFilters(double open, double high, double low, double close, double bodySize, double rangeSize, double bodyPercent, double rangePercent)
{
   bool isBullish = close > open;
   
   //--- RSI Filter
   if(!CheckRSIFilter(isBullish))
      return false;
   
   //--- ATR Filter
   if(!CheckATRFilter(rangeSize))
      return false;
   
   //--- ADX Filter
   if(!CheckADXFilter(isBullish))
      return false;
   
   //--- Volume Filter
   if(!CheckVolumeFilter())
      return false;
   
   //--- MA Filter
   if(!CheckMAFilter(isBullish))
      return false;
   
   //--- Momentum Filter
   if(!CheckMomentumFilter(isBullish))
      return false;
   
   //--- Candle Pattern Filter
   if(!CheckCandlePatternFilter(open, high, low, close))
      return false;
   
   //--- Volatility Filter
   if(!CheckVolatilityFilter())
      return false;
   
   //--- Consecutive Candle Filter
   if(!CheckConsecutiveFilter(isBullish))
      return false;
   
   //--- Support/Resistance Filter
   if(!CheckSRFilter(close))
      return false;
   
   //--- News Filter
   if(!CheckNewsFilter())
      return false;
   
   //--- Close Position Filter
   if(!CheckClosePositionFilter(open, high, low, close, isBullish))
      return false;
   
   //--- Gap Filter
   if(!CheckGapFilter(open))
      return false;
   
   return true;
}

//+------------------------------------------------------------------+
//| Check ATR Filter                                                |
//+------------------------------------------------------------------+
bool CheckATRFilter(double rangeSize)
{
   if(!InpUseATRFilter || atrHandle == INVALID_HANDLE)
      return true;
   
   double atrBuffer[];
   ArraySetAsSeries(atrBuffer, true);
   
   if(CopyBuffer(atrHandle, 0, 1, 1, atrBuffer) <= 0)
   {
      Print("Failed to get ATR data");
      return false;
   }
   
   double atrValue = atrBuffer[0];
   
   if(rangeSize * InpATRMultiplier <= atrValue)
   {
      Print("ATR filter blocked: Range×Multiplier=", DoubleToString(rangeSize * InpATRMultiplier, _Digits), 
            " <= ATR=", DoubleToString(atrValue, _Digits));
      return false;
   }
   
   Print("ATR filter passed: Range×Multiplier=", DoubleToString(rangeSize * InpATRMultiplier, _Digits), 
         " > ATR=", DoubleToString(atrValue, _Digits));
   return true;
}

//+------------------------------------------------------------------+
//| Check ADX Filter                                                |
//+------------------------------------------------------------------+
bool CheckADXFilter(bool isBullish)
{
   if(!InpUseADXFilter || adxHandle == INVALID_HANDLE)
      return true;
   
   double adxBuffer[], plusDIBuffer[], minusDIBuffer[];
   ArraySetAsSeries(adxBuffer, true);
   ArraySetAsSeries(plusDIBuffer, true);
   ArraySetAsSeries(minusDIBuffer, true);
   
   if(CopyBuffer(adxHandle, 0, 1, 1, adxBuffer) <= 0 ||
      CopyBuffer(adxHandle, 1, 1, 1, plusDIBuffer) <= 0 ||
      CopyBuffer(adxHandle, 2, 1, 1, minusDIBuffer) <= 0)
   {
      Print("Failed to get ADX data");
      return false;
   }
   
   double adxValue = adxBuffer[0];
   double plusDI = plusDIBuffer[0];
   double minusDI = minusDIBuffer[0];
   
   if(adxValue < InpADXMinLevel)
   {
      Print("ADX filter blocked: ADX=", DoubleToString(adxValue, 2), " < ", InpADXMinLevel);
      return false;
   }
   
   if(InpUseADXDirection)
   {
      bool adxBullish = plusDI > minusDI;
      
      if(InpADXDirectionFollowTrend)
      {
         // Follow trend: buy when +DI > -DI, sell when -DI > +DI
         if(isBullish != adxBullish)
         {
            Print("ADX direction filter blocked: Signal direction doesn't match ADX trend");
            return false;
         }
      }
      else
      {
         // Counter trend: buy when -DI > +DI, sell when +DI > -DI
         if(isBullish == adxBullish)
         {
            Print("ADX direction filter blocked: Signal direction matches ADX trend (counter mode)");
            return false;
         }
      }
   }
   
   Print("ADX filter passed: ADX=", DoubleToString(adxValue, 2), 
         " | +DI=", DoubleToString(plusDI, 2), " | -DI=", DoubleToString(minusDI, 2));
   return true;
}

//+------------------------------------------------------------------+
//| Check Volume Filter                                             |
//+------------------------------------------------------------------+
bool CheckVolumeFilter()
{
   if(!InpUseVolumeFilter)
      return true;
   
   long currentVolume = iVolume(_Symbol, InpTimeframe, 1);
   double avgVolume = 0;
   
   for(int i = 2; i < 2 + InpVolumePeriod; i++)
   {
      avgVolume += (double)iVolume(_Symbol, InpTimeframe, i);
   }
   avgVolume /= InpVolumePeriod;
   
   if(currentVolume <= avgVolume * InpVolumeMultiplier)
   {
      Print("Volume filter blocked: Current=", currentVolume, 
            " <= Avg×Multiplier=", DoubleToString(avgVolume * InpVolumeMultiplier, 0));
      return false;
   }
   
   Print("Volume filter passed: Current=", currentVolume, 
         " > Avg×Multiplier=", DoubleToString(avgVolume * InpVolumeMultiplier, 0));
   return true;
}

//+------------------------------------------------------------------+
//| Check Moving Average Filter                                     |
//+------------------------------------------------------------------+
bool CheckMAFilter(bool isBullish)
{
   if(!InpUseMAFilter || maHandle == INVALID_HANDLE)
      return true;
   
   double maBuffer[];
   ArraySetAsSeries(maBuffer, true);
   
   if(CopyBuffer(maHandle, 0, 1, 2, maBuffer) <= 0)
   {
      Print("Failed to get MA data");
      return false;
   }
   
   double currentClose = iClose(_Symbol, InpTimeframe, 1);
   double maValue = maBuffer[0];
   
   bool priceAboveMA = currentClose > maValue;
   
   if(InpMAFollowTrend)
   {
      // Follow trend: buy above MA, sell below MA
      if(isBullish != priceAboveMA)
      {
         Print("MA filter blocked: Signal doesn't follow MA trend");
         return false;
      }
   }
   else
   {
      // Counter trend: buy below MA, sell above MA
      if(isBullish == priceAboveMA)
      {
         Print("MA filter blocked: Signal doesn't counter MA trend");
         return false;
      }
   }
   
   Print("MA filter passed: Close=", currentClose, " | MA=", maValue);
   return true;
}

//+------------------------------------------------------------------+
//| Check Momentum Filter                                           |
//+------------------------------------------------------------------+
bool CheckMomentumFilter(bool isBullish)
{
   if(!InpUseMomentumFilter || momentumHandle == INVALID_HANDLE)
      return true;
   
   double momentumBuffer[];
   ArraySetAsSeries(momentumBuffer, true);
   
   if(CopyBuffer(momentumHandle, 0, 1, 1, momentumBuffer) <= 0)
   {
      Print("Failed to get Momentum data");
      return false;
   }
   
   double momentumValue = momentumBuffer[0];
   
   if(isBullish && momentumValue <= InpMomentumThreshold)
   {
      Print("Momentum filter blocked Buy: Momentum=", DoubleToString(momentumValue, 2), " <= ", InpMomentumThreshold);
      return false;
   }
   
   if(!isBullish && momentumValue >= InpMomentumThreshold)
   {
      Print("Momentum filter blocked Sell: Momentum=", DoubleToString(momentumValue, 2), " >= ", InpMomentumThreshold);
      return false;
   }
   
   Print("Momentum filter passed: Momentum=", DoubleToString(momentumValue, 2));
   return true;
}

//+------------------------------------------------------------------+
//| Check Candle Pattern Filter                                     |
//+------------------------------------------------------------------+
bool CheckCandlePatternFilter(double open, double high, double low, double close)
{
   if(!InpUseCandlePatternFilter)
      return true;
   
   bool patternFound = false;
   
   if(InpRequireEngulfing)
   {
      if(IsEngulfingPattern(open, high, low, close))
         patternFound = true;
      else
      {
         Print("Candle pattern filter blocked: No engulfing pattern");
         return false;
      }
   }
   
   if(InpRequirePinBar)
   {
      if(IsPinBarPattern(open, high, low, close))
         patternFound = true;
      else
      {
         Print("Candle pattern filter blocked: No pin bar pattern");
         return false;
      }
   }
   
   Print("Candle pattern filter passed");
   return true;
}

//+------------------------------------------------------------------+
//| Check if candle is engulfing pattern                            |
//+------------------------------------------------------------------+
bool IsEngulfingPattern(double open, double high, double low, double close)
{
   double prevOpen = iOpen(_Symbol, InpTimeframe, 2);
   double prevClose = iClose(_Symbol, InpTimeframe, 2);
   
   bool currentBullish = close > open;
   bool prevBullish = prevClose > prevOpen;
   
   // Bullish engulfing
   if(currentBullish && !prevBullish && open < prevClose && close > prevOpen)
      return true;
   
   // Bearish engulfing
   if(!currentBullish && prevBullish && open > prevClose && close < prevOpen)
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| Check if candle is pin bar pattern                              |
//+------------------------------------------------------------------+
bool IsPinBarPattern(double open, double high, double low, double close)
{
   double bodySize = MathAbs(close - open);
   double upperWick = high - MathMax(open, close);
   double lowerWick = MathMin(open, close) - low;
   
   // Pin bar: one wick should be significantly longer than body
   if(upperWick >= bodySize * InpPinBarWickRatio || lowerWick >= bodySize * InpPinBarWickRatio)
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| Check Time Filters                                              |
//+------------------------------------------------------------------+
bool CheckTimeFilters()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   
   // Hour filter
   if(InpUseHourFilter)
   {
      if(InpStartHour <= InpEndHour)
      {
         if(dt.hour < InpStartHour || dt.hour > InpEndHour)
         {
            Print("Hour filter blocked: Current hour ", dt.hour, " outside range ", InpStartHour, "-", InpEndHour);
            return false;
         }
      }
      else // Overnight range
      {
         if(dt.hour < InpStartHour && dt.hour > InpEndHour)
         {
            Print("Hour filter blocked: Current hour ", dt.hour, " outside overnight range");
            return false;
         }
      }
   }
   
   // Day filter
   if(InpUseDayFilter)
   {
      bool tradeDay = false;
      switch(dt.day_of_week)
      {
         case 1: tradeDay = InpTradeMonday; break;
         case 2: tradeDay = InpTradeTuesday; break;
         case 3: tradeDay = InpTradeWednesday; break;
         case 4: tradeDay = InpTradeThursday; break;
         case 5: tradeDay = InpTradeFriday; break;
         case 6: tradeDay = InpTradeSaturday; break;
         case 0: tradeDay = InpTradeSunday; break;
      }
      
      if(!tradeDay)
      {
         Print("Day filter blocked: Trading not allowed on day ", dt.day_of_week);
         return false;
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Volatility Filter                                         |
//+------------------------------------------------------------------+
bool CheckVolatilityFilter()
{
   if(!InpUseVolatilityFilter)
      return true;
   
   double highest = iHigh(_Symbol, InpTimeframe, iHighest(_Symbol, InpTimeframe, MODE_HIGH, InpVolatilityPeriod, 1));
   double lowest = iLow(_Symbol, InpTimeframe, iLowest(_Symbol, InpTimeframe, MODE_LOW, InpVolatilityPeriod, 1));
   double currentPrice = iClose(_Symbol, InpTimeframe, 1);
   
   if(currentPrice == 0)
      return false;
   
   double volatilityPercent = ((highest - lowest) / currentPrice) * 100.0;
   
   if(volatilityPercent < InpMinVolatilityPercent)
   {
      Print("Volatility filter blocked: Volatility=", DoubleToString(volatilityPercent, 4), "% < ", InpMinVolatilityPercent, "%");
      return false;
   }
   
   if(volatilityPercent > InpMaxVolatilityPercent)
   {
      Print("Volatility filter blocked: Volatility=", DoubleToString(volatilityPercent, 4), "% > ", InpMaxVolatilityPercent, "%");
      return false;
   }
   
   Print("Volatility filter passed: ", DoubleToString(volatilityPercent, 4), "%");
   return true;
}

//+------------------------------------------------------------------+
//| Check Spread Filter                                             |
//+------------------------------------------------------------------+
bool CheckSpreadFilter()
{
   if(!InpUseSpreadFilter)
      return true;
   
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double spreadPoints = (ask - bid) / _Point;
   
   if(spreadPoints > InpMaxSpreadPoints)
   {
      Print("Spread filter blocked: Spread=", DoubleToString(spreadPoints, 1), " points > ", InpMaxSpreadPoints);
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Consecutive Candle Filter                                 |
//+------------------------------------------------------------------+
bool CheckConsecutiveFilter(bool isBullish)
{
   if(!InpUseConsecutiveFilter)
      return true;
   
   int count = 0;
   
   for(int i = 1; i <= InpConsecutiveCandles; i++)
   {
      double open = iOpen(_Symbol, InpTimeframe, i);
      double close = iClose(_Symbol, InpTimeframe, i);
      bool candleBullish = close > open;
      
      if(InpConsecutiveSameDirection)
      {
         if(candleBullish == isBullish)
            count++;
      }
      else
      {
         if(candleBullish != isBullish)
            count++;
      }
   }
   
   if(count < InpConsecutiveCandles)
   {
      Print("Consecutive filter blocked: Found ", count, " of ", InpConsecutiveCandles, " required candles");
      return false;
   }
   
   Print("Consecutive filter passed: ", count, " candles");
   return true;
}

//+------------------------------------------------------------------+
//| Check Support/Resistance Filter                                 |
//+------------------------------------------------------------------+
bool CheckSRFilter(double close)
{
   if(!InpUseSRFilter)
      return true;
   
   // Find recent support and resistance levels
   double resistance = iHigh(_Symbol, InpTimeframe, iHighest(_Symbol, InpTimeframe, MODE_HIGH, InpSRLookbackPeriod, 1));
   double support = iLow(_Symbol, InpTimeframe, iLowest(_Symbol, InpTimeframe, MODE_LOW, InpSRLookbackPeriod, 1));
   
   double distanceToResistance = MathAbs(resistance - close) / close * 100.0;
   double distanceToSupport = MathAbs(close - support) / close * 100.0;
   
   if(distanceToResistance < InpSRDistancePercent || distanceToSupport < InpSRDistancePercent)
   {
      Print("SR filter blocked: Too close to S/R. Distance to R=", DoubleToString(distanceToResistance, 4), 
            "% | Distance to S=", DoubleToString(distanceToSupport, 4), "%");
      return false;
   }
   
   Print("SR filter passed: Distance to R=", DoubleToString(distanceToResistance, 4), 
         "% | Distance to S=", DoubleToString(distanceToSupport, 4), "%");
   return true;
}

//+------------------------------------------------------------------+
//| Check News Filter                                               |
//+------------------------------------------------------------------+
bool CheckNewsFilter()
{
   if(!InpUseNewsFilter)
      return true;
   
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   
   bool isNewsTime = (dt.hour >= InpNewsStartHour && dt.hour <= InpNewsEndHour);
   
   if(InpAvoidNewsTime && isNewsTime)
   {
      Print("News filter blocked: Avoiding news time");
      return false;
   }
   
   if(!InpAvoidNewsTime && !isNewsTime)
   {
      Print("News filter blocked: Only trading during news time");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check Close Position Filter                                     |
//+------------------------------------------------------------------+
bool CheckClosePositionFilter(double open, double high, double low, double close, bool isBullish)
{
   if(!InpUseClosePositionFilter)
      return true;
   
   double closePosition = ((close - low) / (high - low)) * 100.0;
   
   if(isBullish)
   {
      if(closePosition < InpMinClosePosition)
      {
         Print("Close position filter blocked Buy: Close position=", DoubleToString(closePosition, 2), "% < ", InpMinClosePosition, "%");
         return false;
      }
   }
   else
   {
      if(closePosition > (100.0 - InpMinClosePosition))
      {
         Print("Close position filter blocked Sell: Close position=", DoubleToString(closePosition, 2), "% > ", 100.0 - InpMinClosePosition, "%");
         return false;
      }
   }
   
   Print("Close position filter passed: ", DoubleToString(closePosition, 2), "%");
   return true;
}

//+------------------------------------------------------------------+
//| Check Gap Filter                                                |
//+------------------------------------------------------------------+
bool CheckGapFilter(double open)
{
   if(!InpUseGapFilter)
      return true;
   
   double prevClose = iClose(_Symbol, InpTimeframe, 2);
   if(prevClose == 0)
      return false;
   
   double gapPercent = MathAbs(open - prevClose) / prevClose * 100.0;
   
   if(gapPercent < InpMinGapPercent)
   {
      Print("Gap filter blocked: Gap=", DoubleToString(gapPercent, 4), "% < ", InpMinGapPercent, "%");
      return false;
   }
   
   Print("Gap filter passed: ", DoubleToString(gapPercent, 4), "%");
   return true;
}

//+------------------------------------------------------------------+
//| Check Risk Management                                           |
//+------------------------------------------------------------------+
bool CheckRiskManagement()
{
   double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   
   // Update max balance
   if(currentBalance > maxBalance)
      maxBalance = currentBalance;
   
   // Daily loss limit
   if(InpUseDailyLossLimit)
   {
      double dailyLossPercent = ((dailyStartBalance - currentEquity) / dailyStartBalance) * 100.0;
      if(dailyLossPercent >= InpMaxDailyLossPercent)
      {
         if(!dailyLimitReached)
         {
            Print("Daily loss limit reached: ", DoubleToString(dailyLossPercent, 2), "% >= ", InpMaxDailyLossPercent, "%");
            CloseAllPositions();
            dailyLimitReached = true;
         }
         return false;
      }
   }
   
   // Daily profit target
   if(InpUseDailyProfitTarget)
   {
      double dailyProfitPercent = ((currentEquity - dailyStartBalance) / dailyStartBalance) * 100.0;
      if(dailyProfitPercent >= InpDailyProfitTargetPercent)
      {
         if(!dailyLimitReached)
         {
            Print("Daily profit target reached: ", DoubleToString(dailyProfitPercent, 2), "% >= ", InpDailyProfitTargetPercent, "%");
            CloseAllPositions();
            dailyLimitReached = true;
         }
         return false;
      }
   }
   
   // Max drawdown
   if(InpUseMaxDrawdown)
   {
      double drawdownPercent = ((maxBalance - currentEquity) / maxBalance) * 100.0;
      if(drawdownPercent >= InpMaxDrawdownPercent)
      {
         Print("Max drawdown limit reached: ", DoubleToString(drawdownPercent, 2), "% >= ", InpMaxDrawdownPercent, "%");
         CloseAllPositions();
         return false;
      }
   }
   
   return !dailyLimitReached;
}

//+------------------------------------------------------------------+
//| Check Daily Reset                                               |
//+------------------------------------------------------------------+
void CheckDailyReset()
{
   datetime newDay = GetCurrentDay();
   
   if(newDay != currentDay)
   {
      currentDay = newDay;
      dailyStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
      dailyLimitReached = false;
      Print("Daily reset: Start balance = ", dailyStartBalance);
   }
}

//+------------------------------------------------------------------+
//| Get Current Day                                                 |
//+------------------------------------------------------------------+
datetime GetCurrentDay()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   dt.hour = 0;
   dt.min = 0;
   dt.sec = 0;
   return StructToTime(dt);
}

//+------------------------------------------------------------------+
//| Close All Positions                                             |
//+------------------------------------------------------------------+
void CloseAllPositions()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket > 0)
      {
         if(PositionSelectByTicket(ticket))
         {
            string symbol = PositionGetString(POSITION_SYMBOL);
            ulong magic = PositionGetInteger(POSITION_MAGIC);
            
            if(symbol == _Symbol && magic == InpMagicNumber)
            {
               ClosePosition(ticket);
            }
         }
      }
   }
}
