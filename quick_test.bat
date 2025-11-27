@echo off
REM Quick validation script - builds and runs basic smoke test (Windows)

echo SimpleWhile Parser - Quick Validation
echo ======================================
echo.

REM Step 1: Build
echo [1/3] Building parser...
make clean >nul 2>&1
make >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Build successful
) else (
    echo [FAIL] Build failed
    echo Error details:
    make
    exit /b 1
)

echo.

REM Step 2: Run simple test
echo [2/3] Running basic test ^(test_simple.sw^)...
simplewhile_parser.exe test_simple.sw >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Basic test passed
) else (
    echo [FAIL] Basic test failed
    simplewhile_parser.exe test_simple.sw
    exit /b 1
)

echo.

REM Step 3: Run comprehensive test
echo [3/3] Running comprehensive test...
simplewhile_parser.exe test_comprehensive.sw >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Comprehensive test passed
) else (
    echo [FAIL] Comprehensive test failed
    simplewhile_parser.exe test_comprehensive.sw
    exit /b 1
)

echo.
echo ======================================
echo [OK] All quick validation tests passed!
echo ======================================
echo.
echo Run 'run_tests.bat' for complete test suite
