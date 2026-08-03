# راهنمای تکمیل نهایی پروژه روی کامپیوتر ویندوز

این فایل فقط شامل کارهایی است که نیاز به اجرای واقعی برنامه، دو ترمینال MetaTrader 5 و تهیه تصویر دارند.

## 1. Build برنامه Coordinator

در پوشه زیر:

```text
CrossBrokerPriceMonitor/Coordinator
```

فایل زیر را اجرا کن:

```bat
build.bat
```

باید فایل زیر ساخته شود:

```text
CrossBrokerPriceMonitor.exe
```

اگر Build خطا داد، خروجی Command Prompt را ذخیره کن.

## 2. تست Demo Mode

فایل زیر را اجرا کن:

```bat
run.bat
```

سپس Demo Mode را فعال کن و بررسی کن:

- هر دو Feed ساختگی فعال باشند.
- Bid و Ask تغییر کنند.
- اختلاف قیمت نمایش داده شود.
- وضعیت‌ها بین Normal، Warning و Alert تغییر کنند.
- فایل‌های CSV ساخته شوند.

تصویر را با این نام ذخیره کن:

```text
coordinator-demo-mode.png
```

## 3. نصب Agent روی MT5 اول

فایل زیر را در `MQL5/Experts` ترمینال اول کپی کن:

```text
MQL5/CrossBrokerTickAgent.mq5
```

در MetaEditor آن را Compile کن و با تنظیمات زیر روی چارت قرار بده:

```text
InpAgentId=A
InpBrokerLabel=Broker A
InpCoordinatorHost=127.0.0.1
InpCoordinatorPort=19090
```

از صفحه MT5 تصویر بگیر و با این نام ذخیره کن:

```text
mt5-agent-a.png
```

## 4. نصب Agent روی MT5 دوم

همین فایل را در ترمینال دوم نصب کن و این مقادیر را بده:

```text
InpAgentId=B
InpBrokerLabel=Broker B
InpCoordinatorHost=127.0.0.1
InpCoordinatorPort=19090
```

تصویر را با این نام ذخیره کن:

```text
mt5-agent-b.png
```

## 5. تست اتصال هم‌زمان

Coordinator باید هر دو Agent را Connected نشان دهد.

این موارد را بررسی کن:

- Agent A و Agent B هر دو Quote ارسال می‌کنند.
- سن Quote از حد stale کمتر است.
- نام متفاوت Symbol در دو بروکر مشکلی ایجاد نمی‌کند.
- قطع یکی از MT5ها باعث تغییر وضعیت می‌شود.
- بعد از اجرای دوباره MT5، Agent خودکار متصل می‌شود.

تصویر را با این نام ذخیره کن:

```text
coordinator-two-agents-connected.png
```

## 6. ضبط GIF

یک GIF حدود 10 تا 20 ثانیه‌ای بگیر که این موارد را نشان دهد:

1. Coordinator در حال اجرا
2. هر دو Agent متصل
3. تغییر Bid و Ask
4. تغییر اختلاف قیمت و رنگ وضعیت

نام فایل:

```text
crossbroker-demo.gif
```

## 7. محل Upload تصاویر

تمام تصاویر و GIF را در این مسیر GitHub آپلود کن:

```text
CrossBrokerPriceMonitor/docs/screenshots/
```

فایل‌های موردنیاز:

```text
coordinator-demo-mode.png
coordinator-two-agents-connected.png
mt5-agent-a.png
mt5-agent-b.png
crossbroker-demo.gif
```

## 8. بررسی فایل‌های CSV

وجود فایل‌های زیر را بررسی کن:

```text
Coordinator/logs/raw_quotes_YYYYMMDD.csv
Coordinator/logs/comparisons_YYYYMMDD.csv
```

و در هر MT5:

```text
MQL5/Files/CrossBrokerTicks_A_*.csv
MQL5/Files/CrossBrokerTicks_B_*.csv
```

قبل از Upload هر Log، اطلاعات خصوصی، شماره حساب، نام سرور و اطلاعات حساس را حذف کن.

## 9. تأیید نهایی عدم معامله

در تب‌های Experts، Journal، Trade و History بررسی کن که Agent هیچ سفارش معاملاتی باز نکرده باشد.

این پروژه باید Quote-only باقی بماند.

## 10. ساخت Release نسخه 1.0.0

در GitHub وارد بخش Releases شو و گزینه `Draft a new release` را بزن.

Tag:

```text
v1.0.0
```

Release title:

```text
CrossBroker Price Monitor v1.0.0
```

متن فایل زیر را به‌عنوان توضیحات Release استفاده کن:

```text
RELEASE_NOTES_v1.0.0.md
```

فایل‌های پیشنهادی برای Attach:

```text
CrossBrokerPriceMonitor.exe
CrossBrokerTickAgent.mq5
config.ini.example
```

هیچ رمز، شماره حساب، فایل Log خصوصی یا تنظیمات شخصی بروکر را ضمیمه نکن.

## 11. بستن Issue نهایی

بعد از اتمام همه مراحل، Issue زیر را باز کن و تمام Checkboxها را تیک بزن:

```text
Finish CrossBrokerPriceMonitor v1.0.0 on Windows
```

سپس Issue را Close کن.
