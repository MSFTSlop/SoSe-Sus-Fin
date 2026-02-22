# ==============================================================================
# CAPM_REGRESSION_ANALYSIS.R
# ==============================================================================
# VARIABLE DEFINITIONS:
# X         : Design Matrix (25x2). Col 1 = 1s (Alpha), Col 2 = Market Excess.
# Y_vector  : The Long-Short portfolio return vector (25x1).
# B_hat     : Coefficients. [1] = Alpha, [2] = Beta.
# sig2      : Residual Variance (using T - K = 23 degrees of freedom).
# t_stat    : T-statistics for the coefficients.
# ==============================================================================

# after A LOT of back and forth, gemini kinda understood what i wanted
# for a better explaination what happens in the general engine go to the
# corespoinding file Regression_engine_explaination

message("Starting 5.1 CAPM Regression for Beta, ESG and ESGU")

# --- PART 1: THE GENERAL MATH ENGINE ---

run_matrix_regression <- function(Y_vector, X_matrix) {
  # B_hat = (X'X)^-1 * X'Y
  XTX_inv <- solve(t(X_matrix) %*% X_matrix)
  B_hat   <- XTX_inv %*% t(X_matrix) %*% Y_vector
  
  # Residuals and Variance
  E    <- Y_vector - (X_matrix %*% B_hat)
  sig2 <- as.numeric((t(E) %*% E) / (nrow(X_matrix) - ncol(X_matrix)))
  
  # Standard Errors and T-stats
  se     <- sqrt(diag(sig2 * XTX_inv))
  t_stat <- B_hat / se
  
  return(list(coef = B_hat, t = t_stat))
}

# --- PART 2: EXECUTION ---

# Run the three regressions
res_beta <- run_matrix_regression(Sorted_Beta_v, X)
res_esg  <- run_matrix_regression(Sorted_ESG_v, X)
res_unc  <- run_matrix_regression(Sorted_Unc_v, X)
