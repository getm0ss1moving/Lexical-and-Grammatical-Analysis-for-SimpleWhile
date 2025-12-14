// 测试量词优先级：量词应该优先级最低，右结合
// forall x P && Q 应该解析为 forall x (P && Q)
// forall x P || Q 应该解析为 forall x (P || Q)
// forall x P => Q 应该解析为 forall x (P => Q)
// forall x P <=> Q 应该解析为 forall x (P <=> Q)
require forall x x >= 0 => x * x >= 0
ensure exists y y > 0 && y < 100 || y == 0
{
    n = 42;
    // 测试复杂的量词表达式
    inv forall i i >= 0 => i <= n <=> i * 2 <= n * 2
    while (n > 0) {
        n = n - 1
    }
}
