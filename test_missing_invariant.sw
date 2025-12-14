// 错误测试：缺少循环不变量（应该报错）
require x >= 0
ensure x >= 10
while (x < 10) {
    x = x + 1
}
