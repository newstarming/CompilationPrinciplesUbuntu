.PHONY:yacc,clean
yacc:
	yacc -d LexRuler.y
	gcc -o LexRuler y.tab.c lex.yy.c -ll
clean:
	rm -fr y.tab.c computer_expr
