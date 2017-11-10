%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>   

	struct symtab {
		char sym_name[10];
		char sym_type[10];
		double value;
	} symbol_table[10];

	int symbol_count=0;
	int idx=0;
	int temp_var=0;

	int search_symbol(char []);
	void make_symtab_entry(char [],char [],double);
	void display_sym_tab();  
	void addQuadruple(char [],char [],char [],char []);
	void display_Quadruple();
	void push(char*);
	char* pop();

	struct Quadruple {
		char operator[5];
		char operand1[10];
		char operand2[10];
		char result[10];
	}quad[25];

	struct Stack {
		char *items[10];
		int top;
	} stack;
%}

%union {
	int ival;          
	double dval;
	char string[10];
}


%token <dval> NUMBER
%token <string> TYPE
%token <string> ID
%type <string> varlist
%type <string> expr
%token MAIN
%left '+' '-'
%left '*' '/'
%%
program:MAIN '('')''{' body '}';

body: varstmt stmtlist;

varstmt: vardecl varstmt|;

vardecl:TYPE varlist ';';

varlist: varlist ',' ID 	{                
				int i;
				i=search_symbol($3);
			 	if(i != -1)
					printf("\n Multiple Declaration of Variable");
			 	else
				 	make_symtab_entry($3,$<string>0,0);
		 		}

| ID'='NUMBER            	{
				int i;
				i=search_symbol($1);
				if(i != -1)
					printf("\n Multiple Declaration of Variable");
				else
					make_symtab_entry($1,$<string>0,$3);
				}

|varlist ',' ID '=' NUMBER 	{
				int i;
				i=search_symbol($3);
				if(i != -1)
					printf("\n Multiple Declaration of Variable");
				else
					make_symtab_entry($3,$<string>0,$5);
				}

|ID                     	{                
				int i;
				i=search_symbol($1);
				if(i != -1)
					printf("\n Multiple Declaration of Variable");
				else
					make_symtab_entry($1,$<string>0,0);
				};

stmtlist: stmt stmtlist|;

stmt : ID '=' NUMBER ';' 	{
			       	int i;
			       	i=search_symbol($1);
			       	if(i==-1)
					printf("\n Undefined Variable");
			        else {
					char temp[10];
				       	if(strcmp(symbol_table[i].sym_type,"int")==0)
					       	sprintf(temp,"%d",(int)$3);
				       	else
					       	snprintf(temp,10,"%f",$3);
				       	addQuadruple("=","",temp,$1);
			       	}
		       		}
| ID '=' ID ';'			{
				int i,j;
				i=search_symbol($1);
				j=search_symbol($3);
				if(i==-1 || j==-1)
					printf("\n Undefined Variable");
				else
					addQuadruple("=","",$3,$1);
				}
				
| ID '=' expr ';'              	{ 
				addQuadruple("=","",pop(),$1); 
				};

expr :expr '+' expr             {
			      	char str[5],str1[5]="t";
			     	sprintf(str, "%d", temp_var);   
			      	strcat(str1,str);
			      	temp_var++;
			      	addQuadruple("+",pop(),pop(),str1);                               
			      	push(str1);
		      		}
		      		
|expr '-' expr                 	{
				char str[5],str1[5]="t";
				sprintf(str, "%d", temp_var);   
				strcat(str1,str);
				temp_var++;
				addQuadruple("-",pop(),pop(),str1);
				push(str1);
				}  

|expr '*' expr 			{
				char str[5],str1[5]="t";
				sprintf(str, "%d", temp_var);       

				strcat(str1,str);
				temp_var++;
				addQuadruple("*",pop(),pop(),str1);
				push(str1);
				}
				
|expr '/' expr 			{
				char str[5],str1[5]="t";
				sprintf(str, "%d", temp_var);       

				strcat(str1,str);
				temp_var++;
				addQuadruple("/",pop(),pop(),str1);
				push(str1);
				}    

|ID 				{                     
				int i;
				i=search_symbol($1);
				if(i==-1)
					printf("\n Undefined Variable");
				else
					push($1);
				}

|NUMBER 			{       
				char temp[10];
				snprintf(temp,10,"%f",$1);   
				push(temp);
				};
				
%%
extern FILE *yyin;
int main() {
	stack.top = -1;
	yyin = fopen("input.txt","r");
	if(yyin == NULL) {
		printf("\nFile \"input.txt\" not found!\n\n");
		return 1;
	}
	yyparse();
	display_sym_tab();
	printf("\n\n");
	display_Quadruple();
	printf("\n\n");
	return 0;;
}

int search_symbol(char sym[10]) {
	int i,flag=0;
	for(i=0;i<symbol_count;i++) {
		if(strcmp(symbol_table[i].sym_name,sym)==0) {
			flag=1;
			break;
		}
	}
	if(flag==0)
		return(-1);
	else
		return(i);
}

void make_symtab_entry(char sym[10],char dtype[10],double val) {
	strcpy(symbol_table[symbol_count].sym_name,sym);
	strcpy(symbol_table[symbol_count].sym_type,dtype);
	symbol_table[symbol_count].value=val;
	symbol_count++;
}


void display_sym_tab() {
	int i;
	printf("Symbol Table\n\n");
	printf(" Name\t\tType\t\tValue");
	for(i=0;i<symbol_count;i++)
		printf("\n %s\t\t%s\t\t%f",symbol_table[i].sym_name,symbol_table[i].sym_type,symbol_table[i].value);
}
void display_Quadruple() {
	int i;
	printf("INTERMEDIATE CODE\n\n");
	printf("Quadruple Table\n\n");
	printf("\tResult\t\tOperator\tOperand 1\tOperand 2  ");
	for(i=0;i<idx;i++)
		printf("\n %d\t%s\t\t%s\t\t%8s\t%s",i,quad[i].result,quad[i].operator,quad[i].operand1,quad[i].operand2);
}
int yyerror() {
	printf("\nERROR!!\n");
	return(1);
}


void push(char *str) {
	stack.top++;
	stack.items[stack.top]=(char *)malloc(strlen(str)+1);
	strcpy(stack.items[stack.top],str);
}
char * pop() {
	int i;
	if(stack.top==-1) {
		printf("\nStack Empty!! \n");
		exit(0);
	}
	char *str=(char *)malloc(strlen(stack.items[stack.top])+1);;
	strcpy(str,stack.items[stack.top]);
	stack.top--;
	return(str);
}
void addQuadruple(char op[10],char op2[10],char op1[10],char res[10]) {
	strcpy(quad[idx].operator,op);
	strcpy(quad[idx].operand2,op2);
	strcpy(quad[idx].operand1,op1);
	strcpy(quad[idx].result,res);
	idx++;
}
