%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

// 定义符号表项结构
struct Symbol {
    char name[50];
    double value;
};

#define YYSTYPE double
struct Symbol symbol_table[100];  // 符号表
int symbol_count = 0;  // 符号表中的项数
char idstr[50];
char numstr[50];

int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char*s);
%}
%token NUMBER
%token ID
%token ADD SUB MUL DIV LKO RKO ASSIGN
%left LKO
%left ADD SUB
%left MUL DIV
%right UMINUS
%right RKO
%%

lines : lines expr '\n'{printf("%s\n",$2);}
      | lines '\n'
      |
      ;

expr : expr ADD expr {$$=$1+$3;}
     | expr SUB expr {$$=$1-$3;}
     | expr MUL expr {$$=$1*$3;}
     | expr DIV expr {$$=$1/$3;}
     | LKO expr RKO {$$=$2;}
     | NUMBER   {$$ = atof($1);}
     | ID   {$$ = lookup_variable($1);}  // 查找变量的值
     ;

stmt : ID ASSIGN expr {assign_variable($1, $3);}  // 赋值语句

%%

// 自定义词法分析器
int yylex()
{
    int t;
    while (1) {
        t = getchar();
        if (t == ' ' || t == '\t') ;
        else if ((t >= '0' && t <= '9')) {
            int ti = 0;
            while ((t >= '0' && t <= '9')) {
                numstr[ti] = t;
                t = getchar();
                ti++;
            }
            numstr[ti] = '\0';
            yylval = numstr;
            ungetc(t, stdin);
            return NUMBER;
        } else if ((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_')) {
            int ti = 0;
            while ((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z')
                   || (t == '_') || (t >= '0' && t <= '9')) {
                idstr[ti] = t;
                ti++;
                t = getchar();
            }
            idstr[ti] = '\0';
            yylval = idstr;
            ungetc(t, stdin);
            return ID;
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
                case '=':
                    return ASSIGN;  // 新增的赋值操作符
                default:
                    return t;
            }
        }
        return t;
    }
}

// 查找变量并返回其值
double lookup_variable(const char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return symbol_table[i].value;
        }
    }
    // 如果变量未找到，默认值为0
    return 0.0;
}

// 将变量赋值
void assign_variable(const char *name, double value) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            symbol_table[i].value = value;
            return;
        }
    }
    // 如果变量不存在，将其添加到符号表中
    if (symbol_count < 100) {
        strcpy(symbol_table[symbol_count].name, name);
        symbol_table[symbol_count].value = value;
        symbol_count++;
    } else {
        fprintf(stderr, "Symbol table is full. Cannot add more variables.\n");
        exit(1);
    }
}

// 主函数
int main(void)
{
    yyin = stdin;
    do {
        yyparse();
    } while (!feof(yyin));
    return 0;
}

// 错误处理函数
void yyerror(const char *s)
{
    fprintf(stderr, "Parse error:%s\n", s);
    exit(1);
}

