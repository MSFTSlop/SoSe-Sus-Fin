# ==============================================================================
# VERIFICATION OF TASK 8.1 OUTPUTS
# ==============================================================================

# 1. Check Expected Excess Returns (mu^e)
message("--- Expected Excess Returns (mu_e) ---")
print(summary(exp_excess_ret_mu)) # Shows min, max, and average return across all stocks

# 2. Check Covariance Matrix Dimensions
# Should be 500 x 500
message("\n--- Sigma Dimensions ---")
print(dim(Sigma))

# 3. Check for Invertibility (Positive Definiteness)
# If Sigma is not invertible, the portfolio optimization in 8.2 will fail.
# We check if all eigenvalues are positive.
is_positive_definite <- all(eigen(Sigma)$values > 0)
message("\n--- Mathematical Health Check ---")
message("Is Sigma positive definite (invertible)? ", is_positive_definite)

# 4. Inspect a small corner of Sigma
# Just to see the scale of the variances/covariances
message("\n--- Sample of Sigma (Top-Left 3x3 Corner) ---")
print(Sigma[1:3, 1:3])