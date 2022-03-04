%{
    #include<stdio.h>
    #include<ctype.h>
    #include <string.h>
    int yylex(void);
    void yyerror(char *); 
    #include "SemanticAnalysis/semantics.c"
    #include "SemanticAnalysis/type.c"
    int key = 0;
    int key_type=0;
    char* type="";

    //for containers in declarations
    char* containertype="";
    char* cEntries[50] = {};
    int cIterator = 0;


    //for matices in declarations
    char* mEntries[50] = {};
    int mIterator = 0;



%}

%union 
{
        char *string;
        int number;
}

%token START END ASSIGNMENT 

%token <string>NUMBERCONST <string>FLOATCONST <string>CONTAINER MATRIX <string>STRCONST <string>FLAG SEMI

%token ARITHMETIC RELATIONAL LOGICAL 

%token COMMA FULLSTOP <string>ID <string>TYPE COLON BY

%type <string> names init variable types_init contentries
%type <string> constant varconst complex

%token REPEAT FROM TO DONE UPDATE

%token NOTE SEND CALL

%token ADD DELETE REMOVE IN OF SIZE CHANGE ROWSIZE COLUMNSIZE

%token DIGIT IF OTHERWISE THEN 

%token DISPLAY GET LEAVE COMMENTS

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
 
bodytypes                   :       declarations | statement;

  

//declarations 
 
declarations                :       declaration FULLSTOP;
       
declaration                 :       TYPE names 
                                    { 
                                        //we have to set the "type" for all entries in names using set_type function
                                        //for loop for all entries in the hash table for names
                                        //set the type for each entry.
                                        type = $1; 
                                        //display_Type();
                                        for(int i=0;i<=key_type-1;i++)
                                        {     
                                            if(searchUsingIdentifier(Type[i]->ident) == NULL)
                                           {       
                                               if(Type[i]->value == "")
                                               {  
                                                   insert(Type[i]->ident,type,1,key,"","");
                                                    key++;
                                               }
                                               else if(type=="data")
                                               {
                                                   bool check=checkCorrectAssignment("num",Type[i]->value)|checkCorrectAssignment("string",Type[i]->value)|checkCorrectAssignment("com",Type[i]->value)|checkCorrectAssignment("flag",Type[i]->value);
                                               }
                                               else if(checkCorrectAssignment(type,Type[i]->value))
                                               {
                                                    insert(Type[i]->ident,type,1,key,"","");
                                                    key++;
                                               }
                                            }
                                        }
                                        deleteAll(key_type);
                                        key_type = 0;
                                    }

                                    | CONTAINER contnames
                                    {
                                        containertype = $1;
                                        //containerDatatype[strlen(containertype)-1] = '\0';
                                        for(int i=0;i<=key_type-1;i++)
                                        {     
                                            if(searchUsingIdentifier(Type[i]->ident) == NULL)
                                           {
                                                insert(Type[i]->ident,containertype,1,key,"","");
                                                key++;
                                           }
                                        }
                                        deleteAll(key_type);
                                        key_type = 0;
                                    }
                                    
                                    | CONTAINER variable ASSIGNMENT contentries 
                                       {
                                        // multiple initializations for container in a single line is not possible.
                                        containertype = $1;
                                        char *containerDatatype = containertype;
                                        bool flag = true;
                                        containerDatatype[strlen(containertype)-1] = '\0';
                                        if(searchUsingIdentifier($2) == NULL)
                                        {
                                            if(containerDatatype=="data")
                                            {
                                                //check for "data" datatype
                                                for(int i=0;i<=cIterator-1;i++){
                                                 bool check=checkCorrectAssignment("num",cEntries[i])|checkCorrectAssignment("string",cEntries[i])|checkCorrectAssignment("com",cEntries[i])|checkCorrectAssignment("flag",cEntries[i]);
                                                    if(!check){
                                                        flag = false;
                                                    }
                                                }
                                                if(flag == true){
                                                    insert($2,containertype,1,key,"","");
                                                    key++;
                                                }
                                                else{
                                                    //print appropriate error
                                                    printf("the datatype of the container is not matching the values initialized!");
                                                }
                                            }
                                            else{
                                                for(int i=0;i<=cIterator-1;i++){
                                                    if(!checkCorrectAssignment(containerDatatype,cEntries[i])){
                                                        flag = false;
                                                    }
                                                }
                                                if(flag == true){
                                                    insert($2,containertype,1,key,"","");
                                                    key++;
                                                }
                                                else{
                                                    //print appropriate error
                                                    printf("the datatype of the container is not matching the values initialized!");
                                                }

                                            }
                                        }
                                        else{
                                            //print appropriate error
                                            printf("%s is already declared!",$2);
                                        }


                                    }


                                    | TYPE MATRIX matnames 
                                    {
                                        type = $1;
                                        for(int i=0;i<=key_type-1;i++)
                                        {     
                                            if(searchUsingIdentifier(Type[i]->ident) == NULL)
                                           {
                                                insert(Type[i]->ident,type,1,key,Type[i]->matrowsize,Type[i]->matcolsize);
                                                key++;
                                           }
                                        }
                                        deleteAll(key_type);
                                        key_type = 0;
                                    }
                                    
                                    | TYPE MATRIX variable NUMBERCONST BY NUMBERCONST ASSIGNMENT matentries
                                    {
                                        if(mIterator != atoi($4)*atoi($6)){
                                            //print appropriate error
                                            printf("check the number of entries for the matrix %s", $3);
                                        }

                                        type = $1;
                                        char *mdatatype = type;
                                        bool flag = true;
                                        mdatatype[strlen(type)-1] = '\0';
                                        if(searchUsingIdentifier($2) == NULL)
                                        {
                                            if(mdatatype=="data")
                                            {
                                                //check for "data" datatype
                                            }
                                            else{
                                                for(int i=0;i<=mIterator-1;i++){
                                                    if(!checkCorrectAssignment(mdatatype,mEntries[i])){
                                                        flag = false;
                                                    }
                                                }
                                                if(flag == true){
                                                    insert($3,type,1,key,$4,$6);
                                                    key++;
                                                }
                                                else{
                                                    //print appropriate error
                                                    printf("the datatype of the container is not matching the values initialized!");
                                                }

                                            }
                                        }
                                        else{
                                            //print appropriate error
                                            printf("%s is already declared!",$3);
                                        }
                                    }
                                    ;



names                       :       names COMMA variable 
                                    {
                                        insertType($3,"",key_type,"","");
                                        key_type++;
                                    }

                                    | names COMMA init 

                                    | variable 
                                    {
                                        insertType($1,"",key_type,"","");
                                        key_type++;
                                    }

                                    | init

                                    ; 

matnames                    :       matnames COMMA variable NUMBERCONST BY NUMBERCONST 
                                    {
                                        insertType($3,"",key_type,$4,$6);
                                        key_type++;

                                    }
        
                                    | variable NUMBERCONST BY NUMBERCONST
                                    {
                                        insertType($1,"",key_type,$2,$4);
                                        
                                        key_type++;
                                    }
                                    ;
contnames                   :       contnames COMMA variable 
                                    {
                                        insertType($3,"",key_type,"","");
                                        key_type++;
                                    }
            
                                    | variable 
                                    {
                                        insertType($1,"",key_type,"","");
                                        key_type++;
                                    }
                                    ;

init                        :       variable ASSIGNMENT types_init 
                                    {
                                        insertType($1,$3,key_type,"","");
                                        key_type++;
                                    }
                                    ;

types_init                  :       varconst {$$=$1;}| STRCONST {$$=$1;}| FLAG {$$=$1;}| complex {$$=$1;};

contentries                 :       contentries COMMA types_init 
                                    {
                                        cEntries[cIterator] = $3;
                                        cIterator++;
                                    }

                                    | types_init 
                                    {
                                        cEntries[cIterator] = $1;
                                        cIterator++;
                                    }
                                    ;

matentries                  :       matentries COMMA types_init 
                                    {
                                        mEntries[cIterator] = $3;
                                        mIterator++;
                                    }

                                    | types_init 
                                    {
                                        mEntries[cIterator] = $1;
                                        mIterator++;
                                    }
                                    ;

constant                    :       NUMBERCONST {$$ = $1;}

                                   | FLOATCONST {$$ = $1;}
                                   ;

complex                     :       varconst SEMI varconst  
                                    {
                                        strcat($$,$1);
                                        strcat($$,";");
                                        strcat($$,$3);
                                    }
                                    ;

variable                    :       ID  {$$ = $1;};



//assignment statement

assignment                  :       leftside_types ASSIGNMENT rightside_types ;

leftside_types              :       variable assignment_types | variable | variable assignment_types  assignment_types;

rightside_types             :       function_call | variable assign_var | constant assign_const | size | STRCONST | FLAG | complex;

assign_var                  :       assignment_types | ARITHMETIC assignment_types | assignment_types assignment_types |  ;

assign_const                :       ARITHMETIC assignment_types | ;

assignment_types            :       assignment_types ARITHMETIC varconst | varconst ;



//statements

statement                   :       if_statement | repeat_statement | assignment FULLSTOP | function_call FULLSTOP | array_state FULLSTOP | print FULLSTOP | get FULLSTOP | leave FULLSTOP;




//print,scan and leave

print                       :       DISPLAY constants;

constants		            :       constants COMMA variable 
                                    {
                                        if(searchUsingIdentifier($3) == NULL)
                                            printf("Identifier is not declared: %s\n", $3);
                                        else
                                            printf("Identifier is declared: %s\n", $3);
                                    }
                                    | constants COMMA STRCONST 
                                    | constants COMMA constant 
                                    | variable 
                                    {
                                        if(searchUsingIdentifier($1) == NULL)
                                            printf("Identifier is not declared: %s\n", $1);
                                        else
                                            printf("Identifier is declared: %s\n", $1);
                                    }
                                    | STRCONST 
                                    | constant;

get                         :       GET inputs ;

inputs                      :       inputs COMMA variable
                                    {
                                        if(searchUsingIdentifier($3) == NULL)
                                            printf("Identifier is not declared: %s\n", $3);
                                        else
                                            printf("Identifier is declared: %s\n", $3);
                                    }
                                    | variable
                                    {
                                        if(searchUsingIdentifier($1) == NULL)
                                            printf("Identifier is not declared: %s\n", $1);
                                        else
                                            printf("Identifier is declared: %s\n", $1);
                                    }
                                    ;

leave                       :       LEAVE ;
  


//array statements 

size                        :       SIZE OF variable | ROWSIZE OF variable | COLUMNSIZE OF variable;

array_state                 :       REMOVE FROM variable | ADD rightside_types TO variable | DELETE variable rightside_types | CHANGE rightside_types TO rightside_types IN variable ;




//if statement 

if_statement                :       IF  cond  THEN COLON body_inside done otherwise;

otherwise                   :       OTHERWISE cond THEN COLON body_inside done otherwise | OTHERWISE COLON body_inside done | ;

cond                        :       rightside_types RELATIONAL rightside_types LOGICAL cond | rightside_types RELATIONAL rightside_types ; 

varconst                    :       variable {$$ = $1;};

                                    | constant {$$ = $1;};




//repeat

repeat_statement            :       REPEAT variable initialization termination incrementation COLON body_inside done ;

initialization              :       FROM rightside_types |  ;
  
termination                 :       TO rightside_types |  ;

incrementation              :       UPDATE ARITHMETIC rightside_types | ;

done                        :       DONE FULLSTOP | FULLSTOP ;




//function_call

function_call               :       CALL variable param | CALL variable;



//functions

functions_optional          :       functions_optional function_call_outside | ;

function_call_outside       :       NOTE ID param COLON body_inside_function function_end | NOTE ID COLON body_inside_function function_end;

param                       :       param COMMA ID | ID ;

function_end                :       SEND ID FULLSTOP | SEND FULLSTOP ;




//body inside for functions

body_inside_function        :       body_inside_function bodytypes_inside_function | ;

bodytypes_inside_function   :       statement_inside_function ;
 
statement_inside_function   :       if_statement | repeat_statement |  assignment FULLSTOP | declarations | function_call FULLSTOP | array_state FULLSTOP | print FULLSTOP | get FULLSTOP | leave FULLSTOP | done ;




//body inside for if and for loops

body_inside                 :       body_inside statement_inside | ;
 
statement_inside            :       declarations | if_statement | repeat_statement |  assignment FULLSTOP | function_call FULLSTOP | array_state FULLSTOP| print FULLSTOP | get FULLSTOP | leave FULLSTOP ;



%%



void yyerror(char *s) {
 fprintf(stderr, "%s\n", s);
}


int main(int argc, char* argv[]) {
    extern FILE *yyin;

   //for insert order is identifier,type,scope,key
   //insert("hello","num",1,1);
   //insert("hi","string",1,2);

   //display();

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
    display();
    return 0;
}
