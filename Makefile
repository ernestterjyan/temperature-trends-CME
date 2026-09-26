.PHONY: analysis report historical-report clean-report

analysis: report

report:
	Rscript --vanilla -e 'rmarkdown::render("main_part1_markdown.Rmd", output_dir = "outputs", envir = new.env())'

historical-report:
	latexmk -pdf -cd -interaction=nonstopmode -halt-on-error docs/progress.tex

clean-report:
	latexmk -c -cd docs/progress.tex
