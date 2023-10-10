.PHONY:yacc,clean
yacc:
	yacc LexRuler.y
	gcc y.tab.c -o computer_expr
	./computer_expr
clean:
	rm -fr y.tab.c computer_expr
