# ==============================================================================
# 16_MATH_REGRESSION_ENGINE.R
# ==============================================================================
# This file contains the manual matrix solver for the Time-Series Regressions.
# It follows the Gauss-Markov logic for Ordinary Least Squares (OLS).
#
# VARIABLE DEFINITIONS:
# X         : Design Matrix (25x2). Col 1 = 1s (Intercept), Col 2 = Market Excess Returns.
# Y_x       : Dependent Variable vector (25x1). The Long-Short portfolio excess returns.
# B_hat_x   : Coefficient vector (2x1). [1] = Alpha (Intercept), [2] = Beta (Slope).
# E_x       : Residuals (25x1). The difference between actual and predicted returns.
# sig2_x    : Residual Variance (Scalar). Sum of squared errors adjusted for degrees of freedom.
# XTX_inv   : The (X'X)^-1 matrix. Used to calculate the standard errors of coefficients.
# se_x      : Standard Errors (2x1). Square root of the diagonal of (sig2 * XTX_inv).
# t_x       : T-statistics (2x1). Coefficient divided by its Standard Error.
# ==============================================================================

# FUNCTION: run_matrix_regression
# Input: Y_vector (25x1), X_matrix (25x2)
# Output: A list containing coefficients and t-stats
run_matrix_regression <- function(Y_vector, X_matrix) {
  
  # 1. Solve for Coefficients: B_hat = (X'X)^-1 * X'Y
  XTX_inv <- solve(t(X_matrix) %*% X_matrix)
  B_hat   <- XTX_inv %*% t(X_matrix) %*% Y_vector
  
  # 2. Calculate Residuals: E = Y - X * B_hat
  E <- Y_vector - (X_matrix %*% B_hat)
  
  # 3. Residual Variance: sigma^2 = (E'E) / (T - K)
  # nrow - ncol provides the Degrees of Freedom (25 - 2 = 23)
  sig2 <- as.numeric((t(E) %*% E) / (nrow(X_matrix) - ncol(X_matrix)))
  
  # 4. Standard Errors of B_hat
  # sqrt(diagonal of sig2 * (X'X)^-1)
  se <- sqrt(diag(sig2 * XTX_inv))
  
  # 5. T-Statistics
  t_stat <- B_hat / se
  
  # Return results as a structured list
  return(list(
    coefficients = B_hat,
    t_statistics = t_stat,
    residuals    = E,
    sigma_sq     = sig2
  ))
}