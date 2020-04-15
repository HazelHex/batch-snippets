@echo off
setlocal
REM /** Reliably test if path is regular file, folder or doesn't exist.
REM * Works with UNC, junctions, shortcuts, no rights, etc
REM * @version 1.0
REM * @author [HazelHex]{@link https://github.com/HazelHex}
REM * @example
REM * check-path "C:\Documents and Settings\User"
REM * if errorlevel 19 echo/Doesn't exist!
REM * if %errorlevel% == 11 echo/It's folder!
REM * if %errorlevel% == 10 echo/It's file!
REM * @param {string} %1 - Path being tested
REM * @returns {errorlevel} invalid parameter (1), is file (10), is folder (11), doesn't exist (19)
REM */

REM Parameter validation
(call if "%%~1"===&&call set "_v=%%~1"&&set _v|findstr/rix "_v=[^*?<>|\"]*||exit/b1)2>nul>nul

REM Get path attributes
set "attr=%~a1"

if defined attr (
	if "%attr%" neq "%attr:d=%" ( REM check for directory attribute
		exit /b 11 & REM is folder
	) else exit /b 10 & REM is file
) else exit /b 19 & REM no attributes, doesn't exist
