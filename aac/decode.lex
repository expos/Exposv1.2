%{
	#include "data.h"
	#define YY_INPUT(buf,result,max_size)\
	{\
		int c=fgetc(yyin);\
		result = (c==EOF) ? YY_NULL : (buf[0]=c,1);\
	}
%}

%option noyywrap

%x 	PASS1

%%

	int i;
	if (pass == 1) BEGIN (PASS1);
	if (pass == 2) BEGIN (INITIAL);

<PASS1>{

[a-z0-9]+/[\t ]*:	{
				for(i=0; i< symtab.label_count;i++)
					if(strcmp(symtab.entry[i].label,
							yytext)==0)
					{
						printf("<ERROR> Label %s already used in line no %d\n",yytext,symtab.entry[i].lineno);
						error = 1;
					}
				if(!error)
				{
					symtab.label_count++;
					strcpy(symtab.entry[symtab.label_count].label,yytext);
					symtab.entry[symtab.label_count].lineno= (line_count - started - symtab.label_count + 1) ;
				}
			}
START	{
		if(started != -1)
		{
			printf("<ERROR> Duplicate start instruction, earlier at line no %d\n",started);
			error = 1;
		}
		else
		{
			started = line_count;
			start_offset = ftell(yyin)-1;
		}
	}

.	;
[\n]+	line_count++;
<<EOF>>	return 0;

}

MOV		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
PID		{ strcpy(yylval.data,yytext); return(NO_OPND); }
SP 		{ strcpy(yylval.data,yytext); return(NO_OPND); }
BP		{ strcpy(yylval.data,yytext); return(NO_OPND); }
IP		{ //printf("<ERROR> IP cannot be an arguement\n");exit(0);
		  strcpy(yylval.data,yytext); return(NO_OPND); }
ADD		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
SUB		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
MUL		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
DIV		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
MOD		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
INR		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
DCR		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
LT    		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
GT    		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
EQ    		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
NE    		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
GE    		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
LE    		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
JZ 		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
JNZ 		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
JMP 		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
PUSH		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
POP		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
CALL		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
RET		{ strcpy(yylval.data,yytext); return(NO_OPND); }
IN    		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
OUT		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
LOAD		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
STORE		{ strcpy(yylval.data,yytext); return(TWO_OPND); }
INT		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
IRET		{ strcpy(yylval.data,yytext); return(NO_OPND); }
STRCMP	{ strcpy(yylval.data,yytext); return(TWO_OPND); }
STRCPY	{ strcpy(yylval.data,yytext); return(TWO_OPND); }
SIN		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
SOUT		{ strcpy(yylval.data,yytext); return(ONE_OPND); }
HALT		{ strcpy(yylval.data,yytext); return(IS_HALT); }
OVER		{ strcpy(yylval.data,yytext); return(IS_OVER); }
R[0-7]         { strcpy(yylval.data,yytext); yytext++;return(NO_OPND); }
S[0-7]         { strcpy(yylval.data,yytext); yytext++;return(NO_OPND); }
T[0-3]         { strcpy(yylval.data,yytext); yytext++;return(NO_OPND); }
\[R[0-9]\]     {	
			strcpy(yylval.data,yytext); 
			yytext[yyleng-1]='\0';
			yytext=yytext+2;	
			return(NO_OPND); 
		}	
\[S[0-7]\]     {	
			strcpy(yylval.data,yytext); 
			yytext[yyleng-1]='\0';
			yytext=yytext+2;	
			return(NO_OPND); 
		}	
\[T[0-3]\]     {	
			strcpy(yylval.data,yytext); 
			yytext[yyleng-1]='\0';
			yytext=yytext+2;	
			return(NO_OPND); 
		}	
\[[0-9]+\]	{
			strcpy(yylval.data,yytext); 
			yytext[yyleng-1]='\0';
			yytext++;
			return(NO_OPND);
		}
\[SP\]		{ strcpy(yylval.data,yytext); return(NO_OPND); }
\[BP\]		{ strcpy(yylval.data,yytext); return(NO_OPND); }
\[IP\]		{ printf("<ERROR>IP cannot be an arguement\n");exit(0);
		  strcpy(yylval.data,yytext); return(NO_OPND); }
-?[0-9]+  	{ strcpy(yylval.data,yytext); return(NO_OPND); }
[\t ]*		; 
<<EOF>>		{ printf("<ERROR> HALT instruction missing\n"); 
		  exit(0);
		}  
[\n]+	        line_count++;
[A-Za-z0-9]+[\t ]*:	;
\/\/.*		;
[,:]		;
[A-Za-z0-9]+	{ strcpy(yylval.data,yytext); return(IS_LABEL);}
.		{ printf("<ERROR> Unexpected symbol %s\n",yytext);
		  exit(0);
		}
%%
