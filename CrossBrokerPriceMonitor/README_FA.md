# مانیتور مقایسه قیمت دو بروکر

[English documentation](README.md)

این پروژه یک سامانه محلی و فقط‌خواندنی برای دریافت و مقایسه زنده قیمت‌های Bid و Ask از دو ترمینال MetaTrader 5 است. هر ترمینال یک Agent نوشته‌شده با MQL5 اجرا می‌کند و Quoteها را از طریق TCP به برنامه Coordinator ویندوز می‌فرستد. Coordinator قیمت‌ها، اختلاف قابل‌اجرا، سن Quote و وضعیت اتصال را نمایش می‌دهد و فایل CSV می‌سازد.

> این پروژه هیچ معامله‌ای باز، ویرایش یا بسته نمی‌کند و ربات آربیتراژ اجرایی نیست؛ فقط ابزار مانیتورینگ، ثبت داده و تحقیق است.

## معماری

```text
MT5 بروکر A ── CrossBrokerTickAgent.mq5 ──┐
                                           ├── TCP 127.0.0.1:19090 ── Coordinator C# ── رابط کاربری + CSV
MT5 بروکر B ── CrossBrokerTickAgent.mq5 ──┘
```

## محاسبات اصلی

- خرید از A و فروش در B: `Bid(B) - Ask(A)`
- خرید از B و فروش در A: `Bid(A) - Ask(B)`
- اختلاف Mid: `Mid(B) - Mid(A)`

دو مقدار اول اختلاف خام Quote پیش از کمیسیون، اسلیپیج، تأخیر شبکه، هزینه نگهداری و ریسک پرشدن سفارش هستند. مثبت بودن آن‌ها به معنی سود قطعی نیست.

## امکانات

- دریافت Bid و Ask از دو ترمینال MT5
- پروتکل TCP سبک با پیام‌های `HELLO`، `TICK` و `HEARTBEAT`
- اتصال مجدد خودکار Agentها
- ثبت CSV در هر MT5 و Coordinator
- تشخیص Quote قدیمی یا قطع‌شده
- آستانه هشدار و Alert
- حالت Demo بدون نیاز به MT5
- محدودشدن سرور به Loopback برای امنیت بیشتر
- پشتیبانی از نام‌های متفاوت نماد مانند `BTCUSD` و `BTCUSDm`

## ساختار پروژه

```text
CrossBrokerPriceMonitor/
├── README.md
├── README_FA.md
├── LICENSE
├── CHANGELOG.md
├── SECURITY.md
├── docs/
│   └── architecture.svg
├── Coordinator/
│   ├── Coordinator.cs
│   ├── build.bat
│   ├── run.bat
│   └── config.ini.example
└── MQL5/
    ├── CrossBrokerTickAgent.mq5
    ├── Agent_A_Example.txt
    └── Agent_B_Example.txt
```

## پیش‌نیازها

- ویندوز یا Windows Server
- دو ترمینال MetaTrader 5 روی یک سیستم یا VPS
- .NET Framework 4.8 یا Visual Studio Build Tools
- MetaEditor برای Compile فایل MQL5

## ساخت Coordinator

در پوشه `Coordinator` فایل زیر را اجرا کن:

```bat
build.bat
```

بعد برنامه را با این فایل اجرا کن:

```bat
run.bat
```

سرور پیش‌فرض فقط روی `127.0.0.1:19090` گوش می‌دهد.

## نصب Agent روی ترمینال اول

1. فایل `MQL5/CrossBrokerTickAgent.mq5` را در پوشه `MQL5/Experts` ترمینال اول کپی کن.
2. در MetaEditor آن را Compile کن.
3. در تنظیمات Expert Advisors آدرس `127.0.0.1` را مجاز کن.
4. Agent را روی چارت نماد موردنظر قرار بده.
5. تنظیمات نمونه:

```text
InpAgentId=A
InpBrokerLabel=Broker A
InpCoordinatorHost=127.0.0.1
InpCoordinatorPort=19090
```

برای ترمینال دوم همین مراحل را با `InpAgentId=B` انجام بده.

## ترتیب اجرا

1. Coordinator را اجرا کن.
2. Server را Start کن یا `AutoStart=True` بگذار.
3. هر دو MT5 را اجرا کن.
4. Agentها را روی چارت نماد واقعی قرار بده.
5. وضعیت هر دو Agent باید Connected شود.

## فایل‌های خروجی

Agent در هر MT5 فایل‌هایی شبیه زیر می‌سازد:

```text
MQL5/Files/CrossBrokerTicks_A_BTCUSD_YYYYMMDD.csv
```

Coordinator فایل‌های زیر را ایجاد می‌کند:

```text
Coordinator/logs/raw_quotes_YYYYMMDD.csv
Coordinator/logs/comparisons_YYYYMMDD.csv
```

## تنظیمات پیشنهادی اولیه

```text
WarningUsd=10
AlertUsd=25
StaleMilliseconds=1500
ColorMetric=ExecutableEdge
```

بهتر است آستانه‌ها پس از چند روز جمع‌آوری داده و بررسی توزیع اختلاف قیمت تنظیم شوند.

## تست بدون MT5

در برنامه گزینه Demo mode را فعال کن. Coordinator دو جریان قیمت ساختگی تولید می‌کند تا رابط کاربری، رنگ‌ها، تشخیص stale و ثبت CSV آزمایش شوند.

## امنیت و محدودیت‌ها

- اتصال فقط روی Loopback انجام می‌شود و اجزا باید روی یک سیستم باشند.
- پروتکل به‌دلیل محلی‌بودن رمزنگاری و احراز هویت ندارد.
- زمان تیک، Spread، Contract Size و شرایط اجرای دو بروکر ممکن است متفاوت باشد.
- برای ثبت کامل تیک‌ها، Agent را روی همان نمادی نصب کن که مانیتور می‌شود.
- اجرای واقعی آربیتراژ به مدیریت سفارش مستقل، کنترل ریسک هم‌زمان، مدل هزینه و بررسی Fill نیاز دارد و خارج از محدوده این پروژه است.

## رفع اشکال سریع

### Coordinator روی Waiting مانده است

- Server را Start کن.
- پورت Agent و Coordinator باید یکسان باشد.
- `127.0.0.1` را در آدرس‌های مجاز Expert Advisors اضافه کن.
- Algo Trading باید فعال باشد.
- تب‌های Experts و Journal را برای خطاهای Socket بررسی کن.

### یکی از Agentها STALE می‌شود

- ممکن است نماد تیک نداشته باشد یا بازار بسته باشد.
- Agent را روی همان چارت نماد نصب کن.
- مقدار `StaleMilliseconds` را متناسب با بازار تنظیم کن.

## مجوز

این پروژه با مجوز MIT منتشر شده است. فایل [LICENSE](LICENSE) را ببین.
