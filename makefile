#
# makefile for all BLITZ tools
#
# Harry Porter - 5 September 2007
# Kendall Stewart - 22 March 2014
#   - added flags to suppress warnings and linker errors
#   - removed sections not relevant to x86 compilation
# Harley Hauer - 16 April 2014
#   - Modernized the makefile to clean up the compilation directory.
#
# To compile all the Blitz Tools, type 'make' with this 'makefile' file in a
# directory containing the source files for all the Blitz.  The Unix "make"
# utility will execute all the necessary compiles as needed, based
# on files' most-recent-update times.
#
# Here is a list of the executables that should be produced:
#
#    asm
#    dumpObj
#    lddd
#    blitz
#    kpl
#    diskUtil
#    check
#    endian
#    hexdump
# 

CC=cc
CFLAGS=-g -m32 -w -Wl,--no-as-needed -lm -DBLITZ_HOST_IS_LITTLE_ENDIAN
CPLUSPLUS=g++
CPLUSPLUSFLAGS=-g -m32 -w -DBLITZ_HOST_IS_LITTLE_ENDIAN
LINKFLAGS=
BIN=./bin

# Compile the C portion of the software.

CTARGETS=asm dumpObj lddd blitz diskUtil hexdump check endian
CLIST=$(addprefix $(BIN)/, $(CTARGETS))

all: $(CLIST) $(BIN)/kpl

$(BIN)/%: %.c
	$(CC) $(CFLAGS) $< -o $@

# Compile the C++ portion of the software.
KPLSOURCES = main.cc lexer.cc ast.cc printAst.cc parser.cc mapping.cc \
			 ir.cc gen.cc kplcheck.cc

KPLOBJECTS = $(KPLSOURCES:.cc=.o)

$(BIN)/kpl: $(KPLOBJECTS)
	$(CPLUSPLUS) $(CPLUSPLUSFLAGS) $(LINKFLAGS) $(KPLOBJECTS) -o $@

.cc.o:
	$(CPLUSPLUS) $(CPLUSPLUSFLAGS) -c -o $@ $<

.PHONY: clean

clean:
	rm -f $(CLIST)
	rm -f $(BIN)/kpl
	rm -f *.o
