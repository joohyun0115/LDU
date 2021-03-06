LATEXSOURCES = \
	scalability.tex 

EPSSOURCES = \

all: scalability.pdf

scalability.pdf: $(LATEXSOURCES) $(EPSSOURCES) eps2pdf 
	sh utilities/runlatex.sh scalability bib

eps2pdf:
	sh utilities/eps2pdf.sh

clean:
	find . -name '*.aux' -o -name '*.blg' \
		-o -name '*.dvi' -o -name '*.log' \
		-o -name '*.qqz' -o -name '*.toc' | xargs rm

distclean: clean
	sh utilities/cleanpdf.sh

neatfreak: distclean
	# Don't forget to regenerate the .pdf from each .svg file
	find . -name '*.pdf' | xargs rm
