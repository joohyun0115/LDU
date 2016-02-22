TARGET = slides
LATEXSOURCES = \
	$(TARGET).tex 
EPSSOURCES = \

all: $(TARGET).pdf

.PHONY: lint
lint:
	./lint $(SPELLTEX)

SPELLTEX := $(shell ./utilities/get-tex-files.sh $(TARGET).tex)
spell:
	@ for i in $(SPELLTEX) *.bib; do aspell \
		--mode=tex \
		--add-tex-command="pyexpr p" \
		--add-tex-command="XXX op" \
		--add-tex-command="code p" \
		--add-tex-command="cmd p" \
		--add-tex-command="cref p" \
		--add-tex-command="Cref p" \
		--add-tex-command="thiscref p" \
		--add-tex-command="Thiscref p" \
		--add-tex-command="lcnamecref p" \
		-p ./aspell.words -c $$i; done
	@ for i in $(SPELLTEX); do perl utilities/double.pl $$i; done
	@ bash utilities/hyphens.sh $(SPELLTEX)
	@ ( head -1 aspell.words ; tail -n +2 aspell.words | sort ) > aspell.words~
	@ mv aspell.words~ aspell.words
.PHONY: spell

view: $(TARGET).pdf
	evince $(TARGET).pdf &
.PHONY: view

$(TARGET).pdf: $(LATEXSOURCES) $(EPSSOURCES) eps2pdf slide2pdf
	sh utilities/runlatex.sh $(TARGET) bib

eps2pdf:
	sh utilities/eps2pdf.sh

slide2pdf:
	perl utilities/export_overlays.pl slides.svg

clean:
	find . -name '*.aux' -o -name '*.blg' \
		-o -name '*.dvi' -o -name '*.log' \
		-o -name '*.nav' -o -name '*.out' \
		-o -name '*.snm' -o -name '*.pdf' \
		-o -name '*.qqz' -o -name '*.toc' | xargs rm

distclean: clean
	sh utilities/cleanpdf.sh

neatfreak: distclean
	# Don't forget to regenerate the .pdf from each .svg file
	find . -name '*.pdf' | xargs rm
	