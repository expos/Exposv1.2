all:	aac

lex.yy.c: data.h decode.lex
	flex -i decode.lex

aac:	aac.c lex.yy.c
	gcc -o aac aac.c

clean:
	rm lex.yy.c aac
