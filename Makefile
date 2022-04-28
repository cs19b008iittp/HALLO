parser: preprocess y.tab.c lex.yy.c y.tab.h
	gcc y.tab.c lex.yy.c -ll -o parser && ./parser processed_file.hallo
lex.yy.c: ./LexicalAnalysis/lex.l
	lex ./LexicalAnalysis/lex.l
y.tab.c: ./SyntaxAnalysis/parser.y
	yacc -v -d ./SyntaxAnalysis/parser.y
preprocess:
	python3 ./PreProcessor/preprocessor.py
asm:
	python3 ./MipsCode/asmCodeGen.py
clean:
	rm -f parser y.tab.c lex.yy.c y.tab.h y.output processed_file.hallo asm.hallo