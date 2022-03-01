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
COMMENTS                "ignore".*|"skip"(.|\n)*"skip."
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
FLAG                    "true"|"false"
SEMI                    ";"

%option noyywrap
%%

{FLAG}                                                       {yylval.string=strdup(yytext);return FLAG;};
{DATATYPE}                                                   { yylval.string=strdup(yytext);return TYPE;};
{CONTAINER}                                                  {return CONTAINER;};
"matrix"                                                     {return MATRIX;};
{START}                                               	    {return START;};
{END}                                              	       {return END;};
{COMMA}                                            	       {return COMMA;};
{COLON}                                                      {return COLON;};
{SEMI}                                                       {return SEMI;};
{FULLSTOP}                                                   {return FULLSTOP;};
{DONE}                                                       {return DONE;};
"call"                                                       {return CALL;};
{REPEAT}                                                     {return REPEAT;};
{FROM}                                                       {return FROM;};
{TO}                                                         {return TO;};
{NUMBERCONST}                                                {yylval.string=strdup(yytext);return NUMBERCONST;};
{FLOATCONST}                                                 {yylval.string=strdup(yytext);return FLOATCONST;};
"by"                                                         {return BY;};
"note"                                                       {return NOTE;};
"update"                                                     {return UPDATE;};
"send"                                                       {return SEND;};
"if"                                                         {return IF;};
"otherwise"                                                  {return OTHERWISE;};
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
"display"                                                    {return DISPLAY;};
"get"                                                        {return GET;};
"leave"                                                      {return LEAVE;};
"\n"                                                         { lineno += 1; };  
{COMMENTS}                                                   {/*printf("Comments: %s\n",yytext);*/};
{DELIMITERS}                                          	    ;
{RELATIONAL}                                                 {return RELATIONAL;};
{ARITHMETIC}                                                 {return ARITHMETIC;};
{ASSIGNMENT}                                                 {return (ASSIGNMENT);};
{LOGICAL}                                                    {return LOGICAL;};
{STRCONST}                                                   {yylval.string=strdup(yytext);return STRCONST;};
{SPECIALCHARS}                                            	 {yylval.string=strdup(yytext);};
{LETTER_}*                                                 	 {yylval.string=strdup(yytext);/*printf("Identifier: %s\n",yytext);*/ return ID;};



%%

