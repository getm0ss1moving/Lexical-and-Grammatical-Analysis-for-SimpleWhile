// 综合测试：量词不带括号、嵌套量词、优先级、循环不变量
// 测试量词不带括号和量词优先级（forall x x >= 0 && y >= 0 应该是 forall x (x >= 0 && y >= 0)）
require forall x x >= 0 && forall y y >= 0
ensure forall z z >= 0 => exists w w == z * 2
inv x >= 0 && y >= 0
while (x < 10) {
    x = x + 1;
    y = y + x
}
