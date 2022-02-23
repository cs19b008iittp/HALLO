%{
    #include<stdio.h>
    #include<ctype.h>
 int yylex(void);
 void yyerror(char *); 

%}


%token START END ASSIGNMENT NUMBERCONST FLOATCONST CONTAINER MATRIX 

%token ARITHMETIC RELATIONAL LOGICAL

%token COMMA FULLSTOP ID TYPE COLON BY

%token REPEAT FROM TO DONE

%token NOTE SEND CALL

%token DIGIT IF OTHERWISE THEN 

%right '='
%left AND OR
%left LE GE EQ NE
%left  LT GT
%left '+''-'
%left '*''/'
%right UMINUS
%left '!'

%%
program: functions_optional START body END FULLSTOP functions_optional ;

body: bodytypes body | ;
 
bodytypes : declarations | statement ;

//declarations 

declarations: declaration FULLSTOP;

declaration: TYPE names | CONTAINER contnames | TYPE MATRIX matnames ;

names: names COMMA variable | names COMMA init | variable | init;

matnames: matnames NUMBERCONST BY NUMBERCONST COMMA variable NUMBERCONST BY NUMBERCONST | variable NUMBERCONST BY NUMBERCONST;

contnames: names COMMA variable | variable;

init: variable ASSIGNMENT constant;
     
constant: NUMBERCONST | FLOATCONST;

variable: ID;

//statements

statement: if_statement | repeat_statement |  assignment FULLSTOP | function_call FULLSTOP;  

//assignment statement

assignment : variable ASSIGNMENT varconst ARITHMETIC varconst ;

//if statement

if_statement :  IF  cond  THEN COLON body done otherwise;

otherwise : OTHERWISE cond THEN COLON body done otherwise | OTHERWISE THEN COLON body done;

cond : varconst RELATIONAL varconst LOGICAL cond | varconst RELATIONAL varconst ; 

varconst :  variable | constant ;

//repeat

repeat_statement: REPEAT variable initialization termination incrementation COLON body done ;

initialization: FROM varconst |  ;

termination: TO varconst |  ;

incrementation: ARITHMETIC varconst | ;

done: DONE FULLSTOP | FULLSTOP ;

//function_call

function_call : CALL variable param FULLSTOP;

//functions

functions_optional : functions_optional function_call_outside | ;

function_call_outside : NOTE ID param COLON body function_end;

param : param COMMA ID | ID ;

function_end : SEND ID FULLSTOP | SEND FULLSTOP ;


 

%%



void yyerror(char *s) {
 fprintf(stderr, "%s\n", s);
}

int main(void) {
 printf("Enter the code: \n");
 yyparse();
 return 0;
} 

