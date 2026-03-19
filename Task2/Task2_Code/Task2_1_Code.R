# 1. Extract the Year column (since both dataframes are synced, we can pull from either)
years <- ESG_Combined_cleaned_df$Year 

# 2. Calculate the average across all stocks for each year
# We use rowMeans and exclude the first column (-1) which is 'Year'
# na.rm = TRUE is crucial here to ignore missing data for stocks not public yet
avg_esg <- rowMeans(ESG_Combined_cleaned_df[, -1], na.rm = TRUE)
avg_co2_rev <- rowMeans(CO2_to_Rev_cleaned_df[, -1], na.rm = TRUE)

# 3. Combine into the new dataframe requested
Trend_Analysis_df <- data.frame(
  Year = years,
  Avg_ESG_Combined = avg_esg,
  Avg_CO2_to_Rev = avg_co2_rev
)

# 4. Plot the trends side-by-side (over-under)
## reason according to ai is that the numbers are scaled differently
## so putting both in one and the same plot may be difficult
# par(mfrow = c(2, 1)) splits the plotting window into 2 rows, 1 column
# 1. Set up the 2-row layout AND reduce the margins simultaneously
# mar = c(bottom, left, top, right). Default is usually c(5, 4, 4, 2) + 0.1
# We are shrinking the top and bottom margins so both plots fit nicely
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1)) 

# Plot 1: ESG Trend
plot(Trend_Analysis_df$Year, Trend_Analysis_df$Avg_ESG_Combined, 
     type = "b", pch = 16, col = "blue", lwd = 2,
     xlab = "Year", ylab = "Avg ESG Rating",
     main = "Trend of Average ESG Rating (2002-2023)")

# Plot 2: CO2 to Revenue Trend
plot(Trend_Analysis_df$Year, Trend_Analysis_df$Avg_CO2_to_Rev, 
     type = "b", pch = 16, col = "red", lwd = 2,
     xlab = "Year", ylab = "Avg CO2 to Revenue",
     main = "Trend of Avg CO2 to Revenue (2002-2023)")

# Reset the plotting window to default 1x1 and standard margins
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

## Proposed a z-score approach to merge both into one table
# 1. Ensure the Trend_Analysis_df is built with these EXACT names
Trend_Analysis_df <- data.frame(
  Year = ESG_Combined_cleaned_df$Year,
  Avg_ESG = rowMeans(ESG_Combined_cleaned_df[, -1], na.rm = TRUE),
  Avg_CO2 = rowMeans(CO2_to_Rev_cleaned_df[, -1], na.rm = TRUE)
)

# 2. Calculate Z-scores using those exact names
# We use as.numeric() because scale() returns a matrix, and we want a simple vector
Trend_Analysis_df$Z_ESG <- as.numeric(scale(Trend_Analysis_df$Avg_ESG))
Trend_Analysis_df$Z_CO2 <- as.numeric(scale(Trend_Analysis_df$Avg_CO2))

# 3. Plot with tighter margins to avoid the "figure margins too large" error
par(mar = c(4, 4, 3, 1)) # Bottom, Left, Top, Right

y_limits <- range(c(Trend_Analysis_df$Z_ESG, Trend_Analysis_df$Z_CO2), na.rm = TRUE)

plot(Trend_Analysis_df$Year, Trend_Analysis_df$Z_ESG, 
     type = "b", pch = 16, col = "blue", lwd = 2,
     ylim = y_limits,
     xlab = "Year", ylab = "Z-Score",
     main = "Normalized ESG vs. CO2 Trends")

lines(Trend_Analysis_df$Year, Trend_Analysis_df$Z_CO2, 
      type = "b", pch = 17, col = "red", lwd = 2)

legend("topleft", legend = c("ESG Rating", "CO2/Rev"),
       col = c("blue", "red"), pch = c(16, 17), lwd = 2, bty = "n")

abline(h = 0, lty = 2, col = "gray")