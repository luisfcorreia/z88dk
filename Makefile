#
#
#	The impromptu compilation makefile for z88dk
#
#	$Id: Makefile,v 1.57 2016-09-09 09:06:07 dom Exp $
#

# ---> Configurable parameters are below his point

prefix = /usr/local
prefix_share = $(prefix)/share
git_rev = $(shell git rev-parse --short HEAD)
version := $(shell date +%Y%m%d)

INSTALL ?= install
CFLAGS ?= -O2
CC ?= gcc

# --> End of Configurable Options

export CC INSTALL CFLAGS

all: setup appmake copt zcpp sccz80 z80asm zcc zpragma zx7 z80nm ticks z80svg testsuite

setup:
	echo '#define PREFIX "${prefix_share}$"/z88dk"' > src/config.h
	echo '#define UNIX 1' >> src/config.h
	echo '#define Z88DK_VERSION "${version}-${git_rev}"' >> src/config.h
	@mkdir -p bin

appmake:
	$(MAKE) -C src/appmake
	$(MAKE) -C src/appmake PREFIX=`pwd` install

copt:
	$(MAKE) -C src/copt
	$(MAKE) -C src/copt PREFIX=`pwd` install

zcpp:
	$(MAKE) -C src/cpp
	$(MAKE) -C src/cpp PREFIX=`pwd` install

sccz80:
	$(MAKE) -C src/sccz80
	$(MAKE) -C src/sccz80 PREFIX=`pwd` install

z80asm:
	$(MAKE) -C src/z80asm
	$(MAKE) -C src/z80asm PREFIX=`pwd` install

zcc:
	$(MAKE) -C src/zcc
	$(MAKE) -C src/zcc PREFIX=`pwd` install

zpragma:
	$(MAKE) -C src/zpragma
	$(MAKE) -C src/zpragma PREFIX=`pwd` install

zx7:
	$(MAKE) -C src/zx7
	$(MAKE) -C src/zx7 PREFIX=`pwd` install

z80nm:
	$(MAKE) -C src/z80nm
	$(MAKE) -C src/z80nm PREFIX=`pwd` install

z80svg:
	$(MAKE) -C support/graphics
	$(MAKE) -C support/graphics PREFIX=`pwd` install

ticks:
	$(MAKE) -C src/ticks
	$(MAKE) -C src/ticks PREFIX=`pwd` install


libs:
	cd libsrc ; $(MAKE)
	cd libsrc ; $(MAKE) install

install-libs:
	mkdir -p $(DESTDIR)/$(prefix_share)/z88dk/lib/config
	cp -R lib/config/* $(DESTDIR)/$(prefix_share)/z88dk/lib/config/
	find $(DESTDIR)/$(prefix_share)/z88dk/lib/config -type f | xargs chmod 644
	mkdir -p $(DESTDIR)/$(prefix_share)/z88dk/lib/clibs
	cp -R lib/clibs/* $(DESTDIR)/$(prefix_share)/z88dk/lib/clibs/
	find $(DESTDIR)/$(prefix_share)/z88dk/lib/clibs -type f | xargs chmod 644

install:
	cd src/appmake ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/copt ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/cpp ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/sccz80 ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/z80asm ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	cd src/zcc ; $(MAKE) PREFIX=$(DESTDIR)/$(prefix) install
	find include -type d -exec $(INSTALL) -d -m 755 {,$(DESTDIR)/$(prefix_share)/z88dk/}{}  \;
	find include -type f -exec $(INSTALL) -m 664 {,$(DESTDIR)/$(prefix_share)/z88dk/}{}  \;
	find lib -type d -exec $(INSTALL) -d -m 755 {,$(DESTDIR)/$(prefix_share)/z88dk/}{} \;
	find lib -type f -exec $(INSTALL) -m 664 {,$(DESTDIR)/$(prefix_share)/z88dk/}{} \;

test:
	$(MAKE) -C test

clean: clean-bins
	$(MAKE) -C libsrc clean
#	cd lib/config ; $(RM) *.cfg		# .cfg are now stored in CVS
#	cd lib/clibs ; $(RM) *.lib		# .lib are now stored in CVS
#	find . -name "*.o" -type f -exec rm -f {} \;

clean-bins:
	$(MAKE) -C src/appmake clean
	$(MAKE) -C src/copt clean
	$(MAKE) -C src/cpp clean
	$(MAKE) -C src/sccz80 clean
	$(MAKE) -C src/z80asm clean
	$(MAKE) -C src/z80nm clean
	$(MAKE) -C src/zcc clean
	$(MAKE) -C src/zpragma clean
	$(MAKE) -C src/ticks clean
	$(MAKE) -C src/zx7 clean
	$(MAKE) -C test clean
	$(MAKE) -C testsuite clean
	#if [ -d bin ]; then find bin -type f -exec rm -f {} ';' ; fi

testsuite:
	$(MAKE) -C testsuite

.PHONY: test testsuite
