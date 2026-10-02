# Temperature trends in Geneva

Course project for **Computational Methods in Econometrics** at Vrije Universiteit Amsterdam, using Station 08 annual mean temperature data for Geneva.

- Bobo Wen
- Ernest Terjyan
- Trân Thái Bao
- Santonio Pham

## Start here

**[`main.Rmd`](main.Rmd) is the primary analysis file.** It covers **Parts I–III**: the linear trend and diagnostics, structural change and bootstrap inference, and a Monte Carlo simulation study. It combines explanations, executable code, results, plots and independent computational checks in one document.

Open the knitted [main.html](main.html) in a browser to read the code and results, or use the submission [report PDF](report/report.pdf). The full analysis has been rendered and its validation checks pass. The current findings and limits are summarised below; remaining group and submission work is tracked in [`TODO.md`](TODO.md).

Use [`CODE_GUIDE.md`](CODE_GUIDE.md) alongside the Rmd to understand all **49 code chunks**: their inputs, calculations, outputs and interpretation. It also explains the main objects, matrix shortcuts, seed conventions, saved files and limits of the checks. The [Beamer source](presentation.tex) and [presentation PDF](presentation.pdf) provide a ten-minute talk based on the same analysis.

## Reproduce the analysis document

Requirements: R, `rmarkdown`, `knitr`, `ggplot2`, and Pandoc (also bundled with RStudio). `lmtest` is optional and supplies diagnostic cross-checks; the required DW and BP calculations are implemented directly. The latest validated render used R 4.6.1, rmarkdown 2.32, knitr 1.52, ggplot2 4.0.3 and lmtest 0.9-40.

Install packages once if needed:

```r
install.packages(c("rmarkdown", "knitr", "ggplot2", "lmtest"))
```

From the repository root:

```sh
make html
```

`make analysis` is an alias for `make html`. Without Make, use:

```sh
Rscript --vanilla -e 'rmarkdown::render("main.Rmd", output_file = "main.html", envir = new.env())'
```

The self-contained `main.html` is saved beside `main.Rmd` and is included in Git. Download it and open it in a browser to view the rendered analysis. RStudio's **Knit** button also works. These commands render the analysis document; `make report` compiles the LaTeX submission report, `make presentation` compiles the slides, and `make all` runs all three steps.

The source reads `Station08.csv` relative to its own location. Empirical inference is recalculated on every render. By default, complete simulation checkpoints are reused only when their recorded settings match; missing or incompatible scenarios are recomputed. A fresh clone has no checkpoints and therefore runs the full experiment, which can take substantial time. To force a fresh simulation, run in R from the repository root:

```r
rmarkdown::render(
  "main.Rmd", output_file = "main.html",
  params = list(recompute_simulation = TRUE, workers = 4),
  envir = new.env()
)
```

The simulation uses up to the requested number of available workers on macOS/Linux and runs sequentially on Windows. Its seeds do not depend on worker scheduling.

Generated figures, tables, stored draws, checkpoints and validation records live under `work/main_rmd_run/`. In particular:

- `figures/` and `knitr_figures/`: plots with the shared colour palette.
- `tables/`: empirical estimates, DW comparisons, bootstrap tests, slope intervals, sensitivity results and simulation summaries.
- `outputs/part1_validation.txt` and `outputs/validation.txt`: independent computational checks.
- `outputs/sessionInfo.txt`: R and package versions.
- `work/simulation/`: scenario checkpoints and simulation draws.

These paths are relative to `work/main_rmd_run/`. The computational working files are ignored by Git; `main.html`, `report/report.pdf` and the report dependencies are included for reading and compiling without rerunning the simulations. Validation checks the reported results and replays one complete seeded replication from each of the eight simulation scenarios; it does not establish theoretical validity or confidence-interval coverage.

## Sample, methods and current findings

The analysis retains **all 226 supplied observations from 1753 to 2013**, including 2010–2013. There are **35 missing calendar years across five gaps**; the largest is 1981–2009. No temperatures are interpolated. Time is actual calendar time, scaled as **`t = (Year - 1850) / 10`**, so slopes are in °C per decade. Observed-data lines stop across gaps. Dropping the final four observations is a separate descriptive sensitivity check, not the main sample.

| Component | Current implementation and result |
| --- | --- |
| Linear trend | OLS slope approximately **0.03371 °C per decade**; ordinary OLS significance output is not treated as dependence-robust inference. |
| Residual diagnostics | Time plot, observation-lag and calendar-lag ACFs, squared residuals with a descriptive LOESS smooth, and a normal Q–Q plot. Gaps and diagnostic limitations are explained. |
| DW Monte Carlo | The assignment's **observation-adjacent statistic is primary**: **1.4147**. The calendar-adjacent version, **1.3865**, is a separately calibrated sensitivity check. Both two-sided p-values are **0.0002** under the specified iid Gaussian null. |
| BP diagnostic | **BP = 0.4173**, nominal chi-squared(1) **p = 0.5183**. No rejection against a linear variance trend does not establish homoskedasticity; serial dependence qualifies the usual calibration. BP can also be simulated under a fully specified null model. |
| Structural change | Continuous broken trend with **15% observation-count trimming**, searching years **1786–1945**. The best-fitting break is **1851**; slopes are **−0.0525** before and **0.0887 °C per decade** after it. |
| Break inference | IID residual, independent wild and calendar-aware dependent wild bootstrap (DWB). Primary DWB bandwidth **6 years** gives **p = 0.0331**; bandwidths **3** and **12** give **0.0206** and **0.0541**. Break evidence is bandwidth-sensitive. |
| Slope intervals | Percentile and percentile-t intervals from DWB under the fitted alternative, reselecting the break in every draw. Both pre-break intervals include zero; both post-break intervals exclude zero, conditional on the broken-trend specification. |
| Simulation | Eight scenarios cross no break/a slope change, independent/AR(0.4) errors, and constant/increasing innovation scale. Independent bootstrap methods over-reject under serial correlation; DWB is conservative in these designs. Simulated years are consecutive and do not reproduce the empirical gaps. |

The break statistic is the **maximum raw RSS reduction**, not a variance-normalised F statistic. Test bootstraps use restricted residuals under the linear null; interval bootstraps use residuals under the fitted alternative. Every bootstrap sample repeats the break search. The fitted date is not evidence of a particular historical cause, and the later slope is a regime average rather than a recent-decade warming rate.

## Replications, seeds and critical values

- **Master seed:** `20260926`. DW uses the master seed directly. IID, independent wild and primary DWB break tests use offsets `+101`, `+102`, `+103`; DWB bandwidth checks use `+203`, `+212`; slope intervals use `+301`.
- **DW:** 9,999 simulations for each definition using common simulated residual vectors. Separate 2.5% and 97.5% critical values use R quantile **type 6**, with strict rejection outside the cutoffs and a matching two-sided plus-one rank p-value. Primary cutoffs are **1.7549** and **2.2695**.
- **Break tests:** 9,999 bootstrap draws per method/bandwidth, type-1 empirical 95% critical values, and p-values `(1 + exceedances) / (B + 1)`. Inference uses `p <= 0.05`.
- **Slope intervals:** 4,999 DWB draws with type-7 quantiles and calendar-time HAC studentisation. Interval coverage is not evaluated in the simulation study.
- **Simulation:** 8 configurations × 1,000 datasets × 3 methods × 499 bootstrap draws = **11,976,000 bootstrap samples**. Dataset `m` in configuration `c` uses seed `20260926 + 100000*c + m`. Rejection frequencies include Monte Carlo standard errors and 95% Wilson intervals.

## Submission report

[`report/report.tex`](report/report.tex) is the refined LaTeX source, and [`report/report.pdf`](report/report.pdf) is its compiled version. It follows `main.Rmd`, preserves the report's four original bibliography entries and adds ten source entries. The checked version has **11 main-text pages and 20 pages overall**, including its title page, references and appendices.

The `report/` folder is self-contained: `tables/` contains its numerical macros and table inputs, and `figures/` contains every figure used in the report. Keep both subfolders with the TeX file. Compile from the repository root with:

```sh
make report
```

This requires a LaTeX installation with `pdflatex` and `latexmk`; it does not run R. Alternatively, run `latexmk -pdf report.tex` inside `report/`. `make clean-report` removes LaTeX build intermediates while retaining the PDF. Rendering the Rmd does not automatically refresh the report's checked copies of tables, numbers or figures: after statistical changes, reconcile those inputs and the prose before recompiling.

## Presentation

[`presentation.tex`](presentation.tex) is a 16:9 Beamer deck with **ten main slides**, four technical backup slides and two reference pages (**16 pages total**). The main slides have speaker notes and a suggested speaking schedule totalling ten minutes. They cover the sample and gaps, linear diagnostics, the break search, bootstrap procedures, intervals, simulation results and qualified conclusions.

Compile from the repository root with:

```sh
make presentation
```

This uses `pdflatex` and `latexmk` without running R. The resulting [`presentation.pdf`](presentation.pdf) uses the existing plots and numerical inputs under `report/figures/` and `report/tables/`; keep those folders with the source. Rendering the Rmd does not automatically refresh these checked inputs or the slide prose. After analysis changes, reconcile the report inputs, slides and code guide before recompiling.

Before submission, replace the `\author{...}` field with the agreed group names, assign speakers and rehearse the timing. Notes are hidden in the normal PDF; change `\setbeameroption{hide notes}` to `\setbeameroption{show notes}` and recompile for a version containing the notes. Restore `hide notes` for the audience copy. `make clean-presentation` removes build intermediates while retaining the PDF.

## Repository guide

| File or folder | Purpose |
| --- | --- |
| [`main.Rmd`](main.Rmd) | Primary explained analysis for Parts I–III |
| [`main.html`](main.html) | Knitted analysis with code, results and embedded plots |
| [`CODE_GUIDE.md`](CODE_GUIDE.md) | Chunk-by-chunk code explanations and execution reference |
| [`presentation.tex`](presentation.tex) | Beamer slides, speaker notes and technical backups |
| [`presentation.pdf`](presentation.pdf) | Compiled presentation |
| [`report/report.tex`](report/report.tex) | LaTeX submission report source |
| [`report/report.pdf`](report/report.pdf) | Compiled submission report |
| [`report/tables/`](report/tables/) | All numerical inputs required by the TeX source |
| [`report/figures/`](report/figures/) | All plots required by the TeX source |
| [`Station08.csv`](Station08.csv) | Supplied annual temperature data |
| [`Station08_metadata.pdf`](Station08_metadata.pdf) | Station details, variable definition and source |
| [`CMEAssignment2026Handout.pdf`](CMEAssignment2026Handout.pdf) | Assignment requirements |
| [`TODO.md`](TODO.md) | Completed work and remaining group/submission tasks |
| [`Makefile`](Makefile) | Commands for HTML rendering, report and presentation compilation |

## Previous version

The complete repository immediately before the R Markdown transition is preserved by the [`before-rmarkdown-part1` tag](https://github.com/ernestterjyan/temperature-trends-CME/tree/before-rmarkdown-part1), including the old `main.R` and its run instructions. GitHub also provides ZIP and tar.gz downloads from that tagged version.

The obsolete `docs/` progress snapshots and `Rplots.pdf` have been removed from the current checkout. They remain recoverable from Git history; the cleanup does not rewrite history. The active source has been renamed from `main_part1_markdown.Rmd` to `main.Rmd`. Local `work/` checkpoints are kept for faster reproduction but are not committed.

## Sources

- Supplied Station 08 metadata and assignment handout are included above. Dataset DOI: [10.7289/V5XW4GTH](https://doi.org/10.7289/V5XW4GTH).
- Methodological sources are cited in the Rmd and listed in the report's bibliography.
- Statistical estimation and resampling use base R and `parallel`; plots and rendering use `ggplot2`, `knitr` and `rmarkdown`, with optional `lmtest` diagnostic checks.
