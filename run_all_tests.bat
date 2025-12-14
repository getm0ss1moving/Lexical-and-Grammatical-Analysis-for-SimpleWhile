@echo off
REM SimpleWhile 解析器自动化测试脚本
REM 用于批量测试所有 .sw 文件
REM 日期：2025-12-14

SETLOCAL ENABLEDELAYEDEXPANSION

REM 设置控制台代码页为 UTF-8
chcp 65001 >nul 2>&1

REM 颜色代码
SET "GREEN=[32m"
SET "RED=[31m"
SET "YELLOW=[33m"
SET "BLUE=[34m"
SET "CYAN=[36m"
SET "NC=[0m"
SET "BOLD=[1m"

REM 初始化变量
SET TOTAL_TESTS=0
SET PASSED_TESTS=0
SET FAILED_TESTS=0
SET PARSER=simplewhile_parser.exe

REM 关闭回显
REM 不显示命令本身，只显示输出

REM 错误测试文件列表
SET ERROR_TESTS=test_missing_invariant.sw test_error_syntax.sw

REM 打印标题
echo %CYAN%========================================%NC%
echo %CYAN%  SimpleWhile Parser - Automated Test%NC%
echo %CYAN%========================================%NC%
echo.

REM 检查解析器是否存在
IF NOT EXIST "%PARSER%" (
    echo %RED%错误: 找不到解析器 %PARSER%%NC%
    echo %YELLOW%请先编译解析器：%NC%
    echo   bison -d parser.y
    echo   flex lexer.l
    echo   gcc -Wall -g -c parser.tab.c lex.yy.c lang.c main.c
    echo   gcc -Wall -g -o %PARSER% parser.tab.o lex.yy.o lang.o main.o
    pause
    exit /b 1
)

REM 统计 .sw 文件数量
SET FILE_COUNT=0
FOR %%F IN (*.sw) DO SET /A FILE_COUNT+=1

IF !FILE_COUNT! EQU 0 (
    echo %RED%错误: 当前目录下没有找到 .sw 文件%NC%
    pause
    exit /b 1
)

echo %BLUE%找到 %FILE_COUNT% 个测试文件%NC%
echo.

REM 运行所有测试文件
FOR %%F IN (*.sw) DO (
    CALL :RUN_TEST "%%F"
)

REM 打印摘要
CALL :PRINT_SUMMARY

REM 生成报告
CALL :GENERATE_REPORT

REM 等待用户按键
pause
exit /b %ERRORLEVEL%

:RUN_TEST
REM 运行单个测试的函数
SET "TEST_FILE=%~1"
SET "FILENAME=%~n1.sw"

SET /A TOTAL_TESTS+=1

REM 检查是否为错误测试
SET "IS_ERROR_TEST=0"
FOR %%E IN (%ERROR_TESTS%) DO (
    IF "!FILENAME!"=="%%E" (
        SET "IS_ERROR_TEST=1"
        goto :CHECK_ERROR_TEST
    )
)

:CONTINUE_TEST
IF !IS_ERROR_TEST!==1 (
    echo %YELLOW%测试 [%TOTAL_TESTS%]: %FILENAME% (错误测试)%NC%

    REM 运行解析器，捕获输出和错误级别
    REM %PARSER% 会返回退出码，我们检查 %ERRORLEVEL%
    "%PARSER%" "%TEST_FILE%" >out_temp.txt 2>&1
    SET "EXIT_CODE=!ERRORLEVEL!"

    REM 错误测试应该失败（EXIT_CODE != 0）
    IF !EXIT_CODE! NEQ 0 (
        echo %GREEN%  ^✓ PASS - 正确检测到错误%NC%
        REM 从输出中提取错误信息
        FOR /F "tokens=*" %%L IN ('%SYSTEMROOT%\system32\find.exe /I "error" "out_temp.txt" ^| %SYSTEMROOT%\system32\find.exe /V /C ""') DO SET ERROR_COUNT=%%L
        IF !ERROR_COUNT! GTR 0 (
            echo %BLUE%  错误信息: %NC%
            FOR /F "tokens=*" %%L IN ('%SYSTEMROOT%\system32\find.exe /I "error" "out_temp.txt"') DO (
                echo     %%L
                GOTO :YANWEI1
            )
            :YANWEI1
        )
        SET /A PASSED_TESTS+=1
    ) ELSE (
        echo %RED%  ^✗ FAIL - 应该报错但成功解析了%NC%
        SET /A FAILED_TESTS+=1
    )
) ELSE (
    echo %CYAN%测试 [%TOTAL_TESTS%]: %FILENAME%%NC%

    REM 运行解析器
    "%PARSER%" "%TEST_FILE%" >out_temp.txt 2>&1
    SET "EXIT_CODE=!ERRORLEVEL!"

    IF !EXIT_CODE! EQU 0 (
        echo %GREEN%  ^✓ PASS - 解析成功%NC%
        FOR /F "tokens=*" %%L IN ('%SYSTEMROOT%\system32\find.exe /I "successfully parsed" "out_temp.txt"') DO (
            IF NOT "%%L"=="" (
                echo %BLUE%  状态: 成功解析 SimpleWhile 程序%NC%
                GOTO :YANWEI2
            )
        )
        :YANWEI2
        SET /A PASSED_TESTS+=1
    ) ELSE (
        echo %RED%  ^✗ FAIL - 解析失败%NC%
        echo %RED%  错误信息:%NC%
        FOR /F "tokens=*" %%L IN ('%SYSTEMROOT%\system32\find.exe /I "error" "out_temp.txt" 2^>nul') DO (
            echo     %%L
        )
        SET /A FAILED_TESTS+=1
    )
)

IF EXIST "out_temp.txt" DEL "out_temp.txt"
echo.
GOTO :EOF

:CHECK_ERROR_TEST
REM 这个标签用于跳过进一步的错误测试判断
GOTO :CONTINUE_TEST

:PRINT_SUMMARY
echo %CYAN%========================================%NC%
echo %CYAN%           测试摘要报告%NC%
echo %CYAN%========================================%NC%
echo 总测试数:   %BLUE%%TOTAL_TESTS%%NC%
echo 通过测试:   %GREEN%%PASSED_TESTS%%NC%
echo 失败测试:   %RED%%FAILED_TESTS%%NC%

IF %TOTAL_TESTS% GTR 0 (
    SET /A PASS_RATE=%PASSED_TESTS% * 100 / %TOTAL_TESTS%
    echo 通过率:     %BLUE%%PASS_RATE% %% %NC%
)

echo %CYAN%========================================%NC%

IF %FAILED_TESTS% EQU 0 (
    echo %GREEN%✓ 所有测试通过！%NC%
    SET ERRORLEVEL=0
) ELSE (
    echo %RED%✗ 有测试失败，请检查上述错误信息%NC%
    SET ERRORLEVEL=1
)
echo.
GOTO :EOF

:GENERATE_REPORT
REM 生成测试报告文件
SET REPORT_FILE=test_results_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt
REM 删除时间中的空格（上午默认有空格）
SET REPORT_FILE=!REPORT_FILE: =0!

(
echo SimpleWhile Parser 测试报告
echo ======================================
echo 测试时间: %date% %time%
echo 总测试数: %TOTAL_TESTS%
echo 通过测试: %PASSED_TESTS%
echo 失败测试: %FAILED_TESTS%
IF %TOTAL_TESTS% GTR 0 (
echo 通过率: %PASSED_TESTS% 项通过 (100%% 如果全通过)
)
echo ======================================
echo.
echo 测试文件列表：
echo -------------------------------
FOR %%F IN (*.sw) DO echo - %%F >
) > "%REPORT_FILE%"

echo %YELLOW%详细报告已保存到: %REPORT_FILE%%NC%
GOTO :EOF