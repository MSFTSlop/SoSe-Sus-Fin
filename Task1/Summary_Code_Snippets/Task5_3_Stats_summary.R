# --- SECTION: STATISTICAL SIGNIFICANCE & SUMMARY ---

# Calculate mean risk premia (Lambda_hat) and T-stats (Eq. 31 & 32)
mean_lambdas <- colMeans(lambda_3f_storage)
sd_lambdas   <- apply(lambda_3f_storage, 2, sd)
t_stats_3f   <- sqrt(25) * (mean_lambdas / sd_lambdas)

# Create final results table for Section 5.3
Three_Factor_Summary <- data.frame(
  Factor = c("Market (Beta)", "ESG Consensus", "ESG Uncertainty"),
  Risk_Premium_Estimate = mean_lambdas[2:4],
  T_Statistic = t_stats_3f[2:4]
)

# Significance check (|t| > 2)
Three_Factor_Summary$Significant <- ifelse(abs(Three_Factor_Summary$T_Statistic) > 2, "Yes", "No")

# --- FINAL SHARPE RATIO ADD-ON ---

# 1. Calculate Sharpe Ratios for all 3 factors (Columns 2, 3, and 4)
# Formula: Mean Lambda / SD of Lambda
sharpe_ratios <- mean_lambdas[2:4] / sd_lambdas[2:4]

# 2. Update your summary table so everything is in one place
Three_Factor_Summary$Sharpe_Ratio <- sharpe_ratios

# Final summary view
print(Three_Factor_Summary)

# Cleanup
rm(coef_3f, inner_inv_3f, Xt_3f)