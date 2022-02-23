%{
    #include<stdio.h>
    #include<ctype.h>
 int yylex(void);
 void yyerror(char *); 

%}


%token START END ASSIGNMENT NUMBERCONST FLOATCONST CONTAINER MATRIX ARITHMETIC

%token COMMA FULLSTOP ID TYPE COLON BY

%token REPEAT FROM TO DONE

%token NOTE SEND 

%token DIGIT IF OTHERWISE THEN EQUALS LE GE EQ GT LT NE OR AND
%right '='
%left AND OR
%left LE GE EQ NE
%left  LT GT
%left '+''-'
%left '*''/'
%right UMINUS
%left '!'

%%
program: functions_optional START body END FULLSTOP functions_optional;

body: body declarations |  body statements ;

declarations: declarations declaration | declaration;

declaration: TYPE names FULLSTOP | CONTAINER contnames FULLSTOP | TYPE MATRIX matnames FULLSTOP;

names: names COMMA variable | names COMMA init | variable | init;

matnames: matnames NUMBERCONST BY NUMBERCONST COMMA variable NUMBERCONST BY NUMBERCONST | variable NUMBERCONST BY NUMBERCONST;

contnames: names COMMA variable | variable;

init: ID ASSIGNMENT constant;

constant: NUMBERCONST | FLOATCONST;

variable: ID;

statements_list : statements_list  statement| statement;

statement: if_statement | repeat_statement | assignment FULLSTOP | function_call FULLSTOP {printf("Input accepted.\n");exit(0);};  

if_statement  : IF '(' E2 ')' THEN statement1 FULLSTOP OTHERWISE  statement1 FULLSTOP
        | IF '(' E2 ')' THEN statement1 FULLSTOP | IF '('E2')' THEN statement1 FULLSTOP OTHERWISE '('E2')' THEN  statement1 FULLSTOP OTHERWISE statement1 FULLSTOP;

statement1 : statement
        | E ;

        E    : ID'='E
      | E'+'E
      | E'-'E
      | E'*'E
      | E'/'E
      | E'<'E
      | E'>'E
      | E LE E
      | E GE E
      | E LT E
      | E  GT E
      | E EQ E
      | E NE E
      | E OR E
      | E AND E
      | ID
      | DIGIT

      E2  : E'<'E
      | E'>'E
      | E LT E
      | E GT E
      | E LE E
      | E GE E
      | E EQ E
      | E NE E
      | E OR E
      | E AND E
      | ID
      | DIGIT
      ;

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
     printf("Enter the code: ");
 yyparse();
 return 0;
} 

