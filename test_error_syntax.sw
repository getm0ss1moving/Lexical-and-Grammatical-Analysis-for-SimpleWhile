// This file contains intentional syntax errors for testing error handling
// Expected: Parser should report errors

require x >= 0
ensure y == x
{
    // Missing semicolon - should cause error
    x = 5
    y = 10;
}
