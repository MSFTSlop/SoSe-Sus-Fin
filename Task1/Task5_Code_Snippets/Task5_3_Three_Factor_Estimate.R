# ==============================================================================
# ESTIMATE_THREE_FACTOR_MODEL.R (Task 5.3)
# ==============================================================================

# AI slowly gets the hang of it

message("Starting 5.3 Three Factor Model Estimation")

# --- SECTION: MATRIX CONVERSION AND ALLIGNMENT ---

# 1. Convert Stock Beta dataframe to matrix (Assumes 26 rows: 2000-2025)
stock_beta_mx <- as.matrix(stock_beta_df)

# NOTE: ESG_matrix (26x500), ESGU_matrix (26x500), and 
# Stock_Returns_matrix (25x500) are already loaded in the environment.


# --- SECTION: THREE-FACTOR ESTIMATION LOOP ---

# Storage for 25 years of coefficients (Eq. 30)
# Cols: Intercept, Lambda_Mkt, Lambda_ESG, Lambda_ESGU
lambda_3f_storage <- matrix(NA, nrow = 25, ncol = 4)
colnames(lambda_3f_storage) <- c("Alpha", "Lambda_Mkt", "Lambda_ESG", "Lambda_ESGU")

for (t in 1:25) {
  
  # Construct Predictor Matrix Xt (4 rows x 500 columns)
  # Row 1: Constant (1s)
  # Row 2: Market Betas at year t
  # Row 3: ESG scores at year t
  # Row 4: ESGU scores at year t
  Xt_3f <- rbind(1, 
                 stock_beta_mx[t, ], 
                 ESG_combined_mx[t, ], 
                 ESGU_combined_mx[t, ])
  
  # Dependent variable: Returns at year t+1 (Row 1 = 2001)
  Re_t_plus_1 <- stock_excess_return_mx[t, ]
  
  # Equation 27/30: Cross-Sectional Regression via Matrix Algebra
  # Formula: (a, lm, lesg, lesgu) = Re * Xt' * (Xt * Xt')^-1
  inner_inv_3f <- solve(Xt_3f %*% t(Xt_3f))
  coef_3f      <- Re_t_plus_1 %*% t(Xt_3f) %*% inner_inv_3f
  
  # Store results
  lambda_3f_storage[t, ] <- coef_3f
}