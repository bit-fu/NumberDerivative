# vim:sts=8 sw=8 ts=8 noexpandtab:
#
#   Makefile
#   ~~~~~~~~
#
#   Project:		NumDer
#
#   Created 2014-08-20:	Ulrich Singer
#
#   $Id$
#

# Tools
#PATH		= $(PATH)
SHELL		= /bin/sh
INSTALL		= /usr/bin/install -C


# Targets
.PHONY: all clean upload

all: numder repl tags

numder: numder.ml
	ocamlopt -o $@ $^

repl: numder.ml
	ocamlmktop -o $@ $^

clean:
	$(RM) *.o *.cm? a.out numder repl

tags: *.ml
	ctags $^


# ~ Makefile ~ #
