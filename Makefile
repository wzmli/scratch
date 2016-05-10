# scratch
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: ortho.Rout 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
# include $(ms)/perl.def

##################################################################

## Content

Sources += $(wildcard *.R *.rmd *.mkd)

##################################################################

############ nlme "bug"

poly.Rout: poly.R

nlme.html: nlme.rmd

nlme_bug.Rout: nlme_bug.R

Archive += nlme.html

######################################################################

####### Scoring stuff

### Exploring the Johnson distribution

johnson.Rout: johnson.R

######################################################################

##### Orthogonality

ortho.Rout: ortho.R
lm.Rout: lm.R

### Makestuff

## Change this name to download a new version of the makestuff directory
# Makefile: start.makestuff

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
-include $(ms)/oldlatex.mk
-include $(ms)/pandoc.mk
