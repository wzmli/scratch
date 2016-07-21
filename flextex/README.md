Trying to make robust make rules for latex

Issues:
=======

`latex` doesn't always do everything the first time. We don't want to crunch repeatedly, but we _do_ want `make` to know whether `latex` is really done

Bib: some files have bibliographies which adds an extra double-step. `make` should detect this and do it.

includegraphics: `make` should detect when graphics are included, and have the corresponding .pdf depend on the included graphics

input: `make` should detect files included with `input` or `include`. The .pdf depends on those files, _and on things included by those files!_

scripting: .tex files can be "made" products. Dependency files need to make sure that their underlying .tex files are up-to-date (`make` should be good at this).

chaining: ideally `make` should try to make everything needed _but not crash if it can't_. How would that work? I kind of think that it can't (unless we have a `/proc/uptime` in the main rule, and do the real work with subsidiary `$(MAKE)` statements!).

other directories: If .tex files are included from other directories, we have to figure out how to do those .deps. Can't remember why that was so confusing, but it was.

Plan
====

Have a fake target `.reqs` associated with each `.tex` file. `.reqs` depends on any graphics files included, and also on the `.reqs` for included files (these must be inferred from their own `.deps`!)

Require explicit .bbl dependence (since make can't work out from a bibliography statement what the main file name is)
