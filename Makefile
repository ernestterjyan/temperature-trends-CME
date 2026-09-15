.PHONY: analysis report clean-report

analysis:
	Rscript --vanilla main.R > docs/current-output.txt

report:
	latexmk -pdf -cd -interaction=nonstopmode -halt-on-error docs/progress.tex

clean-report:
	latexmk -c -cd docs/progress.tex
