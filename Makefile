.RECIPEPREFIX = >
.PHONY: all pandoc

# Directory variables
export BUILD_DIR     ?= tmp
export EXPORT_DIR    ?= export
export TEMPLATE_DIR  ?= template
export BIB_PATH      ?= ref/ref.bib
export META_PATH     ?= meta.yml
export TEMPLATE_PATH ?= pandoc/mdpi.latex
export DOCUMENTCLASS ?= mdpi
export PDF_ENGINE    ?= pdflatex

# Compilation options
# export PANDOC_COMMON_OPTS = --verbose -F pandoc-include -F pandoc-crossref --citeproc \
#                             --bibliography ${BIB_PATH} --metadata-file ${META_PATH} \
#                             --columns=100
export PANDOC_COMMON_OPTS = --verbose -F pandoc-include -F pandoc-crossref --citeproc \
                            --metadata-file ${META_PATH} --columns=100
export PANDOC_LATEX_OPTS  = ${PANDOC_COMMON_OPTS} --pdf-engine ${PDF_ENGINE} \
                            --template ${TEMPLATE_PATH} --number-sections    \
							-M link-citations=true -M documentclass=${DOCUMENTCLASS}

pandoc:
> echo -e "     -----    Running 'pandoc'    ------     "
> pandoc ${PANDOC_LATEX_OPTS} -s -t latex -o main.tex main.md
# > python3 src/prepare.py

latexmk:
> echo -e "     -----    Building PDF using 'latexmk'    ------     "
> latexmk -pdf -pdflatex=${PDF_ENGINE} main.tex

scale:
> gs -sDEVICE=pdfwrite -dPDFSETTINGS=/printer -dNOPAUSE -dBATCH -sOutputFile=../${EXPORT_DIR}/article.pdf main.pdf
> gs -sDEVICE=pdfwrite -dPDFSETTINGS=/screen -dNOPAUSE -dBATCH -sOutputFile=../${EXPORT_DIR}/draft.pdf ../${EXPORT_DIR}/article.pdf

all: pandoc latexmk scale