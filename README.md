# Temperature trends in Geneva

Course project for **Computational Methods in Econometrics** at Vrije Universiteit Amsterdam, using Station 08 annual mean temperature data for Geneva.

## Start here

**[`main_part1_markdown.Rmd`](main_part1_markdown.Rmd) is the primary analysis file.** It combines the Part I code, explanations, plots, diagnostic tests, and interpretation in one reproducible document.

The document covers the linear trend, missing-year structure, residual diagnostics, the Durbin–Watson Monte Carlo test, and the Breusch–Pagan test. Parts II and III remain future work. The interpretation is a working draft; outstanding methodological review is tracked in [`TODO.md`](TODO.md).

## Reproduce the report

Requirements: R, the `rmarkdown`, `knitr`, `ggplot2`, and `lmtest` packages, and Pandoc (also bundled with RStudio). The report has been rendered with R 4.6.1, rmarkdown 2.32, knitr 1.52, ggplot2 4.0.3, and lmtest 0.9-40.

Install the R packages once if needed:

```r
install.packages(c("rmarkdown", "knitr", "ggplot2", "lmtest"))
```

From the repository root:

```sh
make report
```

`make analysis` runs the same report. Without Make, use:

```sh
Rscript --vanilla -e 'rmarkdown::render("main_part1_markdown.Rmd", output_dir = "outputs", envir = new.env())'
```

Open `outputs/main_part1_markdown.html` in a browser. It contains the code, results, and embedded figures. RStudio's **Knit** button also works; its HTML output is placed alongside the source by default.

The source reads `Station08.csv` relative to the document's location. Generated reports and temporary figures are ignored by Git; they can be rebuilt from the tracked source and data. The report uses 9,999 Durbin–Watson simulations with seed 20260914.

## Data and current scope

The supplied record contains **226 observations from 1753 to 2013**, with **35 missing calendar years**, including 1981–2009. Time is measured in decades relative to 1900. The initial OLS trend is approximately **0.03371 °C per decade**.

The Part I document retains all supplied observations, separates contiguous segments in temperature and residual plots, compares sequence-based and calendar-based ACFs, and uses calendar-adjacent pairs for its primary DW statistic. This differs from the older script's sequence-adjacent calculation. Formal slope-significance conclusions are deferred.

## Repository guide

| File | Purpose |
| --- | --- |
| [`main_part1_markdown.Rmd`](main_part1_markdown.Rmd) | Primary Part I analysis and report source |
| [`Station08.csv`](Station08.csv) | Supplied annual temperature data |
| [`Station08_metadata.pdf`](Station08_metadata.pdf) | Station details, variable definition, and source |
| [`CMEAssignment2026Handout.pdf`](CMEAssignment2026Handout.pdf) | Assignment requirements |
| [`TODO.md`](TODO.md) | Group checklist and outstanding review |
| [`Makefile`](Makefile) | Report rendering and historical report commands |
| [`Rplots.pdf`](Rplots.pdf) | Historical plots from the earlier script |
| [`docs/current-output.txt`](docs/current-output.txt) | Historical console output from the earlier script; not the current R Markdown results |
| [`docs/progress.pdf`](docs/progress.pdf) | Historical progress report dated 15 September |
| [`docs/progress.tex`](docs/progress.tex) | Source of that historical report |

## Previous version

The complete repository immediately before the R Markdown transition is preserved by the [`before-rmarkdown-part1` tag](https://github.com/ernestterjyan/temperature-trends-CME/tree/before-rmarkdown-part1), including the old `main.R` and its run instructions. GitHub also provides ZIP and tar.gz downloads from that tagged version.

The old script has been removed from the active file list so there is one clear entry point. Historical reports and plots remain available above. `make historical-report` rebuilds the dated LaTeX report and requires LaTeX with `latexmk`; it does not run the current analysis.

## Sources

- Supplied Station 08 metadata and assignment handout are included above. Dataset DOI: [10.7289/V5XW4GTH](https://doi.org/10.7289/V5XW4GTH).
- The analysis uses R, ggplot2, and lmtest; the report uses knitr and rmarkdown.
