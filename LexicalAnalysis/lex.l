%{  
   #include <stdio.h>
   #include <stdlib.h>
   #include <string.h>
   int lineno = 1; // initialize to 1
   void yyerror();  
%}

DIGIT                   [0-9]
LETTER                  [A-Za-z]
LETTER_                 [A-Za-z_]
CONTAINER               {DATATYPE}"s"
NUMBERCONST             {DIGIT}* 
FLOATCONST              {DIGIT}*+"."+{DIGIT}{DIGIT}*
STRCONST                "\"".*"\""             
SPECIALCHARS            "["|"]"|"("|")"|"{"|"}"|","|"#"|"*"|"~"|"."
COMMENTS                "ignore".*|"skip"(.|\n)*"skip"
DELIMITERS              "."|[ \n\t]|","
DATATYPE                "num"|"string"|"com"|"flag"|"data"|"matrix"
CONTROLSTATEMENT        "if"|"otherwise"|"repeat"|"leave"|"done"
FUNCTIONS               "note"|"send"|"call"
IOCOMMAND               "display"|"get"
RELATIONAL              "="|">"|"<"|">="|"<="|"!"|"equals"|"greater than"|"less than"|"less than or equals"|"greater than or equals"|"not equals"
ARITHMETIC              "+"|"-"|"*"|"/"|"%"|"plus"|"minus"|"into"|"dividedby"|"remainder"|"inc by"|"dec by"
ASSIGNMENT              "is"  
LOGICAL                 "or"|"and"

%option noyywrap
%%

{COMMENTS}                                               	 ;
{DELIMITERS}                                          	    ;
{RELATIONAL}                                              	 {printf("Relational Operators : %s\n",yytext);}
{ARITHMETIC}                                              	 {printf("Arithmetic Operators : %s\n",yytext);}
{LOGICAL}                                                 	 {printf("Logical Operators : %s\n",yytext);}
{DATATYPE}|{CONTROLSTATEMENT}|{FUNCTIONS}|{IOCOMMAND}|{CONTAINER}   {printf("Keywords :  %s\n",yytext);}
{STRCONST}                                                	 {printf("String Constants : %s\n",yytext);}
{SPECIALCHARS}                                            	 {printf("Special Characters : %s\n",yytext);}


"num"                                               	       {return (NUM);}    
"string"                                            	       {return (STRING);}
"com"                                                   	    {return (COM);}
"flag"                                                     	 {return (FLAG);}
"data"                                                     	 {return (DATA);}
"matrix"                                                	    {return (MATRIX);}
"start"                                                	    {return (START);}
"end"                                                	       {return (END);}
{NUMBERCONST}                                                {return (NUMBERCONST);}
{FLOATCONST}                                                 {return (FLOATCONST);}
{LETTER_}*                                                 	 {printf("Identifier : %s\n",yytext); return (ID);}
{ASSIGNMENT}                                              	 {printf("Assignment Operators : %s\n",yytext); return (ASSIGNMENT);}
","                                                	       {return (COMMA);}
"."                                                	       {return (FULLSTOP);}


"\n"                                                         { lineno += 1; }
[ \t\r\f]+	                                                /* eat up whitespace */      
.                                                            {yyerror("Unrecognized character");}


%%

void yyerror(char *message){
    printf("Error: \"%s\" in line %d. Token = %s\n", message, lineno, yytext);
    exit(1);
}

int main(int argc, char* argv[])
{
   if(argc > 1)
   {
     FILE *fp = fopen(argv[1], "r");
     if(fp)
        yyin = fp;
   }
   yylex();
 
   return 0;
}
