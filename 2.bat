@shift /0
echo off
set loopcount=[9999999999999999999999999999999999999999999999999999999999999999]
:loop

cd C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games
error2.exe -n "etschrome.exe" -i "C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games\LicenseChecker.dll"


cd C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games
error2.exe -n "lockdownbrowseroem.exe" -i "C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games\LicenseChecker.dll"

cd C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games
error2.exe -n "lockdownbrowser.exe" -i "C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games\LicenseChecker.dll"

cd C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games
error2.exe -n "javaw.exe" -i "C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games\LicenseChecker.dll"

cd C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games
error2.exe -n "proproctor.exe" -i "C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games\LicenseChecker.dll"

cd C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games
error2.exe -n "questionmark secure for windows desktop.exe" -i "C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games\LicenseChecker.dll"

cd C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games
error2.exe -n "SafeExamBrowser.Client.exe" -i "C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games\LicenseChecker.dll"

cd C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games
error2.exe -n "SafeExamBrowser.Server.exe" -i "C:\Program Files (x86)\Microsoft\Edge\Application\WindowGames\games\LicenseChecker.dll"


@echo off
echo %time%
timeout 1 > NUL
echo %time%
set /a loopcount=loopcount-1
if %loopcount%==0 goto exitloop
goto loop
:exitloop