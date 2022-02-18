lexer :  lex.yy.c
	gcc lex.yy.c -ll -o lexer

lex.yy.c : lex.l
	lex lex.l

clean:
	rm -f lex.yy.c lexer

