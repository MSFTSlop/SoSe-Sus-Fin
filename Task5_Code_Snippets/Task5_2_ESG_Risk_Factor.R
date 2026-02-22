# ==============================================================================
# ESTIMATE_ESG_RISK_FACTORS.R (Task 5.2)
# ==============================================================================

# AI is a little bit frustrating

message("Starting 5.2 ESG Risk Factors")

# --- SECTION: MATRIX CONVERSION AND ALLIGNMENT ---

# 1. Convert dataframes to numeric matrices (Required for Eq. 27)
# Scores from year t (2000-2025)
ESG_combined_mx  <- as.matrix(ESG_combined_df)
ESGU_combined_mx <- as.matrix(ESGU_combined_df)

# 2. Align Returns for Lead-Lag (t+1)
# We remove the year 2000 from the returns to align with Equation 26.
# Row 1 of this matrix will be the year 2001.
stock_excess_return_mx <- as.matrix(stock_excess_return_df[rownames(stock_excess_return_df) != "2000", ])


# --- SECTION: ESTIMATION OF RISK FACTORS (Loop) ---

# Storage for the annual Risk Premiums (Lambda)
lambda_storage_esg  <- numeric(25)
lambda_storage_esgu <- numeric(25)

for (t in 1:25) {
  # Construct Predictor Matrices Xt (2 rows x 500 columns)
  Xt_esg  <- rbind(1, ESG_combined_mx[t, ])
  Xt_esgu <- rbind(1, ESGU_combined_mx[t, ])
  
  # Dependent variable (Returns at t+1)
  Re_t_plus_1 <- stock_excess_return_mx[t, ]
  
  # Equation 27: Solve for coefficients
  # (a, lambda) = Re * Xt' * (Xt * Xt')^-1
  coef_esg  <- Re_t_plus_1 %*% t(Xt_esg) %*% solve(Xt_esg %*% t(Xt_esg))
  coef_esgu <- Re_t_plus_1 %*% t(Xt_esgu) %*% solve(Xt_esgu %*% t(Xt_esgu))
  
  # Store the Lambda (the second coefficient in the resulting 1x2 vector)
  lambda_storage_esg[t]  <- coef_esg[2]
  lambda_storage_esgu[t] <- coef_esgu[2]
}
