# Our project checklist

Last updated: **20 September 2026**. We keep this file as the live checklist and use [the progress report](docs/progress.pdf) for the dated explanation of our methods and findings.

## Completed

- [x] Load and inspect the supplied Geneva data.
- [x] Sort observations and check complete Year/Temperature rows.
- [x] Define `t = (Year - 1900) / 10`.
- [x] Estimate the linear trend by OLS.
- [x] Plot the temperature series and fitted trend.
- [x] Produce residual time, ACF, squared-residual/LOESS and normal Q–Q plots.
- [x] Calculate the observed DW statistic: **1.4147**.
- [x] Verify that the updated script runs in a clean R session and preserves the original estimates and six plots.
- [x] Document the current findings, limitations and unfinished methods.

## Our next priorities: Part I

- [x] Discuss the 35 missing years, especially 1981–2009.
- [ ] Clarify whether the intended trend uses actual calendar time or a rescaled observation index.
- [x] Document that the current ACF and DW use adjacent available observations, not uniformly one-year intervals.
- [ ] Make missing periods explicit in temperature/residual plots and qualify LOESS across gaps; retain the full supplied sample.
- [x] Specify the DW null error model and its assumptions.
- [x] Implement the **two-sided DW Monte Carlo test with B = 9,999 and alpha = 0.05**, using the residual-maker projection equivalent to refitting the same design in each replication.
- [x] Record separate lower/upper critical values, the two-sided Monte Carlo p-value convention, the seed and the conclusion.
- [x] Fit the BP auxiliary regression `residual_sq ~ t` using the same transformed time variable.
- [x] Report `BP = n * R_squared_aux`, its chi-squared(1) p-value and a qualified interpretation.
- [x] Discuss how residual dependence affects the standard BP calibration.
- [ ] Clarify Question 6: finite-sample simulation requires a specified null distribution; BP is not inherently impossible to calibrate by Monte Carlo. (BP's null doesn't assume the distribution of the errors, it just assumes constant variance over time, whereas DW's null already assumes normality, maybe...)(Santonio)
- [ ] Write our integrated assessment of the initial model and explain each diagnostic.
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

- [ ] Add explicit printing if we want the ggplots to display reliably through `source()`.
- [ ] Refresh `docs/current-output.txt`, figures and reported numbers together after substantive changes.
- [ ] Maintain consistent units, informative captions and clear distinctions between estimates, visual indications and formal tests.
- [ ] Keep the report within **15 main-text pages** and prepare the **10-minute group presentation**.
- [ ] Account for the handout's AI-use restrictions and acknowledge actual assistance and external sources.
- [ ] Make sure every group member understands the submitted code and analysis.

**Report deadline:** 2 October 2026, 18:00.

**Presentation deadline:** 6 October 2026, 18:00.

## Update log

- **20 September 2026:** Implemented and verified the DW Monte Carlo and BP tests. Matched DW critical values to the corrected tail-count rule, documented assumptions and interpretation limits, and refreshed current results. The progress report remains the dated 15 September snapshot.

- **15 September 2026:** We documented the existing Part I script and six plots. The initial model and observed DW are implemented; MC calibration, BP, structural-change inference and the simulation study remain open.
