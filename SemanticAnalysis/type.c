#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

struct type {
   char* ident;
   char* value;
   int key_type;
};

int Size = 100;
struct type* Type[100]; 
struct type* type_item;
struct type* type_emptyItem;

int hashCodeType(int key) {
   return key % Size;
}

void insertType(char* identifier,char* value,int key) {

   struct type *type_item = (struct type*) malloc(sizeof(struct type));
   type_item->ident = identifier;
   type_item->value = value;
   type_item->key_type = key;

   //get the hash 
   int hashIndex = hashCodeType(key);

   //move in array until an empty or deleted cell
   while(Type[hashIndex] != NULL && Type[hashIndex]->key_type != -1) {
      //go to next cell
      ++hashIndex;
		
      //wrap around the table
      hashIndex %= Size;
   }
	
   Type[hashIndex] = type_item;
}

struct type* deleteAll(int key_type) {

    type_emptyItem = (struct type*) malloc(sizeof(struct type));
    type_emptyItem->value = "";  
    type_emptyItem->key_type = -1; 
    type_emptyItem->ident = "";
    
   //get the hash 
   int hashIndex = 0;

   //move in array until an empty
   while(hashIndex < key_type) {
	
      Type[hashIndex] = type_emptyItem; 
      //go to next cell
      hashIndex++;
   }      
	
   return NULL;        
}

void display_Type() {
   int i = 0;
	
   for(i = 0; i<Size; i++) {
	
      if(Type[i] != NULL)
         printf(" (%s,%s,%d)",Type[i]->ident,Type[i]->value,Type[i]->key_type);
      else
         break;
   }
	
   printf("\n");
}
