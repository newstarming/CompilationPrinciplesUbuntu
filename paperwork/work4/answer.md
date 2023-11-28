# question no.1

以下是关于图片中编译原理问题的回答：

1. **终结符、非终结符和开始符号**：
   - 终结符：`num`, `+`, `*`, `(`, `)`
   - 非终结符：`E`, `T`, `F`
   - 开始符号：`E`

2. **串 `num*num+num*num` 的最左推导**：
   - `E → T → F → num`
   - `T → F → num`
   - `T → F * T → num * T → num * F → num * num`
   - `E → T + E → num + E → num + T → num + F → num + num`
   - 最左推导：`E → num + T → num + F → num + num * T → num + num * F → num + num * num`

3. **产生式的语法分析树**：
   - 语法分析树如下：
     ```
     E
     ├── T
     │   └── F
     │       └── num
     ├── +
     └── E
         ├── T
         │   └── F
         │       └── num
         ├── *
         └── T
             └── F
                 └── num
     ```

# question no.2

