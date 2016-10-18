
## Content

format_files = beamer.tmp beamer.fmt

Sources += $(wildcard *.abs *.txt)

## Talk machinery

talkdir = $(ms)/talk

## Images

images = $(Drop)/courses/Lecture_images

images/%: images ;

##################################################################

### Makestuff

-include $(ms)/newlatex.mk
-include $(ms)/talk.mk
