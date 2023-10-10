%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS
%token NUMBER
%left ADD MINUS
%right UMINUS         

%%


lines   :       lines expr ';' { printf("%f\n", $2); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr   { $$=$1+$3; }
        |       expr MINUS expr   { $$=$1-$3; }
        |       MINUS expr %prec UMINUS   {$$=-$2;}
        |       NUMBER  {$$=$1;}
        ;

%%

// programs section

int yylex()
{
    int t;
    while (1) {
        t = getchar();
        if (t == ' ' || t == '\t' || t == '\n') {
            // 忽略空格、制表符和回车
            continue;
        } else if (isdigit(t)) {
            // 识别多位整数
            int value = t - '0'; // 将第一个数字字符转换为整数
            while ((t = getchar()) && isdigit(t)) {
                value = value * 10 + (t - '0'); // 构建多位整数
            }
            ungetc(t, stdin); // 将多读的字符放回输入流
            yylval = value;   // 设置 yylval 以返回整数值
            return NUMBER;
        } else if (t == '+') {
            return ADD;
        } else if (t == '-') {
            return MINUS;
        } else if (t == '*') {
            // TODO: 识别其他符号
        } else if (t == '/') {
            // TODO: 识别其他符号
        } else if (t == '(') {
            // TODO: 识别其他符号
        } else if (t == ')') {
            // TODO: 识别其他符号
        } else {
            return t; // 对于未知字符，返回其 ASCII 值
        }
    }
}



int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}
