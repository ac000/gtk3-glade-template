APP_NAME = app

CC	= gcc
CFLAGS	= -Wall -Wextra -g -O2 -std=c99 -D_FILE_OFFSET_BITS=64 -fstack-protector-strong -fPIC
LDFLAGS	= -Wl,-z,now,--as-needed -pie
LIBS	= $(shell pkg-config --libs gtk+-3.0 glib-2.0 gmodule-2.0)
CFLAGS += $(shell pkg-config --cflags gtk+-3.0 glib-2.0 gmodule-2.0)

sources =	$(wildcard *.c)
objects =	$(sources:.c=.o)

v = @
ifeq ($V,1)
	v =
endif

$(APP_NAME): $(objects)
	@echo -e "  LNK\t$@"
	$(v)$(CC) $(LDFLAGS) -o $@ $(objects) $(LIBS)

$(objects): %.o: %.c
	@echo -e "  CC\t$@"
	$(v)$(CC) $(CFLAGS) -c -o $@ $<

clean:
	$(v)rm -f $(objects) $(APP_NAME)
