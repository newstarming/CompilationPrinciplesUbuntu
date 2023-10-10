%{
#include "stdio.h"  // 包含Bison生成的头文件
%}

%%
[0-9]+ {
    yylval = atoi(yytext); // 将整数值传递给Bison语法分析器
    return INTEGER;
}
"+"     return PLUS;
"*"     return TIMES;
"("     return LPAREN;
")"     return RPAREN;
\n      return NEWLINE;
[ \t]   ;  // 忽略空格和制表符
.       return yytext[0];
%%

int main() {
    yyparse(); // 启动Bison语法分析器
    return 0;
}
