# 自动化测试脚本使用指南

## 脚本概述

提供了两个自动化测试脚本，用于批量测试所有 `.sw` 测试文件：

- **run_all_tests.sh** - Linux/Mac/Git Bash 版本
- **run_all_tests.bat** - Windows 命令提示符版本

## 快速开始

### Linux/Mac/Git Bash 用户

```bash
# 1. 确保脚本有执行权限
chmod +x run_all_tests.sh

# 2. 运行测试
./run_all_tests.sh
```

### Windows 用户（命令提示符）

```cmd
# 直接双击 run_all_tests.bat 或在命令行运行
run_all_tests.bat
```

### Windows 用户（Git Bash）

```bash
# 使用 sh 脚本
./run_all_tests.sh
```

---

## 脚本功能

### 1. 自动检测
- ✅ 自动检测解析器是否存在
- ✅ 自动查找所有 `.sw` 文件
- ✅ 自动识别错误测试用例

### 2. 智能测试
- ✅ 区分正常测试和错误测试
  - 正常测试：期望解析成功
  - 错误测试：期望解析失败（如 `test_missing_invariant.sw`）
- ✅ 彩色输出，直观显示测试结果
- ✅ 实时显示每个测试的状态

### 3. 详细报告
- ✅ 测试通过/失败统计
- ✅ 通过率计算
- ✅ 自动生成测试报告文件

---

## 输出说明

### 测试过程输出

```
========================================
  SimpleWhile Parser - Automated Test
========================================

找到 13 个测试文件

测试 [1]: test_advanced.sw
  ✓ PASS - 解析成功
  状态: 成功解析 SimpleWhile 程序

测试 [2]: test_missing_invariant.sw (错误测试)
  ✓ PASS - 正确检测到错误
  错误信息: Parse error at line 4: syntax error

...
```

### 测试摘要

```
========================================
           测试摘要报告
========================================
总测试数:   13
通过测试:   13
失败测试:   0
通过率:     100%
========================================
✓ 所有测试通过！

详细报告已保存到: test_results_20251214_180106.txt
```

---

## 测试文件分类

### 正常测试（应该成功）

| 文件名 | 测试内容 |
|--------|---------|
| test_simple.sw | 基础赋值语句 |
| test_arithmetic.sw | 算术表达式和优先级 |
| test_quantifiers.sw | 量词（带括号） |
| test_comprehensive.sw | 综合功能（现有） |
| test_advanced.sw | 量词不带括号 |
| test_nested_quantifiers.sw | 嵌套量词 |
| test_quantifier_precedence.sw | 量词优先级 |
| test_quantifier_with_parens.sw | 量词兼容性 |
| test_operators.sw | 所有运算符 |
| test_full_features.sw | 完整功能 |
| test_example.sw | 示例程序 |

### 错误测试（应该失败）

| 文件名 | 测试内容 |
|--------|---------|
| test_missing_invariant.sw | 缺少循环不变量 |
| test_error_syntax.sw | 语法错误 |

---

## 生成的测试报告

脚本会自动生成一个带时间戳的测试报告文件：

**文件名格式**：`test_results_YYYYMMDD_HHMMSS.txt`

**报告内容示例**：
```
SimpleWhile Parser 测试报告
======================================
测试时间: 2025-12-14 18:01:06
总测试数: 13
通过测试: 13
失败测试: 0
通过率: 100%
======================================

测试文件列表：
  - test_advanced.sw
  - test_arithmetic.sw
  - test_comprehensive.sw
  - test_error_syntax.sw
  - test_example.sw
  - test_full_features.sw
  - test_missing_invariant.sw
  - test_nested_quantifiers.sw
  - test_operators.sw
  - test_quantifier_precedence.sw
  - test_quantifier_with_parens.sw
  - test_quantifiers.sw
  - test_simple.sw
```

---

## 前置条件

### 1. 编译解析器

在运行测试前，必须先编译解析器：

```bash
# 清理旧文件（可选）
rm -f parser.tab.c parser.tab.h lex.yy.c *.o simplewhile_parser

# 生成词法分析器
flex lexer.l

# 生成语法分析器
bison -d parser.y

# 编译所有源文件
gcc -Wall -g -c parser.tab.c
gcc -Wall -g -c lex.yy.c
gcc -Wall -g -c lang.c
gcc -Wall -g -c main.c

# 链接生成可执行文件
gcc -Wall -g -o simplewhile_parser parser.tab.o lex.yy.o lang.o main.o
```

或者使用 Makefile（如果有）：
```bash
make clean
make
```

### 2. 确保测试文件存在

测试脚本会自动查找当前目录下的所有 `.sw` 文件。

---

## 脚本特性

### 颜色编码

- 🟦 **蓝色** - 信息性内容（标题、统计）
- 🟩 **绿色** - 成功（测试通过）
- 🟥 **红色** - 失败（测试未通过）
- 🟨 **黄色** - 警告（错误测试）
- 🟦 **青色** - 测试进度

### 错误测试识别

脚本内置了错误测试文件列表：
```bash
ERROR_TESTS=(
    "test_missing_invariant.sw"
    "test_error_syntax.sw"
)
```

这些文件预期应该**解析失败**：
- 如果解析失败 → 测试通过 ✅
- 如果解析成功 → 测试失败 ❌

### 退出码

- `0` - 所有测试通过
- `1` - 有测试失败

可用于自动化流程：
```bash
./run_all_tests.sh
if [ $? -eq 0 ]; then
    echo "准备发布"
else
    echo "修复错误后再试"
fi
```

---

## 常见问题

### Q1: 提示找不到解析器

**错误信息**：
```
错误: 找不到解析器 ./simplewhile_parser
```

**解决方法**：
先编译解析器（见前置条件第1点）

### Q2: 没有找到测试文件

**错误信息**：
```
错误: 当前目录下没有找到 .sw 文件
```

**解决方法**：
确保在正确的目录下运行脚本，该目录应包含 `.sw` 测试文件。

### Q3: 权限被拒绝（Linux/Mac）

**错误信息**：
```
bash: ./run_all_tests.sh: Permission denied
```

**解决方法**：
```bash
chmod +x run_all_tests.sh
```

### Q4: Windows 下乱码

**解决方法**：
- 使用 Git Bash 运行 `.sh` 脚本
- 或确保命令提示符使用 UTF-8 编码：`chcp 65001`

---

## 自定义测试

### 添加新的测试文件

1. 创建新的 `.sw` 文件（如 `test_my_feature.sw`）
2. 运行测试脚本 - 会自动检测并测试新文件

### 添加新的错误测试

如果新测试文件**应该失败**：

**在 run_all_tests.sh 中**：
```bash
ERROR_TESTS=(
    "test_missing_invariant.sw"
    "test_error_syntax.sw"
    "test_my_new_error.sw"  # 添加这里
)
```

**在 run_all_tests.bat 中**：
```batch
SET ERROR_TESTS=test_missing_invariant.sw test_error_syntax.sw test_my_new_error.sw
```

---

## 高级用法

### 只测试特定文件

```bash
# 运行单个测试
./simplewhile_parser test_advanced.sw

# 运行多个特定测试
for file in test_advanced.sw test_operators.sw; do
    ./simplewhile_parser "$file"
done
```

### 保存详细输出

```bash
# 保存完整输出到文件
./run_all_tests.sh | tee full_test_output.txt

# 只保存错误信息
./run_all_tests.sh 2>&1 | grep -i error > errors.txt
```

### 集成到 CI/CD

```yaml
# GitHub Actions 示例
- name: Run Tests
  run: |
    chmod +x run_all_tests.sh
    ./run_all_tests.sh
  shell: bash
```

---

## 性能提示

- 测试脚本会依次执行每个测试（串行）
- 对于大量测试文件，考虑并行化（需修改脚本）
- 典型执行时间：13 个测试约 1-2 秒

---

## 版本信息

- **版本**: 1.0
- **创建日期**: 2025-12-14
- **适用于**: SimpleWhile 词法和语法分析器
- **兼容性**:
  - Linux ✅
  - macOS ✅
  - Windows (Git Bash) ✅
  - Windows (CMD) ✅

---

## 更新日志

### v1.0 (2025-12-14)
- 初始版本
- 支持自动测试所有 .sw 文件
- 区分正常测试和错误测试
- 彩色输出
- 自动生成测试报告

---

## 联系与反馈

如有问题或建议，请查看：
- `TEST_REPORT.md` - 详细测试报告
- `README.md` - 项目说明
- `TEST_GUIDE.md` - 测试指南
