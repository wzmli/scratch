# scratch
### Public or private??
### Location???

current: target

target pngtarget pdftarget vtarget acrtarget pushtarget: redundancy.Rout 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
include $(ms)/perl.def
include $(ms)/python.def

##################################################################

## Sid Reed

Sources += $(wildcard *.py)
SIR.out: SIR.py
	$(PITH)

##################################################################

## Shapes Bewketu)

add.Rout: add.R

shapes.Rout: shapes.R

## Inbred explorations (Adler)

Sources += inbred.pl
inbred.out: inbred.pl
	$(PUSH)

##################################################################

Sources += $(wildcard *.R *.rmd *.mkd)

############ nlme "bug"

dplyrOrder.Rout: dplyrOrder.R

stochSIRsample.pdf: stochSIRsample.rmd

poly.Rout: poly.R

nlme.html: nlme.rmd

nlme_bug.Rout: nlme_bug.R

Archive += nlme.html

######################################################################

Sources += Policy_meeting.html

room.Rout: room.R

cards.Rout: cards.R

cards.Routput.compare: cards.R

### Compare stuff; may be good for makestuff?

%.setgoal: %
	/bin/cp $@ $*.goal

%.goal: 
	/bin/cp $* $@

%.compare: % %.goal
	diff $* $*.goal > $@

####### Scoring stuff

### Exploring the Johnson distribution

factor.Rout: factor.R

johnson.Rout: johnson.R
johnson_test.Rout: johnson.Rout johnson_test.R
johnson.mkd: 
johnson.html: johnson.rmd 
johnson.rmd: johnson_test.Rout-0.png johnson_test.Rout-1.png johnson_test.Rout-2.png

coexistence.html: coexistence.mkd

Sources += gavin70.tex
gavin70.pdf: gavin70.tex
neighbors.Rout: neighbors.R

### Promotion drafts

Sources += research_statement.tex
research_statement.pdf: fitpage.sty research_statement.tex
Archive += research_statement.pdf

Sources += teaching_statement.tex
teaching_statement.pdf: teaching_statement.tex
Archive += teaching_statement.pdf

fitpage.sty:

######################################################################

### Fitting from BB

stochSIRsample.pdf: slice2D.R

######################################################################

##### Orthogonality

### This is just lm, for reference I guess
lm.Rout: lm.R

### We can do lm manually, and were beginning to play with qr, which we will use for orthogonalizaiton
ortho.Rout: ortho.R

##### model matrix manipulation in clmm (for Tanzania)

### What does the ordinal function look like?
### Why do we care?
ordinal.Rout: ordinal.R

## Make some data with structural redundancy
tzdata.Rout: tzdata.R

## Fit it in different ways
redundancy.Rout: tzdata.Rout redundancy.R

######################################################################

### WTF is this? ###

dplyr.Rout: dplyr.R

#### tSIR (move to cards/ subdirectory!)

cards.Rout: cards.R
tSIR.Rout: tSIR.R
Archive += tSIR.Rout

### Fitting for Alejo http://dushoff.github.io/notebook/genFit.html

genFit.Rout: genFit.R

######################################################################

## Useful files

Sources += talk.Makefile

step.deps: step.R
step.Rout: step.R

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/stepR.mk
-include $(ms)/oldlatex.mk
-include $(ms)/pandoc.mk
