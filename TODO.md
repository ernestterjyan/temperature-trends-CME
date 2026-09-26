# Our project checklist

Last updated: **26 September 2026**. The primary analysis is now [`main_part1_markdown.Rmd`](main_part1_markdown.Rmd). The [progress report](docs/progress.pdf) remains a 15 September historical snapshot. The Part I interpretation remains subject to the review items below.

## Completed

- [x] Load and inspect the supplied Geneva data.
- [x] Sort observations and check complete Year/Temperature rows.
- [x] Define `t = (Year - 1900) / 10`.
- [x] Estimate the linear trend by OLS.
- [x] Plot the temperature series and fitted trend.
- [x] Produce residual time, ACF, squared-residual/LOESS and normal Q–Q plots.
- [x] Calculate the earlier sequence-adjacent DW statistic: **1.4147**; retain it for comparison with the current calendar-adjacent statistic in the R Markdown report.
- [x] Verify the earlier script in a clean R session, preserving its original estimates and six plots in the historical snapshot.
- [x] Document the current findings, limitations and unfinished methods.

## Our next priorities: Part I

- [x] Discuss the 35 missing years, especially 1981–2009.
- [ ] Clarify whether the intended trend uses actual calendar time or a rescaled observation index.
- [x] Distinguish the earlier sequence-adjacent ACF/DW from the calendar-aware calculations now used in the R Markdown document.
- [x] Make missing periods explicit in temperature/residual plots and qualify LOESS across gaps; retain the full supplied sample.
- [x] Specify the DW null error model and its assumptions.
- [x] Implement the **two-sided DW Monte Carlo test with B = 9,999 and alpha = 0.05**, using the residual-maker projection equivalent to refitting the same design in each replication.
- [x] Record separate lower/upper critical values, the two-sided Monte Carlo p-value convention, the seed and the conclusion.
- [x] Fit the BP auxiliary regression `residual_sq ~ t` using the same transformed time variable.
- [x] Report `BP = n * R_squared_aux`, its chi-squared(1) p-value and a qualified interpretation.
- [x] Discuss how residual dependence affects the standard BP calibration.
- [ ] Clarify Question 6: finite-sample simulation requires a specified null distribution; BP is not inherently impossible to calibrate by Monte Carlo. (BP's null doesn't assume the distribution of the errors, it just assumes constant variance over time, whereas DW's null already assumes normality, maybe...)(Santonio)
- [ ] Review the integrated assessment drafted in the R Markdown document and reconcile its claims with the diagnostic assumptions.
- [ ] Keep ordinary OLS significance output separate from validated inference; defer trend-significance conclusions as required.

## Part II: structural change and bootstrap inference

- [ ] Explain and implement the continuous broken-trend model.
- [ ] Search candidate breaks with the required **15% trimming**, using a consistent time convention.
- [ ] Plot RSS against candidate break year and report the best-fitting calendar break date.
- [ ] Compute the observed reduction in RSS relative to the no-break model.
- [ ] Select a primary bootstrap method and at least one sensitivity method, justified by residual diagnostics.
- [ ] Write down each complete bootstrap algorithm before interpreting results.
- [ ] Run at least **999 bootstrap replications** for the reported break tests.
- [ ] Report pre-break, change-in-trend and post-break slopes in degrees Celsius per decade.
- [ ] Construct equal-tailed percentile and percentile-t slope intervals, re-estimating the break in every replication.
- [ ] Compare fit and residual diagnostics with the original linear trend.

## Part III: simulation study

- [ ] Specify coherent no-break and break scenarios from the required DGP family.
- [ ] Vary at least two of the additional scenario dimensions in the handout.
- [ ] Compare at least three distinct bootstrap procedures, covering independence, dependence and heteroskedasticity where applicable.
- [ ] Plan at least **1,000 Monte Carlo replications per configuration** and **499 bootstrap replications within each**, or document computational constraints.
- [ ] Set/report seeds, measure rejection rates for size and power, and explain what the comparison teaches us.

## Reproducibility and group deliverables

- [x] Use the R Markdown report as the primary entry point, rendered with `make report` in a clean R session.
- [ ] Re-render `outputs/main_part1_markdown.html` and reconcile reported numbers after substantive changes; `docs/current-output.txt` and `Rplots.pdf` are historical snapshots.
- [ ] Maintain consistent units, informative captions and clear distinctions between estimates, visual indications and formal tests.
- [ ] Keep the report within **15 main-text pages** and prepare the **10-minute group presentation**.
- [ ] Account for the handout's AI-use restrictions and acknowledge actual assistance and external sources.
- [ ] Make sure every group member understands the submitted code and analysis.

**Report deadline:** 2 October 2026, 18:00.

**Presentation deadline:** 6 October 2026, 18:00.

## Update log

- **26 September 2026:** Adopted the Part I R Markdown document as the primary entry point, corrected its rendering setup and data path, and preserved the previous repository under `before-rmarkdown-part1`. The current interpretation still needs the methodological review listed above.

- **20 September 2026:** Implemented and verified the DW Monte Carlo and BP tests. Matched DW critical values to the corrected tail-count rule, documented assumptions and interpretation limits, and refreshed current results. The progress report remains the dated 15 September snapshot.

- **15 September 2026:** We documented the existing Part I script and six plots. The initial model and observed DW are implemented; MC calibration, BP, structural-change inference and the simulation study remain open.
