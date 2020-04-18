@echo off
setlocal
REM /** Clamps numeric value inside variable between min and max, or sets default
REM * @version 1.0
REM * @author [HazelHex]{@link https://github.com/HazelHex}
REM * @example
REM * set /p "percent=Enter percentage: " && set /a "percent = percent" || set percent=
REM * call clamp percent 1 100 5
REM * echo/%percent%
REM * @param {reference} %1 - Name of variable being clamped and set, value must be number or empty
REM * @param {number} %2 - Bottom clamp
REM * @param {number} %3 - Upper clamp
REM * @param {number} [%4=0] - Default value to set, if referenced value is empty
REM * @returns {errorlevel} success (0), invalid parameter (1-4), invalid reference value (5)
REM */

REM Parameter validation
(call if "%%~1"===&&call set "0=%%~1"&&set 0|findstr/rix "0=[a-z#$.@[\]_+-][0123456789a-z#$.@[\]_+-]*"||exit/b1)2>nul>nul
for /l %%v in (2,1,3)do (call if "%%~%%v"===&&call set "0=%%~%%v"&&set 0|findstr/rix "0=0 0=[123456789][0123456789]* 0=-[123456789][0123456789]*"||exit/b%%v)2>nul>nul
call if "%%~4"===2>nul&&call set "0=%%~4"&&(if defined 0 set 0|findstr/rix "0=0 0=[123456789][0123456789]* 0=-[123456789][0123456789]*">nul)||exit/b4
if defined %~1 set %~1|findstr/rix "[^=]*=0 [^=]*=[123456789][0123456789]* [^=]*=-[123456789][0123456789]*">nul||exit/b5

REM Get referenced value, if empty set to default
(call set /a "val = %%%~1%%" || set /a "val = %~4" || set /a "val = 0") 2>nul

REM Swap min and max if needed
set /a "min = %~2, max = %~3"
if %min% gtr %max% set /a "min = max, max = %min%"

if defined %~1 (
	if %val% lss %min% ( REM Clamp to min
		set /a "val = min"
	) else if %val% gtr %max% ( REM Clamp to max
		set /a "val = max"
	)
)

REM Set referenced variable
endlocal & set "%~1=%val%"
exit /b 0
