%{
/*********************************************
中缀表达式转后缀表达式
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#define MAX_EXPR_LENGTH 100
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);

char* stack[MAX_EXPR_LENGTH];
int top = -1;

void push(char* value) {
    if (top < MAX_EXPR_LENGTH - 1) {
        stack[++top] = value;
    }
}

char* pop() {
    if (top >= 0) {
        return stack[top--];
    }
    return NULL;
}
%}

// 定义运算符和单词类别
%token ADD SUB MUL DIV
%token NUMBER
%left ADD SUB
%left MUL DIV

%%

lines   :       lines expr ';' { printf("%s\n", $2); free($2); }
        |       lines ';'
        |
        ;

// 修改表达式的规则以生成后缀表达式
expr    :       expr ADD expr   {
                                char* left = $1;
                                char* right = $3;
                                $$ = malloc(MAX_EXPR_LENGTH);
                                if ($$ == NULL) {
                                    yyerror("Memory allocation failed");
                                } else {
                                    strcpy($$, left);
                                    strcat($$, right);
                                    strcat($$, " +");
                                    free(left);
                                    free(right);
                                }
                            }
        |       // ... (其他运算符的规则类似) ...
        |       NUMBER          { 
                                $$ = malloc(2);
                                if ($$ == NULL) {
                                    yyerror("Memory allocation failed");
                                } else {
                                    strcpy($$, $1);
                                }
                            }
        ;


%%

// 程序部分

int yylex()
{
    int t;
    while (1) {
        t = getchar();
        if (t == ' ' || t == '\t' || t == '\n') {
            // 忽略空白符
        } else if (isdigit(t)) {
            // 解析多位数字
            ungetc(t, stdin);
            double num;
            scanf("%lf", &num);
            return NUMBER;
        } else if (t == '+') {
            return ADD;
        } else if (t == '-') {
            return SUB;
        } else if (t == '*') {
            return MUL;
        } else if (t == '/') {
            return DIV;
        } else if (t == '(' || t == ')') {
            return t;
        } else {
            // 处理其他字符
            return t;
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

void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}

