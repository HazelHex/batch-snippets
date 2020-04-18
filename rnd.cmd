@echo off
setlocal
REM /** Generates wherever possible (PowerShell 5+)
REM * [cryptographically secure]{@link https://github.com/PowerShell/PowerShell/blob/master/src/Microsoft.PowerShell.Commands.Utility/commands/utility/GetRandomCommand.cs}
REM * random number between min and max, and sets variable
REM * @version 1.0
REM * @author [HazelHex]{@link https://github.com/HazelHex}
REM * @example
REM * call rnd pin 9999 1000
REM * echo/%pin%
REM * @requires powershell
REM * @param {reference} %1 - Name of variable to set
REM * @param {number} [%2] - Maximum, must not be equal to minimum
REM * @param {number} [%3=0] - Minimum, must not be equal to maximum
REM * @returns {errorlevel} success (0), invalid parameter (1-3), equal minimum and maximum (4), fatal error (9)
REM */

REM Parameter validation
(call if "%%~1"===&&call set "0=%%~1"&&set 0|findstr/rix "0=[a-z#$.@[\]_+-][0123456789a-z#$.@[\]_+-]*"||exit/b1)2>nul>nul
for /l %%v in (2,1,3)do call if "%%~%%v"===2>nul&&call set "0=%%~%%v"&&(if defined 0 set 0|findstr/rix "0=0 0=[123456789][0123456789]* 0=-[123456789][0123456789]*">nul)||exit/b%%v

set val=

REM Swap min and max if needed
set /a "min = %~3" 2>nul || set /a "min = 0"
set /a "max = %~2" 2>nul || set "max="
if defined max (
	if %min% equ %max% exit /b 4
	if %min% gtr %max% set /a "min = max, max = %min%"
	call set "max=-Maximum %%max%%"
)

REM Get random number
for /f %%f in ('powershell -NoLogo -NoProfile -NonInteractive -Command Get-Random -Minimum %min% %max%') do (
	set /a "val = %%f"
)

if not defined val exit /b 9

REM Set referenced variable
endlocal & set "%~1=%val%"
exit /b 0
