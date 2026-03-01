## over here the average exxcess return of each portfolio over the 25 years (2001-2025)
## is calculated
## the columns are each portfolio (excluding the first column with years in it)

# 1. Calculate the 25-year means
unc_averages_vec <- colMeans(Sorted_Uncertainty_Portfolio_Results_df[, -1], na.rm = TRUE)

# 2. Construct the clean two-column dataframe
Sorted_Uncertainty_Results_Summary_df <- data.frame(
  Portfolio = c("Portfolio 1 (Low Uncertainty)", 
                "Portfolio 2", 
                "Portfolio 3", 
                "Portfolio 4", 
                "Portfolio 5 (High Uncertainty)"),
  Avg_Excess_Return = round(as.numeric(unc_averages_vec), 4)
)

# 3. Display
print(Sorted_Uncertainty_Results_Summary_df)

  # better do your own check. Interpretation may be a good guideline from gemini
  # but certainly NOT foolproof
# --- QUICK INTERPRETATION GUIDE ---
# High Uncertainty (P5) represents stocks where agencies disagree most.
# Some literature suggests investors demand a premium for this "information risk."

# Clean up all values in cache
rm(beta_averages_vec, esg_averages_vec, unc_averages_vec)