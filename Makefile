parser: y.tab.c lex.yy.c y.tab.h
	gcc y.tab.c lex.yy.c -ll -ly -o parser
lex.yy.c: ./LexicalAnalysis/lex.l
	lex ./LexicalAnalysis/lex.l
y.tab.c: ./SyntaxAnalysis/parser.y
	yacc -v -d ./SyntaxAnalysis/parser.y
clean:
	rm -f parser y.tab.c lex.yy.c y.tab.h y.output
