%{
    #include<stdio.h>
    #include<ctype.h>
    int yylex(void);
    void yyerror(char *); 

%}


%token START END ASSIGNMENT NUMBERCONST FLOATCONST CONTAINER MATRIX STRCONST

%token ARITHMETIC RELATIONAL LOGICAL

%token COMMA FULLSTOP ID TYPE COLON BY

%token REPEAT FROM TO DONE

%token NOTE SEND CALL

%token ADD DELETE REMOVE IN OF SIZE CHANGE ROWSIZE COLUMNSIZE

%token DIGIT IF OTHERWISE THEN 

%token DISPLAY GET LEAVE

%right '='
%left AND OR
%left LE GE EQ NE
%left  LT GT
%left '+''-'
%left '*''/'
%right UMINUS
%left '!'

%%
program                     :       functions_optional START body END FULLSTOP functions_optional ;

body                        :       bodytypes body | ;
 
bodytypes                   :       declarations | statement ;



//declarations 

declarations                :       declaration FULLSTOP;

declaration                 :       TYPE names | CONTAINER contnames | TYPE MATRIX matnames | CONTAINER variable ASSIGNMENT contentries | TYPE MATRIX variable NUMBERCONST BY NUMBERCONST ASSIGNMENT matentries;

names                       :       names COMMA variable | names COMMA init | variable | init;

matnames                    :       matnames COMMA variable NUMBERCONST BY NUMBERCONST | variable NUMBERCONST BY NUMBERCONST;

contnames                   :       contnames COMMA variable | variable ;

init                        :       variable ASSIGNMENT constant;

contentries                 :       contentries COMMA constant | constant;

matentries                  :       matentries COMMA constant | constant;

constant                    :       NUMBERCONST | FLOATCONST;

variable                    :       ID ;



//statements

statement                   :       if_statement | repeat_statement | assignment FULLSTOP | function_call FULLSTOP | array_state FULLSTOP | print FULLSTOP | get FULLSTOP | leave FULLSTOP;



//print,scan and leave

print                       :       DISPLAY variable ;

get                         :       GET variable ;

leave                       :       LEAVE ;



//assignment statement

assignment                  :       leftside_types ASSIGNMENT rightside_types ;

leftside_types              :       variable assignment_types | variable | variable assignment_types  assignment_types;

rightside_types             :       function_call | variable assign_var | constant assign_const | size | STRCONST ;

assign_var                  :       assignment_types | ARITHMETIC varconst | assignment_types assignment_types |  ;



//arr_var                   :       variable COMMA  arr_var | ;

assign_const                :       ARITHMETIC varconst | ;

assignment_types            :       varconst ARITHMETIC varconst | varconst ;



//array statements

size                        :       SIZE OF variable | ROWSIZE OF variable | COLUMNSIZE OF variable;

array_state                 :       REMOVE FROM variable | ADD varconst TO variable | DELETE variable varconst | CHANGE varconst TO varconst IN variable ;



//if statement 

if_statement                :       IF  cond  THEN COLON body_inside done otherwise;

otherwise                   :       OTHERWISE cond THEN COLON body_inside done otherwise | OTHERWISE THEN COLON body_inside done;

cond                        :       varconst RELATIONAL varconst LOGICAL cond | varconst RELATIONAL varconst ; 

varconst                    :       variable | constant ;



//repeat

repeat_statement            :       REPEAT variable initialization termination incrementation COLON body_inside done ;

initialization              :       FROM varconst |  ;
  
termination                 :       TO varconst |  ;

incrementation              :       ARITHMETIC varconst | ;

done                        :       DONE FULLSTOP | FULLSTOP ;



//function_call

function_call               :       CALL variable param FULLSTOP;



//functions

functions_optional          :       functions_optional function_call_outside | ;

function_call_outside       :       NOTE ID param COLON body_inside_function function_end;

param                       :       param COMMA ID | ID ;

function_end                :       SEND ID FULLSTOP | SEND FULLSTOP ;



//body inside for functions

body_inside_function        :       bodytypes_inside_function body_inside_function | ;

bodytypes_inside_function   :       statement_inside_function ;
 
statement_inside_function   :       if_statement | repeat_statement |  assignment COMMA | function_call COMMA | array_state COMMA | print COMMA | get COMMA | leave COMMA  ;



//body inside for if and for loops

body_inside                 :       bodytypes_inside body_inside | bodytypes_inside1 | ;

bodytypes_inside            :       statement_inside ;
 
statement_inside            :       if_statement | repeat_statement |  assignment COMMA | function_call COMMA | array_state COMMA| print COMMA | get COMMA | leave COMMA ;

bodytypes_inside1           :       assignment | function_call | array_state | print | get | leave;


%%



void yyerror(char *s) {
 fprintf(stderr, "%s\n", s);
}

int main(int argc, char* argv[]) {
    extern FILE *yyin;
    if(argc > 1)
    {
        FILE *fp = fopen(argv[1], "r");
        if(fp)
        yyin = fp;
    }
    else
    {
        printf("Enter the code: \n");
    }
    yyparse();
    return 0;
} 

