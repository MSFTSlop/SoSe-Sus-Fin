# --- SECTION 5.4: COST-OF-CAPITAL TEST ---

message("Start 5.4 Three Factor Model COC explainer")

# 1. Define the Dependent Variables (Your Long-Short Portfolios)
# Assumes these were calculated in your previous portfolio sorting scripts
portfolios <- list(
  Beta = Sorted_Beta_v, 
  ESG  = Sorted_ESG_v, 
  ESGU = Sorted_Unc_v
)

# 2. Prepare the Explanatory Variables (The Factors)
# We use the Lambdas estimated in 5.3 (excluding the intercept)
# These should be 25 rows (2001-2025)
factors_3f <- lambda_3f_storage[, c("Lambda_Mkt", "Lambda_ESG", "Lambda_ESGU")]

# 3. Storage for Results
ThreeF_Summary <- data.frame()

# 4. Run Regression (Equation 33) for each portfolio
for (p_name in names(portfolios)) {
  
  # The Portfolio excess return for t (2001-2025)
  # Ensure the portfolio vector length matches the factors (25 years)
  Y <- portfolios[[p_name]]
  
  # Regression: LS_p = alpha + beta*Lambda_m + gamma*Lambda_esg + theta*Lambda_esgu
  model <- lm(Y ~ factors_3f)
  s <- summary(model)
  
  # Extract Alpha (the intercept) and its t-stat
  # If Alpha is 0, the model 'explains' the cost of capital perfectly
  alpha_val  <- s$coefficients[1, 1]
  alpha_t    <- s$coefficients[1, 3]
  
  # Collect results
  ThreeF_Summary <- rbind(ThreeF_Summary, data.frame(
    Portfolio = p_name,
    Alpha = alpha_val,
    T_Stat_Alpha = alpha_t,
    Significant = ifelse(abs(alpha_t) > 2, "Yes", "No")
  ))
}
