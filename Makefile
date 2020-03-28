APP_NAME = app

DEPDIR  := .d
$(shell mkdir -p $(DEPDIR) >/dev/null)
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td

CC	= gcc
CFLAGS	= -Wall -Wextra -Wdeclaration-after-statement -Wvla -g -O2 -std=c99 -D_FILE_OFFSET_BITS=64 -fstack-protector-strong -fPIC
LDFLAGS	= -Wl,-z,now,-z,relro,-z,defs,--as-needed -pie
LIBS	= $(shell pkg-config --libs gtk+-3.0 glib-2.0 gmodule-2.0)
CFLAGS += $(shell pkg-config --cflags gtk+-3.0 glib-2.0 gmodule-2.0)

POSTCOMPILE = @mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

sources =	$(wildcard *.c)
objects =	$(sources:.c=.o)

v = @
ifeq ($V,1)
	v =
endif

ifeq ($(ASAN),1)
        LDFLAGS += -fsanitize=address
endif

$(APP_NAME): $(objects)
	@echo -e "  LNK\t$@"
	$(v)$(CC) $(LDFLAGS) -o $@ $(objects) $(LIBS)

%.o: %.c
%.o: %.c $(DEPDIR)/%.d
	@echo -e "  CC\t$@"
	$(v)$(CC) $(DEPFLAGS) $(CFLAGS) -c -o $@ $<
	$(POSTCOMPILE)

$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

include $(wildcard $(patsubst %,$(DEPDIR)/%.d,$(basename $(sources))))

.PHONY: clean
clean:
	$(v)rm -f $(objects) $(APP_NAME)
	$(v)rm -f $(DEPDIR)/*
	$(v)rmdir $(DEPDIR)
