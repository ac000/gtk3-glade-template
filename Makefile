CC=gcc
CFLAGS=-Wall -g -O2 -std=c99
LDFLAGS=
LIBS=`pkg-config --libs gtk+-3.0 glib-2.0 gmodule-2.0`
INCS=`pkg-config --cflags gtk+-3.0 glib-2.0 gmodule-2.0`

app: app.o
	$(CC) ${LDFLAGS} -o app app.o ${LIBS}

app.o: app.c
	$(CC) $(CFLAGS) -c app.c ${INCS}

clean:
	rm -f app *.o
