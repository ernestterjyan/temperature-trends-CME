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

# Center the data at 1900 and divide by 10? 
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

# Fitting the linear model with lm if permitted ? 

trend_model <- lm(Temperature ~ t, data = dat)
summary(trend_model)

# Coeffs
beta0_hat <- coef(trend_model)[1]
beta1_hat <- coef(trend_model)[2]

cat("Estimated intercept", beta0_hat, "C\n")
cat("Estimated trend", beta1_hat, "C per decade \n")

# Maybe add discussions on t-statistics or ordinary OLS p-value later?

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
acf(
  dat$residual,
  main = "ACF of Linear-Trend Residuals",
  xlab = "Lag"
)

# instpect lag 1, if there is a large positive lag 1
# autocorrelation, this will correspond to low Durbin - Watson stat.

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
X <- model.matrix(trend_model)
H <- X %*% solve(t(X) %*% X) %*% t(X)
M <- diag(n) - H  # Residual maker matrix

d_sim <- numeric(B)

for (i in 1:B) {
  # Generate standard normal pseudo-errors under the null of no autocorrelation
  eps_star <- rnorm(n)
  
  # Obtain OLS residuals from the pseudo-errors
  e_star <- M %*% eps_star
  
  # Compute simulated Durbin-Watson statistic
  d_sim[i] <- sum(diff(e_star)^2) / sum(e_star^2)
}

# Two-sided critical values at significance level alpha = 0.05
alpha <- 0.05
crit_lower <- quantile(d_sim, alpha / 2)
crit_upper <- quantile(d_sim, 1 - alpha / 2)

# Two-sided Monte Carlo p-value calculation
p_lower_adj <- (sum(d_sim <= d_obs) + 1) / (B + 1)
p_upper_adj <- (sum(d_sim >= d_obs) + 1) / (B + 1)
p_val_dw <- 2 * min(p_lower_adj, p_upper_adj, 0.5)

cat("--- Monte Carlo Durbin-Watson Test Results ---\n")
cat("MC Lower Critical Value (2.5%):", crit_lower, "\n")
cat("MC Upper Critical Value (97.5%):", crit_upper, "\n")
cat("Monte Carlo p-value:", p_val_dw, "\n")


# ====================================================================================
# Breusch-Pagan Test for Heteroskedasticity
# ====================================================================================

# Auxiliary regression: squared residuals on the transformed time trend
aux_model <- lm(residual_sq ~ t, data = dat)
summary_aux <- summary(aux_model)

# Compute Breusch-Pagan statistic: BP = n * R^2
R2_aux <- summary_aux$r.squared
BP_stat <- n * R2_aux

# Under H0, BP follows an asymptotic chi-squared distribution with 1 degree of freedom
p_val_bp <- 1 - pchisq(BP_stat, df = 1)

cat("\n--- Breusch-Pagan Test Results ---\n")
cat("Breusch-Pagan Statistic (BP):", BP_stat, "\n")
cat("Degrees of freedom:", 1, "\n")
cat("BP p-value:", p_val_bp, "\n")