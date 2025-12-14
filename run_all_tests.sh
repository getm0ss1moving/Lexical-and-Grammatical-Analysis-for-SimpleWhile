#!/bin/bash

# SimpleWhile 解析器自动化测试脚本
# 用途：批量测试所有 .sw 文件
# 日期：2025-12-14

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 测试统计变量
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
PARSER="./simplewhile_parser"

# 错误测试文件列表（这些文件预期应该失败）
ERROR_TESTS=(
    "test_missing_invariant.sw"
    "test_error_syntax.sw"
)

# 打印标题
print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  SimpleWhile Parser - Automated Test${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

# 检查解析器是否存在
check_parser() {
    if [ ! -f "$PARSER" ]; then
        echo -e "${RED}错误: 找不到解析器 $PARSER${NC}"
        echo -e "${YELLOW}请先编译解析器：${NC}"
        echo "  bison -d parser.y"
        echo "  flex lexer.l"
        echo "  gcc -Wall -g -c parser.tab.c lex.yy.c lang.c main.c"
        echo "  gcc -Wall -g -o simplewhile_parser parser.tab.o lex.yy.o lang.o main.o"
        exit 1
    fi
}

# 检查文件是否在错误测试列表中
is_error_test() {
    local filename="$1"
    for error_test in "${ERROR_TESTS[@]}"; do
        if [ "$filename" == "$error_test" ]; then
            return 0  # 是错误测试
        fi
    done
    return 1  # 不是错误测试
}

# 运行单个测试
run_test() {
    local test_file="$1"
    local filename=$(basename "$test_file")

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    # 判断是否为错误测试
    if is_error_test "$filename"; then
        echo -e "${YELLOW}测试 [$TOTAL_TESTS]: $filename (错误测试)${NC}"

        # 运行解析器，捕获输出和退出码
        output=$($PARSER "$test_file" 2>&1)
        exit_code=$?

        # 错误测试应该失败（非零退出码）
        if [ $exit_code -ne 0 ]; then
            echo -e "${GREEN}  ✓ PASS - 正确检测到错误${NC}"
            echo -e "${BLUE}  错误信息: ${NC}$(echo "$output" | grep -i "error" | head -1)"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        else
            echo -e "${RED}  ✗ FAIL - 应该报错但成功解析了${NC}"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    else
        echo -e "${CYAN}测试 [$TOTAL_TESTS]: $filename${NC}"

        # 运行解析器，捕获输出和退出码
        output=$($PARSER "$test_file" 2>&1)
        exit_code=$?

        # 正常测试应该成功（零退出码）
        if [ $exit_code -eq 0 ]; then
            echo -e "${GREEN}  ✓ PASS - 解析成功${NC}"
            # 提取并显示关键信息
            if echo "$output" | grep -q "Successfully parsed"; then
                echo -e "${BLUE}  状态: 成功解析 SimpleWhile 程序${NC}"
            fi
            PASSED_TESTS=$((PASSED_TESTS + 1))
        else
            echo -e "${RED}  ✗ FAIL - 解析失败${NC}"
            echo -e "${RED}  错误信息:${NC}"
            echo "$output" | grep -i "error" | sed 's/^/    /'
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    fi

    echo ""
}

# 打印测试摘要
print_summary() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}           测试摘要报告${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "总测试数:   ${BLUE}$TOTAL_TESTS${NC}"
    echo -e "通过测试:   ${GREEN}$PASSED_TESTS${NC}"
    echo -e "失败测试:   ${RED}$FAILED_TESTS${NC}"

    if [ $TOTAL_TESTS -gt 0 ]; then
        PASS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
        echo -e "通过率:     ${BLUE}$PASS_RATE%${NC}"
    fi

    echo -e "${CYAN}========================================${NC}"

    if [ $FAILED_TESTS -eq 0 ]; then
        echo -e "${GREEN}✓ 所有测试通过！${NC}"
        return 0
    else
        echo -e "${RED}✗ 有测试失败，请检查上述错误信息${NC}"
        return 1
    fi
}

# 生成详细报告
generate_report() {
    local report_file="test_results_$(date +%Y%m%d_%H%M%S).txt"

    {
        echo "SimpleWhile Parser 测试报告"
        echo "======================================"
        echo "测试时间: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "总测试数: $TOTAL_TESTS"
        echo "通过测试: $PASSED_TESTS"
        echo "失败测试: $FAILED_TESTS"
        if [ $TOTAL_TESTS -gt 0 ]; then
            echo "通过率: $((PASSED_TESTS * 100 / TOTAL_TESTS))%"
        fi
        echo "======================================"
        echo ""
        echo "测试文件列表："

        for test_file in *.sw; do
            if [ -f "$test_file" ]; then
                echo "  - $test_file"
            fi
        done
    } > "$report_file"

    echo -e "${YELLOW}详细报告已保存到: $report_file${NC}"
}

# 主函数
main() {
    print_header

    # 检查解析器
    check_parser

    # 查找所有 .sw 文件
    sw_files=(*.sw)

    if [ ${#sw_files[@]} -eq 0 ] || [ ! -f "${sw_files[0]}" ]; then
        echo -e "${RED}错误: 当前目录下没有找到 .sw 文件${NC}"
        exit 1
    fi

    echo -e "${BLUE}找到 ${#sw_files[@]} 个测试文件${NC}"
    echo ""

    # 运行所有测试
    for test_file in "${sw_files[@]}"; do
        if [ -f "$test_file" ]; then
            run_test "$test_file"
        fi
    done

    # 打印摘要
    print_summary
    result=$?

    echo ""

    # 生成报告
    generate_report

    exit $result
}

# 执行主函数
main
