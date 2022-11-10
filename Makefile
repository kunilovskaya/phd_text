#
# Edit the $FILES and $FIGURES variables before you run this makefile.
#

SHELL=/bin/sh
RM=/bin/rm
MV=/bin/mv

PREFIX=/usr/bin
LATEX=$(PREFIX)/pdflatex
BIBTEX=$(PREFIX)/bibtex
GLOSSARIES=$(PREFIX)/makeglossaries
VIEWER=$(PREFIX)/evince
DETEX=$(PREFIX)/detex

LINT=/usr/bin/chktex
LINT_OPTIONS=-q

# If you use vi replace this with ctags.
TAGS=$(PREFIX)/etags

.SUFFIXES:      .tex .dvi .eps .ps .pdf .jpg .png

.PHONEY: 	all clean tags lint view neat wc

MAIN = phd

FIGDIR = figures

CHAPDIR = chapters

# Add your own .eps figures to this list.
FIGURES = $(FIGDIR)/wlv-logo.jpg \
		$(FIGDIR)/subsets.png

# Add your own LaTeX files to this list.
FILES = phd.tex thesis.sty \
	$(CHAPDIR)/dedication.tex \
	$(CHAPDIR)/00_abstract.tex \
	$(CHAPDIR)/0_ack.tex \
	contents.tex \
	tables.tex \
	figures.tex \
	abbr.tex \
	$(CHAPDIR)/1_intro.tex \
	$(CHAPDIR)/2_features.tex \
	$(CHAPDIR)/3_varieties.tex \
	$(CHAPDIR)/4_quest.tex \
	$(CHAPDIR)/5_translationese.tex \
	$(CHAPDIR)/6_pro_qua.tex \
	$(CHAPDIR)/7_fin.tex \
	$(CHAPDIR)/app1.tex \
	$(CHAPDIR)/app2.tex \
	$(CHAPDIR)/app3.tex \
	$(CHAPDIR)/app4.tex \
	$(CHAPDIR)/app5.tex \
	$(CHAPDIR)/app6.tex \
	refs/intro.bib \
	refs/features.bib \
	refs/varieties.bib \
	refs/quest.bib \
	refs/experiments.bib \
	refs/related.bib \
	refs/myown.bib \

###
### DO NOT EDIT BELOW THIS LINE UNLESS YOU REALLY KNOW WHAT YOU'RE DOING!
###

all:    $(MAIN).pdf

$(MAIN).pdf:    $(MAIN).tex $(FIGURES) $(FILES)
	$(LATEX) $*.tex; 
	$(BIBTEX) $*;
	$(GLOSSARIES) $*;
	$(LATEX) $*.tex; 
	$(LATEX) $*.tex; 


view:       $(MAIN).pdf
	- $(VIEWER) $<

lint:
# Since your program is exiting with a code of 1, make sees that as an error, and then returns the same error itself. You can tell make to ignore errors by placing a - at the beginning of the line
	-@ $(LINT) $(LINT_OPTIONS) *.tex $(CHAPDIR)/*.tex 2>/dev/null # redirects stderr to file; /dev/null is the null device it takes any input you want and throws it away. It can be used to suppress any output. 

clean:
	- $(RM) -f *.aux \
        $(CHAPDIR)/*.aux \
		$(MAIN).log $(MAIN).dvi $(MAIN).ps $(MAIN).blg $(MAIN).bbl \
		$(MAIN).lot $(MAIN).lol $(MAIN).lof $(MAIN).toc $(MAIN).pdf $(MAIN).synctex.gz $(MAIN).out \
		$(MAIN).acn $(MAIN).acr $(MAIN).alg $(MAIN).glo $(MAIN).glg $(MAIN).glo $(MAIN).gls $(MAIN).glsdefs

# Generate a TAGS file for Emacs etags.
# Replace etags with ctags if you use vi.
tags:
	find . -name "*.tex" -print0 | xargs -0 $(TAGS)

# Suggested by Neil B.
neat:
	$(RM) -f *.aux \
        $(CHAPDIR)/*.aux \
		$(MAIN).log $(MAIN).blg $(MAIN).bbl \
		$(MAIN).lot $(MAIN).lof $(MAIN).toc

# Count words in thesis
wc:
	-@ echo 
	-@ echo -n "Total word count, excluding references and appendices: "
	-@ $(DETEX) $(CHAPDIR)/1_intro.tex $(CHAPDIR)/2_features.tex $(CHAPDIR)/3_varieties.tex $(CHAPDIR)/4_quest.tex $(CHAPDIR)/5_translationese.tex $(CHAPDIR)/6_pro_qua.tex $(CHAPDIR)/7_fin.tex | wc -w
	-@ echo 
	
	-@ echo -n "Chapter 1. Introduction: "
	-@ $(DETEX) $(CHAPDIR)/1_intro.tex | wc -w
	-@ echo -n "Chapter 2. Translationese Indicators: "
	-@ $(DETEX) $(CHAPDIR)/2_features.tex | wc -w
	-@ echo -n "Chapter 3. Human Translation Varieties: "
	-@ $(DETEX) $(CHAPDIR)/3_varieties.tex | wc -w
	-@ echo -n "Chapter 4. Quality in Translation: "
	-@ $(DETEX) $(CHAPDIR)/4_quest.tex | wc -w
	-@ echo -n "Chapter 5. Translation Detection: "
	-@ $(DETEX) $(CHAPDIR)/5_translationese.tex | wc -w
	-@ echo -n "Chapter 6. Professional Varieties and Quality Judgments: "
	-@ $(DETEX) $(CHAPDIR)/6_pro_qua.tex | wc -w
	-@ echo -n "Chapter 7. Conclusion: "
	-@ $(DETEX) $(CHAPDIR)/7_fin.tex | wc -w
	-@ echo 
	
	-@ echo -n "Appendices: "
	-@ $(DETEX) $(CHAPDIR)/app1.tex $(CHAPDIR)/app2.tex $(CHAPDIR)/app3.tex $(CHAPDIR)/app4.tex $(CHAPDIR)/app5.tex $(CHAPDIR)/app6.tex | wc -w
	-@ echo
