// Test quantifiers: forall and exists
require forall x (x >= 0 => x * x >= 0) && exists y (y == 0)
ensure forall z (z > 0 => result > 0) && exists w (w == result)
{
    result = 42;

    // Test nested quantifiers
    if (forall a (exists b (a + b == 0))) {
        flag = 1
    } else {
        flag = 0
    };

    // Test quantifiers in while invariant
    i = 0;
    inv forall j (j >= 0 && j < i => j < 10) && i >= 0
    while (i < 10) {
        i = i + 1
    }
}
