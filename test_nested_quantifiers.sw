// 测试嵌套量词（不带括号）
require forall x exists y y > x
ensure forall a forall b a + b >= a && a + b >= b
{
    x = 5;
    y = 10
}
