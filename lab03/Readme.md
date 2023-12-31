注意:接下来几次上机作业都由助教线下检查给分不需要撰写、提交报告 (但在长江雨课堂还是需要提交源程序或Git链接，以便打分)最后一步完成编译器时写一个报告提交即可，因此平时也注意积累素材列出你要实现的SysY编译器支持的语言特性所涉及的单词，设计正规定义。利用Lex工具实现词法分析器，识别所有单词，能将源程序转化为单词流。设计符号表，当然目前符号表项还只是词素等简单内容，但符号表的数据结构、搜索算法、词素的保存、保留字的处理等问题都可以考虑了。验证你的程序，可以输入简单的SySY源程序，输出单词流，包括每个单词的词素内容、单词类别和属性 (常数的属性可以是数值，标识符可以是指向符号表的指针)。

如下例:

![Alt text](<image/屏幕截图 2023-10-28 140732.png>)

![Alt text](<image/屏幕截图 2023-10-28 141730.png>)

课外探索:

- 能否设计实现一个Lex工具(或其流程中的主要算法)?即
1. 设计实现正则表达式>NFA的转换程序(可借助Bison工具)
2. 设计实现NFA>DFA的转换程序:
3. 设计实现DFA化简的程序;
4. 实现模拟DFA运转的程序 (将前三步转换的DFA与标准的模拟运行算法融合起来)。


本次实验主要借助FLEX工具构建了一个简单的词法分析器


# 文件分布
```
词法分析器
├── Makefile
├── Readme.md
├── source_code
│   └── Lexical_Analyzer.l
└── test_code
    ├── compare.sy
    └── test.sy
```
我们在 `source_code` 文件夹下存放了词法分析器的lex程序源码，在 `test_code` 文件夹下存放了用于验证词法分析器的程序。



# 执行测试
在主目录下执行 `make lex` 即可执行词法分析器，之后在命令行中输入需要进行词法分析的程序路径即可执行分析。程序路径形式如下：
```sh
test_code/test.sy
```



# 文件分析
## Makefile
在 `Makefile` 中我们定义了两个操作，即 `make lex` 和 `make clean`。`make lex` 作用为编译并执行词法分析器， `make clean` 作用为清除生成的词法分析器后续代码，保护仓库的整洁。

## source_code/Lexical_Analyzer.l
这是词法分析器的lex源码，在其中使用正则表达式定义了如下可供分析的单词：
* 整数：包括十进制整数、八进制整数、十六进制整数。
* 标识符：以非数字开头的非保留字。
* 特殊字符：包括(、,、)、;、{、}和运算符。
* 保留字：包括if、while、for、break等。

除此以外，通过定义一些特殊函数实现了输出行数和列数的功能。