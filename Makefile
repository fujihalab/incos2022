#
# Makefile for TeX document
#
# ver 0.31 (2007.02.09) by K. Wako
# modified (2008.10.10) by A. Fujihara
#

# file name
#NAME = tecrep
#NAME = template
NAME = incos2022_manuscript

# latex
LATEX  = platex
BIBTEX = bibtex

# converter
DVI2PS  = dvi2ps
DVI2PDF = dvipdfmx

# viewer
DVIVIEW = xdvi
PSVIEW  = gv
#PDFVIEW = acroread
PDFVIEW = evince
#PDFVIEW = xpdf -z width 


UTF8TEXFILE = utf8-$(NAME).tex
TEXFILE = $(NAME).tex
DVIFILE = $(NAME).dvi
PSFILE  = $(NAME).ps
PDFFILE = $(NAME).pdf

LOGFILE = $(NAME).log
AUXFILE = $(NAME).aux
BBLFILE = $(NAME).bbl
BLGFILE = $(NAME).blg


all: pdf

#
# generate complete dvi file
#

full:
	$(LATEX) $(TEXFILE)
	$(BIBTEX) $(NAME)
	$(LATEX) $(TEXFILE)
	$(LATEX) $(TEXFILE)

#
# short-cut
#

dvi: $(DVIFILE)

ps: $(PSFILE)

pdf: $(PDFFILE)


#
# output files
#

$(TEXFILE): $(UTF8TEXFILE)
	nkf -w -Lu -d $(UTF8TEXFILE) > $(TEXFILE)
#	nkf -e -Lu -d $(UTF8TEXFILE) > $(TEXFILE)

$(DVIFILE): $(TEXFILE)
	$(LATEX) $(TEXFILE)

$(PSFILE): $(TEXFILE) $(DVIFILE)
	$(DVI2PS) $(DVIFILE) > $(PSFILE)

$(PDFFILE): $(TEXFILE) $(DVIFILE)
	$(DVI2PDF) $(DVIFILE)

#
# edit file
#
edit: $(UTF8TEXFILE)
	vi $(UTF8TEXFILE)


#
# view file
#

view: view_pdf

view_dvi: $(DVIFILE) $(TEXFILE)
	$(DVIVIEW) $(DVIFILE) &

view_ps: $(PSFILE) $(DVIFILE) $(TEXFILE)
	$(PSVIEW) $(PSFILE) &

view_pdf: $(PDFFILE) $(DVIFILE) $(TEXFILE)
	$(PDFVIEW) $(PDFFILE) &

#
# aspell for spell checking
#
aspell: $(UTF8TEXFILE)
	aspell --lang=en -c -t $(UTF8TEXFILE)


#
# backup by Mercurial
#
hg_archive:
	hg archive -t tgz -r $$(hg tip --template '{rev}') ../$(NAME).%h.tgz


#
# rcsdiff
#

diff:
	rcsdiff $(TEXFILE)

#
# misc
#

src_only:
	rm -f $(TEXFILE) $(DVIFILE) $(PSFILE) $(PDFFILE)
	rm -f $(AUXFILE) $(LOGFILE)
	rm -f $(BBLFILE) $(BLGFILE)

clean:
	rm -f $(TEXFILE) $(DVIFILE) $(PSFILE)
	rm -f $(AUXFILE) $(LOGFILE)
	rm -f $(BBLFILE) $(BLGFILE)
