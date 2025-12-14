// 测试所有运算符
require a >= 0 && b > 0 && c <= 10 && d < 20 && e == 5 && f != 0
ensure result1 + result2 - result3 * result4 >= 0
{
    // 测试算术运算符
    result1 = a + b * c;
    result2 = d - e;
    result3 = f * 2 + 3;
    result4 = (a + b) * (c - d);

    // 测试所有比较运算符和逻辑运算符
    inv x >= 0 && (x < 100 || x == 100) && !(x > 100) && (x <= 50 => x * 2 <= 100)
    while (x < 10) {
        if (x < 5 && x >= 0) {
            x = x + 1
        } else {
            if (x > 5 || x == 5) {
                x = x + 2
            } else {
                x = x + 1
            }
        }
    };

    // 测试 IFF (<=>) 运算符
    inv (y == 0 <=> z == 0) && (y != 0 <=> z != 0)
    while (y < 5) {
        y = y + 1;
        z = z + 1
    }
}
