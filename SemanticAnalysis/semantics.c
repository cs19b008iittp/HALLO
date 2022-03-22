#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
void display();
struct DataItem
{
   char *identifier;
   char *type;
   int scope;
   int key;
   char *matrowsize;
   char *matcolsize;
};

struct Function
{
   char *name;
   int key;
   int no_of_params;
   char *params;
   bool dec;
   char *return_type;
};

int maxSize = 1000;
struct DataItem *symbolTable[1000];
struct DataItem *emptyItem;
struct DataItem *item;
struct Function *functions[1000];

int hashCode(int key)
{
   return key % maxSize;
}

void insertFunction(char *name, int key, int no_of_params, char *params, bool dec, char *return_type)
{
   struct Function *func = (struct Function *)malloc(sizeof(struct Function));
   func->name = name;
   func->no_of_params = no_of_params;
   func->dec = dec;
   func->params = params;
   func->return_type = return_type;
   int hashIndex = hashCode(key);
   while (functions[hashIndex] != NULL && functions[hashIndex]->key != -1)
   {
      ++hashIndex;
      hashIndex %= maxSize;
   }
   functions[hashIndex] = func;
}

struct Function *searchFunctions(char *name)
{
   int hashIndex = 0;
   while (functions[hashIndex] != NULL)
   {
      if (strcmp(functions[hashIndex]->name, name) == 0)
      {
         return functions[hashIndex];
      }
      ++hashIndex;
      hashIndex %= maxSize;
   }
   return NULL;
}

void displayFunctions()
{
   int i = 0, j = 0;

   for (i = 0; i < maxSize; i++)
   {

      if (functions[i] != NULL)
      {
         printf("%s, %d, %d, %d %s : %s\n", functions[i]->name, functions[i]->key, functions[i]->dec, functions[i]->no_of_params, functions[i]->params, functions[i]->return_type);
      }
      else
         break;
   }

   printf("\n");
}

struct DataItem *searchUsingIdentifier(char *identifier)
{

   // get the hash
   int hashIndex = 0;
   // move in array until an empty
   while (symbolTable[hashIndex] != NULL)
   {
      if (strcmp(symbolTable[hashIndex]->identifier, identifier) == 0)
      {
         return symbolTable[hashIndex];
      }
      // go to next cell
      ++hashIndex;

      // wrap around the table
      hashIndex %= maxSize;
   }

   return NULL;
}

void insert(char *identifier, char *type, int scope, int key, char *mrowsize, char *mcolsize)
{

   struct DataItem *item = (struct DataItem *)malloc(sizeof(struct DataItem));
   item->identifier = identifier;
   item->type = type;
   item->scope = scope;
   item->key = key;
   item->matrowsize = mrowsize;
   item->matcolsize = mcolsize;

   // get the hash
   int hashIndex = hashCode(key);

   // move in array until an empty or deleted cell
   while (symbolTable[hashIndex] != NULL && symbolTable[hashIndex]->key != -1)
   {
      // go to next cell
      ++hashIndex;

      // wrap around the table
      hashIndex %= maxSize;
   }

   symbolTable[hashIndex] = item;
}

struct DataItem *delete (struct DataItem *item)
{
   int key = item->key;

   emptyItem = (struct DataItem *)malloc(sizeof(struct DataItem));
   emptyItem->scope = -1;
   emptyItem->key = -1;
   emptyItem->identifier = "";
   emptyItem->type = "";
   emptyItem->matrowsize = "";
   emptyItem->matcolsize = "";

   // get the hash
   int hashIndex = hashCode(key);

   // move in array until an empty
   while (symbolTable[hashIndex] != NULL)
   {

      if (symbolTable[hashIndex]->key == key)
      {
         struct DataItem *temp = symbolTable[hashIndex];

         // assign a dummy item at deleted position
         symbolTable[hashIndex] = emptyItem;
         return temp;
      }

      // go to next cell
      ++hashIndex;

      // wrap around the table
      hashIndex %= maxSize;
   }

   return NULL;
}

void deleteAllSymbol()
{
   emptyItem = (struct DataItem *)malloc(sizeof(struct DataItem));
   emptyItem->scope = -1;
   emptyItem->key = -1;
   emptyItem->identifier = "";
   emptyItem->type = "";
   emptyItem->matrowsize = "";
   emptyItem->matcolsize = "";

   // get the hash
   int hashIndex = 0;

   // move in array until an empty
   while (symbolTable[hashIndex] != NULL)
   {

      struct DataItem *temp = symbolTable[hashIndex];

      // assign a dummy item at deleted position
      symbolTable[hashIndex] = emptyItem;

      // go to next cell
      ++hashIndex;

      // wrap around the table
      hashIndex %= maxSize;
   }
}

void display()
{
   int i = 0;

   for (i = 0; i < maxSize; i++)
   {

      if (symbolTable[i] != NULL)
         printf(" (%d,%s,%s,%d)", symbolTable[i]->key, symbolTable[i]->type, symbolTable[i]->identifier, symbolTable[i]->scope);
      else
         break;
   }

   printf("\n");
}

bool checkCorrectAssignment(char *type, char *value)
{
   if (strcmp(type, "num") == 0)
   {
      int dots = 0;
      for (int i = 0; value[i] != '\0'; i++)
      {
         if (value[i] == '.')
            dots++;
         else if (value[i] >= '0' && value[i] <= '9')
         {
            continue;
         }
         else
            return false;
      }
      if (dots > 1)
         return false;
      return true;
   }
   else if (strcmp(type, "string") == 0)
   {
      if (value[0] == '"' && value[strlen(value) - 1] == '"')
      {
         return true;
      }
      return false;
   }
   else if (strcmp(type, "flag") == 0)
   {
      if (value == "true" || value == "false")
      {
         return true;
      }
      return false;
   }
   else if (strcmp(type, "com") == 0)
   {
      int dots = 0;
      for (int i = 0; i < strlen(value); i++)
      {
         if (value[i] == ';')
            break;
         else if (value[i] >= '0' && value[i] <= '9')
         {
            continue;
         }
         else if (value[i] == '.')
            dots++;
         else
            return false;
      }
      if (dots <= 1)
      {
         int dots = 0;
         for (int i = 0; i < strlen(value); i++)
         {
            if (value[i] == ';')
               break;
            else if (value[i] >= '0' && value[i] <= '9')
            {
               continue;
            }
            else if (value[i] == '.')
               dots++;
            else
               return false;
         }
         if (dots > 1)
            return false;
         return true;
      }
   }

   return false;
}

char *checkcond(char *cond[100], int condition, char *str)
{
   bool flag = true;
   for (int j = 0; j <= condition - 1; j++)
   {
      if (cond[j][0] >= '0' && cond[j][0] <= '9')
      {
         continue;
      }
      else
      {
         struct DataItem *temptype = searchUsingIdentifier(cond[j]);
         if (temptype == NULL)
         {
            return "wrong";
         }
         else
         {
            if (strcmp(temptype->type, "num") == 0)
            {
               continue;
            }
            else
            {
               flag = false;
               return "wrong";
            }
         }
      }
   }
   if (flag)
   {
      return str;
   }
   return "";
}
