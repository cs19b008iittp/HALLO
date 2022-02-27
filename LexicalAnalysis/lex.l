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
FLOATCONST              {DIGIT}*+"."+{DIGIT}{DIGIT}*
STRCONST                "\"".*"\""              
SPECIALCHARS            "["|"]"|"("|")"|"{"|"}"|","|"#"|"*"|"~"|"."
COMMENTS                "ignore".*|"skip"(.|\n)*"skip"
DELIMITERS              "."|[ \n\t]|","
DATATYPE                "num"|"string"|"com"|"flag"|"data"  
CONTROLSTATEMENT        "if"|"otherwise"|"repeat"|"leave"|"done"
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

{DATATYPE}                                                   {printf("datatype: %s\n",yytext);return TYPE;};
{CONTAINER}                                                  {printf("container: %s\n",yytext);return CONTAINER;};
"matrix"                                                     {printf("matrix: %s\n",yytext);return MATRIX;};
{START}                                               	    {return START;};
{END}                                              	       {return END;};
{COMMA}                                            	       {return COMMA;};
{COLON}                                                      {return COLON;};
{FULLSTOP}                                                   {return FULLSTOP;};
{DONE}                                                       {printf("done: %s\n",yytext);return DONE;};
"call"                                                       {printf("call: %s\n",yytext);return CALL;};
{REPEAT}                                                     {printf("repeat: %s\n",yytext);return REPEAT;};
{FROM}                                                       {return FROM;};
{TO}                                                         {return TO;};
{NUMBERCONST}                                                {printf("number: %s\n",yytext); return NUMBERCONST;};
{FLOATCONST}                                                 {return FLOATCONST;};
"by"                                                         {return BY;};
"note"                                                       {return NOTE;};
"send"                                                       {return SEND;};
"if"                                                         {printf("if: %s\n",yytext);return IF;};
"otherwise"                                                  {printf("otherwise: %s\n",yytext);return OTHERWISE;};
"then"                                                       {return THEN;};
"add"                                                        {return ADD;};
"remove"                                                     {return REMOVE;};
"delete"                                                     {return DELETE;};
"change"                                                     {return CHANGE;};
"size"                                                       {return SIZE;};
"rowsize"                                                    {return ROWSIZE;};
"columnsize"                                                 {return COLUMNSIZE;};
"of"                                                         {return OF;};
"in"                                                         {return IN;};
"display"                                                    {printf("display: %s\n",yytext);return DISPLAY;};
"get"                                                        {return GET;};
"leave"                                                      {printf("leave: %s\n",yytext); return LEAVE;};
"\n"                                                         { lineno += 1; };  
{COMMENTS}                                                   ;
{DELIMITERS}                                          	     ;
{RELATIONAL}                                                 {return RELATIONAL;};
{ARITHMETIC}                                                 {return ARITHMETIC;};
{ASSIGNMENT}                                                 {printf("assignment: %s\n",yytext); return (ASSIGNMENT);};
{LOGICAL}                                                    {return LOGICAL;};
{STRCONST}                                                   {return STRCONST;};
{SPECIALCHARS}                                            	 {printf("Special Characters: %s\n",yytext);};
{LETTER_}*                                                 	 {printf("Identifier: %s\n",yytext); return ID;};



%%

