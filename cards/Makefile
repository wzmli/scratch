# scratch
### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget pushtarget: poisfits.Rout 

##################################################################

# make files

Sources = Makefile .gitignore README.md stuff.mk LICENSE.md
include stuff.mk
# include $(ms)/perl.def

##################################################################

## Content

Sources += $(wildcard *.R *.rmd *.mkd)

sim.Rout: sim.R

fakesim.Rout: sim.Rout fakesim.R

binfits.Rout: fakesim.Rout binfits.R
cardfits.Rout: fakesim.Rout cardfits.R
poisfits.Rout: fakesim.Rout poisfits.R 

Archive += .fakesim.RData

######################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
-include $(ms)/oldlatex.mk
-include $(ms)/pandoc.mk
