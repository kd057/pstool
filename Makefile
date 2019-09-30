# Makefile for the pstool project

# +++ CONFIG +++

# target objects to create
# if asciidoctor-pdf is available, you might include README.pdf as well:w
PDFs = \
	README.pdf		\
	frankfurt-2020.pdf	\
	card/easter-2018.pdf

OUTNAME = $*.pdf

# --- CONFIG ---

TESTsrc != (find test -type f -name '*.ps' 2>/dev/null || echo)
TESTpdf != ((find test -type f -name '*.ps' 2>/dev/null | sed s/ps$$/pdf/ ) || echo)

.SUFFIXES: .pdf .ps .html .adoc

.adoc.pdf:
	asciidoctor-pdf $*.adoc

.adoc.html:
	asciidoctor $*.adoc

.ps.pdf:
	gs -q -sDEVICE=pdfwrite -dEmbedAllFonts=true -o $(OUTNAME) $*.ps || { rm $*.pdf; exit 1; }

...nodef...:
	@echo
	@echo "make target missing - to find out more, run: make what"
	@echo

what:
	@echo
	@sed -n <$(MAKEFILE) 's/^\([a-zA-Z].*\):.*#- /make \1		to /p'
	@echo

all:	clean depend create				#- rebuild the PDFs

clean:							#- to clean the workspace and remove build artefacts
	-rm -f  $(PDFs) $(TESTpdf)
	-rm -rf  .ps.depend
	-rm -f  .m.dependencies .m.dependencies.old

create:	$(PDFs)						#- create all defined PDF files

tests:							#- run all tests, w/o creating PDFs
	for t in $(TESTsrc); do echo TESTING $$t; gs $$t </dev/null || break; done

tests.pdf: depend					#- run all tests, creating PDFs
	for t in $(TESTpdf); do echo TESTING $$t; make $(MAKEFLAGS) $$t || break; done

refresh: clean depend test create			#- clean the workspace, rebuild dependencies and create defined PDF files

search:	
	egrep "$(key)" `find * -name '*.ps'` || : # ignore error messages

edit:	
	vi -c "/$(key)" `egrep -l "$(key)" \`find * -name '*.ps'\`` || : # ignore error messages

view:	$(PDFs)						#- create and view PDFs
	[ "$(PDFs)" ]	# no PDFs defined
	atril $(PDFs) 

depend:							#- rebuild dependencies
	-mv .m.dependencies .m.dependencies.old
	@make $(MAKEFLAGS) .m.dependencies

.m.dependencies: 
	@echo "[ refreshing dependencies ]"
	@[ -f $@ ] && mv $@ $@.old || :
	# .ps files depend on included files
	./ps.depend $(PDFs) $(TESTpdf) >$@

-include .m.dependencies

# Makefile ends here -----------------------------------------------
