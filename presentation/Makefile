# Makefile for the pstool/presentation sub-project
# based on the main Makefile

# +++ CONFIG +++

# target objects to create
PDFs =	\
	Ein-do-it-youself-Kalender-aus-der-Unix-Toolbox.pdf	\
	FraOSUG.pdf	\
	structure.pdf	\
	about-kdo.pdf

HTMLs =	\
	FraOSUG.html	\
	structure.html	\
	about-kdo.html

# ignore:	FraOSUG-initial.pdf draft.pdf draft.html

# these are not yet ready ...
OUTNAME = $*.pdf

SCRIPTS = ..

# --- CONFIG ---

.SUFFIXES: .jpg .pdf .ps .html .adoc

.adoc.pdf:
	asciidoctor-pdf $*.adoc

.adoc.html:
	# asciidoctor $*.adoc
	asciidoc --backend slidy $*.adoc

.ps.pdf:
	gs -q -sDEVICE=pdfwrite -dEmbedAllFonts=true -o $(OUTNAME) $*.ps || { rm $*.pdf; exit 1; }

.pdf.jpg:
	gs -sDEVICE=jpeg -r300x300 -dFirstPage=1 -dLastPage=1 -dNOPAUSE -sOutputFile=page-%02d-`basename $*.pdf .pdf`.jpg $*.pdf -c quit
	touch $*.jpg

...nodef...:
	@echo
	@echo "make target missing - to find out more, run: make what"
	@echo

Ein-do-it-youself-Kalender-aus-der-Unix-Toolbox.pdf: FraOSUG.pdf
	ln $? $@

what:
	@echo
	@sed -n <$(MAKEFILE) 's/^\([a-zA-Z].*\):.*#- /make \1		to /p'
	@echo

all:							#- rebuild documents
	@echo
	@echo "	target 'depend' not yet implemented -"
	@echo "	you should run:  make refresh"
	@echo

clean:							#- to clean the workspace and remove build artefacts
	-rm -f *.pdf .m.dependencies* $(PDFs) $(HTMLs)
	-rm -rf .build.dep

create:	$(PDFs) $(HTMLs)				#- create all defined PDF and HTMLand HTMLand HTML   files

titlepages:						#- extract all calendar title pages
	for p in ../*.pdf; do echo EXTRACTING $$p; make $(MAKEFLAGS) ../`basename $$p .pdf`.jpg || break; done

refresh: clean depend test create			#- clean the workspace, rebuild dependencies and create defined PDF files

search:	
	egrep "$(key)" `find * -name '*.ps'` || : # ignore error messages

edit:	
	vi -c "/$(key)" `egrep -l "$(key)" \`find * -name '*.ps'\`` || : # ignore error messages

view:	$(PDFs)						#- create and view PDFs
	[ "$(PDFs)" ]	# no PDFs defined
	atril $(PDFs) 

depend:							#- rebuild dependencies
	@echo '++++++ dependencies are not yet created automatically ++++++'
	# -mv .m.dependencies .m.dependencies.old
	# @make $(MAKEFLAGS) .m.dependencies

-include .m.dependencies

# Makefile ends here -----------------------------------------------
