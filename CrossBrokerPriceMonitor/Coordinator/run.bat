@echo off
setlocal
cd /d "%~dp0"
if not exist CrossBrokerPriceMonitor.exe (
  echo CrossBrokerPriceMonitor.exe was not found.
  echo Run build.bat first.
  pause
  exit /b 1
)
start "Cross Broker Price Monitor" CrossBrokerPriceMonitor.exe
