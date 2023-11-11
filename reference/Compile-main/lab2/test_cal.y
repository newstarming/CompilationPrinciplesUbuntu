%{
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double 
#endif
int yylex();
extern int yyparse();
FILE *yyin;
void yyerror(const char* s);
%}

%token add 
%token sub 
%token mul 
%token DIV 
%token l_bracket 
%token r_barcket
%token eq 
%token var
%token show
%token NUMBER
%left add sub to
%left mul DIV eq show
%right UMINUS

%%

lines		:	lines expr ';' {printf("%f\n", $2);}
		|	lines ';'
		|
		;

expr		:	expr add expr {$$ = $1 + $3;}
		|	expr sub expr {$$ = $1 - $3;}
		|	expr mul expr {$$ = $1 * $3;}
		|	expr DIV expr {$$ = $1 / $3;}
		|   l_bracket expr r_barcket  {$$ = $2;}
		|	sub expr %prec UMINUS {$$ = -$2;}
		|   show NUMBER %prec UMINUS{$$ = $2;}
		|	NUMBER {$$ = $1;}

		;

%%

int var_array[200] = {0};
int var_value[200] = {0};

int yylex()
{

	int t;
	while(1){
		t = getchar();
		if(t == ' ' || t == '\t' || t == '\n'){

		}
		else if(isdigit(t))
		{
			yylval = 0;

			while(isdigit(t)){
				yylval = yylval * 10 + t - '0';
				t = getchar();
			}//计算出输入的数字的大小


			ungetc(t, stdin);
			return NUMBER;
		}
		else if(t == '+'){
			return add;
		}
		else if(t == '-'){
			return sub;
		}
		else if(t == '*'){
			return mul;
		}
		else if(t == '/'){
			return DIV;
		}
		else if(t == '('){
			return l_bracket;
		}
		else if(t == ')'){
			return r_barcket;
		}
		else if(t == '='){
			return eq;
		}

		else if(t >= 'a' && t <= 'z') {
			if (var_array[t] == 0) {
				var_array[t] = 1;
				int s;
				while (1) {
					s = getchar();
					if(s == ' ' || s == '\t' || s == '\n' || s == '='){
					}		
					else if(isdigit(s)){
						yylval = 0;

						while(isdigit(s)){
							yylval = yylval * 10 + s - '0';
							s = getchar();
						}//计算出输入的数字的大小
						ungetc(s, stdin);

						var_value[t] = yylval;
						
						return NUMBER;
					}
				}
			} else {
				yylval = var_value[t];
				return NUMBER;
			}
		}
		else if(t == '?') {
			return show;
		}
		else{
			return t;
		}
	}
}
int main(void)
{
	yyin = stdin;
	do{
		yyparse();
	}while(!feof(yyin));
	return 0;
}

void yyerror(const char* s){
	fprintf(stderr, "Parse error:%s\n", s);
	exit(1);
}