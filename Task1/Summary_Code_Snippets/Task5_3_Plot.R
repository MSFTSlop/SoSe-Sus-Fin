# --- SECTION: MARKET FACTOR VERIFICATION (Plot & Correlation) ---

# 1. Extract the Estimated Market Risk Premium (Column 2 of our results matrix)
# In asset pricing theory, the cross-sectional lambda for the market 
# should track the actual realized excess market return.
estimated_mkt_lambda <- lambda_3f_storage[, "Lambda_Mkt"]

# 2. Get Actual Market Excess Returns (Rf subtracted from Mkt)
# Using the 25-year vector (2001-2025) already in your environment
actual_mkt_excess <- mkt_excess_v 

# 3. Calculate Correlation
# A high correlation (typically > 0.9) indicates that the model is 
# correctly 'uncovering' the market factor from the 500 individual stocks.
mkt_correlation <- cor(estimated_mkt_lambda, actual_mkt_excess)

# 4. Generate Verification Plot
# DESCRIPTION: This plot compares the 'Theory' (Estimated Lambda) vs 'Reality' (Actual Returns).
# We expect the red dashed line (Lambda) to mirror the blue solid line (Actual).
# Large gaps or inverse movements would suggest the model is mis-specified.
plot(2001:2025, actual_mkt_excess, type = "l", col = "blue", lwd = 2,
     main = "Verification: Actual Market Return vs. Estimated Risk Premium",
     xlab = "Year", ylab = "Excess Return / Lambda",
     sub = paste("Correlation coefficient:", round(mkt_correlation, 4)))

lines(2001:2025, estimated_mkt_lambda, col = "red", lty = 2, lwd = 2)

legend("topright", legend = c("Actual Market Excess", "Estimated Lambda_m"), 
       col = c("blue", "red"), lty = c(1, 2), lwd = 2, cex = 0.8)


# --- SECTION: INTERPRETATION NOTE ---

# Store a summary note for the final write-up
cat("\n--- Analysis of Results ---\n")
cat("1. Correlation:", round(mkt_correlation, 4), "\n")
cat("2. Logic Check: If correlation is high, the model successfully identifies the market factor.\n")
cat("3. Economic Size: Observe if the Lambda estimates for ESG/ESGU are positive or negative.\n")
cat("   - Positive Lambda: Investors demand a premium for holding this risk.\n")
cat("   - Negative Lambda: The factor provides a hedge, and investors accept lower returns for it.\n")