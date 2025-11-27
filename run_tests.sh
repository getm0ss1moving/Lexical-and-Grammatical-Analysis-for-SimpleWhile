#!/bin/bash

# Test runner script for SimpleWhile parser
# This script runs all test files and reports results

echo "=========================================="
echo "SimpleWhile Parser Test Suite"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if parser exists
if [ ! -f "./simplewhile_parser" ]; then
    echo -e "${RED}Error: simplewhile_parser not found${NC}"
    echo "Please run 'make' first to build the parser"
    exit 1
fi

# Counter for test results
TOTAL=0
PASSED=0
FAILED=0

# Function to run a test
run_test() {
    local test_file=$1
    local test_name=$(basename "$test_file" .sw)

    echo -e "${YELLOW}Testing: $test_name${NC}"
    echo "File: $test_file"
    echo "----------------------------------------"

    TOTAL=$((TOTAL + 1))

    if ./simplewhile_parser "$test_file" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASSED${NC}"
        PASSED=$((PASSED + 1))
        echo ""
        # Show actual output
        ./simplewhile_parser "$test_file"
    else
        echo -e "${RED}✗ FAILED${NC}"
        FAILED=$((FAILED + 1))
        echo "Error output:"
        ./simplewhile_parser "$test_file" 2>&1
    fi

    echo ""
    echo "=========================================="
    echo ""
}

# Run all test files
echo "Running valid test cases..."
echo ""

run_test "test_simple.sw"
run_test "test_example.sw"
run_test "test_arithmetic.sw"
run_test "test_quantifiers.sw"
run_test "test_comprehensive.sw"

# Summary
echo ""
echo "=========================================="
echo "TEST SUMMARY"
echo "=========================================="
echo "Total tests: $TOTAL"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo "=========================================="

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
