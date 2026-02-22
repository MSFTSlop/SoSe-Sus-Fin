# ==============================================================================
# TASK 7.2: SUMMARY, CORRELATIONS, AND PLOTTING
# ==============================================================================

# 1. CALCULATE PERFORMANCE METRICS
# For the Long-Short portfolios generated in Task 7.1
Double_Sort_summary <- data.frame(
  Metric = c("Mean Excess Return", "Sharpe Ratio", "Correlation with Lambda"),
  
  # ESG Consensus Results
  ESG = c(
    mean(ls_esg_returns),
    mean(ls_esg_returns) / sd(ls_esg_returns),
    cor(ls_esg_returns, lambda_3f_storage[, 3]) # Correlation with Section 5.3
  ),
  
  # ESG Uncertainty Results
  ESGU = c(
    mean(ls_esgu_returns),
    mean(ls_esgu_returns) / sd(ls_esgu_returns),
    cor(ls_esgu_returns, lambda_3f_storage[, 4]) # Correlation with Section 5.3
  )
)

print("--- DOUBLE SORT PERFORMANCE SUMMARY ---")
print(Double_Sort_summary)

# 2. TIME-SERIES PLOTTING
# Requirement: Plot the long-short portfolio and the estimated lambda in the same figure
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))

# ESG Consensus Plot
plot(2001:2025, ls_esg_returns, type = "l", col = "blue", lwd = 2,
     main = "ESG: Long-Short Portfolio vs. Lambda (Section 5.3)",
     ylab = "Returns / Premium", xlab = "Year")
lines(2001:2025, lambda_3f_storage[, 3], col = "red", lty = 2, lwd = 2)
legend("topright", legend = c("LS Portfolio", "Lambda ESG"), 
       col = c("blue", "red"), lty = 1:2, bty = "n", cex = 0.8)

# ESG Uncertainty Plot
plot(2001:2025, ls_esgu_returns, type = "l", col = "darkgreen", lwd = 2,
     main = "ESGU: Long-Short Portfolio vs. Lambda (Section 5.3)",
     ylab = "Returns / Premium", xlab = "Year")
lines(2001:2025, lambda_3f_storage[, 4], col = "orange", lty = 2, lwd = 2)
legend("topright", legend = c("LS Portfolio", "Lambda ESGU"), 
       col = c("darkgreen", "orange"), lty = 1:2, bty = "n", cex = 0.8)

# 3. INTERPRETATION CAT SNIPPET
cat("\n--- DISCUSSION POINTS FOR REPORT ---\n",
    "1. Correlation: If correlation is high (>0.7), the regression and sorting\n",
    "   methods yield similar risk signals, confirming robustness.\n",
    "2. Univariate vs Double Sort: Unlike Task 4, this method ensures that\n",
    "   the ESG premium is not simply a proxy for market beta.\n",
    "3. Regression vs Sort: Sorting is easier to understand and less sensitive\n",
    "   to outliers, but ignores the middle 60% of the distribution.\n")