## over here the average exxcess return of each portfolio over the 25 years (2001-2025)
## is calculated
## the columns are each portfolio (excluding the first column with years in it)

# 1. Calculate the mean for each ESG quintile over the 25-year period
# We take the column means of the results we just calculated
esg_averages_vec <- colMeans(Sorted_ESG_Portfolio_Results_df[, -1], na.rm = TRUE)

# 2. Construct the clean two-column dataframe
# This is the "Visual" table for your fellow students and your report
Sorted_ESG_Results_Summary_df <- data.frame(
  Portfolio = c("Portfolio 1 (Low ESG Score)", 
                "Portfolio 2", 
                "Portfolio 3", 
                "Portfolio 4", 
                "Portfolio 5 (High ESG Score)"),
  Avg_Excess_Return = as.numeric(esg_averages_vec)
)

# 3. Professional Formatting
# Rounding to 4 decimal places for consistency
Sorted_ESG_Results_Summary_df$Avg_Excess_Return <- round(Sorted_ESG_Results_Summary_df$Avg_Excess_Return, 4)

# 4. Display the results to the console
print(Sorted_ESG_Results_Summary_df)

  # better do your own check. Interpretation may be a good guideline from gemini
  # but certainly NOT foolproof
# --- QUICK INTERPRETATION GUIDE ---
# If P5 > P1: High ESG stocks outperformed (The "Doing well by doing good" theory).
# If P1 > P5: Low ESG stocks outperformed (The "Sin stock" premium theory).