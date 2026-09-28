.DEFAULT_GOAL := all
.PHONY: all analysis html report presentation clean-report clean-presentation

all: html report presentation

analysis: html

html:
	Rscript --vanilla -e 'rmarkdown::render("main.Rmd", output_file = "main.html", envir = new.env())'

report:
	latexmk -pdf -cd -interaction=nonstopmode -halt-on-error report/report.tex

presentation:
	latexmk -pdf -interaction=nonstopmode -halt-on-error presentation.tex

clean-report:
	latexmk -c -cd report/report.tex

clean-presentation:
	latexmk -c presentation.tex
