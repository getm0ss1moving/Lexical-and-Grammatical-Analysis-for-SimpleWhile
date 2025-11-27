#!/bin/bash

# Quick validation script - builds and runs basic smoke test

echo "SimpleWhile Parser - Quick Validation"
echo "======================================"
echo ""

# Step 1: Build
echo "[1/3] Building parser..."
make clean > /dev/null 2>&1
if make > /dev/null 2>&1; then
    echo "✓ Build successful"
else
    echo "✗ Build failed"
    echo "Error details:"
    make
    exit 1
fi

echo ""

# Step 2: Run simple test
echo "[2/3] Running basic test (test_simple.sw)..."
if ./simplewhile_parser test_simple.sw > /dev/null 2>&1; then
    echo "✓ Basic test passed"
else
    echo "✗ Basic test failed"
    ./simplewhile_parser test_simple.sw
    exit 1
fi

echo ""

# Step 3: Run comprehensive test
echo "[3/3] Running comprehensive test..."
if ./simplewhile_parser test_comprehensive.sw > /dev/null 2>&1; then
    echo "✓ Comprehensive test passed"
else
    echo "✗ Comprehensive test failed"
    ./simplewhile_parser test_comprehensive.sw
    exit 1
fi

echo ""
echo "======================================"
echo "✓ All quick validation tests passed!"
echo "======================================"
echo ""
echo "Run './run_tests.sh' for complete test suite"
