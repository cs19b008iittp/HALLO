%{
    #include<stdio.h>
    #include<ctype.h>
    void yyerror(char const*s){
        fprintf(stderr,"%s\n",s);
    }
%}





%token START END ASSIGNMENT NUMBERCONST FLOATCONST

%token NUM STRING FLAG DATA

%token COMMA FULLSTOP






%%
program: functions_optional START declarations statements END '.' functions_optional;


declarations: declarations declaration | declaration;

declaration: type names FULLSTOP;

type: NUM | STRING | FLAG | DATA;

names: names COMMA variable | names COMMA init | variable | init ;

init: ID ASSIGNMENT constant;

constant: NUMBERCONST | FLOATCONST;

variable: ID;


statements: statements statement | statement;

statement: if_statement | for_statement | while_statement | assigment FULLSTOP | function_call FULLSTOP; 
%%




int yyparse(void);

int main () {
	return yyparse( ) ;
}