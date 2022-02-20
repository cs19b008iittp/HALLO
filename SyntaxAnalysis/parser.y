%{
    #include<stdio.h>
    #include<ctype.h>
 int yylex(void);
 void yyerror(char *); 

%}


%token START END ASSIGNMENT NUMBERCONST FLOATCONST

%token COMMA FULLSTOP ID TYPE



%%
program: functions_optional START body END FULLSTOP functions_optional;

body: body declarations | body statements | ;

declarations: declarations declaration | declaration;

declaration: TYPE names FULLSTOP;

names: names COMMA variable | names COMMA init | variable | init ;

init: ID ASSIGNMENT constant;

constant: NUMBERCONST | FLOATCONST;

variable: ID;

statements: statements statement | statement;

statement: if_statement | for_statement | while_statement | assigment FULLSTOP | function_call FULLSTOP; 

%%



void yyerror(char *s) {
 fprintf(stderr, "%s\n", s);
}

int main(void) {
 yyparse();
 return 0;
} 

