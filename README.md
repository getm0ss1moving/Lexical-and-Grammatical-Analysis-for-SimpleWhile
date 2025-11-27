# SimpleWhile Language Parser

A complete lexer and parser implementation for the annotated SimpleWhile language using Flex and Bison.

## Language Features

### Annotated Programs
- Programs start with `require` (precondition) and `ensure` (postcondition)
- While loops have invariants specified with `inv`

### Integer Expressions
- Constants: `0`, `1`, `42`, etc.
- Variables: `x`, `y`, `counter`, etc.
- Binary operations: `+`, `-`, `*` (Note: **division `/` is NOT supported**)

### Boolean Expressions
- Constants: `true`, `false`
- Comparisons: `<`, `>`, `<=`, `>=`, `==`, `!=`
- Logical operators: `&&`, `||`, `=>`, `<=>`, `!`
- Quantifiers: `forall x (...)`, `exists y (...)`

### Commands
- Assignment: `x = expr;`
- Skip: `skip;`
- Sequence: `cmd1; cmd2`
- If-else: `if (cond) { cmd1 } else { cmd2 }`
- While: `inv invariant while (cond) { body }`

## Building

### Prerequisites
- GCC compiler
- Flex (lexical analyzer generator)
- Bison (parser generator)
- Make

### Compile
```bash
make
```

This will generate the `simplewhile_parser` executable.

### Clean
```bash
make clean
```

## Usage

### Parse from file
```bash
./simplewhile_parser test_example.sw
```

### Parse from stdin
```bash
./simplewhile_parser
```
Then type your program and press Ctrl+D (Unix/Linux/Mac) or Ctrl+Z (Windows) to finish input.

## Example Program

```
require x >= 0
ensure y == x * 2
{
    y = 0;
    inv y == x * 2 - i * 2 && i >= 0
    while (i < x) {
        y = y + 2;
        i = i + 1
    }
}
```

## Testing

### Quick Validation
Run a quick smoke test to verify everything works:

**Linux/Mac/Unix:**
```bash
chmod +x quick_test.sh
./quick_test.sh
```

**Windows:**
```batch
quick_test.bat
```

### Complete Test Suite
Run all tests with detailed output:

**Linux/Mac/Unix:**
```bash
chmod +x run_tests.sh
./run_tests.sh
```

**Windows:**
```batch
run_tests.bat
```

### Available Test Files
- `test_simple.sw` - Basic assignment test
- `test_example.sw` - Loop with invariant
- `test_arithmetic.sw` - Arithmetic operations and precedence
- `test_quantifiers.sw` - Forall and exists quantifiers
- `test_comprehensive.sw` - All language features combined
- `test_error_syntax.sw` - Syntax error handling test

See `TEST_GUIDE.md` for detailed testing instructions.

## File Structure

- `lexer.l` - Flex lexer specification for tokenization
- `parser.y` - Bison parser specification for grammar analysis
- `lang.h` - Header file with AST data structures
- `lang.c` - Implementation of AST construction functions
- `main.c` - Main driver program with AST pretty-printer
- `Makefile` - Build configuration
- `test_*.sw` - Test programs
- `run_tests.sh/bat` - Complete test suite runner
- `quick_test.sh/bat` - Quick validation script
- `TEST_GUIDE.md` - Detailed testing guide

## Grammar Overview

```
program → require expr_bool ensure expr_bool cmd

cmd → simple_cmd
    | cmd ; cmd

simple_cmd → ident = expr_int
           | skip
           | if (expr_bool) { cmd } else { cmd }
           | inv expr_bool while (expr_bool) { cmd }
           | { cmd }

expr_int → term
         | expr_int + term
         | expr_int - term

term → factor
     | term * factor

factor → number
       | identifier
       | (expr_int)

expr_bool → atomic_bool
          | quant_bool
          | expr_bool && expr_bool
          | expr_bool || expr_bool
          | expr_bool => expr_bool
          | expr_bool <=> expr_bool
          | ! expr_bool
          | (expr_bool)

atomic_bool → true | false
            | expr_int < expr_int
            | expr_int > expr_int
            | expr_int <= expr_int
            | expr_int >= expr_int
            | expr_int == expr_int
            | expr_int != expr_int

quant_bool → forall ident (expr_bool)
           | exists ident (expr_bool)
```

## Output

The parser will:
1. Perform lexical analysis (tokenization)
2. Perform syntactic analysis (parsing)
3. Build an Abstract Syntax Tree (AST)
4. Pretty-print the parsed AST showing:
   - REQUIRE clause
   - ENSURE clause
   - Program commands with proper indentation

## Error Handling

- Lexical errors: Unknown characters are reported with line numbers
- Syntax errors: Parse errors are reported with line numbers
- Memory allocation failures are caught and reported

### Common Errors

**"Unknown character: / at line X"**
- Cause: You used the division operator `/` which is not supported
- Solution: Remove division - only `+`, `-`, `*` are supported
- See `LANGUAGE_SPEC.md` for complete operator list

**"Parse error at line X: syntax error"**
- Cause: Missing semicolons, unmatched braces, or unsupported syntax
- Solution: Check syntax matches the grammar in this README
