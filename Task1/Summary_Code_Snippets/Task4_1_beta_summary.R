# 1. Calculate the mean of each column (excluding the 'Year' column)
# This gives us the average annual excess return for each quintile

## over here the average exxcess return of each portfolio over the 25 years (2001-2025)
## is calculated
## the columns are each portfolio (excluding the first column with years in it)

beta_averages_vec <- colMeans(Sorted_Beta_Portfolio_Results_df[, -1], na.rm = TRUE)

# 2. Construct the clean two-column dataframe
# Column 1: Portfolio Name
# Column 2: Average Excess Return
Sorted_Beta_Results_Summary_df <- data.frame(
  Portfolio = c("Portfolio 1 (Low Beta)", 
                "Portfolio 2", 
                "Portfolio 3", 
                "Portfolio 4", 
                "Portfolio 5 (High Beta)"),
  Avg_Excess_Return = as.numeric(beta_averages_vec)
)

# 3. Optional: Rounding for a professional look (e.g., 4 decimal places)
Sorted_Beta_Results_Summary_df$Avg_Excess_Return <- round(Sorted_Beta_Results_Summary_df$Avg_Excess_Return, 4)

# 4. Display the result
print(Sorted_Beta_Results_Summary_df)

  # better do your own check. Interpretation may be a good guideline from gemini
  # but certainly NOT foolproof
# Note for your report:
# If Portfolio 5 > Portfolio 1, the CAPM holds (Higher risk = Higher reward).
# If Portfolio 1 > Portfolio 5, you have found the 'Low Beta Anomaly'.