#define BUFF 80
#define TABSIZE 128
#define TWO_OPND 2
#define ONE_OPND 1
#define NO_OPND 0
#define IS_LABEL 3
#define IS_HALT 4
#define IS_OVER 5

struct {
	char data[BUFF];
	int flag;
}yylval;

struct entry{
	char label[BUFF];
	int lineno;
};

struct {
	struct entry entry[TABSIZE];
	int label_count;
}symtab;

int pass,started,start_offset,line_count,error;

