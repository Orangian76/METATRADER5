#include <Trade\Trade.mqh>
CTrade trade;

// پارامترهای ورودی
input double lotSize = 0.1;            // حجم معامله پایه
input double stopLossDollar = 500;     // استاپ کلی به دلار
input double profitTarget = 100;       // تارگت سود کل به دلار
input string symbolName = "BTCUSD";    // نماد معاملاتی
input double minProfitClose = -5.0;    // بستن پوزیشن با سود/زیان (-5 برای لات 0.01)
input double position2Percent = 2.5;   // درصد منفی برای باز کردن پوزیشن دوم
input double position3Percent = 3.0;   // درصد فاصله برای باز کردن پوزیشن سوم
input bool showDetailedInfo = true;    // نمایش اطلاعات جزئی در کامنت

// متغیرهای سراسری
datetime lastCheckedDay = 0;           // آخرین روز بررسی شده
datetime lastSessionCloseDay = 0;      // آخرین روز بسته شدن جلسه
bool sessionClosed = false;            // وضعیت جلسه
double startingBalance;                // تراز اولیه حساب برای محاسبه استاپ کلی
double startingSessionBalance;         // تراز شروع جلسه معاملاتی فعلی
int lastSessionNumber = 0;             // شماره آخرین جلسه معاملاتی
bool inRestMode = false;               // آیا در حالت استراحت است؟
bool isFirstPositionAfterRest = false; // آیا اولین پوزیشن پس از استراحت است؟
datetime restEndTime = 0;              // زمان پایان استراحت
datetime disableProfitCheckUntil = 0;  // تا این زمان بررسی پرافیت انجام نشود

// متغیرهای مربوط به پوزیشن‌ها
int positionCount = 0;                 // تعداد پوزیشن‌های باز شده
double entryPrice1 = 0.0;              // قیمت ورود پوزیشن اول
double entryPrice2 = 0.0;              // قیمت ورود پوزیشن دوم
double entryPrice3 = 0.0;              // قیمت ورود پوزیشن سوم
datetime position1OpenTime = 0;        // زمان باز شدن پوزیشن اول
datetime position2OpenTime = 0;        // زمان باز شدن پوزیشن دوم
datetime position3OpenTime = 0;        // زمان باز شدن پوزیشن سوم
int tradeDirection = 0;                // جهت معامله (1 برای خرید، -1 برای فروش)

// تشخیص دوجی بودن کندل
bool IsDoji(double open, double close, double refPrice)
{
   // محاسبه بدنه کندل
   double body = MathAbs(close - open);
   
   // رند کردن قیمت مرجع به نزدیکترین 5000 دلاری به بالا
   double rounded = MathCeil(refPrice / 5000.0) * 5000.0;
   
   // محاسبه آستانه دوجی بودن
   double threshold = 0.006 * rounded;
   
   // اگر بدنه کندل کوچکتر از آستانه باشد، دوجی است
   return (body < threshold);
}

// تابع مقداردهی اولیه
int OnInit()
{
   startingBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   startingSessionBalance = startingBalance;
   EventSetTimer(10);  // فعال‌سازی تایمر برای بررسی هر 10 ثانیه
   lastSessionNumber = 1;
   sessionClosed = false;
   isFirstPositionAfterRest = false;
   
   Print("EA با موفقیت راه‌اندازی شد - تراز اولیه: ", DoubleToString(startingBalance, 2));
   return INIT_SUCCEEDED;
}

// تابع اصلی - اجرا در هر تیک قیمت
void OnTick()
{
   // فقط برای نماد مورد نظر اجرا شود
   if(_Symbol != symbolName) return;

   // نمایش اطلاعات در سمت چپ ترمینال
   DisplayInfo();
   
   // زمان کندل روزانه فعلی
   datetime d1Time = iTime(symbolName, PERIOD_D1, 0);
   
   // زمان فعلی
   MqlDateTime now;
   TimeToStruct(TimeCurrent(), now);
   
   // بررسی دقیق برای باز کردن پوزیشن - فقط در لحظه باز شدن کندل روزانه
   // ساعت 00:00 تا 00:01
   if(now.hour == 0 && now.min < 2) 
   {
      // اگر قبلاً در این روز بررسی نشده، بررسی کنیم
      if(d1Time != lastCheckedDay)
      {
         // ثبت آخرین روز بررسی شده
         lastCheckedDay = d1Time;
         
         // اگر در حالت استراحت هستیم و یک روز گذشته، از حالت استراحت خارج شویم
         if(inRestMode && (d1Time - lastSessionCloseDay) >= 86400)
         {
            // خروج از حالت استراحت
            inRestMode = false;
            
            // ریست وضعیت جلسه
            sessionClosed = false;
            
            // تنظیم متغیرهای جدید
            isFirstPositionAfterRest = true;  // این پرچم نشان می‌دهد که اولین پوزیشن پس از استراحت است
            restEndTime = TimeCurrent();      // ثبت زمان پایان استراحت
            
            // غیرفعال کردن بررسی پرافیت به مدت یک روز کامل (86400 ثانیه)
            disableProfitCheckUntil = TimeCurrent() + 86400;
            
            // به‌روزرسانی تراز شروع جلسه جدید
            startingSessionBalance = AccountInfoDouble(ACCOUNT_BALANCE);
            lastSessionNumber++;
            
            Print("✅ پایان دوره استراحت. سیستم مجدداً فعال شد. جلسه شماره ", lastSessionNumber);
            Print("💰 تراز شروع جلسه جدید: ", DoubleToString(startingSessionBalance, 2));
            Print("🔄 وضعیت متغیرها - sessionClosed: ", sessionClosed ? "بله" : "خیر", 
                  ", isFirstPositionAfterRest: ", isFirstPositionAfterRest ? "بله" : "خیر");
            Print("⏱️ بررسی پرافیت تا ", TimeToString(disableProfitCheckUntil, TIME_DATE|TIME_MINUTES), " غیرفعال است");
         }

         // اگر در حالت استراحت هستیم، اقدامی نکنیم
         if(inRestMode)
         {
            Print("⏸️ سیستم در حالت استراحت است. تا زمان شروع روز بعد معامله‌ای انجام نمی‌شود.");
            return;
         }
         
         // منطق باز کردن پوزیشن فقط در شروع روز
         Print("🕒 شروع کندل روزانه جدید - بررسی شرایط باز کردن پوزیشن");

         // اگر پوزیشنی باز نیست، پوزیشن اول را بررسی کنیم
         if (PositionsTotal() == 0)
         {
            // تحلیل بازار و باز کردن پوزیشن اول در صورت نیاز
            AnalyzeMarket();
         }
         // اگر پوزیشن اول باز است، شرایط باز کردن پوزیشن دوم را بررسی کنیم
         else if (positionCount == 1)
         {
            // بررسی پوزیشن دوم
            CheckForSecondPosition();
         }
         // اگر پوزیشن دوم باز است، شرایط باز کردن پوزیشن سوم را بررسی کنیم
         else if (positionCount == 2)
         {
            // بررسی پوزیشن سوم
            CheckForThirdPosition();
         }
      }
   }
   
   // بررسی استاپ کلی در هر تیک (همیشه فعال برای محافظت از حساب)
   CheckGlobalStopLoss();
   
   // بررسی تارگت پرافیت در هر تیک (همیشه فعال)
   CheckProfitTarget();
}

// تایمر (برای بررسی مداوم)
void OnTimer()
{
   // بررسی اختصاصی پرافیت کلی فقط یک دقیقه قبل از پایان روز
   datetime d1TimeNow = iTime(symbolName, PERIOD_D1, 0);
   datetime nextDayStart = d1TimeNow + 86400;
   datetime currentTime = TimeCurrent();
   int secondsToNextDay = (int)(nextDayStart - currentTime);
   
   // منطق بررسی پرافیت - فقط در 1 دقیقه پایانی روز (بین 60 تا 0 ثانیه مانده)
   if(secondsToNextDay <= 60)
   {
      // لاگ برای اطلاع
      if(secondsToNextDay % 10 == 0) // هر 10 ثانیه یکبار لاگ
         Print("⏰ زمان بررسی پایان روز: ", secondsToNextDay, " ثانیه مانده");
      
      // بررسی پرافیت کلی (فقط در پایان روز)
      CheckCloseProfit();
   }
}

// بررسی استاپ کلی - همیشه فعال
void CheckGlobalStopLoss()
{
   // اگر پوزیشنی باز نیست یا در حالت استراحت هستیم، بررسی نکنیم
   if(PositionsTotal() == 0 || inRestMode || sessionClosed) return;

   // محاسبه سود/زیان فعلی
   double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   double totalLoss = startingBalance - currentEquity;
   
   // اگر به استاپ کلی رسیده است
   if(totalLoss >= stopLossDollar)
   {
      Print("🔴 استاپ کلی فعال شد. همه پوزیشن‌ها بسته می‌شوند. ضرر: ", DoubleToString(totalLoss, 2), " دلار");
      Print("💹 قبل از بستن - بالانس اولیه: ", DoubleToString(startingBalance, 2), 
            ", اکوئیتی فعلی: ", DoubleToString(currentEquity, 2));
      
      // بستن همه پوزیشن‌ها قبل از تغییر متغیرها
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         ulong ticket = PositionGetTicket(i);
         if(PositionSelectByTicket(ticket))
         {
            string symbol = PositionGetString(POSITION_SYMBOL);
            if(symbol == symbolName)
            {
               Print("🔒 بستن پوزیشن (استاپ کلی): ", ticket);
               trade.PositionClose(ticket);
            }
         }
      }
      
      // به‌روزرسانی بالانس اولیه پس از بستن پوزیشن‌ها
      double newEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      startingBalance = newEquity;
      startingSessionBalance = newEquity;
      
      // فعال کردن حالت استراحت
      inRestMode = true;
      lastSessionCloseDay = TimeCurrent();
      sessionClosed = true;
      isFirstPositionAfterRest = false;
      
      // ریست متغیرهای پوزیشن
      positionCount = 0;
      entryPrice1 = 0.0;
      entryPrice2 = 0.0;
      entryPrice3 = 0.0;
      position1OpenTime = 0;
      position2OpenTime = 0;
      position3OpenTime = 0;
      tradeDirection = 0;
      
      Print("💰 پس از بستن - بالانس جدید: ", DoubleToString(newEquity, 2), 
            ", بروزرسانی startingBalance به: ", DoubleToString(startingBalance, 2));
      Print("⏸️ سیستم به حالت استراحت رفت. تا فردا معامله‌ای انجام نخواهد شد.");
      Print("📊 زمان استراحت: ", TimeToString(lastSessionCloseDay, TIME_DATE|TIME_MINUTES));
      Print("⚠️ وضعیت متغیرها پس از استاپ کلی - inRestMode: ", inRestMode ? "بله" : "خیر", 
            ", sessionClosed: ", sessionClosed ? "بله" : "خیر",
            ", positionCount: ", positionCount);
   }
}

// بررسی تارگت پرافیت (در هر تیک)
void CheckProfitTarget()
{
   // اگر پوزیشنی باز نیست یا در حالت استراحت هستیم، بررسی نکنیم
   if(PositionsTotal() == 0 || inRestMode || sessionClosed) return;

   // محاسبه سود/زیان فعلی نسبت به شروع جلسه
   double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   double totalProfit = currentEquity - startingSessionBalance;

   // بررسی تارگت سود
   if(totalProfit >= profitTarget)
   {
      Print("🟢 تارگت سود رسیده شد. همه پوزیشن‌ها بسته می‌شوند. سود: ", DoubleToString(totalProfit, 2), " دلار");
      Print("💹 قبل از بستن - بالانس جلسه: ", DoubleToString(startingSessionBalance, 2),
            ", اکوئیتی فعلی: ", DoubleToString(currentEquity, 2));
      
      // بستن همه پوزیشن‌ها قبل از تغییر متغیرها
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         ulong ticket = PositionGetTicket(i);
         if(PositionSelectByTicket(ticket))
         {
            string symbol = PositionGetString(POSITION_SYMBOL);
            if(symbol == symbolName)
            {
               Print("🔒 بستن پوزیشن (تارگت پرافیت): ", ticket);
               trade.PositionClose(ticket);
            }
         }
      }
      
      // به‌روزرسانی بالانس اولیه پس از بستن پوزیشن‌ها
      double newEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      // فقط در صورتی که تارگت پرافیت محقق شده، startingBalance را به‌روز می‌کنیم
      // چون می‌خواهیم ضررهای قبلی را در نظر بگیریم
      startingBalance = newEquity; 
      startingSessionBalance = newEquity;
      
      // فعال کردن حالت استراحت
      inRestMode = true;
      lastSessionCloseDay = TimeCurrent();
      sessionClosed = true;
      isFirstPositionAfterRest = false;
      
      // ریست متغیرهای پوزیشن
      positionCount = 0;
      entryPrice1 = 0.0;
      entryPrice2 = 0.0;
      entryPrice3 = 0.0;
      position1OpenTime = 0;
      position2OpenTime = 0;
      position3OpenTime = 0;
      tradeDirection = 0;
      
      Print("💰 پس از بستن - بالانس جدید: ", DoubleToString(newEquity, 2), 
            ", بروزرسانی startingBalance به: ", DoubleToString(startingBalance, 2));
      Print("⏸️ سیستم به حالت استراحت رفت. تا فردا معامله‌ای انجام نخواهد شد.");
      Print("📊 زمان استراحت: ", TimeToString(lastSessionCloseDay, TIME_DATE|TIME_MINUTES));
      Print("✅ وضعیت متغیرها پس از تارگت پرافیت - inRestMode: ", inRestMode ? "بله" : "خیر", 
            ", sessionClosed: ", sessionClosed ? "بله" : "خیر",
            ", positionCount: ", positionCount);
   }
}

// بررسی پرافیت در زمان پایان روز
void CheckCloseProfit()
{
   // اگر پوزیشنی باز نیست یا در حالت استراحت هستیم، بررسی نکنیم
   if(PositionsTotal() == 0 || inRestMode || sessionClosed) return;
   
   // اگر بررسی پرافیت غیرفعال است، بازگردیم (برای اولین پوزیشن پس از استراحت)
   if(TimeCurrent() < disableProfitCheckUntil)
   {
      Print("⚠️ بررسی پایان روز غیرفعال است تا: ", TimeToString(disableProfitCheckUntil, TIME_DATE|TIME_MINUTES));
      return;
   }

   // محاسبه سود/زیان فعلی نسبت به شروع جلسه
   double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   double totalProfit = currentEquity - startingSessionBalance;
   
   // محاسبه حد سود/ضرر متناسب با استارت لات
   double profitThreshold = minProfitClose * (lotSize / 0.01);
   
   Print("💹 بررسی سود/زیان در پایان روز - سود فعلی: ", DoubleToString(totalProfit, 2), 
         ", حد تعیین شده: ", DoubleToString(profitThreshold, 2));

   // بررسی سود/زیان محدود
   if((totalProfit >= profitThreshold && totalProfit <= 0) || totalProfit > 0)
   {
      // اطلاعات دقیق برای لاگ
      string status = totalProfit > 0 ? "سود" : "زیان محدود";
      
      Print("🔄 پایان جلسه معاملاتی - ", status, ": ", DoubleToString(totalProfit, 2), 
            " دلار (حد تعیین شده: ", DoubleToString(profitThreshold, 2), " دلار)");
      Print("💹 قبل از بستن - بالانس جلسه: ", DoubleToString(startingSessionBalance, 2),
            ", اکوئیتی فعلی: ", DoubleToString(currentEquity, 2));
      
      // بستن همه پوزیشن‌ها قبل از تغییر متغیرها
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         ulong ticket = PositionGetTicket(i);
         if(PositionSelectByTicket(ticket))
         {
            string symbol = PositionGetString(POSITION_SYMBOL);
            if(symbol == symbolName)
            {
               Print("🔒 بستن پوزیشن (پایان روز): ", ticket);
               trade.PositionClose(ticket);
            }
         }
      }
      
      // به‌روزرسانی بالانس‌ها پس از بستن پوزیشن‌ها
      double newEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      startingBalance = newEquity;
      startingSessionBalance = newEquity;
      
      // فعال کردن حالت استراحت
      inRestMode = true;
      lastSessionCloseDay = TimeCurrent();
      sessionClosed = true;
      isFirstPositionAfterRest = false;
      
      // ریست متغیرهای پوزیشن
      positionCount = 0;
      entryPrice1 = 0.0;
      entryPrice2 = 0.0;
      entryPrice3 = 0.0;
      position1OpenTime = 0;
      position2OpenTime = 0;
      position3OpenTime = 0;
      tradeDirection = 0;
      
      Print("💰 پس از بستن - بالانس جدید: ", DoubleToString(newEquity, 2), 
            ", بروزرسانی startingBalance به: ", DoubleToString(startingBalance, 2));
      Print("⏸️ سیستم به حالت استراحت رفت. تا فردا معامله‌ای انجام نخواهد شد.");
      Print("📊 زمان استراحت: ", TimeToString(lastSessionCloseDay, TIME_DATE|TIME_MINUTES));
      Print("📋 وضعیت متغیرها پس از بستن پایان روز - inRestMode: ", inRestMode ? "بله" : "خیر", 
            ", sessionClosed: ", sessionClosed ? "بله" : "خیر",
            ", positionCount: ", positionCount);
   }
   else
   {
      // اگر زیان بیشتر از حد تعیین شده باشد، ادامه می‌دهیم
      Print("⚠️ زیان فعلی (", DoubleToString(totalProfit, 2), 
            " دلار) بیشتر از حد تعیین شده (", DoubleToString(profitThreshold, 2), 
            " دلار) است. پوزیشن‌ها باز می‌مانند.");
   }
}

// تابع خروج از اکسپرت
int OnDeinit(const int reason)
{
   EventKillTimer();
   return 0;
}

// نمایش اطلاعات در سمت چپ ترمینال
void DisplayInfo()
{
   if(!showDetailedInfo) return;

   // دریافت اطلاعات حساب
   double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double totalProfit = currentEquity - startingBalance;
   double sessionProfit = currentEquity - startingSessionBalance;
   
   // قیمت فعلی
   double currentPrice = SymbolInfoDouble(symbolName, SYMBOL_BID);
   
   // محاسبه فاصله‌ها
   string distance1to2 = "---";
   string distance2to3 = "---";
   string distance1toCurrent = "---";
   string distance2toCurrent = "---";
   
   if(positionCount >= 2 && entryPrice1 > 0 && entryPrice2 > 0)
   {
      distance1to2 = DoubleToString(MathAbs(entryPrice2 - entryPrice1), 2) + " $";
      double dist1to2Percent = MathAbs(entryPrice2 - entryPrice1) / entryPrice1 * 100;
      distance1to2 += " (" + DoubleToString(dist1to2Percent, 2) + "%)";
   }
   
   if(positionCount >= 3 && entryPrice2 > 0 && entryPrice3 > 0)
   {
      distance2to3 = DoubleToString(MathAbs(entryPrice3 - entryPrice2), 2) + " $";
      double dist2to3Percent = MathAbs(entryPrice3 - entryPrice2) / entryPrice2 * 100;
      distance2to3 += " (" + DoubleToString(dist2to3Percent, 2) + "%)";
   }
   
   if(entryPrice1 > 0)
   {
      distance1toCurrent = DoubleToString(MathAbs(currentPrice - entryPrice1), 2) + " $";
      double dist1toCurrentPercent = MathAbs(currentPrice - entryPrice1) / entryPrice1 * 100;
      distance1toCurrent += " (" + DoubleToString(dist1toCurrentPercent, 2) + "%)";
   }
   
   if(entryPrice2 > 0)
   {
      distance2toCurrent = DoubleToString(MathAbs(currentPrice - entryPrice2), 2) + " $";
      double dist2toCurrentPercent = MathAbs(currentPrice - entryPrice2) / entryPrice2 * 100;
      distance2toCurrent += " (" + DoubleToString(dist2toCurrentPercent, 2) + "%)";
   }
   
   // تعیین وضعیت سیستم
   string systemStatus = "در انتظار";
   if(inRestMode)
      systemStatus = "استراحت";
   else if(positionCount > 0)
      systemStatus = "فعال - " + IntegerToString(positionCount) + " پوزیشن";
   
   if(isFirstPositionAfterRest && positionCount > 0)
      systemStatus += " (اولین پس از استراحت)";
   
   // آماده‌سازی متن کامنت
   string infoText = "";
   infoText += "🤖 وضعیت سیستم: " + systemStatus + "\n";
   infoText += "💰 بالانس اولیه: " + DoubleToString(startingBalance, 2) + " $\n";
   infoText += "💹 بالانس جلسه " + IntegerToString(lastSessionNumber) + ": " + DoubleToString(startingSessionBalance, 2) + " $\n";
   infoText += "💵 اکویتی فعلی: " + DoubleToString(currentEquity, 2) + " $\n";
   infoText += "📊 سود/زیان کل: " + DoubleToString(totalProfit, 2) + " $ (" + 
               DoubleToString(totalProfit/startingBalance*100, 2) + "%)\n";
   infoText += "📈 سود/زیان جلسه: " + DoubleToString(sessionProfit, 2) + " $ (" + 
               DoubleToString(sessionProfit/startingSessionBalance*100, 2) + "%)\n";
   infoText += "🔢 لات سایز: " + DoubleToString(lotSize, 2) + "\n";
   infoText += "🔴 استاپ کلی: " + DoubleToString(stopLossDollar, 2) + " $\n";
   infoText += "🟢 تارگت سود: " + DoubleToString(profitTarget, 2) + " $\n";
   infoText += "➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖\n";
   
   // اطلاعات پوزیشن‌ها
   if(positionCount >= 1)
   {
      string direction = (tradeDirection > 0) ? "خرید" : "فروش";
      infoText += "▶️ پوزیشن اول: " + direction + " در " + DoubleToString(entryPrice1, 2) + " $\n";
      infoText += "⏱️ زمان باز شدن: " + TimeToString(position1OpenTime, TIME_DATE|TIME_MINUTES) + "\n";
   }
   
   if(positionCount >= 2)
   {
      infoText += "▶️ پوزیشن دوم: " + DoubleToString(entryPrice2, 2) + " $\n";
      infoText += "⏱️ زمان باز شدن: " + TimeToString(position2OpenTime, TIME_DATE|TIME_MINUTES) + "\n";
      infoText += "📏 فاصله از پوزیشن اول: " + distance1to2 + "\n";
   }
   
   if(positionCount >= 3)
   {
      infoText += "▶️ پوزیشن سوم: " + DoubleToString(entryPrice3, 2) + " $\n";
      infoText += "⏱️ زمان باز شدن: " + TimeToString(position3OpenTime, TIME_DATE|TIME_MINUTES) + "\n";
      infoText += "📏 فاصله از پوزیشن دوم: " + distance2to3 + "\n";
   }
   
   if(positionCount > 0)
   {
      infoText += "➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖\n";
      infoText += "📈 قیمت فعلی: " + DoubleToString(currentPrice, 2) + " $\n";
      
      if(positionCount >= 1)
         infoText += "📏 فاصله از پوزیشن اول: " + distance1toCurrent + "\n";
      if(positionCount >= 2)
         infoText += "📏 فاصله از پوزیشن دوم: " + distance2toCurrent + "\n";
   }
   
   // نمایش اطلاعات در ترمینال
   Comment(infoText);
}

// تحلیل بازار و تصمیم‌گیری برای معاملات
void AnalyzeMarket()
{
   // گرفتن دیتای کندل‌های قبلی (فقط بسته‌شده‌ها)
   double open1 = iOpen(symbolName, PERIOD_D1, 1);    // کندل روز قبل - باز شدن
   double close1 = iClose(symbolName, PERIOD_D1, 1);  // کندل روز قبل - بسته شدن
   double open2 = iOpen(symbolName, PERIOD_D1, 2);    // کندل دو روز قبل - باز شدن
   double close2 = iClose(symbolName, PERIOD_D1, 2);  // کندل دو روز قبل - بسته شدن
   double open3 = iOpen(symbolName, PERIOD_D1, 3);    // کندل سه روز قبل - باز شدن
   double close3 = iClose(symbolName, PERIOD_D1, 3);  // کندل سه روز قبل - بسته شدن

   double refPrice = close1; // قیمت مرجع برای محاسبه رند (قیمت بسته شدن روز قبل)

   // بررسی دوجی بودن کندل‌ها
   bool isDoji1 = IsDoji(open1, close1, refPrice);  // آیا کندل روز قبل دوجی است؟
   bool isDoji2 = IsDoji(open2, close2, refPrice);  // آیا کندل دو روز قبل دوجی است؟
   bool isDoji3 = IsDoji(open3, close3, refPrice);  // آیا کندل سه روز قبل دوجی است؟

   int direction = 0;  // جهت معامله (0=بدون معامله، 1=خرید، -1=فروش)

   // شرط 1: کندل روز قبل نباید دوجی باشد، یا اگر دو کندل آخر در یک جهت هستند، پوزیشن زده نمی‌شود
   if (!isDoji1 && (close1 - open1) * (close2 - open2) > 0) {
      // اگر هر دو کندل در یک جهت هستند، پوزیشن زده نمی‌شود
      direction = 0;
   }
   // شرط 2: کندل روز قبل کامل باشد و کندل دو روز قبل دوجی باشد
   else if (!isDoji1 && isDoji2) {
      // پوزیشن هم‌جهت با کندل روز قبل
      direction = (close1 > open1) ? 1 : -1;
   }
   // شرط جدید: اگر کندل روز قبل و کندل دو روز قبل هر دو کامل باشند ولی در جهت مخالف
   else if (!isDoji1 && !isDoji2 && (close1 - open1) * (close2 - open2) < 0) {
      // پوزیشن هم‌جهت با کندل روز قبل
      direction = (close1 > open1) ? 1 : -1;
      Print("⚡ شرط جدید: کندل‌های متوالی در جهت مخالف. پوزیشن در جهت کندل آخر باز می‌شود");
   }
   // شرط 3: سه کندل آخر کامل باشند و در یک جهت باشند
   else if (!isDoji1 && !isDoji2 && !isDoji3) {
      // بررسی جهت کندل‌ها
      bool allBullish = (close1 > open1) && (close2 > open2) && (close3 > open3);
      bool allBearish = (close1 < open1) && (close2 < open2) && (close3 < open3);
      
      if (allBullish) {
         // اگر همه صعودی هستند، پوزیشن نزولی باز کن
         direction = -1;
      }
      else if (allBearish) {
         // اگر همه نزولی هستند، پوزیشن صعودی باز کن
         direction = 1;
      }
   }

   // اگر شرایط باز کردن پوزیشن وجود دارد و هنوز پوزیشنی باز نیست
   if (direction != 0 && PositionsTotal() == 0) {
      OpenFirstPosition(direction);
   }
}

// باز کردن پوزیشن اول
void OpenFirstPosition(int direction)
{
   double currentPrice = (direction > 0) ? SymbolInfoDouble(symbolName, SYMBOL_ASK)
                                         : SymbolInfoDouble(symbolName, SYMBOL_BID);

   bool result = (direction > 0) ?
      trade.Buy(lotSize, symbolName, currentPrice, 0, 0, "Level1") :
      trade.Sell(lotSize, symbolName, currentPrice, 0, 0, "Level1");

   if(result)
   {
      entryPrice1 = currentPrice;
      positionCount = 1;
      position1OpenTime = TimeCurrent();
      tradeDirection = direction;
      
      // اگر اولین پوزیشن پس از استراحت است، ثبت می‌کنیم
      if(isFirstPositionAfterRest)
      {
         Print("🔰 اولین پوزیشن پس از استراحت باز شد - زمان: ", TimeToString(TimeCurrent()));
         isFirstPositionAfterRest = false;  // پرچم را ریست می‌کنیم تا دیگر اولین پوزیشن نباشد
      }
      
      Print("✅ پوزیشن اول باز شد در قیمت ", DoubleToString(currentPrice, 2), 
            " (", (direction > 0 ? "خرید" : "فروش"), ")");
   }
}

// بررسی شرایط باز کردن پوزیشن دوم
void CheckForSecondPosition()
{
   // حداقل یک روز از پوزیشن اول گذشته باشد
   if((TimeCurrent() - position1OpenTime) < 86400) return;
   
   // بررسی کندل روز قبل
   double open1 = iOpen(symbolName, PERIOD_D1, 1);    // کندل روز قبل - باز شدن
   double close1 = iClose(symbolName, PERIOD_D1, 1);  // کندل روز قبل - بسته شدن
   
   // محاسبه مقدار درصد تغییر قیمت نسبت به پوزیشن اول
   double priceChange = 0;
   
   if(tradeDirection > 0) // اگر پوزیشن اول خرید بوده
   {
      // نسبت به قیمت ورود چقدر منفی شده
      priceChange = (close1 - entryPrice1) / entryPrice1 * 100;
   }
   else // اگر پوزیشن اول فروش بوده
   {
      // نسبت به قیمت ورود چقدر منفی شده (معکوس)
      priceChange = (entryPrice1 - close1) / entryPrice1 * 100;
   }
   
   // اگر تغییر قیمت منفی و بیشتر از درصد تعیین شده باشد
   if(priceChange < -position2Percent)
   {
      // باز کردن پوزیشن دوم
      OpenSecondPosition();
   }
}

// باز کردن پوزیشن دوم
void OpenSecondPosition()
{
   double currentPrice = (tradeDirection > 0) ? SymbolInfoDouble(symbolName, SYMBOL_ASK)
                                              : SymbolInfoDouble(symbolName, SYMBOL_BID);

   bool result = (tradeDirection > 0) ?
      trade.Buy(lotSize, symbolName, currentPrice, 0, 0, "Level2") :
      trade.Sell(lotSize, symbolName, currentPrice, 0, 0, "Level2");

   if(result)
   {
      entryPrice2 = currentPrice;
      positionCount = 2;
      position2OpenTime = TimeCurrent();
      Print("✅ پوزیشن دوم باز شد در قیمت ", DoubleToString(currentPrice, 2), 
            " (", (tradeDirection > 0 ? "خرید" : "فروش"), ")");
   }
}

// بررسی شرایط باز کردن پوزیشن سوم
void CheckForThirdPosition()
{
   // حداقل یک روز از پوزیشن دوم گذشته باشد
   if((TimeCurrent() - position2OpenTime) < 86400) return;
   
   // قیمت فعلی
   double currentPrice = (tradeDirection > 0) ? SymbolInfoDouble(symbolName, SYMBOL_BID)
                                              : SymbolInfoDouble(symbolName, SYMBOL_ASK);
   
   // محاسبه فاصله بین پوزیشن اول و دوم
   double distance1to2 = MathAbs(entryPrice2 - entryPrice1);
   
   // محاسبه فاصله بین قیمت فعلی و پوزیشن دوم
   double distance2toCurrent = MathAbs(currentPrice - entryPrice2);
   
   // محاسبه درصد تغییر قیمت فعلی نسبت به پوزیشن دوم
   double percentChange = 0;
   
   if(tradeDirection > 0) // اگر خرید بوده
   {
      // نسبت به قیمت ورود پوزیشن دوم چقدر فاصله گرفته
      percentChange = (currentPrice - entryPrice2) / entryPrice2 * 100;
   }
   else // اگر فروش بوده
   {
      // نسبت به قیمت ورود پوزیشن دوم چقدر فاصله گرفته (معکوس)
      percentChange = (entryPrice2 - currentPrice) / entryPrice2 * 100;
   }
   
   // شرایط باز کردن پوزیشن سوم:
   // 1. پوزیشن دوم در ضرر باشد
   // 2. فاصله قیمت فعلی از پوزیشن دوم بیشتر از فاصله بین پوزیشن اول و دوم باشد
   // 3. فاصله قیمت فعلی از پوزیشن دوم حداقل 3 درصد باشد
   if(percentChange < 0 && distance2toCurrent > distance1to2 && MathAbs(percentChange) >= position3Percent)
   {
      // باز کردن پوزیشن سوم
      OpenThirdPosition();
   }
}

// باز کردن پوزیشن سوم
void OpenThirdPosition()
{
   double currentPrice = (tradeDirection > 0) ? SymbolInfoDouble(symbolName, SYMBOL_ASK)
                                              : SymbolInfoDouble(symbolName, SYMBOL_BID);

   // پوزیشن سوم با حجم دو برابر استارت لات
   bool result = (tradeDirection > 0) ?
      trade.Buy(lotSize * 2, symbolName, currentPrice, 0, 0, "Level3") :
      trade.Sell(lotSize * 2, symbolName, currentPrice, 0, 0, "Level3");

   if(result)
   {
      entryPrice3 = currentPrice;
      positionCount = 3;
      position3OpenTime = TimeCurrent();
      Print("✅ پوزیشن سوم باز شد در قیمت ", DoubleToString(currentPrice, 2), 
            " (", (tradeDirection > 0 ? "خرید" : "فروش"), ")");
   }
}
