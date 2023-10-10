.PHONY:test,clean
test:
	lex test.l
	gcc lex.yy.c -o test -ll
	./test
clean:
	rm -fr lex.yy.c test