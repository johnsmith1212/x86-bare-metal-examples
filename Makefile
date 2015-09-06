.POSIX:

-include params.makefile

BITS ?= 32
IN_EXT ?= .S
LD ?= ld
MYAS ?= as
OBJ_EXT ?= .o
OUT_EXT ?= .img
RUN ?= bios_hello_world

INS := $(wildcard *$(IN_EXT))
OUTS := $(patsubst %$(IN_EXT),%$(OUT_EXT),$(INS))

.PRECIOUS: %$(OBJ_EXT)
.PHONY: all clean run

all: $(OUTS)

%$(OUT_EXT): %$(OBJ_EXT) a.ld
	$(LD) --oformat binary -o '$@' '$<' -T a.ld #-Ttext 0x7C00

%$(OBJ_EXT): %$(IN_EXT)
	$(MYAS) -o '$@' '$<'

clean:
	rm -f *$(OBJ_EXT) *$(OUT_EXT)

run: all
	qemu-system-i386 '$(RUN)$(OUT_EXT)'