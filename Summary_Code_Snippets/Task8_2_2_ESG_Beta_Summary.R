# ==============================================================================
# SCRIPT 4: SUMMARY STATISTICS AND VISUALIZATION (ESG + BETA) - BASE R
# ==============================================================================

# --- 1. CALCULATE SUMMARY STATISTICS ---
# We calculate Mean and SD separately then merge them
avg_rets <- aggregate(Realized_Ret ~ Target_Ret + Target_ESG, 
                      data = Portfolio_Opt_ESG_Beta_df, FUN = mean)

volatilities <- aggregate(Realized_Ret ~ Target_Ret + Target_ESG, 
                          data = Portfolio_Opt_ESG_Beta_df, FUN = sd)

# Merge into a single summary dataframe
Summary_ESG_Beta_df <- merge(avg_rets, volatilities, by = c("Target_Ret", "Target_ESG"))
colnames(Summary_ESG_Beta_df) <- c("Target_Ret", "Target_ESG", "Avg_Realized_Return", "Volatility")

# Add a Year Range column for clarity
Summary_ESG_Beta_df$Years <- "2001-2025"

# Sort for readability
Summary_ESG_Beta_df <- Summary_ESG_Beta_df[order(Summary_ESG_Beta_df$Target_ESG, Summary_ESG_Beta_df$Target_Ret), ]

# Preview results
print(head(Summary_ESG_Beta_df))

# --- 2. VISUALIZATION (Efficient Frontiers) ---

# Define colors for the three ESG levels
colors <- c("-4" = "red", "0" = "blue", "2" = "darkgreen")
esg_levels <- c(-4, 0, 2)

# Set up the plot window limits based on the data
x_lim <- range(Summary_ESG_Beta_df$Volatility)
y_lim <- range(Summary_ESG_Beta_df$Avg_Realized_Return)

# Initialize the plot with the first ESG level (-4)
plot(NULL, xlim = x_lim, ylim = y_lim,
     main = "Realized Efficient Frontiers (2001-2025)",
     sub = "Constraints: Market Neutrality (Beta = 1) and ESG Targets",
     xlab = "Annualized Realized Volatility (Std. Dev)",
     ylab = "Average Annual Realized Excess Return",
     las = 1) # las=1 makes y-axis labels horizontal

# Add a line and points for each ESG target
for (i in seq_along(esg_levels)) {
  sub_data <- subset(Summary_ESG_Beta_df, Target_ESG == esg_levels[i])
  lines(sub_data$Volatility, sub_data$Avg_Realized_Return, 
        col = colors[as.character(esg_levels[i])], lwd = 2, type = "b", pch = 16)
}

# Add legend
legend("bottomright", 
       legend = c("Low ESG (-4)", "Medium ESG (0)", "High ESG (2)"),
       col = c("red", "blue", "darkgreen"), 
       lwd = 2, pch = 16, bty = "n")

grid() # Add a grid for better readability