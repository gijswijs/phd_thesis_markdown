PY=python
PANDOC=pandoc

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/source
OUTPUTDIR=$(BASEDIR)/output
TEMPLATEDIR=$(INPUTDIR)/templates
STYLEDIR=$(BASEDIR)/style
INPUTFILES=$(sort $(wildcard $(INPUTDIR)/*.md))

BIBFILE=$(INPUTDIR)/references.bib

help:
	@echo ' 																	  '
	@echo 'Makefile for the Markdown thesis                                       '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        generate a web version             '
	@echo '   make pdf                         generate a PDF file  			  '
	@echo '   make docx	                       generate a Docx file 			  '
	@echo '   make tex	                       generate a Latex file 			  '
	@echo '                                                                       '
	@echo ' 																	  '
	@echo ' 																	  '
	@echo 'get local templates with: pandoc -D latex/html/etc	  				  '
	@echo 'or generic ones from: https://github.com/jgm/pandoc-templates		  '

pdf:
	pandoc $(INPUTFILES) \
	-o "$(OUTPUTDIR)/proposal-p95677.pdf" \
	-H "$(STYLEDIR)/preamble.tex" \
	--template="$(STYLEDIR)/template.tex" \
	--bibliography="$(BIBFILE)" 2>pandoc.log \
	--csl="$(STYLEDIR)/Gaya-UKM-2017.csl" \
	--highlight-style pygments \
	--lua-filter="$(STYLEDIR)/git-revision.lua" \
	-V fontsize=12pt \
	-V papersize=a4paper \
	-V documentclass=report \
	-N \
	--pdf-engine=xelatex \

tex:
	pandoc $(INPUTFILES) \
	-o "$(OUTPUTDIR)/thesis.tex" \
	-H "$(STYLEDIR)/preamble.tex" \
	--bibliography="$(BIBFILE)" \
	-V fontsize=12pt \
	-V papersize=a4paper \
	-V documentclass=report \
	-N \
	--csl="$(STYLEDIR)/Gaya-UKM-2017.csl" \
	--latex-engine=xelatex

docx:
	pandoc $(INPUTFILES) \
	-o "$(OUTPUTDIR)/thesis.docx" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLEDIR)/ref_format.csl" \
	--toc

html:
	pandoc $(INPUTFILES) \
	-o "$(OUTPUTDIR)/thesis.html" \
	--standalone \
	--template="$(STYLEDIR)/template.html" \
	--bibliography="$(BIBFILE)" \
	--csl="$(STYLEDIR)/Gaya-UKM-2017.csl" \
	--include-in-header="$(STYLEDIR)/style.css" \
	--toc \
	--number-sections
	powershell rm "$(OUTPUTDIR)/source" -r -fo
	powershell mkdir "$(OUTPUTDIR)/source"
	powershell copy  "$(INPUTDIR)/figures" "$(OUTPUTDIR)/source/figures" -Recurse

.PHONY: help pdf docx html tex
