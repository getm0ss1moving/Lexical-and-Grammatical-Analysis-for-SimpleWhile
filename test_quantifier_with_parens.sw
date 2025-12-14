// 测试量词带括号和不带括号的混合使用
require forall x (x >= 0 => exists y (y > x)) && exists z z == 0
ensure forall a forall b (a == b || a != b) <=> true
{
    x = 0;
    y = 1;

    // 测试量词在循环不变量中的使用（带括号）
    inv forall i (i >= 0) => (exists j (j == i + 1))
    while (x < 5) {
        x = x + 1;
        y = y * 2
    }
}
