%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>
    #include <stdbool.h>
    #include "SemanticAnalysis/semantics.c"
    #include "SemanticAnalysis/type.c"
    int yylex(void);
    void yyerror(char *); 
    int key = 0;
    int key_type=0;
    char* type="";

    //variables for TAC
    extern int lines;
    int if_label = 0;
    // int else_label = 0;
    int label = 1;
    char temp_label[5] = "";
    int else_labels[100] = {0};
    int else_labels_iterator = -1;

    //for containers in declarations
    char* containertype="";
    char* cEntries[50] = {};
    int cIterator = 0;


    //for matices in declarations
    char* mEntries[50] = {};
    int mIterator = 0;

    //for functions declarations
    int function_no = 0;
    char* parm = "";
    char* param[8];
    int param_no = 0;
    bool in_main = false;
    char* temp_var = "";
    char function_name[20]="";

    char* cond[100] = {};
    int condition = 0;

    char* arith[100] = {};
    int arith_count = 0;

    int line_number=1;

    char tac[100000] = "";
    char data[100000] = "";
    int temp_number = 1;

    char leftside[1000] = "";
    char rightside[1000] = "";

    int assign[2];
    int assign_count = 0;

    int right[100];
    int right_count = 0;
    char relat[100] = "";

    char right_type[100] = "no";
   
    int param_count = 0;

    int repeat_array[1000];
    int repeat_array_count = 0;
    int repeat_label[100];
    int repeat_label_count = -1;

    int repeat_num[100];
    int repeat_num_count = 0;

    char* repeat_var[100] = {};
    int repeat_var_count = 0;

    bool main_present=false;

    int if_lab = 0;
    int repeat_lab = 0;

    char repeat_variable[100] = "";

%}

%union 
{
        char *string;
        int number;
}

%token START END ASSIGNMENT 

%token <string>NUMBERCONST <string>FLOATCONST <string>CONTAINER MATRIX <string>STRCONST <string>FLAG SEMI <string>ARITHMETIC

%token <string>RELATIONAL LOGICAL 

%token COMMA FULLSTOP <string>ID <string>TYPE COLON BY

%type <string> names init variable types_init contentries leftside_types assign_var function_end array_state
%type <string> constant varconst complex size rightside_types  assign_const data function_call  
%type <string> initialization termination incrementation constants inputs variable_name function_name

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
%left '!'

%%
program                     :       functions_optional start body END FULLSTOP functions_optional ;

start                       :       START
                                    {
                                        strcat(tac,"start:\n");
                                    }

body                        :       bodytypes body {in_main = true;} | {in_main = true;} ;
 
bodytypes                   :       declarations 
                                    {
                                        if(main_present==false)
                                        {
                                        main_present=true;
                                        }
                                        //printf("declarations %d\n",line_number);
                                         line_number++;
                                    }
                                    | statement 
                                    {
                                        if(main_present==false)
                                        {
                                        main_present=true;
                                        }
                                        //printf("statements %d\n",line_number);
                                         line_number++;
                                    }
                                    |
                                    error
                                    {
                                        printf("Error in line number %d\n",line_number++);
                                    }
                                    ;

  

//declarations 
 
declarations                :       declaration FULLSTOP ;
       
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
                                            else
                                            {
                                                printf("Redeclaration of variable %s\n", Type[i]->ident);
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
                                           else
                                            {
                                                printf("Redeclaration of variable %s\n", Type[i]->ident);
                                            }
                                        }
                                        deleteAll(key_type);
                                        key_type = 0;
                                    }
                                    
                                    | CONTAINER variable ASSIGNMENT contentries 
                                       {
                                        // multiple initializations for container in a single line is not possible.
                                        containertype = $1;
                                        char *containerDatatype = (char*)malloc(10);
                                        strcpy(containerDatatype,$1);
                                        bool flag = true;
                                        containerDatatype[strlen(containerDatatype)-1] = '\0';

                                        strcat(data,$2);
                                        strcat(data,": .word ");

                                        if(searchUsingIdentifier($2) == NULL)
                                        {
                                            if(containerDatatype=="data")
                                            {
                                                //check for "data" datatype
                                                for(int i=0;i<=cIterator-1;i++){
                                                 bool check=checkCorrectAssignment("num",cEntries[i])|checkCorrectAssignment("string",cEntries[i])|checkCorrectAssignment("com",cEntries[i])|checkCorrectAssignment("flag",cEntries[i]);
                                                    
                                                    strcat(data,cEntries[i]);
                                                    if(i!=cIterator-1)
                                                      strcat(data,",");
                                                    
                                                    if(!check){
                                                        flag = false;
                                                    }
                                                }
                                                strcat(data,"\n");
                                                if(flag == true)
                                                {
                                                    insert($2,$1,1,key,"","");
                                                    key++;
                                                }
                                                else{
                                                    //print appropriate error
                                                    printf("the datatype of the container is not matching the values initialized!");
                                                }
                                            }
                                            else{
                                                for(int i=0;i<=cIterator-1;i++){

                                                    strcat(data,cEntries[i]);
                                                    if(i!=cIterator-1)
                                                      strcat(data,",");

                                                    if(!checkCorrectAssignment(containerDatatype,cEntries[i])){
                                                        flag = false;
                                                    }
                                                }
                                                strcat(data,"\n");
                                                if(flag == true){
                                                    insert($2,$1,1,key,"","");
                                                    key++;
                                                }
                                                else{
                                                    //print appropriate error
                                                    printf("the datatype of the container is not matching the values initialized!");
                                                }

                                            }
                                        }
                                        else{
                                            printf("Redeclaration of variable %s\n", $2);
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
                                           else
                                            {
                                                printf("Redeclaration of variable %s",Type[i]->ident);
                                            }
                                        }
                                        deleteAll(key_type);
                                        key_type = 0;
                                    }
                                    
                                    | TYPE MATRIX variable NUMBERCONST BY NUMBERCONST ASSIGNMENT matentries
                                    {
                                        if(mIterator != atoi($4)*atoi($6)){
                                            printf("Check the number of entries for the matrix %s", $3);
                                        }

                                        type = $1;
                                        char *mdatatype = type;
                                        bool flag = true;

                                        if(searchUsingIdentifier($2) == NULL)
                                        {

                                            

                                        strcat(data,$3);
                                        strcat(data,": .word ");

                                            if(mdatatype=="data")
                                            {
                                                //check for "data" datatype
                                                for(int i=0;i<=mIterator-1;i++){

                                                    strcat(data,mEntries[i]);
                                                    if(i!=mIterator-1)
                                                      strcat(data,",");

                                                    if(!checkCorrectAssignment(mdatatype,mEntries[i])){
                                                        flag = false;
                                                    }
                                                }
                                                strcat(data,"\n");
                                                if(flag == true){
                                                    insert($3,type,1,key,$4,$6);
                                                    key++;
                                                }
                                                else{
                                                    //print appropriate error
                                                    printf("the datatype of the container is not matching the values initialized!");
                                                }
                                            }
                                            else{
                                                for(int i=0;i<=mIterator-1;i++){

                                                    strcat(data,cEntries[i]);
                                                    if(i!=cIterator-1)
                                                      strcat(data,",");

                                                    if(!checkCorrectAssignment(mdatatype,mEntries[i])){
                                                        flag = false;
                                                    }
                                                }
                                                 strcat(data,"\n");
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
                                            printf("Redeclaration of variable %s\n", $3);
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


                                        //TAC
                                        //printf("%s = %s;\n",$1,$3);
                                        if($3[0]=='"')
                                        {
                                            strcat(data,$1);
                                            strcat(data,": .asciiz ");
                                            strcat(data,$3);
                                            strcat(data,"\n");
                                        }
                                        else
                                        {
                                            strcat(tac,$1);
                                            strcat(tac," = ");
                                            strcat(tac,$3);
                                            strcat(tac,"\n");
                                        }
                                    }
                                    ;

types_init                  :       varconst {$$=$1;} | STRCONST {$$=$1;} | FLAG {$$=$1;} | complex {$$=$1;};

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

                                  
variable                    :       ID  {$$ = $1; };

variable_name               :       ID  {$$ = $1; strcpy(leftside,$1);};

//assignment statement

assignment                  :       leftside_types ASSIGNMENT rightside_types
                                    {
                                        if(strcmp($1,$3)!=0)
                                        {
                                            printf("%s, %s, error in arithmetic statement\n", $1, $3);
                                        }

                                        if(strcmp(right_type,"func")==0)
                                        {
                                            strcat(tac,leftside);
                                            strcat(tac," = func");
                                            strcat(tac,"\n");

                                            strcpy(right_type,"no");
                                        }
                                        else if(strcmp($3,"string")!=0)
                                        {
                                            strcat(tac,leftside);
                                            strcat(tac," = ");
                                            strcat(tac,"T");
                                            char string[20];
                                            sprintf(string, "%d", temp_number-1);
                                            strcat(tac,string);
                                            strcat(tac,"\n");
                                        }
                                        else
                                        {
                                            strcat(data,leftside);
                                            strcat(data,": .asciiz ");
                                            strcat(data,rightside);
                                            strcat(data,"\n");
                                        }

                                        for(int j=0;j<=99;j++)cond[j]="";
                                        condition = 0; 
                                        for(int j=0;j<=99;j++)arith[j]="";
                                        arith_count = 0; 
                                         for(int j=0;j<=99;j++)right[j]=0;
                                        right_count = 0; 
                                    }
                                    ;

leftside_types              :       variable_name assignment_types 
                                    {
                                        struct DataItem* temp = searchUsingIdentifier($1);
                                        if(temp == NULL)
                                        {
                                            printf("container is not declared: %s\n", $1);
                                            $$ = "wrong";
                                        }
                                        else
                                        {
                                            char* str = (char*)malloc(10);
                                            strcpy(str,temp->type);
                                            if(strcmp(str,"nums")==0||strcmp(str,"strings")==0||strcmp(str,"coms")==0||strcmp(str,"datas")==0||strcmp(str,"flags")==0)
                                            {
                                                str[strlen(str)-1]='\0';
                                                $$=checkcond(cond,condition,str);

                                                //tac
                                                if(strcmp($$,"wrong")!=0)
                                                {
                                                    if(condition == 1)
                                                    {
                                                        strcat(tac,"T");
                                                        char string[20];
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,"4 * ");
                                                        strcat(tac,cond[0]);
                                                        strcat(tac,"\n");
                                                    }
                                                    else
                                                    {
                                                        strcat(tac,"T");
                                                        char string[20];
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,cond[0]);
                                                        strcat(tac," ");
                                                        strcat(tac,arith[0]);
                                                        strcat(tac," ");
                                                        strcat(tac,cond[1]);
                                                        strcat(tac,"\n");
                                                        for(int j=0;j<=condition-3;j++)
                                                        {
                                                            strcat(tac,"T");
                                                            char string[20];
                                                            sprintf(string, "%d", temp_number++);
                                                            strcat(tac,string);
                                                            strcat(tac," = ");
                                                            strcat(tac,"T");
                                                            sprintf(string, "%d", temp_number-2);
                                                            strcat(tac,string);
                                                            strcat(tac," ");
                                                            strcat(tac,arith[j+1]);
                                                            strcat(tac," ");
                                                            strcat(tac,cond[j+2]);
                                                            strcat(tac,"\n");
                                                        }
                                                        strcat(tac,"T");
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,"4 * ");
                                                        strcat(tac,"T"); 
                                                        sprintf(string, "%d",temp_number-2);
                                                        strcat(tac,string);
                                                        strcat(tac,"\n");
                                                    }
                                                    strcat(leftside,"(");
                                                    strcat(leftside,"T");
                                                    char string[20];
                                                    sprintf(string, "%d", temp_number-1);
                                                    strcat(leftside,string);
                                                    strcat(leftside,")");
                                                }

                                            }
                                            else
                                            {
                                                $$ = "wrong";
                                            }
                                        }

                                        for(int j=0;j<=99;j++)cond[j]="";
                                        condition = 0;
                                        for(int j=0;j<=99;j++)arith[j]="";
                                        arith_count = 0;
                                        for(int j=0;j<=1;j++)assign[j]=0;
                                        assign_count = 0; 

                                    } 

                                    | variable_name
                                    {
                                        struct DataItem* temp = searchUsingIdentifier($1);
                                        if(temp==NULL)
                                        {
                                            printf("Identifier not declared : %s\n",$1);
                                            $$="wrong";
                                        }
                                        else 
                                        {
                                          $$ = temp->type;
                                        }
                                        for(int j=0;j<=1;j++)assign[j]=0;
                                        assign_count = 0; 
                                    }

                                    | variable_name assignment_types  assignment_types
                                    {
                                        struct DataItem* temp = searchUsingIdentifier($1);
                                        if(temp == NULL)
                                        {
                                            printf("container is not declared: %s\n", $1);
                                            $$ = "wrong";
                                        }
                                        else
                                        {
                                            char* str = temp->type;
                                            if(strcmp(str,"num")==0||strcmp(str,"string")==0||strcmp(str,"com")==0||strcmp(str,"data")==0||strcmp(str,"flag")==0)
                                            {
                                                $$=checkcond(cond,condition,str);

                                                //TAC
                                                int val_cond = 0;
                                                int val_arith = 0;
                                                int diff = assign[1]-1;
                                                for(int i=0;i<=1;i++)
                                                {
                                                    if(diff <= 1)
                                                    {
                                                        strcat(tac,"T");
                                                        char string[20];
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,"4 * ");
                                                        strcat(tac,cond[val_cond++]);
                                                        strcat(tac,"\n");
                                                    }
                                                    else
                                                    {
                                                        strcat(tac,"T");
                                                        char string[20];
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,cond[val_cond]);
                                                        strcat(tac," ");
                                                        strcat(tac,arith[val_arith++]);
                                                        strcat(tac," ");
                                                        strcat(tac,cond[++val_cond]);
                                                        strcat(tac,"\n");
                                                        for(int j=0;j<=diff-3;j++)
                                                        {
                                                            strcat(tac,"T");
                                                            char string[20];
                                                            sprintf(string, "%d", temp_number++);
                                                            strcat(tac,string);
                                                            strcat(tac," = ");
                                                            strcat(tac,"T");
                                                            sprintf(string, "%d", temp_number-2);
                                                            strcat(tac,string);
                                                            strcat(tac," ");
                                                            strcat(tac,arith[val_arith++]);
                                                            strcat(tac," ");
                                                            strcat(tac,cond[++val_cond]);
                                                            strcat(tac,"\n");
                                                        }
                                                        strcat(tac,"T");
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,"4 * ");
                                                        strcat(tac,"T");
                                                        sprintf(string, "%d", temp_number-2);
                                                        strcat(tac,string);
                                                        strcat(tac,"\n");
                                                        val_cond++;
                                                    }
                                                    diff = condition-assign[1]+1;
                                                    assign[i] = temp_number-1;
                                                }
                                                char string[20];
                                                strcat(tac,"T");
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,temp->matcolsize);
                                                strcat(tac," * ");
                                                strcat(tac,"T");
                                                sprintf(string, "%d", assign[0]);
                                                strcat(tac,string);
                                                strcat(tac,"\n");

                                                strcat(tac,"T");
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,"T"); 
                                                sprintf(string, "%d", assign[1]);
                                                strcat(tac,string);
                                                strcat(tac," + ");
                                                strcat(tac,"T");
                                                sprintf(string, "%d", temp_number-2);
                                                strcat(tac,string);
                                                strcat(tac,"\n");

                                                strcat(leftside,"(");
                                                strcat(leftside,"T");
                                                sprintf(string, "%d", temp_number-1);
                                                strcat(leftside,string);
                                                strcat(leftside,")");

                                            }
                                            else
                                            {
                                                $$ = "wrong";
                                            }
                                        }
                                        for(int j=0;j<=99;j++)cond[j]="";
                                        condition = 0;
                                        for(int j=0;j<=99;j++)arith[j]="";
                                        arith_count = 0; 
                                        for(int j=0;j<=1;j++)assign[j]=0;
                                        assign_count = 0; 
                                    }
                                    ;

rightside_types             :       function_call
                                    {
                                        //add TAC for rightside_types
                                        struct Function* temp = searchFunctions($1);
                                        $$ = temp->return_type;
                                        right[right_count++] = temp_number-1;
                                        
                                        strcpy(right_type,"func");

                                        strcat(tac,"\ngoto ");
                                        strcat(tac,$1); 
                                        //printf("%d\n",param_no);
                                        int i;
                                        for(i=0;i<=param_count-2;i++)
                                        {
                                          strcat(tac,param[i]);
                                          strcat(tac, " , ");
                                        }
                                        if (param_count-2>=0)
                                        strcat(tac,param[i]);
                                        strcat(tac,"\n");

                                        strcat(tac,"L");
                                        strcat(tac,$1);
                                        strcat(tac,":\n");

                                        right[right_count++] = temp_number-1;

                                    } 
                                     
                                    | variable assign_var 
                                    {
                                        if(strcmp($2,"wrong")==0)
                                        {
                                            $$ = "wrong";
                                        }
                                        else if(strcmp($2,"nothing")==0) 
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($1);
                                            if(temp == NULL)
                                            {
                                                printf("identifier is not declared: %s\n", $1);
                                                $$ = "wrong";
                                            }
                                            else
                                            {
                                                $$ = temp->type;  
                                                //tac
                                                strcat(tac,"T");
                                                char string[20];
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,$1);
                                                strcat(tac,"\n");
                                            }
                                        }
                                        else if(strcmp($2,"arith")==0)
                                        {
                                            cond[condition] = $1;
                                            condition++;
                                            $$ = checkcond(cond,1,"num");

                                            //tac
                                            if(condition == 1)
                                            {
                                                strcat(tac,"T");
                                                char string[20];
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,"4 * ");
                                                strcat(tac,cond[0]);
                                                strcat(tac,"\n");
                                            }
                                            else
                                            {
                                                strcat(tac,"T");
                                                char string[20];
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,$1);
                                                strcat(tac," ");
                                                strcat(tac,arith[arith_count-1]);
                                                strcat(tac," ");
                                                strcat(tac,cond[0]);
                                                strcat(tac,"\n");
                                                for(int j=0;j<=condition-3;j++)
                                                {
                                                    strcat(tac,"T");
                                                    char string[20];
                                                    sprintf(string, "%d", temp_number++);
                                                    strcat(tac,string);
                                                    strcat(tac," = ");
                                                    strcat(tac,"T");
                                                    sprintf(string, "%d", temp_number-2);
                                                    strcat(tac,string);
                                                    strcat(tac," ");
                                                    strcat(tac,arith[j]);
                                                    strcat(tac," ");
                                                    strcat(tac,cond[j+1]);
                                                    strcat(tac,"\n");
                                                }
                                            }
                                        }
                                        else
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($1);
                                            if(temp == NULL)
                                            {
                                                printf("container is not declared: %s\n", $1);
                                                $$ = "wrong";
                                            }
                                            else
                                            {
                                                char* str = (char*)malloc(10);
                                                strcpy(str,temp->type);
                                                if(strcmp(str,"nums")==0||strcmp(str,"strings")==0||strcmp(str,"coms")==0||strcmp(str,"datas")==0||strcmp(str,"flags")==0)
                                                {
                                                    if(strcmp($2,"container")==0)
                                                    {
                                                        str[strlen(str)-1]='\0';
                                                        $$ = str;

                                                        //tac
                                                        if(condition == 1)
                                                        {
                                                            strcat(tac,"T");
                                                            char string[20];
                                                            sprintf(string, "%d", temp_number++);
                                                            strcat(tac,string);
                                                            strcat(tac," = ");
                                                            strcat(tac,"4 * ");
                                                            strcat(tac,cond[0]);
                                                            strcat(tac,"\n");
                                                        }
                                                        else
                                                        {
                                                            strcat(tac,"T");
                                                            char string[20];
                                                            sprintf(string, "%d", temp_number++);
                                                            strcat(tac,string);
                                                            strcat(tac," = ");
                                                            strcat(tac,cond[0]);
                                                            strcat(tac," ");
                                                            strcat(tac,arith[0]);
                                                            strcat(tac," ");
                                                            strcat(tac,cond[1]);
                                                            strcat(tac,"\n");
                                                            for(int j=0;j<=condition-3;j++)
                                                            {
                                                                strcat(tac,"T");
                                                                char string[20];
                                                                sprintf(string, "%d", temp_number++);
                                                                strcat(tac,string);
                                                                strcat(tac," = ");
                                                                strcat(tac,"T");
                                                                sprintf(string, "%d", temp_number-2);
                                                                strcat(tac,string);
                                                                strcat(tac," ");
                                                                strcat(tac,arith[j+1]);
                                                                strcat(tac," ");
                                                                strcat(tac,cond[j+2]);
                                                                strcat(tac,"\n");
                                                            }
                                                            strcat(tac,"T");
                                                            sprintf(string, "%d", temp_number++);
                                                            strcat(tac,string);
                                                            strcat(tac," = ");
                                                            strcat(tac,"4 * ");
                                                            strcat(tac,"T");
                                                            sprintf(string, "%d", temp_number-2);
                                                            strcat(tac,string);
                                                            strcat(tac,"\n");
                                                        }
                                                        strcat(tac,"T");
                                                        char string[20];
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,$1);
                                                        strcat(tac,"(T");
                                                        sprintf(string, "%d", temp_number-2);
                                                        strcat(tac,string);
                                                        strcat(tac,")");   
                                                        strcat(tac,"\n");  
                                                                          
                                                    }
                                                    else
                                                      $$ = "wrong";
                                                }
                                                else if(strcmp(str,"num")==0||strcmp(str,"string")==0||strcmp(str,"com")==0||strcmp(str,"data")==0||strcmp(str,"flag")==0)
                                                {
                                                    if(strcmp($2,"matrix")==0)
                                                    {
                                                        $$ = str;

                                                        //TAC
                                                        int val_cond = 0;
                                                        int val_arith = 0;
                                                        int diff = assign[1]-1;
                                                        for(int i=0;i<=1;i++)
                                                        {
                                                            if(diff <= 1)
                                                            {
                                                                strcat(tac,"T");
                                                                char string[20];
                                                                sprintf(string, "%d", temp_number++);
                                                                strcat(tac,string);
                                                                strcat(tac," = ");
                                                                strcat(tac,"4 * ");
                                                                strcat(tac,cond[val_cond++]);
                                                                strcat(tac,"\n");
                                                            }
                                                            else
                                                            {
                                                                strcat(tac,"T");
                                                                char string[20];
                                                                sprintf(string, "%d", temp_number++);
                                                                strcat(tac,string);
                                                                strcat(tac," = ");
                                                                strcat(tac,cond[val_cond]);
                                                                strcat(tac," ");
                                                                strcat(tac,arith[val_arith++]);
                                                                strcat(tac," ");
                                                                strcat(tac,cond[++val_cond]);
                                                                strcat(tac,"\n");
                                                                for(int j=0;j<=diff-3;j++)
                                                                {
                                                                    strcat(tac,"T");
                                                                    char string[20];
                                                                    sprintf(string, "%d", temp_number++);
                                                                    strcat(tac,string);
                                                                    strcat(tac," = ");
                                                                    strcat(tac,"T");
                                                                    sprintf(string, "%d", temp_number-2);
                                                                    strcat(tac,string);
                                                                    strcat(tac," ");
                                                                    strcat(tac,arith[val_arith++]);
                                                                    strcat(tac," ");
                                                                    strcat(tac,cond[++val_cond]);
                                                                    strcat(tac,"\n");
                                                                }
                                                                strcat(tac,"T");
                                                                sprintf(string, "%d", temp_number++);
                                                                strcat(tac,string);
                                                                strcat(tac," = ");
                                                                strcat(tac,"4 * ");
                                                                strcat(tac,"T");
                                                                sprintf(string, "%d", temp_number-2);
                                                                strcat(tac,string);
                                                                strcat(tac,"\n");
                                                                val_cond++;
                                                            }
                                                            diff = condition-assign[1]+1;
                                                            assign[i] = temp_number-1;
                                                        }
                                                        char string[20];
                                                        strcat(tac,"T");
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,temp->matcolsize);
                                                        strcat(tac," * ");
                                                        strcat(tac,"T");
                                                        sprintf(string, "%d", assign[0]);
                                                        strcat(tac,string);
                                                        strcat(tac,"\n");

                                                        strcat(tac,"T");
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,"T"); 
                                                        sprintf(string, "%d", assign[1]);
                                                        strcat(tac,string);
                                                        strcat(tac," + ");
                                                        strcat(tac,"T");
                                                        sprintf(string, "%d", temp_number-2);
                                                        strcat(tac,string);
                                                        strcat(tac,"\n");

                                                        strcat(tac,"T");
                                                        sprintf(string, "%d", temp_number++);
                                                        strcat(tac,string);
                                                        strcat(tac," = ");
                                                        strcat(tac,$1);
                                                        strcat(tac,"(T");
                                                        sprintf(string, "%d", temp_number-2);
                                                        strcat(tac,string);
                                                        strcat(tac,")");
                                                        strcat(tac,"\n");
                                                    }
                                                    else
                                                      $$ = "wrong";
                                                }
                                                else
                                                {
                                                    $$ = "wrong";
                                                }
                                            }
                                        }

                                        right[right_count++] = temp_number-1;
                                        for(int j=0;j<=99;j++) cond[j]="";
                                        condition = 0;

                                        for(int j=0;j<=99;j++) arith[j]="";
                                        arith_count = 0;

                                        for(int j=0;j<=1;j++)assign[j]=0;
                                        assign_count = 0; 
                                    }

                                    | constant assign_const 
                                    {
                                       if(strcmp($2,"arith")==0)
                                        {
                                            $$ = "num";

                                            //tac
                                            if(condition == 1)
                                            {
                                                strcat(tac,"T");
                                                char string[20];
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,"4 * ");
                                                strcat(tac,cond[0]);
                                                strcat(tac,"\n");
                                            }
                                            else
                                            {
                                                strcat(tac,"T");
                                                char string[20];
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,$1);
                                                strcat(tac," ");
                                                strcat(tac,arith[arith_count-1]);
                                                strcat(tac," ");
                                                strcat(tac,cond[0]);
                                                strcat(tac,"\n");
                                                for(int j=0;j<=condition-2;j++)
                                                {
                                                    strcat(tac,"T");
                                                    char string[20];
                                                    sprintf(string, "%d", temp_number++);
                                                    strcat(tac,string);
                                                    strcat(tac," = ");
                                                    strcat(tac,"T");
                                                    sprintf(string, "%d", temp_number-2);
                                                    strcat(tac,string);
                                                    strcat(tac,arith[j]);
                                                    strcat(tac," ");
                                                    strcat(tac,cond[j+1]);
                                                    strcat(tac,"\n");
                                                }
                                            }
                                        }
                                       else if(strcmp($2,"nothing")==0)
                                       {
                                            $$ = "num";

                                            //tac
                                            strcat(tac,"T");
                                            char string[20];
                                            sprintf(string, "%d", temp_number++);
                                            strcat(tac,string);
                                            strcat(tac," = ");
                                            strcat(tac,$1);
                                            strcat(tac,"\n");
                                       }
                                        else
                                           $$ = "wrong";
                                        
                                        for(int j=0;j<=99;j++) cond[j]="";
                                        condition = 0;

                                        for(int j=0;j<=99;j++) arith[j]="";
                                        arith_count = 0;

                                        for(int j=0;j<=1;j++)assign[j]=0;
                                        assign_count = 0; 

                                        right[right_count++] = temp_number-1;
                                    }

                                    | size 
                                    {
                                        $$ = $1;
                                        right[right_count++] = temp_number-1;
                                    }

                                    | STRCONST  
                                    {
                                        cond[condition] = $1;
                                        condition++;
                                        $$ = "string";
                                   
                                        /*
                                        //TAC
                                        strcat(tac,"T");
                                        char string[20];
                                        sprintf(string, "%d", temp_number++);
                                        strcat(tac,string);
                                        strcat(tac," = ");
                                        strcat(tac,$1);
                                        strcat(tac,"\n");
                                        */

                                        strcpy(rightside,$1);

                                        right[right_count++] = temp_number-1;
                                    }

                                    | FLAG  
                                    {
                                        cond[condition] = $1;
                                        condition++; 
                                        $$ = "flag";

                                        //TAC
                                        strcat(tac,"T");
                                        char string[20];
                                        sprintf(string, "%d", temp_number++);
                                        strcat(tac,string);
                                        strcat(tac," = ");
                                        strcat(tac,$1);
                                        strcat(tac,"\n");

                                        right[right_count++] = temp_number-1;
                                    }
                                    
                                    | complex
                                    {
                                        cond[condition] = $1;
                                        condition++;
                                        $$ = "complex";

                                        //TAC
                                        strcat(tac,"T");
                                        char string[20];
                                        sprintf(string, "%d", temp_number++);
                                        strcat(tac,string);
                                        strcat(tac," = ");
                                        strcat(tac,$1);
                                        strcat(tac,"\n");

                                        right[right_count++] = temp_number-1;
                                    }
                                    ;

assign_var                  :       assignment_types  
                                    { 
                                        char* str = "container";
                                        // strcpy(str,"container");
                                        $$ = checkcond(cond,condition,str);
                                    }

                                    | ARITHMETIC assignment_types  
                                    {
                                        char* str = "arith";
                                        $$ = checkcond(cond,condition,str);

                                        if(strcmp($1,"plus") == 0) strcpy($1,"+");
                                        else if(strcmp($1,"minus") == 0) strcpy($1,"-");
                                        else if(strcmp($1,"into") == 0) strcpy($1,"*");
                                        else if(strcmp($1,"dividedby") == 0) strcpy($1,"/");
                                        else if(strcmp($1,"remainder") == 0) strcpy($1,"%");
                                         
                                        arith[arith_count] = $1;
                                        arith_count++;

                                    }
                                    
                                    | assignment_types assignment_types 
                                    {
                                        char* str = "matrix";
                                        // strcpy(str,"matrix");
                                        $$ = checkcond(cond,condition,str);
                                    }
                                    
                                    |  
                                    {
                                        $$ = "nothing";
                                    }
                                    ;

assign_const                :       ARITHMETIC assignment_types 
                                    {
                                        char* str = "arith";
                                        // strcpy(str,"arith");
                                        $$ = checkcond(cond,condition,str);

                                        arith[arith_count] = $1;
                                        arith_count++;
                                    }
                                    | 
                                    {
                                        $$ = "nothing";
                                    }
                                    ;

assignment_types            :       assignment_types ARITHMETIC varconst 
                                    {
                                        cond[condition] = $3;
                                        condition++; 
                                        arith[arith_count] = $2;
                                        arith_count++;

                                    } 
                                        
                                    | varconst  
                                    {
                                        cond[condition] = $1;
                                        condition++; 
                                        assign[assign_count] = condition;
                                        assign_count++;
                                    }
                                    ;


//statements

statement                   :       if_statement | repeat_statement | assignment FULLSTOP | function_call FULLSTOP | array_state FULLSTOP | print FULLSTOP | get FULLSTOP | leave FULLSTOP;




//print,scan and leave

print                       :       DISPLAY constants
                                    {
                                        strcat(tac, "disp ");
                                        strcat(tac, $2);
                                        strcat(tac, "\n");
                                    };

constants		            :       constants COMMA variable 
                                    {
                                        if(searchUsingIdentifier($3) == NULL)
                                            printf("Identifier is not declared: %s\n", $3);
                                        char *temp = $1;
                                        strcat(temp, ", ");
                                        strcat(temp, $3);
                                        $$ = temp;
                                    }

                                    | constants COMMA STRCONST 
                                    {
                                        char *temp = $1;
                                        strcat(temp, ", $");
                                        strcat(temp, $3);
                                        $$ = temp;
                                    }

                                    | constants COMMA constant 
                                    {
                                        char *temp = $1;
                                        strcat(temp, ", ");
                                        strcat(temp, $3);
                                        $$ = temp;
                                    }

                                    | variable 
                                    {
                                        if(searchUsingIdentifier($1) == NULL)
                                            printf("Identifier is not declared: %s\n", $1);
                                        else if(strcmp(searchUsingIdentifier($1)->type,"string")==0)
                                        {
                                            char temp[100] = "";
                                            strcat(temp, "$");
                                            strcat(temp, $1);
                                            $$ = temp;
                                        }
                                        else
                                         $$ = $1;
                                    }

                                    | STRCONST 
                                    { 
                                        char *temp = "";
                                        strcat(temp, "$");
                                        strcat(temp, $1);
                                        $$ = temp;
                                    }

                                    | constant { $$ = $1;};

get                         :       GET inputs 
                                    {
                                        strcat(tac, "get ");
                                        strcat(tac, $2);
                                        strcat(tac, "\n");
                                    }
                                    ;

inputs                      :       inputs COMMA variable
                                    {
                                        if(searchUsingIdentifier($3) == NULL)
                                            printf("Identifier is not declared: %s\n", $3);
                                        char *temp = $1;
                                        strcat(temp, ", ");
                                        strcat(temp, $3);
                                        $$ = temp;
                                    }
                                    | variable
                                    {
                                        if(searchUsingIdentifier($1) == NULL)
                                            printf("Identifier is not declared: %s\n", $1);
                                        $$ = $1;
                                    }
                                    ;

leave                       :       LEAVE ;
  


//array statements 

size                        :       SIZE OF variable 
                                    {
                                        if(searchUsingIdentifier($3) != NULL)
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($3);
                                            char* str = temp->type;
                                            if(strcmp(str,"nums")==0||strcmp(str,"strings")==0||strcmp(str,"coms")==0||strcmp(str,"datas")==0||strcmp(str,"flags")==0)
                                            {
                                                $$ = "num";

                                                //tac
                                                strcat(tac,"T");
                                                char string[20];
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = sizeof(");
                                                strcat(tac,$3);
                                                strcat(tac,")");
                                                strcat(tac,"\n");
                                            }
                                            else
                                               $$ = "wrong";
                                        
                                        }
                                        else
                                        {
                                            $$ = "wrong";
                                            printf("container not found.\n");
                                        }
                                    }
                                    
                                    | ROWSIZE OF variable 
                                    {
                                        if(searchUsingIdentifier($3) != NULL)
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($3);
                                            char* str = temp->type;
                                            if(strcmp(str,"num")==0||strcmp(str,"string")==0||strcmp(str,"com")==0||strcmp(str,"data")==0||strcmp(str,"flag")==0)
                                            {
                                                $$ = "num";

                                                //tac
                                                strcat(tac,"T");
                                                char string[20];
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,temp->matrowsize);
                                                strcat(tac,"\n");
                                            }
                                            else
                                               $$ = "wrong";
                                        }
                                        else
                                        {
                                            $$ = "wrong";
                                            printf("matrix not found.\n");
                                        }
                                    }
                                    
                                    | COLUMNSIZE OF variable
                                    {
                                        if(searchUsingIdentifier($3) != NULL)
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($3);
                                            char* str = temp->type;
                                            if(strcmp(str,"num")==0||strcmp(str,"string")==0||strcmp(str,"com")==0||strcmp(str,"data")==0||strcmp(str,"flag")==0)
                                            {
                                                $$ = "num";

                                                //tac
                                                strcat(tac,"T");
                                                char string[20];
                                                sprintf(string, "%d", temp_number++);
                                                strcat(tac,string);
                                                strcat(tac," = ");
                                                strcat(tac,temp->matrowsize);
                                                strcat(tac,"\n");
                                            }
                                            else
                                               $$ = "wrong";
                                        }
                                        else
                                        {
                                            $$ = "wrong";
                                            printf("matrix not found.\n");
                                        }
                                    }
                                    ;

array_state                 :       REMOVE FROM variable 
                                    {
                                           if(searchUsingIdentifier($3) != NULL)
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($3);
                                            char* str = temp->type;
                                            if(strcmp(str,"nums")==0||strcmp(str,"strings")==0||strcmp(str,"coms")==0||strcmp(str,"datas")==0||strcmp(str,"flags")==0)
                                            {
                                                $$ = "num";
                                            }
                                            else
                                               printf("Remove from not valid for this variable %s\n",$3);
                                        }
                                        else
                                        {
                                            printf("array not found.\n");
                                        }
                                    }

                                    | ADD rightside_types TO variable 
                                    {
                                           if(searchUsingIdentifier($4) != NULL)
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($4);
                                            char* str ;
                                            strcpy(str,temp->type);
                                            if(strcmp(str,"nums")==0||strcmp(str,"strings")==0||strcmp(str,"coms")==0||strcmp(str,"datas")==0||strcmp(str,"flags")==0)
                                            {
                                                if(strcmp($2,"wrong")==0)
                                                {
                                                    printf("%s %s, not matching for adding an element to array",$2,str);
                                                }
                                                else
                                                {
                                                    str[strlen(str)-1]='\0';
                                                    if(strcmp(str,$2)!=0)
                                                    {
                                                        printf("%s %s, not matching for adding an element to array",$2,str);
                                                    }
                                                }
                                            }
                                            else
                                               printf("Add to not valid for this variable %s\n",$4);
                                        }
                                        else
                                        {
                                            printf("array not found.\n");
                                        }
                                    }
                                    
                                    | DELETE variable rightside_types 
                                    {
                                           if(searchUsingIdentifier($2) != NULL)
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($2);
                                            char* str ;
                                            strcpy(str,temp->type);
                                            if(strcmp(str,"nums")==0||strcmp(str,"strings")==0||strcmp(str,"coms")==0||strcmp(str,"datas")==0||strcmp(str,"flags")==0)
                                            {
                                                if(strcmp($3,"wrong")==0)
                                                {
                                                    printf("%s %s, not matching for deleting an element to array",$3,str);
                                                }
                                                else
                                                {
                                                    str[strlen(str)-1]='\0';
                                                    if(strcmp(str,$3)!=0)
                                                    {
                                                        printf("%s %s, not matching for deleting an element to array",$3,str);
                                                    }
                                                }
                                            }
                                            else
                                               printf("delete not valid for this variable %s\n",$2);
                                        }
                                        else
                                        {
                                            printf("array not found.\n");
                                        }
                                    }
                                    
                                    | CHANGE rightside_types TO rightside_types IN variable 
                                    {
                                           if(searchUsingIdentifier($6) != NULL)
                                        {
                                            struct DataItem* temp = searchUsingIdentifier($6);
                                            char* str ;
                                            strcpy(str,temp->type);
                                            if(strcmp(str,"nums")==0||strcmp(str,"strings")==0||strcmp(str,"coms")==0||strcmp(str,"datas")==0||strcmp(str,"flags")==0)
                                            {
                                                if(strcmp($2,"wrong")==0 || strcmp($4,"wrong")==0)
                                                {
                                                    printf("%s or %s %s, not matching for adding an element to array",$2,$4,str);
                                                }
                                                else
                                                {
                                                    str[strlen(str)-1]='\0';
                                                    if(strcmp(str,$2)!=0 || strcmp(str,$4)!=0)
                                                    {
                                                        printf("%s or %s %s, not matching for changing an element to array",$2,$4,str);
                                                    }
                                                }
                                            }
                                            else
                                               printf("Change not valid for this variable %s\n",$6);
                                        }
                                        else
                                        {
                                            printf("array not found.\n");
                                        }
                                    }
                                    
                                    ;




//if statement 

if_statement                :       IF cond THEN COLON 
                                    {
                                        strcat(tac,"if T");
                                        sprintf(temp_label,"%d",right[0]);
                                        strcat(tac,temp_label);
                                        strcat(tac," ");
                                        strcat(tac,relat);
                                        strcat(tac," T");
                                        sprintf(temp_label,"%d",right[1]);
                                        strcat(tac,temp_label);

                                        for(int j=0;j<=99;j++)right[j]=0;
                                        right_count = 0; 

                                        strcat(tac," goto L");
                                        if_label = label;
                                        sprintf(temp_label,"%d",label);
                                        strcat(tac,temp_label);
                                        strcat(tac, "\n");
                                        label++;
                                        strcat(tac,"goto L");
                                        sprintf(temp_label,"%d",label);
                                        strcat(tac,temp_label);
                                        strcat(tac, "\n");
                                        else_labels_iterator++;
                                        else_labels[else_labels_iterator] = label;
                                        label++;

                                        strcat(tac, "L");
                                        sprintf(temp_label,"%d",if_label);
                                        strcat(tac,temp_label);
                                        strcat(tac, ": \n");
                                        
                                    }
                                    body_inside 
                                    {
                                        //storing in tac the body for if condition using if_label
                                        //strcat(tac, "a = c\n"); 
                                        //fill in the statements
                                    }
                                    done
                                    {
                                        strcat(tac,"goto L");
                                        if_label = label;
                                        sprintf(temp_label,"%d",label);
                                        strcat(tac,temp_label);
                                        strcat(tac, "\n");
                                        label++;
                                        if_lab = if_label;
                                    }
                                    otherwise
                                    {
                                        
                                    }
                                    ;

otherwise                   :       OTHERWISE
                                    {
                                        //printf("\nprinting otherwise line number1: %d\n", lines);
                                        strcat(tac,"L");
                                        sprintf(temp_label,"%d",else_labels[else_labels_iterator]);
                                        else_labels[else_labels_iterator] = 0;
                                        else_labels_iterator--;
                                        strcat(tac,temp_label);
                                        strcat(tac,": \n");
                                    }
                                    cond THEN COLON 
                                    {
                                        strcat(tac,"if T");
                                        sprintf(temp_label,"%d",right[0]);
                                        strcat(tac,temp_label);
                                        strcat(tac," ");
                                        strcat(tac,relat);
                                        strcat(tac," T");
                                        sprintf(temp_label,"%d",right[1]);
                                        strcat(tac,temp_label);

                                        for(int j=0;j<=99;j++)right[j]=0;
                                        right_count = 0; 

                                        strcat(tac," goto L");
                                        if_label = label;
                                        sprintf(temp_label,"%d",label);
                                        strcat(tac,temp_label);
                                        strcat(tac, "\n");
                                        label++;
                                        strcat(tac,"goto L");
                                        sprintf(temp_label,"%d",label);
                                        strcat(tac,temp_label);
                                        strcat(tac, "\n");
                                        else_labels_iterator++;
                                        else_labels[else_labels_iterator] = label;
                                        label++;

                                        strcat(tac, "L");
                                        sprintf(temp_label,"%d",if_label);
                                        strcat(tac,temp_label);
                                        strcat(tac, ": \n");
                                    } 
                                    body_inside
                                    {
                                        //strcat(tac, "a = c\n"); 
                                        //fill in the statements
                                    }
                                    done
                                    {
                                        strcat(tac,"goto L");
                                        sprintf(temp_label,"%d",if_lab);
                                        strcat(tac,temp_label);
                                        strcat(tac, "\n");
                                        label++;
                                    }
                                    otherwise 
                                    | OTHERWISE COLON 
                                    {
                                        //printf("\nprinting otherwise line number2: %d\n", lines);
                                        strcat(tac,"L");
                                        sprintf(temp_label,"%d",else_labels[else_labels_iterator]);
                                        else_labels[else_labels_iterator] = 0;
                                        else_labels_iterator--;
                                        strcat(tac,temp_label);
                                        strcat(tac,": \n");
                                    }
                                    body_inside
                                    {
                                        //strcat(tac, "a = c\n"); //fill in the statements from body_inside
                                    }
                                    done
                                    {
                                        strcat(tac,"\n");

                                        strcat(tac,"L");
                                        sprintf(temp_label,"%d",if_lab);
                                        strcat(tac,temp_label);
                                        strcat(tac, ":\n");
                                        label++;
                                    } 
                                    | 
                                    {
                                        else_labels[else_labels_iterator] = 0;
                                        else_labels_iterator--;
                                        //printf("\nprinting otherwise line number3: %d\n", lines);
                                    }
                                    ;

cond                        :       rightside_types RELATIONAL rightside_types LOGICAL cond
                                    {
                                            char* datatype= searchUsingIdentifier(cond[0])->type;
                                            for(int i=0;i<=condition;i++)
                                            {
                                                char* temp = searchUsingIdentifier(cond[i])->identifier; 
                                                bool valid = true;
                                                if(strcmp(datatype,temp)==0)
                                                {
                                                    valid = false;
                                                }
                                                if(valid == false)
                                                printf("invalid condition");
                                            }
                                            for(int j=0;j<=99;j++)cond[j]="";
                                            condition = 0;
                                            for(int j=0;j<=99;j++)arith[j]="";
                                            arith_count = 0; 
                                    }
                                         
                                    | rightside_types RELATIONAL rightside_types         
                                    {
                                        //strcat(tac,$2);
                                        strcpy(relat,$2);
                                        struct DataItem* data = searchUsingIdentifier(cond[0]);
                                        if(data != NULL)
                                        {
                                            char* datatype = data->type;
                                            for(int i=0;i<=condition;i++)
                                            {
                                                struct DataItem* temp = searchUsingIdentifier(cond[i]);
                                                if(temp != NULL)
                                                {
                                                    char* tempiden = temp->identifier;
                                                    bool valid = true;
                                                    if(strcmp(datatype,tempiden)==0)
                                                    {
                                                        valid = false;
                                                    }
                                                    if(valid == false)
                                                        printf("invalid condition");
                                                }
                                            }
                                        }
                                        for(int j=0;j<=99;j++)cond[j]="";
                                        condition = 0;
                                        for(int j=0;j<=99;j++)arith[j]="";
                                        arith_count = 0; 
                                    }
                                    ;
                                        

varconst                    :       variable {$$ = $1;};

                                    | constant {$$ = $1;};




//repeat

repeat_statement            :       REPEAT variable initialization termination incrementation COLON 
                                    {
                                        strcpy(repeat_variable,$2);
                                        strcat(tac,$2);
                                        strcat(tac," = ");
                                        strcat(tac,"T");
                                        sprintf(temp_label,"%d",repeat_array[repeat_array_count-4]);
                                        strcat(tac,temp_label);    
                                        strcat(tac,"\n");

                                        //printf("\nT values: %d %d %d %d\n", repeat_array[0], repeat_array[1], repeat_array[2], repeat_array[3]);

                                        strcat(tac,"goto L");
                                        repeat_array_count++;
                                        repeat_label[repeat_array_count] = label;
                                        sprintf(temp_label,"%d",repeat_label[repeat_array_count]);
                                        strcat(tac,temp_label);
                                        
                                        label++;
                                        strcat(tac, "\n");

                                        //Examples/conditional_tac_example.hallo

                                        strcat(tac, "L");
                                        strcat(tac,temp_label);
                                        strcat(tac,": \nif T");

                                        sprintf(temp_label,"%d",repeat_array[repeat_array_count-5]);
                                        strcat(tac,temp_label);                       

                                        strcat(tac," <=");
                                        strcat(tac," T");
                                        sprintf(temp_label,"%d",repeat_array[repeat_array_count-4]);
                                        strcat(tac,temp_label); 
                                        strcat(tac," goto L");
                                        sprintf(temp_label,"%d",label);
                                        strcat(tac,temp_label);

                                        strcat(tac, "\n");

                                        
                                        strcat(tac,"goto L");
                                        sprintf(temp_label,"%d",++label);
                                        repeat_lab = label;
                                        strcat(tac,temp_label);
                                        label++;
                                        strcat(tac, "\n");

                                        repeat_num[repeat_num_count++] = label-1;
                                        repeat_var[repeat_var_count++] = $2;

                                        strcat(tac, "L");
                                        sprintf(temp_label,"%d",label-2);
                                        strcat(tac,temp_label);
                                        strcat(tac,": \n");



                                        label++;


                                        

                                        

                                        struct DataItem *var = searchUsingIdentifier($2);
                                        if(var == NULL)
                                            printf("%s: Variable not declared\n", $2);
                                        else   
                                        {
                                            if(strcmp(var->type, $3)!=0)
                                                printf("%s, %s, %s, Wrong initialization\n", var->identifier, var->type, $3);
                                            if(strcmp(var->type, $4)!=0)
                                                printf("%s, %s, %s, Wrong Termination\n", var->identifier, var->type, $4);
                                            if(strcmp(var->type, $5)!=0)
                                                printf("%s, %s, %s, Wrong Incrementation\n", var->identifier, var->type, $5);
                                        }
                                      
                                    }
                                    body_inside done
                                    {
                                        // strcat(tac,"increment\n");
                                        strcat(tac,"T");
                                        sprintf(temp_label,"%d",repeat_array[repeat_array_count-5]);
                                        strcat(tac,temp_label);
                                        strcat(tac, " = ");
                                        strcat(tac,"T");
                                        sprintf(temp_label,"%d",repeat_array[repeat_array_count-5]);
                                        strcat(tac,temp_label);
                                        if(repeat_array[repeat_array_count-2]==1){
                                            strcat(tac," + ");
                                        }
                                        else{
                                            strcat(tac," - ");
                                        }
                                        strcat(tac,"T");
                                        sprintf(temp_label,"%d",repeat_array[repeat_array_count-3]);
                                        strcat(tac,temp_label);
                                        strcat(tac,"\n");

                                        strcat(tac,repeat_var[--repeat_var_count]);
                                        strcat(tac," = ");
                                        strcat(tac,"T");
                                        sprintf(temp_label,"%d",repeat_array[repeat_array_count-5]);
                                        strcat(tac,temp_label);
                                        strcat(tac,"\n");

                                        strcat(tac,"goto L");
                                        sprintf(temp_label,"%d",repeat_label[repeat_array_count]);
                                        strcat(tac,temp_label);
                                        repeat_array_count--;
                                        strcat(tac,"\n\n");
                                        repeat_array_count = repeat_array_count - 4;

                                        strcat(tac,"L");
                                        sprintf(temp_label,"%d",repeat_num[--repeat_num_count]);
                                        strcat(tac,temp_label);
                                        label++;
                                        strcat(tac, ":\n");


                                    }
                                    ;

initialization              :       FROM rightside_types
                                    {
                                        $$ = $2;
                                        //printf("\nT value for initialisation is: %d\n", temp_number);
                                        repeat_array[repeat_array_count] = temp_number - 1;
                                        repeat_array_count++;
                                     
                                    } 
                                    |  
                                    {
                                        $$ = "NULL";
                                    }
                                    ;
  
termination                 :       TO rightside_types 
                                    {
                                        $$ = $2; 
                                        //printf("\nT value for termination is: %d\n", temp_number);
                                        repeat_array[repeat_array_count] = temp_number - 1;
                                        repeat_array_count++;
                                    }
                                    |  
                                    {
                                        $$ = "NULL";
                                    }
                                    ;

incrementation              :       UPDATE ARITHMETIC rightside_types
                                    {
                                        $$ = $3;
                                        //printf("\nT value for incrementation is: %d\n", temp_number);
                                        repeat_array[repeat_array_count] = temp_number - 1;
                                        repeat_array_count++;
                                        if(strcmp($2,"inc by")==0){
                                            //printf("\nim inc by\n");
                                            repeat_array[repeat_array_count] = 1;
                                            repeat_array_count++;
                                        }
                                        else if(strcmp($2,"dec by")==0){
                                            //printf("\nim dec by\n");
                                            repeat_array[repeat_array_count] = 0;
                                            repeat_array_count++;
                                        }

                                    } 
                                    | 
                                    {
                                        $$ = "NULL";
                                    }
                                    ; 

done                        :       DONE FULLSTOP | FULLSTOP ;




//function_call

function_call               :       CALL variable param 
                                    {
                                        struct Function *func = searchFunctions($2);
                                        if(func == NULL)
                                            insertFunction($2, function_no++, param_no, parm, false,"");
                                        else
                                        {
                                            if(func->no_of_params != param_no && strcmp(func->params, parm) != 0)
                                                printf("Function parameter error: %s\n", func->name);
                                        }
                                        param_count = param_no;
                                        param_no = 0;
                                        $$ = $2;
                                    }
                                    
                                    | CALL variable
                                    {
                                        struct Function *func = searchFunctions($2);
                                        if(func == NULL)
                                            insertFunction($2, function_no++, param_no, NULL, false,"");
                                        else
                                        {
                                            if(func->no_of_params != param_no)
                                                printf("Function parameter error: %s\n", func->name);
                                        }
                                        param_count = param_no;
                                        param_no = 0;
                                        $$ = $2;
                                    }
                                    ;



//functions

functions_optional          :       functions_optional function_call_outside 
                                    {
                                        in_main = false;
                                    } 
                                    | 
                                    {
                                        in_main = false;
                                    } ;

function_name               :      ID{ $$ = $1; strcpy(function_name,$1);};

function_call_outside       :       NOTE function_name param_note COLON body_inside_function function_end
                                    {
                                        strcat(tac,"goto L");
                                        strcat(tac,$2);
                                        strcat(tac,"\n");
                                        struct Function *func = searchFunctions($2);
                                        if(func == NULL) 
                                        {
                                            insertFunction($2, function_no++, param_no, parm, true,$6);
                                            
                                        }
                                        else if(func->dec == false)
                                        {
                                            if(func->no_of_params != param_no && strcmp(func->params, parm) != 0)
                                                printf("Function parameter error: %s\n", func->name);
                                            else
                                                functions[func->key]->dec = true;
                                        }
                                        else
                                            printf("Function name exists: %s\n", $2);
                                        param_count = param_no;
                                        param_no = 0;

                                        deleteAllSymbol();
                                        key=0;
                                    }
                                    | NOTE function_name COLON body_inside_function function_end
                                    {
                                        strcat(tac,"goto L");
                                        strcat(tac,$2);
                                        strcat(tac,"\n");
                                        struct Function *func = searchFunctions($2);
                                        if(func == NULL)
                                            insertFunction($2, function_no++, 0, NULL, true,$5);
                                        else if(func->dec == false)
                                        {
                                            if(func->no_of_params != param_no)
                                                printf("Function parameter error: %s\n", func->name);
                                            else
                                                functions[func->key]->dec = true;
                                        }
                                        param_count = param_no;
                                        param_no = 0;
                                        deleteAllSymbol();
                                        key = 0;
                                    }
                                    ;

param                       :       param COMMA ID 
                                    {
                                        if (in_main == false)
                                        {
                                            strcat(parm, ",");
                                            strcat(parm, $3);
                                            param[param_no++] = $3;
                                        }
                                        else
                                        {
                                            struct DataItem *iden = searchUsingIdentifier($3);
                                            if(iden == NULL)
                                                printf("Identifier not defined: %s\n", $3);
                                            else
                                            {
                                                strcat(parm, ",");
                                                strcat(parm, $3);
                                                param[param_no++] = $3;
                                            }
                                        }
                                    }
                                    | ID 
                                    { 
                                        if (in_main == false)
                                        {
                                            parm = $1;
                                            param[param_no++] = $1;
                                        }
                                        else
                                        {
                                            struct DataItem *iden = searchUsingIdentifier($1);
                                            if( iden == NULL)
                                                printf("Identifier not defined: %s\n", $1);
                                            else
                                            {
                                                parm = $1;
                                                param[param_no++] = $1;
                                            }
                                        }
                                    }
                                    ;

param_note                       :   param_note COMMA data ID 
                                    {
                                        strcat(parm, ",");
                                        strcat(parm, $4);
                                        param[param_no++] = $4;
                                        insert($4,$3,2,key,"","");
                                        key++;
                                    }
                                    | data ID 
                                    { 
                                        char* p;
                                        p = (char*)malloc(20);
                                        strcpy(p,$2);
                                        parm = $2;
                                        param[param_no++] = $2;
                                        insert(p,$1,2,key,"","");
                                        key++;
                                    }
                                    ;

data                                : TYPE
                                    {
                                        $$ = $1;
                                    }
                                    | CONTAINER
                                    {
                                        $$ = $1;
                                    }
                                    | TYPE MATRIX
                                    {
                                        $$ = $1;
                                    }
                                    ;


function_end                :       SEND ID FULLSTOP
                                    {
                                        bool flag = false;
                                        for(int i=0;i<param_no;i++)
                                            if(strcmp(param[i], $2) == 0) flag = true;
                                        if(searchUsingIdentifier($2) != NULL)
                                            flag = true;
                                        if(!flag) printf("Return ID not found: %s\n", $2);
                                        else
                                        {
                                            $$ = searchUsingIdentifier($2)->type;
                                        }

                                        strcat(tac,"send ");
                                        strcat(tac,$2);
                                        strcat(tac,"\n");



                                    }
                                    | SEND FULLSTOP 
                                    {
                                         $$ = "null";
                                    }
                                    ;


//body inside for functions

body_inside_function        :       body_inside_function bodytypes_inside_function 
                                     | 
                                     {
                                        strcat(tac,function_name); 
                                        strcat(tac,": ");
                                        strcat(tac,"\n");
                                     }
                                     ;

bodytypes_inside_function   :       statement_inside_function 
                                    {
                                        line_number++;
                                    };
 
statement_inside_function   :       if_statement | repeat_statement |  assignment FULLSTOP | declarations | function_call FULLSTOP | array_state FULLSTOP | print FULLSTOP | get FULLSTOP | leave FULLSTOP | done ;




//body inside for if and for loops

body_inside                 :       body_inside statement_inside
                                    {
                                        line_number++;
                                    }
                                    | ;
 
statement_inside            :       declarations | if_statement | repeat_statement | 
                                   assignment FULLSTOP;| function_call FULLSTOP | array_state FULLSTOP| print FULLSTOP | get FULLSTOP | leave FULLSTOP ;



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

    FILE *file = fopen("tac.txt", "w");
    FILE *file_data = fopen("data.txt", "w");
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

    printf("\n==============: SYMBOL TABLE :===============\n");
    display();
    printf("\n==========================: FUNCTIONS :===========================\n");
    displayFunctions();
    printf("\n==========================: TAC :===========================\n");
    printf("%s\n", tac);
    fputs(tac,file);
    printf("\n==========================: DATA :===========================\n");
    printf("%s\n", data);
    fputs(data,file_data);

    return 0;
}