#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

struct DataItem {
   char* identifier;
   char* type;
   int scope; 
   int key;
};

int maxSize = 1000;
struct DataItem* symbolTable[1000]; 
struct DataItem* emptyItem;
struct DataItem* item;

int hashCode(int key) {
   return key % maxSize;
}

struct DataItem *searchUsingIdentifier(char* identifier,int key) {
   //get the hash 
   int hashIndex = hashCode(key);  
	
   //move in array until an empty 
   while(symbolTable[hashIndex] != NULL) {
	
      if(symbolTable[hashIndex]->identifier == identifier)
         return symbolTable[hashIndex]; 
			
      //go to next cell
      ++hashIndex;
		
      //wrap around the table
      hashIndex %= maxSize;
   }        
	
   return NULL;        
}

void insert(char* identifier,char* type,int scope,int key) {

   struct DataItem *item = (struct DataItem*) malloc(sizeof(struct DataItem));
   item->identifier = identifier;  
   item->type = type;
   item->scope = scope;
   item->key = key;

   //get the hash 
   int hashIndex = hashCode(key);

   //move in array until an empty or deleted cell
   while(symbolTable[hashIndex] != NULL && symbolTable[hashIndex]->key != -1) {
      //go to next cell
      ++hashIndex;
		
      //wrap around the table
      hashIndex %= maxSize;
   }
	
   symbolTable[hashIndex] = item;
}

struct DataItem* delete(struct DataItem* item) {
   int key = item->key;

   //get the hash 
   int hashIndex = hashCode(key);

   //move in array until an empty
   while(symbolTable[hashIndex] != NULL) {
	
      if(symbolTable[hashIndex]->key == key) {
         struct DataItem* temp = symbolTable[hashIndex]; 
			
         //assign a dummy item at deleted position
         symbolTable[hashIndex] = emptyItem; 
         return temp;
      }
		
      //go to next cell
      ++hashIndex;
		
      //wrap around the table
      hashIndex %= maxSize;
   }      
	
   return NULL;        
}

void display() {
   int i = 0;
	
   for(i = 0; i<maxSize; i++) {
	
      if(symbolTable[i] != NULL)
         printf(" (%d,%s,%s,%d)",symbolTable[i]->key,symbolTable[i]->type,symbolTable[i]->identifier,symbolTable[i]->scope);
      else
         printf(" ~~ ");
   }
	
   printf("\n");
}