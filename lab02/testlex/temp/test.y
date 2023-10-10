%{
#include <stdio.h>
%}

%token INTEGER PLUS TIMES LPAREN RPAREN NEWLINE

%left PLUS
%left TIMES

%%
program: lines
       ;

lines: lines line
     | line
     ;

line: expression NEWLINE
    | NEWLINE
    ;

expression: INTEGER
           | expression PLUS expression
           | expression TIMES expression
           | LPAREN expression RPAREN
           ;

%%

int yylex();  // 由Flex生成，用于词法分析

int main() {
    yyparse(); // 启动Bison语法分析器
    return 0;
}
