%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define YYSTYPE char*
char idstr[50];
char numstr[50];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUMBER   // 定义数字的单词类别
%token ID       // 定义标识符的单词类别
%token ADD SUB MUL DIV LKO RKO   // 定义运算符和括号的单词类别
%left LKO      // 左括号的单词类别
%left ADD SUB  // 加减法运算符的单词类别
%left MUL DIV  // 乘除法运算符的单词类别
%right UMINUS  // 负号的单词类别
%right RKO     // 右括号的单词类别

%%

lines : lines expr '\n' { printf("%s\n", $2); free($2); }  // 解析并打印每行的表达式结果
      | lines '\n'   // 忽略空行
      |
      ;

expr : expr ADD expr { $$ = strcat($1, " "); $$ = strcat($$, $3); $$ = strcat($$, " +"); free($1); free($3); }
     | expr SUB expr { $$ = strcat($1, " "); $$ = strcat($$, $3); $$ = strcat($$, " -"); free($1); free($3); }
     | expr MUL expr { $$ = strcat($1, " "); $$ = strcat($$, $3); $$ = strcat($$, " *"); free($1); free($3); }
     | expr DIV expr { $$ = strcat($1, " "); $$ = strcat($$, $3); $$ = strcat($$, " /"); free($1); free($3); }
     | LKO expr RKO { $$ = $2; }  // 处理括号内的表达式
     | NUMBER { $$ = strdup($1); }  // 处理数字
     | ID { $$ = strdup($1); strcat($$, " "); }  // 处理标识符
     ;

%%

int yylex()
{
    int t;
    while (1) {
        t = getchar();
        while (t == ' ' || t == '\t') {
            t = getchar(); // 忽略多个空格和制表符
        }
        if (isdigit(t)) {
            int ti = 0;
            while (isdigit(t)) {
                numstr[ti] = t;
                t = getchar();
                ti++;
            }
            numstr[ti] = '\0';
            yylval = numstr;
            return NUMBER;  // 返回数字单词类别
        } else if (isalpha(t) || t == '_') {
            int ti = 0;
            while (isalnum(t) || t == '_') {
                idstr[ti] = t;
                t = getchar();
                ti++;
            }
            idstr[ti] = '\0';
            yylval = idstr;
            return ID;  // 返回标识符单词类别
        } else {
            switch (t) {
                case '+':
                    return ADD;
                case '-':
                    return SUB;
                case '*':
                    return MUL;
                case '/':
                    return DIV;
                case '(':
                    return LKO;
                case ')':
                    return RKO;
                default:
                    return t;
            }
        }
    }
}

int main(void)
{
    yyin = stdin;
    do {
        yyparse();
    } while (!feof(yyin));
    return 0;
}

void yyerror(const char* s)
{
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}

