# Temperature trends in Geneva

We are investigating long-run temperature patterns in Geneva for **Computational Methods in Econometrics** at Vrije Universiteit Amsterdam. Our starting question is whether a simple linear trend adequately describes the station record, and what residual dependence, changing variance and possible structural change imply for inference.

We use **Station 08**, a supplied series of 226 annual mean temperatures in degrees Celsius, spanning **1753–2013**. The metadata identifies the source as NOAA NCEI's GHCN Monthly Temperature Version 4, QCF adjusted series. An annual mean requires at least ten valid monthly observations.

## Where we are now

**Last documented: 20 September 2026.** We have implemented the initial OLS model, all four residual diagnostics, the two-sided Durbin–Watson Monte Carlo test, and the specified Breusch–Pagan auxiliary regression. The numerical tests are complete; the remaining Part I work includes the inferential comparison and integrated model assessment.

| Completed step | What we have saved |
| --- | --- |
| Data inspection and preparation | Reading, sorting and complete-case checks in `main.R` |
| Linear trend estimation | OLS coefficients and model summary |
| Temperature plots | Raw series and fitted trend |
| Residual diagnostics | Residual time plot, ACF, squared residuals with LOESS, normal Q–Q plot |
| Durbin–Watson Monte Carlo test | Observed statistic, 9,999 simulations, separate critical values and two-sided p-value |
| Breusch–Pagan test | Auxiliary regression, nR² statistic and nominal chi-squared(1) p-value |

The **[progress report](docs/progress.pdf)** and its **[LaTeX source](docs/progress.tex)** are retained as a **15 September historical snapshot**, before the formal tests were implemented. This README and the [saved console output](docs/current-output.txt) describe the current results. We track next steps in **[TODO.md](TODO.md)**.

## Our findings so far

We estimate the model with calendar time measured in decades relative to 1900:

$$
x_i=\frac{\mathrm{Year}_i-1900}{10},\qquad
\widehat y_i=9.61663+0.0337093x_i.
$$

| Quantity | Current value |
| --- | ---: |
| Observations | 226 |
| Fitted temperature in 1900 | 9.6166 °C |
| Estimated trend | +0.03371 °C per decade |
| Equivalent century trend | +0.3371 °C per century |
| Model R² | 0.1054 |
| Residual standard error | 0.6596 °C |
| Observed Durbin–Watson statistic | 1.4147 |
| DW lower / upper critical values (5% two-sided) | 1.751960 / 2.271755 |
| DW Monte Carlo p-value | 0.0002 |
| BP statistic | 0.417306 |
| BP nominal p-value | 0.518285 |

These values are reproducible from our current script. The [saved console output](docs/current-output.txt) comes from running it in a clean R session. We read the positive slope as an average upward fitted trend in the supplied record and continue to postpone conclusions about trend significance.

### Formal diagnostic tests

For DW, we hold the observed regression design fixed and simulate **iid Gaussian errors with constant variance**, using seed **20260914** and **9,999** replications. This null is stronger than simply assuming zero first-order correlation. Projecting each draw with the residual-maker matrix is equivalent to refitting the same intercept and trend in every replication. The fitted coefficients and a common error scale cancel from DW.

At 5%, we reject when **DW < 1.751960 or DW > 2.271755**. We use `quantile(..., type = 6)`, which selects simulation ranks 250 and 9750 and agrees with the plus-one tail-count rule for this continuous null. The two-sided p-value is twice the smaller corrected tail probability, capped at one. Our observed DW falls below the lower critical value, in the direction associated with positive residual dependence. No simulated statistic was as small as the observed DW, so **0.0002 is the simulation's minimum attainable two-sided p-value**, not an exact underlying tail probability.

For BP, we regress squared OLS residuals on an intercept and the same transformed time variable, then calculate **nR²** from that auxiliary regression. The nominal chi-squared(1) p-value of **0.518285** does not reject a zero linear variance trend at 5%. This does not establish constant variance or exclude nonlinear variance patterns. The conventional calibration does not adjust for serial dependence, so we qualify this result in light of the DW diagnostic.

### The missing-year issue

There are **35 missing calendar years**, including the whole period **1981–2009**. No supplied rows have missing values, so our complete-case filter drops nothing. Our time transformation respects elapsed calendar time, while the ACF and DW calculation use consecutive *available observations*. In particular, they treat 1980 and 2010 as adjacent observations.

The line joining those dates in our plots is a graphical connection across the gap. We cannot use it as evidence of recorded annual temperature movements in the missing period. We still need to clarify the indexing convention and make these gaps explicit in the figures.

## Repository guide

| File | Purpose |
| --- | --- |
| [`main.R`](main.R) | Our current Part I script, including DW Monte Carlo and BP tests |
| [`Station08.csv`](Station08.csv) | Supplied annual temperature data |
| [`Station08_metadata.pdf`](Station08_metadata.pdf) | Station details, variable definition and source |
| [`CMEAssignment2026Handout.pdf`](CMEAssignment2026Handout.pdf) | Assignment requirements |
| [`Rplots.pdf`](Rplots.pdf) | Six plots generated by the current script |
| [`docs/current-output.txt`](docs/current-output.txt) | Captured output from a clean-session run |
| [`docs/progress.pdf`](docs/progress.pdf) | Historical progress report dated 15 September; predates the formal tests |
| [`docs/progress.tex`](docs/progress.tex) | Source of the historical progress report |
| [`TODO.md`](TODO.md) | Ongoing checklist |
| [`Makefile`](Makefile) | Commands to run the analysis and rebuild the report |

The supplied data and assignment PDFs are unchanged. The added formal tests leave the original OLS estimates and six diagnostic plots unchanged. The historical progress report embeds pages of `Rplots.pdf` directly.

## Reproduce our current work

We verified the script with **R 4.6.1** and **ggplot2 4.0.3**. R and ggplot2 are required for the analysis; LaTeX is only needed to rebuild the report.

```sh
git clone git@github.com:ernestterjyan/temperature-trends-CME.git
cd temperature-trends-CME
```

If ggplot2 is not installed:

```sh
Rscript -e 'install.packages("ggplot2", repos="https://cloud.r-project.org")'
```

Run from the repository root so that the relative CSV path resolves correctly:

```sh
Rscript --vanilla main.R > docs/current-output.txt
```

This refreshes `Rplots.pdf` and captures the model output. The script begins with `rm(list = ls())`; we use a separate R process so it does not clear an existing interactive workspace. Default `source("main.R")` may omit the bare ggplot expressions from display, so the command above is our verified execution route.

Alternatively, we can run `make analysis`. To rebuild the progress report with a LaTeX installation providing `latexmk` and `pdflatex`:

```sh
make report
```

Or directly:

```sh
latexmk -pdf -cd -interaction=nonstopmode -halt-on-error docs/progress.tex
```

The report's written numbers and interpretations are a dated snapshot. Rebuilding it updates the embedded plot pages, but we must also update the text and tables when our analysis changes.

## What comes next

1. Resolve the missing-year and time-indexing issue.
2. Finish the Part I write-up: compare the inferential principles in Question 6 and combine the graphical and formal diagnostics into an overall model assessment.
3. Investigate a continuous broken trend with an unknown break date and bootstrap inference.
4. Compare bootstrap procedures through the assignment's simulation study.

We have not yet estimated a break date, implemented bootstrap tests or intervals, or run the Part III experiment. We also postpone conclusions about trend significance, as required in Part I.

## Sources and acknowledgements

- Supplied Station 08 metadata and assignment handout are included above. Dataset DOI: [10.7289/V5XW4GTH](https://doi.org/10.7289/V5XW4GTH).
- We use base R and ggplot2. The report records an additional methodological reference for the distinction between Monte Carlo and asymptotic testing.
- We have used ChatGPT/Codex for initial code suggestions, debugging and drafting repository documentation. Our course handout limits AI use to debugging and writing clarity, which we need to account for before any assessed submission. This repository records work in progress.
