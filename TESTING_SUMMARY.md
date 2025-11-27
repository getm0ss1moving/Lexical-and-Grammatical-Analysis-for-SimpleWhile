# Testing Summary for SimpleWhile Parser

## Overview

A comprehensive test suite has been created to verify the correctness of the SimpleWhile parser implementation. This document summarizes all test files and how to use them.

## Test Files Created

### Valid Test Programs

| File | Purpose | Features Tested |
|------|---------|----------------|
| `test_simple.sw` | Basic functionality | require/ensure, simple assignment |
| `test_example.sw` | Loop with invariant | while loop, invariant, arithmetic |
| `test_arithmetic.sw` | Arithmetic expressions | All operators, precedence, associativity |
| `test_quantifiers.sw` | Logical quantifiers | forall, exists, nested quantifiers |
| `test_comprehensive.sw` | Complete coverage | ALL language features combined |

### Error Test Programs

| File | Purpose | Expected Result |
|------|---------|----------------|
| `test_error_syntax.sw` | Syntax error detection | Should fail with error message |

## Test Runners

### Quick Validation Scripts
- **quick_test.sh** (Linux/Mac/Unix) - Fast smoke test
- **quick_test.bat** (Windows) - Fast smoke test

**What they do:**
1. Build the parser from scratch
2. Run basic test (test_simple.sw)
3. Run comprehensive test (test_comprehensive.sw)
4. Report pass/fail

**Usage:**
```bash
# Unix-like systems
chmod +x quick_test.sh
./quick_test.sh

# Windows
quick_test.bat
```

### Complete Test Suite
- **run_tests.sh** (Linux/Mac/Unix) - All tests with detailed output
- **run_tests.bat** (Windows) - All tests with detailed output

**What they do:**
1. Run all valid test files
2. Show AST output for each test
3. Count passed/failed tests
4. Provide summary report

**Usage:**
```bash
# Unix-like systems
chmod +x run_tests.sh
./run_tests.sh

# Windows
run_tests.bat
```

## Test Coverage

### Language Features Tested

✓ **Integer Expressions**
- Constants (0, 1, 42, etc.)
- Variables (x, y, counter, etc.)
- Addition (+)
- Subtraction (-)
- Multiplication (*)
- Operator precedence (* before +/-)
- Left associativity
- Parenthesized expressions

✓ **Boolean Expressions**
- Boolean constants (true, false)
- Comparison operators (<, >, <=, >=, ==, !=)
- Logical AND (&&)
- Logical OR (||)
- Implication (=>)
- If-and-only-if (<=>)
- Logical NOT (!)
- Parenthesized expressions

✓ **Quantifiers**
- Universal quantifier (forall)
- Existential quantifier (exists)
- Nested quantifiers

✓ **Commands**
- Assignment (x = expr)
- Skip command
- Sequence (cmd1; cmd2)
- If-else statements
- While loops with invariants
- Nested commands
- Block scoping with braces

✓ **Annotations**
- Preconditions (require)
- Postconditions (ensure)
- Loop invariants (inv)

✓ **Comments**
- Single-line comments (//)
- Multi-line comments (/* */)

✓ **Error Handling**
- Syntax error detection
- Line number reporting
- Graceful error messages

## How to Verify Correctness

### Step 1: Build
```bash
make
```
Should complete without errors.

### Step 2: Quick Test
```bash
./quick_test.sh  # or quick_test.bat on Windows
```
Should report: "All quick validation tests passed!"

### Step 3: Full Test Suite
```bash
./run_tests.sh  # or run_tests.bat on Windows
```
Should show:
- All 5 valid tests passing
- AST output for each test
- Summary: "All tests passed!"

### Step 4: Manual Verification
Test individual files and verify AST output:

```bash
./simplewhile_parser test_arithmetic.sw
```

**Verify:**
- Parsing succeeds
- REQUIRE clause shows correct boolean expression
- ENSURE clause shows correct boolean expression
- COMMAND section shows program structure
- Indentation is correct
- Operators are preserved

### Step 5: Error Handling
```bash
./simplewhile_parser test_error_syntax.sw
```

**Verify:**
- Parsing fails
- Error message is clear
- Line number is included
- Exit code is non-zero

## Expected Test Results

### test_simple.sw
```
REQUIRE: (x >= 0)
ENSURE: (y == x)
COMMAND:
  y = x;
```

### test_example.sw
```
REQUIRE: (x >= 0)
ENSURE: (y == (x * 2))
COMMAND:
  y = 0;
  inv ((y == ((x * 2) - (i * 2))) && (i >= 0))
  while (i < x) {
    y = (y + 2);
    i = (i + 1);
  }
```

### test_arithmetic.sw
Shows correct operator precedence:
- `2 + 3 * 4` → `(2 + (3 * 4))`
- `10 - 2 * 3` → `(10 - (2 * 3))`
- `(2 + 3) * 4` → `((2 + 3) * 4)`

### test_quantifiers.sw
Shows quantifiers:
- `forall x (...)` → `forall x (...)`
- `exists y (...)` → `exists y (...)`

### test_comprehensive.sw
Shows all features working together in a complex program.

## Debugging Tips

### If parser doesn't build:
1. Check that flex and bison are installed
2. Check that gcc is installed
3. Run `make clean` then `make` again

### If tests fail:
1. Check generated files: `parser.tab.c`, `lex.yy.c`
2. Look for compilation warnings
3. Run parser with single test file to isolate issue
4. Check error messages for line numbers

### If AST output is wrong:
1. Verify operator precedence in parser.y
2. Check associativity declarations
3. Verify AST construction in lang.c

### If memory errors occur:
1. Run with valgrind (Linux): `valgrind ./simplewhile_parser test_simple.sw`
2. Check for NULL pointer dereferences
3. Verify malloc return values

## Success Criteria

The parser is considered correct if:

1. ✓ Builds without errors or warnings
2. ✓ All 5 valid test files parse successfully
3. ✓ AST output is correctly structured
4. ✓ Operator precedence is correct
5. ✓ Operator associativity is correct
6. ✓ All operators are supported
7. ✓ All commands are supported
8. ✓ Quantifiers work correctly
9. ✓ Comments are ignored
10. ✓ Syntax errors are detected and reported
11. ✓ No memory leaks or crashes
12. ✓ Can read from both files and stdin

## Additional Testing

For thorough testing, also try:

1. **Large files**: Create programs with 100+ lines
2. **Deep nesting**: Nest if-else statements 10+ levels deep
3. **Complex expressions**: Chain 20+ operators
4. **Edge cases**: Empty blocks, single statements, etc.
5. **Unicode**: Ensure only ASCII is supported
6. **Stress test**: Very long variable names, many variables

## Documentation

- `TEST_GUIDE.md` - Detailed step-by-step testing instructions
- `README.md` - General usage and build instructions
- This file - Testing summary and quick reference

## Conclusion

This test suite provides comprehensive coverage of the SimpleWhile language. Running all tests successfully demonstrates that the parser correctly implements:
- Lexical analysis (tokenization)
- Syntactic analysis (parsing)
- AST construction
- Error handling
- All language features as specified
