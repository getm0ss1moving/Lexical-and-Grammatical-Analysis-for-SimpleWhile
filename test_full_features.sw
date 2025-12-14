// 完整功能测试：所有语言特性
require forall x x >= 0 => exists y y == x + 1 && y > x
ensure result >= 0 && forall z z < result => z * z < n
{
    // 初始化变量
    n = 100;
    result = 0;
    temp = 0;

    // 第一个循环：计算平方根
    inv result * result <= n && (result + 1) * (result + 1) > n || result == 0
    while (result * result <= n) {
        // 嵌套 if-else
        if (result * result == n) {
            temp = 1
        } else {
            temp = 0
        };
        result = result + 1
    };

    // 第二个循环：调整结果
    inv result >= 0
    while (result * result > n) {
        result = result - 1
    };

    // 第三个循环：使用更复杂的条件
    inv temp >= 0 && temp <= 10
    while (temp < 10) {
        if (temp < 5) {
            temp = temp + 1
        } else {
            if (temp < 8) {
                temp = temp + 2
            } else {
                temp = temp + 1
            }
        }
    };

    // 测试 skip
    if (result > 0) {
        skip
    } else {
        result = 0
    }
}
