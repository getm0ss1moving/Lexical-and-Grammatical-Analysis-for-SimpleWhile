// Test all arithmetic operations and precedence
require a >= 0 && b >= 0
ensure result > 0
{
    // Test operator precedence: * before + and -
    x = 2 + 3 * 4;        // Should be 2 + 12 = 14
    y = 10 - 2 * 3;       // Should be 10 - 6 = 4
    z = 5 * 6 + 7 * 8;    // Should be 30 + 56 = 86

    // Test left associativity of + and -
    p = 10 - 5 - 2;       // Should be (10 - 5) - 2 = 3
    q = 10 + 5 + 2;       // Should be (10 + 5) + 2 = 17

    // Test left associativity of *
    r = 2 * 3 * 4;        // Should be (2 * 3) * 4 = 24

    // Test parentheses
    s = (2 + 3) * 4;      // Should be 5 * 4 = 20
    t = 2 * (3 + 4);      // Should be 2 * 7 = 14

    // Complex expression
    result = (a + b) * (a - b) + a * b
}
