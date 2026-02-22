# --- FINAL EVALUATION ---
print(ThreeF_Summary)

cat("\n--- INTERPRETATION GUIDE ---\n",
    "1. Significance: If 'Significant' is NO, the 3-factor model explains the portfolio perfectly.\n",
    "2. Comparison: Look at the Alphas you got in Task 5.1 (CAPM).\n",
    "3. Verdict: The model with the Alphas closest to zero is the superior model.\n\n ")

# modifying the CAPM and COC Summary Table 
CAPM_Summary$Beta <- NULL
CAPM_Summary$t_Beta <- NULL
CAPM_Summary$CAPM_Fails <- NULL
ThreeF_Summary$Significant <- NULL

# Renaming CAPM and COC Col Names
colnames(CAPM_Summary)[2:3] <- c("Alpha_CAPM", "t_Alpha_CAPM")
colnames(ThreeF_Summary)[2:3] <- c("Alpha_3F", "t_Alpha_3F")

# Merging and printing out the Horse race table
CAPM_VS_ThreeF_df <- merge(CAPM_Summary, ThreeF_Summary, by="Portfolio")

print(CAPM_VS_ThreeF_df)

cat("\nThe three-factor model provides a superior estimate of the cost of capital compared to the CAPM, as the risk exposures to ESG and ESG Uncertainty account for the returns that the market beta previously could not explain")

# Cleanup of data
rm(s, CAPM_Summary, factors_3f, Y, model, portfolios)
# Cleanup of Values
rm(actual_mkt_excess, alpha_t, alpha_val, estimated_mkt_lambda, lambda_storage_esg, lambda_storage_esgu,
   mkt_correlation, p_name, Re_t_plus_1, sd_lambdas, sharpe_ratios, t, year_labels)