# Our project checklist

Last updated: **29 September 2026**. [`main.Rmd`](main.Rmd) contains the complete analysis for **Parts I–III**, and [`main.html`](main.html) is its knitted reading version. The refined [LaTeX report](report/report.tex), [PDF](report/report.pdf), tables and required figures are now together in `report/`. Historical progress files have been removed from the current checkout and remain in Git history.

## Completed: data and Part I

- [x] Load, sort and validate all **226** supplied observations, with no missing cells or duplicated years.
- [x] Retain the complete sample, including 2010–2013; document all **35 missing years across five gaps**, especially 1981–2009, without interpolation.
- [x] Use actual calendar time, **`t = (Year - 1850) / 10`**; explain centring and verify that slopes, fits and test statistics are unchanged by the reference year.
- [x] Estimate the linear OLS trend and plot observed temperatures and fitted values without joining observed lines across gaps.
- [x] Produce residual time, observation-lag/calendar-lag ACF, squared-residual/LOESS and normal Q–Q plots, with their interpretation limits.
- [x] Use the assignment's **observation-adjacent DW statistic (1.4147)** as primary and retain the **calendar-adjacent statistic (1.3865)** as a separately calibrated sensitivity check.
- [x] Implement both two-sided DW Monte Carlo calibrations with **B = 9,999**, **alpha = 0.05**, master seed **20260926**, and the observed regression design under an iid Gaussian null.
- [x] Use **type-6** DW critical values with strict outside-cutoff rejection and the matching two-sided plus-one rank p-value; explain the assumptions behind finite-sample exactness.
- [x] Calculate **BP = nR²** from `residual_sq ~ t`, report the nominal chi-squared(1) p-value, and explain why non-rejection against a linear variance trend does not establish homoskedasticity.
- [x] Clarify Question 6: squared residuals do not prevent BP simulation; a finite-sample Monte Carlo calibration requires a specified null error distribution. Explain the studentised BP convention and the effect of serial dependence on its usual calibration.
- [x] Reconcile the integrated assessment with these assumptions; keep ordinary OLS significance output separate from justified inference.

## Completed: Part II, structural change and bootstrap inference

- [x] Explain and implement the continuous broken-trend model, distinguishing a slope change from a level jump.
- [x] Search with **15% observation-count trimming**, candidates **34–192 (1786–1945)**, and plot the RSS profile.
- [x] Report the best-fitting break (**1851**), raw RSS reduction (**12.2106**) and pre-break/change/post-break slopes in °C per decade.
- [x] Implement IID residual, independent wild and calendar-aware dependent wild bootstrap procedures, with complete algorithms and diagnostics-based justification.
- [x] Run **9,999** draws for every reported break test; generate under the linear null using restricted residuals and repeat the complete break search in each draw.
- [x] Report primary DWB bandwidth **6** and sensitivities **3** and **12**, including the change from rejection at bandwidth 6 (**p = 0.0331**) to non-rejection at bandwidth 12 (**p = 0.0541**).
- [x] Explain restricted-residual effects, finite p-value resolution and why bandwidth effects need not be monotonic.
- [x] Construct percentile and percentile-t slope intervals from **4,999** alternative-model DWB draws, reselecting the break and recomputing calendar-time HAC standard errors.
- [x] Qualify the slope intervals as conditional on the fitted broken-trend specification; describe reselected dates without claiming a calibrated break-date confidence set.
- [x] Compare fit and residual diagnostics with the linear model, including the limits of adjusted R², BIC and post-selection DW interpretation.
- [x] Run descriptive sensitivity checks omitting 1851 and ending the sample in 1980; retain all observations for primary results.

## Completed: Part III, simulation study

- [x] Specify eight no-break/break scenarios using the required DGP family, varying serial dependence and innovation-scale heteroskedasticity.
- [x] Compare all three bootstrap procedures on the same generated datasets.
- [x] Complete **1,000 Monte Carlo datasets per configuration** with **499 bootstrap draws per method**: 8,000 datasets and 24,000 tests in total.
- [x] Record settings, scenario checkpoints and replication seeds independent of worker scheduling.
- [x] Report size and power with Monte Carlo standard errors and 95% Wilson intervals.
- [x] Explain independent-method over-rejection under serial dependence and DWB conservatism, without interpreting inflated size as superior power.
- [x] State the experiment's limits: consecutive simulated years, one sample size, a central break and Gaussian innovations; no empirical-gap design or confidence-interval coverage experiment.

## Completed: reproducibility and report refinement

- [x] Render the full Rmd and refresh `main.html` and its generated artifacts under `work/main_rmd_run/`.
- [x] Verify sample/gap counts, centring invariance, both DW distributions by independent QR projection, and BP by an independent identity.
- [x] Validate the optimised break search against explicit OLS, 21 bootstrap comparisons, both slope-interval constructions and empirical p-values.
- [x] Validate all 8,000 stored simulation replications, 24 rejection frequencies, Monte Carlo standard errors and Wilson intervals; replay one complete seeded replication per scenario. This check is not a new full simulation run or a coverage study.
- [x] Use a consistent colour palette throughout Parts I–III and distinguish descriptive evidence, fitted estimates and formal inference.
- [x] Refine the LaTeX report using the Rmd as the source for explanations, numbers, plots and limitations.
- [x] Preserve all **four original report references** and add **ten source entries**; verify citations and bibliography links in the source.
- [x] Compile and visually check the revised report: **11 main-text pages**, within the **15-page limit**, and **20 pages overall** including title page, references and appendices.
- [x] Rename the analysis to `main.Rmd`, rebuild the self-contained `main.html`, and include both as versioned deliverables.
- [x] Bring the report, numerical inputs and required plots into the repository; verify that it compiles from its own folder.
- [x] Remove obsolete progress files and `Rplots.pdf` from the current checkout, retaining Git history and local backups.
- [x] Update the README, this checklist, build commands and ignore rules for the organised repository.
- [x] Add `CODE_GUIDE.md` covering all 49 R chunks, important objects, formulas, seeds, output paths and validation limits.
- [x] Create `presentation.tex` from the current Rmd/report, with ten main slides, a ten-minute speaking plan, speaker notes, technical backups and references.
- [x] Compile and visually check all 16 pages of `presentation.pdf`; reuse the report's checked numerical inputs and plots.
- [x] Add presentation build/cleanup commands and ignore Beamer build intermediates.

## Remaining group and submission work

- [ ] Review the final report against the assignment handout as a group, confirm author/group details and complete the submission check. A successful compile and numerical validation do not replace this review.
- [ ] Review the current [presentation](presentation.pdf), add agreed group names in `presentation.tex`, assign speaker roles and rehearse the **10-minute group presentation**.
- [ ] Use [CODE_GUIDE.md](CODE_GUIDE.md) to make sure every group member understands the code, bootstrap assumptions, missing-year treatment, bandwidth sensitivity and interpretation limits.
- [ ] Submit the agreed final report and presentation by their deadlines.

After any further analysis change, re-render the Rmd, inspect its validation records, and refresh the report and presentation inputs before compiling and checking those deliverables. Rmd rendering does not automatically update the report's copied inputs or prose.

**Report deadline:** 2 October 2026, 18:00.

**Presentation deadline:** 6 October 2026, 18:00.

## Update log

- **29 September 2026, code guide and presentation:** Added a companion guide for all 49 chunks and a Beamer deck with speaker notes, technical backups and references. Compiled and visually checked the slides, and added documentation and build commands. Analysis methods, results and the existing report are unchanged.

- **29 September 2026, repository cleanup:** Renamed the main Rmd, included its rebuilt HTML and the report with every required dependency, updated build commands, and removed historical snapshots from the active file list. Analysis methods and results are unchanged.

- **29 September 2026:** Updated the README and checklist to reflect completed Parts I–III, the refined Rmd and validated outputs, and the revised separate LaTeX report. Replaced stale time-index, seed, primary-DW and unfinished-analysis descriptions; retained group review and submission tasks as open.

- **28 September 2026:** Refined the Rmd's diagnostics, inference qualifications, computational checks and plot colours. Aligned the separate report with that Rmd, retaining its original references and adding the missing sources; compiled and visually checked the report.

- **26 September 2026:** Adopted the Part I R Markdown document as the primary entry point, corrected its rendering setup and data path, and preserved the previous repository under `before-rmarkdown-part1`. The current interpretation still needs the methodological review listed above.

- **20 September 2026:** Implemented and verified the DW Monte Carlo and BP tests. Matched DW critical values to the corrected tail-count rule, documented assumptions and interpretation limits, and refreshed current results. The progress report remains the dated 15 September snapshot.

- **15 September 2026:** We documented the existing Part I script and six plots. The initial model and observed DW are implemented; MC calibration, BP, structural-change inference and the simulation study remain open.
