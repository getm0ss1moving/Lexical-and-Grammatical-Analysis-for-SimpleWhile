# SimpleWhile Parser Test Guide

This document describes how to test the SimpleWhile parser and what to expect.

## Prerequisites

1. Build the parser:
   ```bash
   make
   ```

2. Ensure you have the following test files:
   - `test_simple.sw` - Basic assignment test
   - `test_example.sw` - Loop with invariant
   - `test_arithmetic.sw` - Arithmetic operations and precedence
   - `test_quantifiers.sw` - Forall and exists quantifiers
   - `test_comprehensive.sw` - All language features
   - `test_error_syntax.sw` - Intentional syntax error

## Running Tests

### Automated Testing

#### On Linux/Mac/Unix:
```bash
chmod +x run_tests.sh
./run_tests.sh
```

#### On Windows:
```batch
run_tests.bat
```

### Manual Testing

Test individual files:
```bash
./simplewhile_parser test_simple.sw
./simplewhile_parser test_comprehensive.sw
```

Test from stdin:
```bash
./simplewhile_parser
# Type or paste program, then Ctrl+D (Unix) or Ctrl+Z (Windows)
```

## Test Cases Description

### 1. test_simple.sw
**Purpose**: Basic functionality test
**Features tested**:
- require/ensure annotations
- Simple assignment
- Variable usage

**Expected output**:
- Should parse successfully
- AST should show require condition, ensure condition, and assignment

### 2. test_example.sw
**Purpose**: Loop with invariant
**Features tested**:
- While loop with invariant
- Integer arithmetic (+, -)
- Comparison operators (<)
- Loop invariant annotation

**Expected output**:
- Should parse successfully
- AST should show while loop with invariant

### 3. test_arithmetic.sw
**Purpose**: Arithmetic expression evaluation
**Features tested**:
- All arithmetic operators (+, -, *)
- Operator precedence (* before +/-)
- Left associativity
- Parenthesized expressions

**Expected output**:
- Should parse successfully
- AST should reflect correct precedence and associativity

### 4. test_quantifiers.sw
**Purpose**: Logical quantifiers
**Features tested**:
- forall quantifier
- exists quantifier
- Nested quantifiers
- Quantifiers in invariants

**Expected output**:
- Should parse successfully
- AST should show quantified expressions

### 5. test_comprehensive.sw
**Purpose**: Complete language coverage
**Features tested**:
- All integer operators (+, -, *)
- All comparison operators (<, >, <=, >=, ==, !=)
- All logical operators (&&, ||, =>, <=>, !)
- Quantifiers (forall, exists)
- All commands (assignment, skip, sequence, if-else, while)
- Nested structures
- Comments (single-line and multi-line)
- Complex boolean expressions

**Expected output**:
- Should parse successfully
- AST should show all nested structures correctly

### 6. test_error_syntax.sw
**Purpose**: Error handling verification
**Features tested**:
- Syntax error detection
- Error reporting with line numbers

**Expected output**:
- Should FAIL to parse
- Should report parse error with line number
- Error message should indicate the problem

## What to Verify

### For Successful Parses:
1. ✓ "Successfully parsed annotated SimpleWhile program" message
2. ✓ REQUIRE clause is correctly displayed
3. ✓ ENSURE clause is correctly displayed
4. ✓ COMMAND structure is properly formatted with indentation
5. ✓ All operators are preserved correctly
6. ✓ Nested structures show proper indentation

### For Failed Parses:
1. ✓ Error message is displayed
2. ✓ Line number is included in error message
3. ✓ Parser exits with non-zero status

## Checklist for Complete Testing

- [ ] All valid test files parse successfully
- [ ] AST output is properly formatted
- [ ] Operator precedence is correct (* before +/-)
- [ ] Operator associativity is correct (left-to-right)
- [ ] All comparison operators work (<, >, <=, >=, ==, !=)
- [ ] All logical operators work (&&, ||, =>, <=>, !)
- [ ] Quantifiers work (forall, exists)
- [ ] While loops with invariants parse correctly
- [ ] If-else statements parse correctly
- [ ] Nested structures parse correctly
- [ ] Comments are ignored
- [ ] Syntax errors are caught and reported
- [ ] Line numbers in errors are accurate
- [ ] Parser can read from both files and stdin

## Expected AST Structure

For a simple program like:
```
require x >= 0
ensure y == x
{
    y = x
}
```

Expected output should include:
```
REQUIRE: (x >= 0)
ENSURE: (y == x)
COMMAND:
  y = x;
```

## Common Issues and Solutions

### Issue: "simplewhile_parser not found"
**Solution**: Run `make` to build the parser

### Issue: "Unknown character" errors
**Solution**: Check for non-ASCII characters in test files

### Issue: Parse errors on valid syntax
**Solution**: Check for:
- Missing semicolons between statements
- Unmatched braces
- Missing require/ensure clauses

### Issue: Segmentation fault
**Solution**: Check for:
- NULL pointer access in AST construction
- Memory allocation failures

## Performance Testing

For large programs, verify:
- Parser completes in reasonable time
- No memory leaks (use valgrind on Linux)
- Proper error recovery

## Additional Manual Tests

Try these interactive tests:

1. **Empty program**:
   ```
   require true
   ensure true
   { skip }
   ```

2. **Deeply nested expressions**:
   ```
   require true
   ensure true
   {
       x = ((((1 + 2) * 3) - 4) + 5) * 6
   }
   ```

3. **Complex boolean**:
   ```
   require (a > 0 && b > 0) || (a < 0 && b < 0)
   ensure forall x (exists y (x + y == 0))
   { skip }
   ```

## Success Criteria

All tests pass if:
1. All valid test files parse without errors
2. AST output is correct and readable
3. Syntax errors are caught and reported
4. No crashes or hangs occur
5. Memory is properly managed (no leaks)
