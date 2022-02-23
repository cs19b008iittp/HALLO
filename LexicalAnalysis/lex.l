%{  
   #include <stdio.h>
   #include <stdlib.h>
   #include <string.h>
   #include "y.tab.h"
   int lineno = 1; // initialize to 1 
%}

DIGIT                   [0-9]
LETTER                  [A-Za-z]
LETTER_                 [A-Za-z_]
CONTAINER               {DATATYPE}"s"
NUMBERCONST             {DIGIT}* 
FLOATCONST              {DIGIT}+"."+{DIGIT}{DIGIT}
STRCONST                "\"".*"\""             
SPECIALCHARS            "["|"]"|"("|")"|"{"|"}"|","|"#"|"*"|"~"|"."
COMMENTS                "ignore".|"skip"(.|\n)"skip"
DELIMITERS              "."|[ \n\t]|","
DATATYPE                "num"|"string"|"com"|"flag"|"data"
CONTROLSTATEMENT        "if"|"otherwise"|"leave"|"then
FUNCTIONS               "note"|"send"|"call"
IOCOMMAND               "display"|"get"
RELATIONAL              "="|">"|"<"|">="|"<="|"!"|"equals"|"greater than"|"less than"|"less than or equals"|"greater than or equals"|"not equals"
ARITHMETIC              "+"|"-"|"*"|"/"|"%"|"plus"|"minus"|"into"|"dividedby"|"remainder"|"inc by"|"dec by"
ASSIGNMENT              "is"
LOGICAL                 "or"|"and"
START                   "start"
END                     "end"
FULLSTOP                "."
COMMA                   ","
COLON                   ":"
DONE                    "done"
REPEAT                  "repeat"
FROM                    "from"
TO                      "to"

%option noyywrap
%%

 
{DATATYPE}                                                   {return TYPE;};
"matrix"                                                     {return MATRIX;};
{CONTAINER}                                                  {return CONTAINER;};
{START}                                               	    {return START;};
{END}                                              	       {return END;};
{COMMA}                                            	       {return COMMA;};
{COLON}                                                      {return COLON;};
{FULLSTOP}                                                   {return FULLSTOP;};
{DONE}                                                       {return DONE;};
{REPEAT}                                                     {return REPEAT;};
{FROM}                                                       {return FROM;};
{TO}                                                         {return TO;};
{ARITHMETIC}                                                 {return ARITHMETIC;};
"note"                                                       {return NOTE;};
"send"                                                       {return SEND;};
"if"                                                         {return IF;};
"otherwise"                                                  {return OTHERWISE;};
"then"                                                       {return THEN;};
{NUMBERCONST}                                                {return NUMBERCONST;};
{FLOATCONST}                                                 {return FLOATCONST;};
{ASSIGNMENT}                                              	 {printf("Assignment Operators : %s\n",yytext); return (ASSIGNMENT);};
{LETTER_}*                                                 	 {printf("Identifier : %s\n",yytext); return ID;};
{}
"\n"                                                         { lineno += 1; };
[ \t\r\f]+	                                                 {}
  


%%
