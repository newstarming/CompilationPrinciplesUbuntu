# 一、基于“预备工作1”，继续:
1. 确定你要实现的编译器支持哪些SySY语言特性，给出其形式化定义————学习教材第2章及第2章讲义中的2.2节、参考SvsY中巴克斯瑙尔范式定义，用上下文无关文法描述你的SysY语言子集。
2. 设计几个SysY程序（如“预备工作1”给出的阶乘或斐波那契），编写等价的ARM汇编程序，用汇编器生成可执行程序，调试通过、能正常运行得到正确结果。

## 要求:
- 撰写研究报告，要求同前，小组两人提交一份报告即可
- 在报告中用一个小节明确指出两人的分工情况————两人各负责哪部分 (CFG) 设计、各负责哪部分 (ARM汇编) 编程，以后作业要求相同。
- 不要用GCC等编译器生成C程序对应的汇编程序直接交上来！可学习GCC生成的其他C程序的汇编程序，仿照着编写自己SysY程序的汇编程序。

## 思考
- 如果不是人“手工编译”，而是要实现一个计算机程序(编译器)来将SysY程序转换为汇编程序，应该如何做 (这个编译器程序的数据结构和算法设计) ?
- 注意: 编译器不能只会翻译一个源程序，而是要有能力翻译所有合法的SysY程序。
    穷举所有SysY程序(无穷无尽) 是不可能的，怎么办?搞定每个语言特性如何翻译即可!每个语言特性仍然有无穷多个合法的实例 (a=1b=2.0，·..)，怎么办?符号化一-语法制导翻译! 参见讲义2.8节。
- 鼓励有余力的同学进行尝试，设计语法制导定义/翻译模式实现简单的SysY程序到汇编程序的翻译，并通过Bison进行实验

## 安装Bison软件，熟悉其使用，对讲义中简单表达式计算的Yacc程序进行如下修改:
1. 将所有的词法分析功能均放在yylex函数内实现，为+、*、1、(、)每个运算符及整数分别定义一个单词类别，在yylex内实现代码，能识别这些单词，并将单词类别返回给词法分析程序。
2. 实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等空白符，能识别多位十进制整数。
3. 修改Yacc程序，不进行表达式的计算，而是实现中缀表达式到后缀表达式的转换

## 思考
1. 在2的基础上，实现功能更强的词法分析和语法分析程序使之能支持变量，修改词法分析程序，能识别变量 (标识符)和“=”符号，修改语法分析器，使之能分析、翻译“a=2形式的(或更复杂的，“a=表达式”) 赋值语句，当变量出现在表达式中时，能正确获取其值进行计算(未赋值的变量取0)。当然，这些都需要实现符号表功能。
2. 将翻译目标改为生成汇编代码。
要求:无需撰写实验报告，在上机课直接向助教展示 (也在雨课堂提交一下代码链接，以便打分)