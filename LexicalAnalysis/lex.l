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
DATATYPE                "num"|"string"|"com"|"flag"|"data"|"matrix"
CONTROLSTATEMENT        "if"|"otherwise"|"repeat"|"leave"|"done"
FUNCTIONS               "note"|"send"|"call"
IOCOMMAND               "display"|"get"
RELATIONAL              "="|">"|"<"|">="|"<="|"!"|"equals"|"greater than"|"less than"|"less than or equals"|"greater than or equals"|"not equals"
ARITHMETIC              "+"|"-"|"*"|"/"|"%"|"plus"|"minus"|"into"|"dividedby"|"remainder"|"inc by"|"dec by"
ASSIGNMENT              "is"  
LOGICAL                 "or"|"and"
START                   "start"
END                     "end"
FULLSTOP                 "."
COMMA                     ","

%option noyywrap
%%

 
{DATATYPE}                                                   {return TYPE;};
{START}                                               	    {return START;};
{END}                                              	       {return END;};
{COMMA}                                            	       {return (COMMA);};
{FULLSTOP}                                                	       {return (FULLSTOP);};
{NUMBERCONST}                                                {return NUMBERCONST;};
{FLOATCONST}                                                 {return FLOATCONST;};
{ASSIGNMENT}                                              	 {printf("Assignment Operators : %s\n",yytext); return (ASSIGNMENT);};



{COMMENTS}                                               	 ;
{DELIMITERS}                                          	         ;
{RELATIONAL}                                              	 {printf("Relational Operators : %s\n",yytext);};
{ARITHMETIC}                                              	 {printf("Arithmetic Operators : %s\n",yytext);};
{LOGICAL}                                                 	 {printf("Logical Operators : %s\n",yytext);};
{DATATYPE}|{CONTROLSTATEMENT}|{FUNCTIONS}|{IOCOMMAND}|{CONTAINER}   {printf("Keywords :  %s\n",yytext);};
{STRCONST}                                                	 {printf("String Constants : %s\n",yytext);};
{SPECIALCHARS}                                            	 {printf("Special Characters : %s\n",yytext);};
{LETTER_}*                                                 	 {printf("Identifier : %s\n",yytext); return ID;};

"\n"                                                         { lineno += 1; };
[ \t\r\f]+	                                                /* eat up whitespace */      


%%
