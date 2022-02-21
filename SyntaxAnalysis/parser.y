%{
    #include<stdio.h>
    #include<ctype.h>
 int yylex(void);
 void yyerror(char *); 

%}


%token START END ASSIGNMENT NUMBERCONST FLOATCONST CONTAINER MATRIX ARITHMETIC

%token COMMA FULLSTOP ID TYPE COLON

%token REPEAT FROM TO DONE

%token NOTE SEND 



%%
program: functions_optional START body END FULLSTOP functions_optional;

body: body declarations |  body statements | ;


declarations: declarations declaration | declaration;

declaration: TYPE names FULLSTOP | CONTAINER contnames FULLSTOP | TYPE MATRIX matnames FULLSTOP;

names: names COMMA variable | names COMMA init | variable | init;

matnames: matnames NUMBERCONST BY NUMBERCONST COMMA variable NUMBERCONST BY NUMBERCONST | variable NUMBERCONST BY NUMBERCONST;

contnames: names COMMA variable | variable;

init: ID ASSIGNMENT constant;

constant: NUMBERCONST | FLOATCONST;

variable: ID;

statements: statements statement | statement;

statement: if_statement | repeat_statement | assigment FULLSTOP | function_call FULLSTOP; 

repeat_statement: REPEAT variable initialization termination incrementation statements done | REPEAT COLON statements done ;

initialization: FROM constant | FROM variable | COLON ;

termination: TO constant | TO variable | COLON ;

incrementation: ARITHMETIC constant | ARITHMETIC variable | COLON ;

done: DONE FULLSTOP | FULLSTOP ;

functions_optional : functions_optional function_call | ;

function_call : NOTE ID param COLON body function_end;

param : param COMMA ID | ID ;

function_end : SEND ID FULLSTOP | SEND FULLSTOP ;

%%



void yyerror(char *s) {
 fprintf(stderr, "%s\n", s);
}

int main(void) {
 yyparse();
 return 0;
} 

