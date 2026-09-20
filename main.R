# ====================================================================================
# Computational Methods in Econometrics
# Assignment - Part I (at least)
# Station 08: Geneva
# ====================================================================================

rm(list = ls())

set.seed(20260914)

# Loading the data

dat <- read.csv("Station08.csv")

head(dat)
str(dat)
summary(dat)

# Sort observations (just in case)
dat <- dat[order(dat$Year),]

# Keep the complete year/temp obs. only
dat <- dat[complete.cases(dat[,c("Year","Temperature")]),]

# number of obs.
n <- nrow(dat)

cat("Number of obs.", n, "\n")
cat("First year", min(dat$Year), "\n")
cat("Last year", max(dat$Year), "\n")

# Center calendar time at 1900 and measure it in decades.
# Then \beta_0 becomes the fitted temp. around the year 1900
# \beta_1 is measured in C per decade

dat$t <- (dat$Year - 1900) /10
# ====================================================================================
# Exploratory analysis
# ====================================================================================

plot(
  dat$Year,
  dat$Temperature,
  type = "o",
  pch = 16,
  cex = 0.5,
  xlab = "Year",
  ylab = "Annual mean temp. in C",
  main = "Annual mean temp. Geneva"
)

# The model is y_t = \beta_0 + \beta_1 t + \epsilon_t
# With my definition of t, \beta_1 is already C per decade

# ====================================================================================
# Linear trend model
# ====================================================================================

# Estimate the linear trend by OLS.

trend_model <- lm(Temperature ~ t, data = dat)
summary(trend_model)

# Coeffs
beta0_hat <- coef(trend_model)[1]
beta1_hat <- coef(trend_model)[2]

cat("Estimated intercept", beta0_hat, "C\n")
cat("Estimated trend", beta1_hat, "C per decade \n")

# Part I postpones trend-significance conclusions; the printed OLS p-values
# do not account for the residual dependence investigated below.

# Plot of the fitted trend
library(ggplot2)

dat$fitted_linear <- fitted(trend_model)
ggplot(dat, aes(x = Year, y = Temperature)) + geom_line(linewidth = 0.5) +
  geom_point(size = 1) + geom_line( aes(y = fitted_linear), linewidth = 1) +
  labs(
    title = "Geneva temp. series with linear trend",
    x = "year",
    y = "Annual mean temp. C"
  ) + theme_minimal(base_size = 12) 



# ====================================================================================
# Residual diagnostics
# ====================================================================================

dat$residual <- residuals(trend_model)
dat$residual_sq <- dat$residual^2

ggplot(dat, aes(x = Year, y = residual)) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line() +
  geom_point(size = 1) +
  labs(
    title = "Residuals from Linear Trend Model",
    x = "Year",
    y = "Residual"
  ) +
  theme_minimal(base_size = 12)

# Residual ACF - autocorrelation function
# Lags count adjacent available observations, not necessarily calendar years.
acf(
  dat$residual,
  main = "ACF of Linear-Trend Residuals",
  xlab = "Lag"
)

# A large positive lag-one autocorrelation corresponds to a low DW statistic.

# Residual variance over time 
ggplot(dat, aes(x = Year, y = residual_sq)) +
  geom_point(size = 1) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(
    title = "Squared Residuals over Time",
    x = "Year",
    y = expression(hat(epsilon)[t]^2)
  ) +
  theme_minimal(base_size = 12)

# Normal QQ plot 
qqnorm(
  dat$residual,
  main = "Normal QQ Plot of Residuals"
)

qqline(dat$residual)


# Durbin - Watson statistic

# ====================================================================================
# Durbin Watson Monte Carlo test
# ====================================================================================
# diff() also uses observation order, including the gap from 1980 to 2010.
dw_stat <- function(residuals) {
  
  numerator <- sum(diff(residuals)^2)
  denominator <- sum(residuals^2)
  
  numerator / denominator
}

d_obs <- dw_stat(dat$residual)

cat("Observed Durbin-Watson statistic:", d_obs, "\n")

# ====================================================================================
# Two-Sided Monte Carlo Durbin-Watson Test
# ====================================================================================

set.seed(20260914)
B <- 9999
n <- nrow(dat)

# Extract design matrix X and compute residual maker matrix M
# M removes the fitted intercept and trend from any simulated sample.
# Since M X = 0, M %*% eps_star is equivalent to refitting the same OLS
# design to X %*% beta + eps_star. A common error scale cancels from DW.
X <- model.matrix(trend_model)
H <- X %*% solve(t(X) %*% X) %*% t(X)
M <- diag(n) - H  # Residual maker matrix

d_sim <- numeric(B)

for (i in 1:B) {
  # Null: iid Gaussian errors with constant variance, conditional on X.
  # This is stronger than assuming only zero first-order autocorrelation.
  eps_star <- rnorm(n)
  
  # Obtain OLS residuals from the pseudo-errors
  e_star <- M %*% eps_star
  
  # Compute simulated Durbin-Watson statistic
  d_sim[i] <- dw_stat(e_star)
}

# Two-sided critical values at significance level alpha = 0.05
alpha <- 0.05
# With B + 1 = 10000, type 6 selects ranks 250 and 9750 exactly.
# These agree with the plus-one p-value rule below for the continuous null;
# reject outside the critical values, using strict inequalities.
crit_lower <- quantile(d_sim, alpha / 2, type = 6)
crit_upper <- quantile(d_sim, 1 - alpha / 2, type = 6)

# Two-sided Monte Carlo p-value calculation
p_lower_adj <- (sum(d_sim <= d_obs) + 1) / (B + 1)
p_upper_adj <- (sum(d_sim >= d_obs) + 1) / (B + 1)
p_val_dw <- 2 * min(p_lower_adj, p_upper_adj, 0.5)

cat("--- Monte Carlo Durbin-Watson Test Results ---\n")
cat("Null: iid Gaussian errors with constant variance, conditional on X.\n")
cat(sprintf("Simulations: %d | Seed: %d\n", B, 20260914))
cat(sprintf("MC Lower Critical Value (2.5%%): %.7g\n", crit_lower))
cat(sprintf("MC Upper Critical Value (97.5%%): %.7g\n", crit_upper))
cat(sprintf("Monte Carlo p-value: %.7g\n", p_val_dw))
cat(sprintf("Rejection region at 5%%: DW < %.7g or DW > %.7g\n", crit_lower, crit_upper))
cat(sprintf("Lower/upper simulation tail counts: %d / %d\n",
            sum(d_sim <= d_obs), sum(d_sim >= d_obs)))
cat(sprintf("Minimum attainable two-sided Monte Carlo p-value: %.7g\n", 2 / (B + 1)))
if (p_val_dw <= alpha) {
  cat("Conclusion: reject the stated DW null at 5%.\n")
} else {
  cat("Conclusion: do not reject the stated DW null at 5%.\n")
}
cat("DW and ACF lags refer to adjacent available observations, not necessarily years.\n")


# ====================================================================================
# Breusch-Pagan Test for Heteroskedasticity
# ====================================================================================

# Auxiliary regression: squared residuals on the transformed time trend
aux_model <- lm(residual_sq ~ t, data = dat)
summary_aux <- summary(aux_model)

# Compute Breusch-Pagan statistic: BP = n * R^2
R2_aux <- summary_aux$r.squared
BP_stat <- n * R2_aux

# Use the assignment's asymptotic chi-squared(1) reference distribution.
# This conventional calibration does not adjust for serial dependence.
p_val_bp <- pchisq(BP_stat, df = 1, lower.tail = FALSE)

cat("\n--- Breusch-Pagan Test Results ---\n")
cat(sprintf("Breusch-Pagan Statistic (BP): %.7g\n", BP_stat))
cat("Degrees of freedom: 1\n")
cat(sprintf("BP p-value: %.7g\n", p_val_bp))
if (p_val_bp <= alpha) {
  cat("Nominal conclusion at 5%: reject a zero linear variance trend.\n")
} else {
  cat("Nominal conclusion at 5%: do not reject a zero linear variance trend.\n")
}
cat("This test does not rule out nonlinear variance patterns; its p-value is not adjusted for serial dependence.\n")
