# scratch/flextex
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: test.pdf 

##################################################################

# make files

Sources = Makefile .gitignore stuff.mk README.md
include stuff.mk
include $(ms)/perl.def

##################################################################

## Content

Sources += $(wildcard *.pl)
Sources += $(wildcard *.tex)
Sources += $(wildcard *.R)

######################################################################

test.deps: test.tex
test.pdf: test.tex

## flextex.mk

Sources += deps.mk

latex = pdflatex -interaction=nonstopmode

.PRECIOUS: %.aux
%.aux: /proc/uptime %.tex
	- $(MAKE) $*.reqs
	- $(MAKE) -f deps.mk $@

%.pdf: %.aux
	$(call hide, $<)
	$(latex) $*
	$(call difftouch, $<)

%.reqs: %.deps
	$(MAKE) -f $< -f Makefile $@

.PRECIOUS: %.deps
%.deps: %.tex latexdeps.pl
	$(PUSH)

######################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk
