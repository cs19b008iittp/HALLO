%{  
   #include <stdio.h>
   #include <stdlib.h>
   #include <string.h>
   int lineno = 1; // initialize to 1
   void yyerror();  
%}

digit                   [0-9]
letter                  [A-Za-z]
letter_                 [A-Za-z_]
datatype                "num"|"string"|"com"|"flag"|"data"|"matrix"
container               {datatype}"s"
controlstatement        "if"|"otherwise"|"repeat"|"leave"|"done"|"end"|"start"
functions               "note"|"send"|"call"
iocommand               "display"|"get"
numberconst             {digit}* 
floatconst              {digit}*+"."+{digit}{digit}*
strconst                "\"".*"\""  
assignment              "is"             
relational              "="|">"|"<"|">="|"<="|"!"|"equals"|"greater than"|"less than"|"less than or equals"|"greater than or equals"|"not equals"
arithmetic              "+"|"-"|"*"|"/"|"%"|"plus"|"minus"|"into"|"dividedby"|"remainder"|"inc by"|"dec by"
logical                 "or"|"and"
specialchars            "["|"]"|"("|")"|"{"|"}"|","|"#"|"*"|"~"|"."
comments                "ignore".*|"skip"(.|\n)*"skip"
delimiters              "."|[ \n\t]|","

%option noyywrap
%%

{comments}                                               	 ;
{delimiters}                                          	    ;
{assignment}                                              	 {printf("Assignment Operators : %s\n",yytext);}
{relational}                                              	 {printf("Relational Operators : %s\n",yytext);}
{arithmetic}                                              	 {printf("Arithmetic Operators : %s\n",yytext);}
{logical}                                                 	 {printf("Logical Operators : %s\n",yytext);}
{datatype}|{controlstatement}|{functions}|{iocommand}|{container}   {printf("Keywords :  %s\n",yytext);}
{letter_}*                                                 	 {printf("Identifier : %s\n",yytext);}
{numberconst}|{floatconst}                                       {printf("Number Constants :  %s\n",yytext);}
{strconst}                                                	 {printf("String Constants : %s\n",yytext);}
{specialchars}                                            	 {printf("Special Characters : %s\n",yytext);}
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
