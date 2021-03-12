#$Id: Makefile,v 1.2 2004/05/01 14:53:48 morsiani Exp morsiani $
# Makefile for mips-linux
#
# Edited for uMPS v3 by MikeyG on 2020/04/14

# Simplistic search for the umps3 installation prefix.
# If you have umps3 installed on some weird location, set UMPS3_DIR_PREFIX by hand.
ifneq ($(wildcard /usr/bin/umps3),)
	UMPS3_DIR_PREFIX = /usr
	LIBDIR = $(UMPS3_DIR_PREFIX)/lib/x86_64-linux-gnu/umps3
	
else
	UMPS3_DIR_PREFIX = /usr/local
	LIBDIR = $(UMPS3_DIR_PREFIX)/lib/umps3
endif

INCDIR = $(UMPS3_DIR_PREFIX)/umps3/umps
SUPDIR = $(UMPS3_DIR_PREFIX)/share/umps3
#LIBDIR = $(UMPS3_DIR_PREFIX)/lib/umps3

DEFS = ../h/const.h ../h/types.h ../h/asl.h ../h/pcb.h $(INCDIR)/libumps.h Makefile

CFLAGS = -ffreestanding -std=c99 -c -mips1 -w -mabi=32 -mfp32 -mno-gpopt -G 0 -fno-pic -mno-abicalls -I.

LDAOUTFLAGS = -G 0 -nostdlib -T $(SUPDIR)/umpsaout.ldscript
LDCOREFLAGS =  -G 0 -nostdlib -T $(SUPDIR)/umpscore.ldscript


CC = mipsel-linux-gnu-gcc
LD = mipsel-linux-gnu-ld
AS = mipsel-linux-gnu-as -KPIC

EF = umps3-elf2umps

#main target
all: kernel.core.umps 

kernel.core.umps: kernel
	$(EF) -k kernel

kernel: p1test.o asl.o pcb.o
	$(LD) $(LDCOREFLAGS) $(LIBDIR)/crtso.o p1test.o asl.o pcb.o $(LIBDIR)/libumps.o -o kernel

%.o: %.c $(DEFS)
	$(CC) $(CFLAGS) $<


clean:
	rm -f *.o term*.umps kernel kernel.*.umps


distclean: clean
	-rm kernel.*.umps
