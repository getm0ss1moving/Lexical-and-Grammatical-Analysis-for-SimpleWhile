// Comprehensive test for SimpleWhile parser
// This test covers all language features

require x >= 0 && y > 0 && forall k (k >= 0 => k * 2 >= 0)
ensure result == x + y && exists m (m == result)
{
    // Test assignment with arithmetic expressions
    a = 10;
    b = a + 5;
    c = b * 2 - 3;

    // Test skip command
    skip;

    // Test if-else with complex boolean expressions
    if (a < b && b <= c) {
        result = a + b
    } else {
        result = b + c
    };

    // Test nested if-else
    if (x == 0) {
        temp = 1
    } else {
        if (x > 0) {
            temp = x
        } else {
            temp = 0 - x
        }
    };

    // Test while loop with invariant
    i = 0;
    sum = 0;
    inv sum >= 0 && i >= 0 && i <= x
    while (i < x) {
        sum = sum + i;
        i = i + 1
    };

    // Test complex boolean expressions with all operators
    // Testing: &&, ||, =>, <=>, !
    if ((a > 0 || b < 0) && !(c == 0)) {
        flag = 1
    } else {
        flag = 0
    };

    // Test implication and iff
    if (x > 0 => y > 0) {
        p = 1
    } else {
        p = 0
    };

    if (a == b <=> c == d) {
        q = 1
    } else {
        q = 0
    };

    // Test all comparison operators
    if (a < b) { t1 = 1 } else { t1 = 0 };
    if (a > b) { t2 = 1 } else { t2 = 0 };
    if (a <= b) { t3 = 1 } else { t3 = 0 };
    if (a >= b) { t4 = 1 } else { t4 = 0 };
    if (a == b) { t5 = 1 } else { t5 = 0 };
    if (a != b) { t6 = 1 } else { t6 = 0 };

    // Test nested while loops
    outer = 0;
    inv outer >= 0 && outer <= 5
    while (outer < 5) {
        inner = 0;
        inv inner >= 0 && inner <= 3 && outer >= 0
        while (inner < 3) {
            product = outer * inner;
            inner = inner + 1
        };
        outer = outer + 1
    };

    /* Multi-line comment test
       This should be ignored by the lexer
       Testing: *, +, -, =, ==, etc.
    */

    // Final computation
    result = x + y
}
