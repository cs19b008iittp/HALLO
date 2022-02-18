lexer:  lex.yy.c
	gcc lex.yy.c -ll -o lexer

lex.yy.c: LexicalAnalysis/lex.l
	lex ./LexicalAnalysis/lex.l

clean:
	rm -f lex.yy.c lexer

