@echo off
REM Test runner script for SimpleWhile parser (Windows)
REM This script runs all test files and reports results

echo ==========================================
echo SimpleWhile Parser Test Suite
echo ==========================================
echo.

REM Check if parser exists
if not exist "simplewhile_parser.exe" (
    echo Error: simplewhile_parser.exe not found
    echo Please run 'make' first to build the parser
    exit /b 1
)

set TOTAL=0
set PASSED=0
set FAILED=0

echo Running valid test cases...
echo.

REM Test 1: Simple test
call :run_test test_simple.sw

REM Test 2: Example test
call :run_test test_example.sw

REM Test 3: Arithmetic test
call :run_test test_arithmetic.sw

REM Test 4: Quantifiers test
call :run_test test_quantifiers.sw

REM Test 5: Comprehensive test
call :run_test test_comprehensive.sw

REM Summary
echo.
echo ==========================================
echo TEST SUMMARY
echo ==========================================
echo Total tests: %TOTAL%
echo Passed: %PASSED%
echo Failed: %FAILED%
echo ==========================================

if %FAILED%==0 (
    echo All tests passed!
    exit /b 0
) else (
    echo Some tests failed.
    exit /b 1
)

:run_test
set /a TOTAL+=1
set test_file=%1

echo Testing: %~n1
echo File: %test_file%
echo ----------------------------------------

simplewhile_parser.exe %test_file% >nul 2>&1
if %errorlevel%==0 (
    echo [PASSED]
    set /a PASSED+=1
    echo.
    REM Show actual output
    simplewhile_parser.exe %test_file%
) else (
    echo [FAILED]
    set /a FAILED+=1
    echo Error output:
    simplewhile_parser.exe %test_file%
)

echo.
echo ==========================================
echo.
goto :eof
