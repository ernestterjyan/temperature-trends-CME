.DEFAULT_GOAL := all
.PHONY: all analysis html report clean-report

all: html report

analysis: html

html:
	Rscript --vanilla -e 'rmarkdown::render("main.Rmd", output_file = "main.html", envir = new.env())'

report:
	latexmk -pdf -cd -interaction=nonstopmode -halt-on-error report/report.tex

clean-report:
	latexmk -c -cd report/report.tex
