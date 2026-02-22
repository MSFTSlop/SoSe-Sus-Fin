# --- TASK 6 DISCUSSION: EXPECTED (LAMBDA) VS. REALIZED (B) ---

# 1. Extract the Lambdas from the Task 5 storage we just calculated
# mean_lambdas[3] is ESG, mean_lambdas[4] is ESGU (based on your code above)
lambda_esg_val  <- mean_lambdas[3]
lambda_esgu_val <- mean_lambdas[4]

# 2. Create the Comparison Table
Comparison_Final <- data.frame(
  Factor = c("ESG Consensus", "ESG Uncertainty"),
  Risk_Premium_Lambda = c(lambda_esg_val, lambda_esgu_val), # Long-term (Section 5)
  News_Impact_b = mean_b                                    # Short-term (Section 6)
)

print("--- FINAL EVALUATION: TASK 5 VS TASK 6 ---")
print(Comparison_Final)


cat("\n--- TASK 6: THEORETICAL INTERPRETATION ---\n\n",
    "1. THE PRICE DISCOVERY ARGUMENT:\n",
    "   If b_esg is positive while Lambda_esg is negative, this is consistent with\n",
    "   investors viewing ESG as a hedge. When 'Good News' (positive news shock)\n",
    "   occurs, investors bid up the stock price immediately to secure the hedge.\n",
    "   This 'Price Jump' creates a positive return today (b > 0) but naturally\n",
    "   depresses the yield/return for the future (Lambda < 0).\n\n",
    
    "2. THE RISK PREMIUM DIRECTION:\n",
    "   The contemporaneous coefficient (b) represents the market's 'Realized' reaction,\n",
    "   whereas Lambda represents the 'Expected' return. If both have the same sign,\n",
    "   it suggests ESG is a standard risk factor where shocks and long-term premia\n",
    "   move in tandem rather than acting as a price-level adjustment for a hedge.\n\n",
    
    "3. THE UNCERTAINTY EFFECT:\n",
    "   A significant b_esgu suggests that 'News' about ESG disagreement (shocks to\n",
    "   uncertainty) causes immediate portfolio rebalancing. This indicates that\n",
    "   investors don't just care about the ESG score itself, but also the 'Quality'\n",
    "   of that information, reacting instantly when data providers diverge.")

# ==============================================================================
# CLEANUP FOR TASK 7 (Double Sorting)
# ==============================================================================

# We KEEP the core dfs and matrices:
# - ESG_combined_df/mx
# - ESGU_combined_df/mx
# - stock_beta_df/mx
# - stock_excess_return_df/mx
# - mean_lambdas (needed for the Task 7 correlation analysis)

# We REMOVE the regression-specific storage and loop variables
rm(b_storage, model_news, News_Impact_Summary, 
   Sorted_Beta_v, Sorted_ESG_v, Sorted_Unc_v, 
   Three_Factor_Summary, ThreeF_Summary, CAPM_VS_ThreeF_df,
   Comparison_Final, X, x1_news, x2_news, y_ret, sd_b, t, t_stats_b)