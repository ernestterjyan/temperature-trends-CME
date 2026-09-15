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
