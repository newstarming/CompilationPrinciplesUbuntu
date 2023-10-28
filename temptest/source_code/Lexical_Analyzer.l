%{
	#include<stdio.h>
	#include<stdlib.h>
	int line = 1;        // 初始化行数
	int column = 1;      // 初始化列数
	int charnum = 0;     // 初始化字符计数
	char path[100];      // 用于保存路径的数组

	void clearcolumn();  // 清空列数的函数
	void addcolumn(int); // 增加列数的函数
%}

VOID void
INT int
CHAR char
IF if
WHILE while
FOR for
BREAK break
CONTINUE continue
RETURN return
SEMICOLON ;
COMMA ,
LPAREN \(
RPAREN \)
LBRACE \{
RBRACE \}
CMPEQUAL \=\=
EQUAL \=
ADD \+
SUB \-
MUL \*
DIV \/
SMALLER \<
BIGGER \>

digit [0-9]
octal_digit [0-7]
hexadecimal_digit [0-9a-fA-F]
identifier_nondigit [a-zA-Z_]

decimal_const [1-9]{digit}*
octal_const (0){octal_digit}*
hexadecimal_const (0x|0X){hexadecimal_digit}*

Identifier ({identifier_nondigit})({identifier_nondigit}|{digit})*


%%

{decimal_const} {
    addcolumn(charnum);	// 调用 addcolumn 函数更新列号信息
    printf("%-20s%-20s%-10d%-10d%-20s\n","decimal_const",yytext,line,column,yytext);
    charnum = yyleng;	// 更新字符数信息
    } 
{octal_const} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d%-20s\n","octal_const",yytext,line,column,yytext);
    charnum = yyleng;
    } 
{hexadecimal_const} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d%-20s\n","hexadecimal_const",yytext,line,column,yytext);
    charnum = yyleng;
    }
{VOID} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","VOID",yytext,line,column);
    charnum = yyleng;
    }
{INT} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","INT",yytext,line,column);
    charnum = yyleng;
    }
{CHAR} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","CHAR",yytext,line,column);
    charnum = yyleng;
    }
{IF} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","IF",yytext,line,column);
    charnum = yyleng;
    }
{WHILE} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","WHILE",yytext,line,column);
    charnum = yyleng;
    }
{FOR} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","FOR",yytext,line,column);
    charnum = yyleng;
    }
{BREAK} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","BREAK",yytext,line,column);
    charnum = yyleng;
    }
{CONTINUE} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","CONTINUE",yytext,line,column);
    charnum = yyleng;
    }
{RETURN} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","RETURN",yytext,line,column);
    charnum = yyleng;
    }
{Identifier} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d%-20p\n","Identifier",yytext,line,column,yytext);
    charnum = yyleng;
    }
{SEMICOLON} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","SEMICOLON",yytext,line,column);
    charnum = yyleng;
    }
{COMMA} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","COMMA",yytext,line,column);
    charnum = yyleng;
    }
{LPAREN} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","LPAREN",yytext,line,column);
    charnum = yyleng;
    }
{RPAREN} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","RPAREN",yytext,line,column);
    charnum = yyleng;
    }
{LBRACE} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","LBRACE",yytext,line,column);
    charnum = yyleng;
    }
{RBRACE} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","RBRACE",yytext,line,column);
    charnum = yyleng;
    }
{CMPEQUAL} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","CMPEQUAL",yytext,line,column);
    charnum = yyleng;
    }
{EQUAL} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","EQUAL",yytext,line,column);
    charnum = yyleng;
    }
{ADD} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","ADD",yytext,line,column);
    charnum = yyleng;
    }
{SUB} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","SUB",yytext,line,column);
    charnum = yyleng;
    }
{MUL} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","MUL",yytext,line,column);
    charnum = yyleng;
    }
{DIV} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","DIV",yytext,line,column);
    charnum = yyleng;
    }
{SMALLER} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","SMALLER",yytext,line,column);
    charnum = yyleng;
    }
{BIGGER} {
    addcolumn(charnum);
    printf("%-20s%-20s%-10d%-10d\n","BIGGER",yytext,line,column);
    charnum = yyleng;
    }


\n {
    ++line;	// 每当遇到换行符，行号加1
    clearcolumn();	// 清除列号和字符数信息
    }

. {
    addcolumn(1);	// 遇到其他字符，调用 addcolumn 增加列号
    }

[ \t]+ {}	// 忽略空格和制表符

%%
int main(){
    scanf("%s",path);	// 从标准输入读取文件路径
	yyin=fopen(path,"r");	// 打开文件以供词法分析
	yylex();	// 调用词法分析器
	return 0;
}
int yywrap(){
	return 1;	// 告诉词法分析器到达文件末尾
}
void clearcolumn(){
    column = 1;	// 清除列号
    charnum = 0;	// 清除字符数
}
void addcolumn(int temp){
    column += temp;	// 增加列号
}