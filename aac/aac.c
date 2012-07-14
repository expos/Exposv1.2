#include "lex.yy.c"

/*
extern struct {char data[BUFF];int flag;}yylval;
extern struct {char label[BUFF];int position;int lineno;}entry;
extern struct {struct entry entry[TABSIZE];int label_count}symtab;
extern int pass,started,error;
*/
FILE *fp;
// void Initialize (void);
// void Printoneinstr (int);
// int Findlabellineno(char*);
// void Islabel(int opnd);

int baseVal = 0;
void Initialize()
{
	 started = -1;
	 line_count = 1;
	 symtab.label_count = 0;
	 error = 0;
}

int Findlabellineno(char str[BUFF])
{
	 int i;
	 for(i=1; i<=symtab.label_count; i++)
		  if(strcmp(symtab.entry[i].label,str) == 0)
				return (symtab.entry[i].lineno);
	 return -1;
}

void Islabel(int opnd)
{
	 int check;
	 if(opnd == 0)
		  fprintf(fp,"%s",yylval.data);
	 else
	 {
		  if((check = Findlabellineno(yylval.data))<0)
		  {
				printf("<ERROR:%d:> Label not found",line_count);
				exit(0);
		  }
		  else
		  {
				fprintf(fp,"%d",check + baseVal);
		  }
	 }
	 
}


void printAfterOver(){
  char c;
  int noOfLabels = symtab.label_count;
  while(noOfLabels--)
    fprintf(fp, "\n");
  c = getc(yyin);			//getc sets EOF flag only after reading EOF
  while(!feof(yyin)){
    fprintf(fp, "%c", c);
    c = getc(yyin);
  }
}

void Printoneinstr(int instr)
{
	 int opnd1,opnd2;
	 switch(instr)
	 {
		  
		  case NO_OPND:   fprintf(fp,"%s\n",yylval.data);
		  break;
		  
		  case ONE_OPND:  fprintf(fp,"%s ",yylval.data);
		  opnd1 = yylex();
		  Islabel(opnd1);
		  fprintf(fp,"\n");
		  break;
		  
		  case TWO_OPND: 	fprintf(fp,"%s ",yylval.data);
		  opnd1 = yylex();
		  Islabel(opnd1);
		  fprintf(fp," ");
		  opnd2 = yylex();
		  Islabel(opnd2);
		  fprintf(fp,"\n");
		  break;
		  
		  case IS_HALT: 	fprintf(fp,"%s\n",yylval.data);
		  break;
		  
		  case IS_OVER:	fprintf(fp,"%s\n",yylval.data);
		  printAfterOver();
		  fclose(fp);
		  exit(0);
		  break;
		  
		  default:	
				     printf("<ERROR>Illegal instruction\n");
		  exit(0);
		  
		  
	 }
}

void menu() {
	
	int flag;
	do {
		
		int choice, intNo;
		
		flag = 0;
		
		printf("1. User Program\n");
		printf("2. Startup Code\n");
		printf("3. Interrupts\n");
		printf("Enter ur choice(1/2/3)\n");
		scanf("%d",&choice);
		
		switch(choice) {
		
			case 1 : baseVal = 0;
			break;
			
			case 2 : baseVal = 256;
			break;
			
			case 3 : 
					printf("Enter interrupt no :\n");
					scanf("%d", &intNo);
					baseVal = ( 56 + intNo) * 256;
			break;
			
			default : 	flag = 1;
						printf("Invalid Option\n");
		}
		
	}while(flag==1);
}

main(int argc,char **argv)
{
	
	int instr;
	menu();
	Initialize();
	fp = fopen("labels_replaced.esim","w");      //output file is labels_replaced.esim
	if(argc < 2)
	{
		printf("<ERROR> Format is sim [filename] [Starting word address of the interrupt ]\n");
		exit(0);
	}
	yyin = fopen(argv[1],"r");
	if(yyin == NULL)
	{
		printf("File %s doesn't exist\n",argv[1]);
		exit(0);
	}
	pass = 1;
	yylex();
	if(started == -1)
	{
		printf("<ERROR> start missing\n");
		exit(0);
	}
	if(error == 1)
	{
		printf("\nAborting pass 2");
		exit(0);
	}
	pass = 2;
	line_count = started;
	fseek(yyin,start_offset,0);
	YY_FLUSH_BUFFER;
	fprintf(fp,"START\n");
	while(1)
	{
		instr = yylex();
		Printoneinstr(instr);
	}

}
