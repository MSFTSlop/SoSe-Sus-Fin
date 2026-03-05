# --- SECTION: STATISTICAL SIGNIFICANCE DATAFRAME ---

# Calculating components for Equation 28 and 29
# Lambda_hat = (1/25) * sum(lambda_t)
ESG_Summary <- data.frame(
  Factor = c("ESG Consensus", "ESG Uncertainty"),
  Estimated_Risk_Price = c(mean(lambda_storage_esg), 
                           mean(lambda_storage_esgu)),
  Standard_Deviation   = c(sd(lambda_storage_esg), 
                           sd(lambda_storage_esgu))
)

# Calculate t-stat: sqrt(25) * (mean / sd)
ESG_Summary$T_Statistic <- sqrt(25) * (ESG_Summary$Estimated_Risk_Price / ESG_Summary$Standard_Deviation)

# Answer the question: Is it significantly different from 0?
# Significant if |t| > 2 (5% level)
ESG_Summary$Significant_at_5pct <- ifelse(abs(ESG_Summary$T_Statistic) > 2, "Yes", "No")

# Clean view for the final report
ESG_Summary$Standard_Deviation <- NULL

# Print the final dataframe to console
print(ESG_Summary)

# Cleanup
rm(coef_esg, coef_esgu, Xt_esg, Xt_esgu)