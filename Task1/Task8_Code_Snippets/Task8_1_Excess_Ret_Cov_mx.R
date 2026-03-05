# short data prep
  # Stock excess returns
rownames(stock_excess_return_pre_2000_df) <- 1927:2000
stock_excess_return_pre_2000_df$Year <- NULL
  # Cov Factor CSV
cov_factors_df_pre_2000_df <- cov_factors_df[cov_factors_df$Year >= 1927 & cov_factors_df$Year <= 2000, ]
rownames(cov_factors_df_pre_2000_df) <- 1927:2000
cov_factors_df_pre_2000_df$Year <- NULL

# ==============================================================================
# TASK 8.1: ESTIMATING EXPECTED RETURNS AND THE COVARIANCE MATRIX
# ==============================================================================

# --- 1. ESTIMATE EXPECTED EXCESS RETURNS (mu^e) ---
# Goal: Calculate the historical average for each of the 500 stocks.
# Assumption: A stock's exposure to priced risk is relatively constant over time.
# Equation (44): E[R_i] = (1 / (2000 + 1 - 1927)) * sum(R_i,t) from 1927 to 2000.
exp_excess_ret_mu <- colMeans(stock_excess_return_pre_2000_df)


# --- 2. PREPARE THE FACTOR MODEL (X MATRIX) ---
# Problem: A standard covariance matrix is often singular (non-invertible).
# Solution: Decompose returns into common factor components and idiosyncratic components.
# Matrix X (Size 74x4): Column 1 is all 1s (intercepts xi_0). Columns 2-4 are C1, C2, C3.
X <- as.matrix(cbind(1, cov_factors_df_pre_2000_df[, c("Covariance.Factor.1", "Covariance.Factor.2", "Covariance.Factor.3")]))

# Matrix Re (Size 74x500): The dependent variable containing excess returns for all stocks.
stock_excess_return_pre_2000_mx <- as.matrix(stock_excess_return_pre_2000_df)


# --- 3. ESTIMATE LOADINGS (B) AND RESIDUALS (E) ---
# Equation (47): B = (X'X)^-1 * X' * Re
# This is the "Ordinary Least Squares" (OLS) solution for all 500 regressions at once.
# B contains 4 rows: Intercepts (xi_0), and the loadings (xi_1, xi_2, xi_3) for each stock.
B <- solve(t(X) %*% X) %*% t(X) %*% stock_excess_return_pre_2000_mx

# Equation (46): E = Re - XB
# Matrix E contains the "error terms" or "residuals" (e_i,t) for each stock.
# These represent the portion of returns not explained by the three covariance factors.
E <- stock_excess_return_pre_2000_mx - (X %*% B)


# --- 4. CONSTRUCT THE COVARIANCE MATRIX (Sigma) ---
# Equation (48): Sigma = (B_-1)' * Sigma_C * B_-1 + Sigma_e
# This reconstructs the 500x500 matrix from factor risk and idiosyncratic risk.

# A. Factor Loadings (B_-1): Remove the first row of B (the intercepts).
# We only care about the exposures to C1, C2, and C3 for the covariance.
B_minus_1 <- B[-1, ]

# B. Sigma_C: The 3x3 covariance matrix of the three factors (C1, C2, C3).
# This captures the systematic co-movement of the market environment.
Sigma_C <- cov(cov_factors_df_pre_2000_df[, c("Covariance.Factor.1", "Covariance.Factor.2", "Covariance.Factor.3")])

# C. Sigma_e: The Diagonal Matrix of Residual Variances.
# Equation (49): Calculate the variance of residuals for each stock i.
# Equation (50): Assume off-diagonal elements are 0 (firm-specific risks are uncorrelated).
res_var <- colSums(E^2) / (nrow(E) - 1)
Sigma_e <- diag(res_var)

# D. Final Assembly: Sum the Systematic component and the Idiosyncratic component.
Sigma <- t(B_minus_1) %*% Sigma_C %*% B_minus_1 + Sigma_e