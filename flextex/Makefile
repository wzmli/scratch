# scratch/flextex
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: draft.pdf 

##################################################################

# make files

Sources = Makefile .gitignore stuff.mk README.md
include stuff.mk
include $(ms)/perl.def

##################################################################

## Content

Sources += $(wildcard *.pl)
Sources += $(wildcard *.tex *.bib *.md)
Sources += $(wildcard *.R)

######################################################################

# Test files

proposal.deps: proposal.tex
proposal.pdf: proposal.tex

test.deps: test.tex
test.pdf: test.tex

draft.deps:
draft.pdf:

ms.md.tex: ms.md
	pandoc -o $@ --biblatex $<

## flextex.mk

Sources += deps.mk

latex = pdflatex -interaction=nonstopmode
bibtex = biber

.PRECIOUS: %.aux
%.aux: /proc/uptime %.tex
	- $(MAKE) $*.reqs
	- $(MAKE) -f deps.mk $@

%.pdf: %.aux
	touch $<
	$(call hide, $<)
	$(latex) $*
	$(call difftouch, $<)

%.bbl: %.tex 
	/bin/rm -f $@
	$(bibtex) $*

%.reqs: %.deps
	-$(MAKE) -f $< -f Makefile $@

.PRECIOUS: %.deps
%.deps: %.tex latexdeps.pl
	$(PUSH)

######################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
-include $(ms)/pandoc.mk
# -include $(ms)/oldlatex.mk
