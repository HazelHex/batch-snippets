@echo off
setlocal
REM /** Clamps numeric value inside variable between min and max, or sets default
REM * @version 1.0
REM * @author [HazelHex]{@link https://github.com/HazelHex}
REM * @example
REM * set /p "percent=Enter percentage: " && set /a "percent = percent" || set percent=
REM * clamp percent 1 100 5
REM * echo/%percent%
REM * @param {reference} %1 - Name of variable being clamped and set, value must be number or empty
REM * @param {number} %2 - Bottom clamp
REM * @param {number} %3 - Upper clamp
REM * @param {number} [%4=0] - Default value, if referenced value is empty
REM * @returns {errorlevel} success (0), check parameters (2)
REM */

REM Basic check if required parameters are empty or malformed
for /l %%p in (1,1,3) do call set /a "%%~%%p" 2>nul || exit /b 2

REM Swap min and max if needed
set /a "min = %~2, max = %~3"
if %min% gtr %max% set /a "min = max, max = %min%"

REM Get referenced value
call set /a "val = %%%~1%%" 2>nul

if defined val (
	if %val%0 lss %min%0 ( REM Clamp to min
		set /a "val = min"
	) else if %val%0 gtr %max%0 ( REM Clamp to max
		set /a "val = max"
	)
) else ( REM Empty to default
	set /a "val = %~4" 2>nul || set /a "val = 0"
)

REM Set referenced variable
endlocal & set /a "%~1 = %val%"
exit /b 0
