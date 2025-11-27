CC = gcc
CFLAGS = -Wall -g
FLEX = flex
BISON = bison

TARGET = simplewhile_parser
OBJS = parser.tab.o lex.yy.o lang.o main.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

parser.tab.c parser.tab.h: parser.y
	$(BISON) -d parser.y

lex.yy.c: lexer.l parser.tab.h
	$(FLEX) lexer.l

parser.tab.o: parser.tab.c lang.h
	$(CC) $(CFLAGS) -c parser.tab.c

lex.yy.o: lex.yy.c parser.tab.h lang.h
	$(CC) $(CFLAGS) -c lex.yy.c

lang.o: lang.c lang.h
	$(CC) $(CFLAGS) -c lang.c

main.o: main.c lang.h
	$(CC) $(CFLAGS) -c main.c

clean:
	rm -f $(TARGET) $(OBJS) parser.tab.c parser.tab.h lex.yy.c

.PHONY: all clean
