# SimpleWhile Language Specification

## Important: Supported Operators

The SimpleWhile language has specific limitations on supported operators. This document clarifies what is and isn't supported.

## Integer Arithmetic Operators

### Supported (3 operators)
- **Addition**: `+`
- **Subtraction**: `-`
- **Multiplication**: `*`

### NOT Supported
- **Division**: `/` - NOT SUPPORTED
- **Modulo**: `%` - NOT SUPPORTED
- **Exponentiation**: `**` or `^` - NOT SUPPORTED

## Example: Valid Arithmetic Expressions

✅ **Valid:**
```
x = 2 + 3
y = 10 - 5
z = 4 * 5
result = (a + b) * (c - d)
sum = x + y + z
```

❌ **Invalid (will cause "Unknown character" error):**
```
x = 10 / 2        // Division not supported
y = 15 % 4        // Modulo not supported
z = 2 ** 3        // Exponentiation not supported
```

## Boolean Comparison Operators (All Supported)

✅ All 6 comparison operators are supported:
- Less than: `<`
- Greater than: `>`
- Less than or equal: `<=`
- Greater than or equal: `>=`
- Equal: `==`
- Not equal: `!=`

## Boolean Logical Operators (All Supported)

✅ All logical operators are supported:
- AND: `&&`
- OR: `||`
- Implication: `=>`
- If-and-only-if: `<=>`
- NOT: `!`

## Quantifiers (All Supported)

✅ Both quantifiers are supported:
- Universal: `forall x (...)`
- Existential: `exists y (...)`

## Why Division is Not Supported

The SimpleWhile language is designed for program verification and formal methods education. According to the language specification in `lang.h`, the `IntBinOpType` enum only defines:

```c
enum IntBinOpType {
  T_PLUS,
  T_MINUS,
  T_MUL
};
```

Division is intentionally excluded to keep the language simple for teaching purposes.

## Common Mistakes

### Mistake 1: Using division in loop invariants
❌ **Wrong:**
```
inv sum == i * (i + 1) / 2 && i >= 0
```

✅ **Correct:**
```
inv sum >= 0 && i >= 0
```

### Mistake 2: Using modulo for even/odd checks
❌ **Wrong:**
```
if (x % 2 == 0) { ... }
```

✅ **Workaround (using subtraction):**
```
// Not directly expressible - keep conditions simple
if (x >= 0) { ... }
```

## Testing Your Programs

Before running your SimpleWhile programs, verify:

1. ✓ Only use `+`, `-`, `*` for arithmetic
2. ✓ All comparison operators (`<`, `>`, `<=`, `>=`, `==`, `!=`) are fine
3. ✓ All logical operators (`&&`, `||`, `=>`, `<=>`, `!`) are fine
4. ✓ Quantifiers (`forall`, `exists`) are fine
5. ✓ No division `/` or modulo `%` operators

## Reference

See `lang.h` for the complete language specification:
- Lines 7-11: Integer binary operators
- Lines 13-20: Comparison operators
- Lines 22-27: Propositional logic operators
- Lines 29-31: Unary operators
- Lines 33-36: Quantifiers
- Lines 38-59: Expression and command types
