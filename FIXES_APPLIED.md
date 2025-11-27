# Fixes Applied for Line Ending Issues

## Problems Identified

### Problem 1: Shell Script Line Endings
**Error**: `/bin/bash^M: bad interpreter: No such file or directory`

**Cause**: Shell scripts were created with Windows line endings (CRLF = `\r\n`) but WSL/Linux expects Unix line endings (LF = `\n`). The `^M` character is the carriage return `\r`.

### Problem 2: Parser Failing on Valid Files
**Error**: `Parse error at line 2: syntax error`

**Cause**: The lexer didn't handle carriage return (`\r`) characters, treating them as unknown characters. When test files had Windows line endings, the `\r` characters caused parse errors.

## Fixes Applied

### Fix 1: Updated Lexer (lexer.l)
**Changed line 61** to handle carriage returns:

**Before:**
```c
[ \t]+          { /* ignore whitespace */ }
```

**After:**
```c
[ \t\r]+        { /* ignore whitespace and carriage returns */ }
```

This makes the lexer ignore `\r` characters, allowing it to work with both Windows (CRLF) and Unix (LF) line endings.

### Fix 2: Created Line Ending Fix Script
Created `fix_line_endings.sh` to convert shell scripts to Unix line endings.

## How to Apply the Fixes

### Step 1: Rebuild the Parser
The lexer has been fixed. Rebuild the parser to use the updated lexer:

```bash
make clean
make
```

### Step 2: Fix Shell Script Line Endings (if needed)
If you get "bad interpreter" errors when running shell scripts:

**Option A: Use the fix script**
```bash
bash fix_line_endings.sh
```

**Option B: Manual fix with sed**
```bash
sed -i 's/\r$//' run_tests.sh
sed -i 's/\r$//' quick_test.sh
chmod +x run_tests.sh
chmod +x quick_test.sh
```

**Option C: Use dos2unix (if installed)**
```bash
dos2unix run_tests.sh quick_test.sh
chmod +x run_tests.sh quick_test.sh
```

### Step 3: Test the Parser
After rebuilding, test with the provided test files:

```bash
# Test a simple file
./simplewhile_parser test_simple.sw

# Test comprehensive file
./simplewhile_parser test_comprehensive.sw

# Run all tests
./run_tests.sh
```

## Expected Results After Fixes

### Test: test_simple.sw
```bash
$ ./simplewhile_parser test_simple.sw
Parsing file: test_simple.sw
Successfully parsed annotated SimpleWhile program

=== Parsed Program AST ===

REQUIRE: (x >= 0)

ENSURE: (y == x)

COMMAND:
  y = x;

=== End of AST ===
```

### Test: test_comprehensive.sw
Should parse successfully and display the full AST without errors.

## Why This Happened

1. **Development Environment**: Files were created on Windows, which uses CRLF line endings
2. **Execution Environment**: Running in WSL/Linux, which expects LF line endings
3. **Lexer Design**: Original lexer only handled `\n`, not `\r`

## Prevention for Future

### For Source Code Files (.c, .h, .l, .y)
The lexer now handles both line ending types, so these will work regardless of format.

### For Shell Scripts (.sh)
Use one of these approaches:

1. **Set Git to auto-convert** (recommended):
   ```bash
   git config --global core.autocrlf input
   ```

2. **Configure your editor** to use LF line endings for `.sh` files

3. **Run fix script** whenever you get "bad interpreter" errors

## Verification

After applying fixes, verify everything works:

```bash
# Should work without errors
./simplewhile_parser test_simple.sw
./simplewhile_parser test_arithmetic.sw
./simplewhile_parser test_quantifiers.sw
./simplewhile_parser test_comprehensive.sw

# All should parse successfully
```

## Additional Notes

- The parser now works with files that have either Windows (CRLF) or Unix (LF) line endings
- Test files (.sw) don't need conversion - the lexer handles them
- Only shell scripts (.sh) need line ending conversion for WSL/Linux execution
- Windows users running .bat files don't need any fixes
