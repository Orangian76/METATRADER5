@echo off
setlocal
cd /d "%~dp0"
set CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe
if not exist "%CSC%" set CSC=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\csc.exe
if not exist "%CSC%" (
  echo .NET Framework C# compiler was not found.
  echo Install .NET Framework 4.8 or compile Coordinator.cs in Visual Studio.
  pause
  exit /b 1
)
"%CSC%" /nologo /target:winexe /optimize+ /platform:anycpu /out:CrossBrokerPriceMonitor.exe /r:System.dll /r:System.Core.dll /r:System.Drawing.dll /r:System.Windows.Forms.dll Coordinator.cs
if errorlevel 1 (
  echo Build failed.
  pause
  exit /b 1
)
echo Build completed: CrossBrokerPriceMonitor.exe
pause
