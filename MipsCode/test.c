#include<stdio.h>
#include<string.h>
#include<conio.h>
#include<ctype.h>
void main()
{
char a[20];
int i,j=0,k=0,x=0;
FILE *fp;
if(( fp = fopen("z.dat", "r")) != 0)
 {
 while(fscanf(fp,"%s", a) != EOF)
 {
 i=0;
 if( strlen(a)==5)
 {
 i=i+2;
 if(islower(a[i]))
 printf("lw $t%d, (%c)\n", j++,a[i]);
 else
{
 for(i=2;i < strlen(a);i++)
 {
 if(isdigit(a[i]))
 {
 x= a[i] - '0';
 k=k*10 +x;
 }
 }
 printf("li $t%d, %d\n", j,k);
}
i=i+2;
if(islower( a[i]))
 printf("lw $t%d, (%c)\n", j++,a[i]);
 else
 {
 for(i=2;i < strlen(a);i++)
 {
 if(isdigit(a[i]))
 {
 x= a[i] - '0';
 k=k*10 +x;
 }
 }
 printf("li $t%d, %d\n", j,k);
}
 i=i-1;
 if(a[i] == '+')
 printf("add $t%d, $t%d, $t%d\n", j,j-1,j-2);
 else if( a[i] == '-')
 printf("sub $t%d, $t%d, $t%d\n", j,j-2,j-1);
 else if( a[i] == '*')
 printf("mul $t%d, $t%d, $t%d\n", j,j-2,j-1);
 else if( a[i] == '/')
 printf("div $t%d, $t%d, $t%d\n", j,j-2,j-1);
 }

 else if(strlen(a)==3) {
 i=i+2;
 if( islower(a[i]))
{
 printf("lw $t%d, %c\n",j,a[i]);
 printf("copy %c, $t%d\n", a[i-2],j);
}
 else
 printf("li $t%d, %c\n",j,a[i]);
 }
 j=j+1;
 }
 }
 } 