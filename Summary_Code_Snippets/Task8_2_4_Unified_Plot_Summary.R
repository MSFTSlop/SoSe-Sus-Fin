# --- 1. PREPARE THE DATA ---
# We use the summary dataframes you already created: 
# Summary_ESG_Beta_df (has ESG targets)
# Summary_Beta_Only_df (has no ESG targets)

# Map the "Beta Only" data into a similar format for plotting
benchmark_data <- Summary_Beta_Only_df
colnames(benchmark_data) <- c("Target_Ret", "Avg_Realized_Return", "Volatility")
benchmark_data$Target_ESG <- "Benchmark"

# --- 2. DEFINE THE PLOT RANGE ---
# Combine all volatilities and returns to find the global min/max for the axes
all_vols <- c(Summary_ESG_Beta_df$Volatility, benchmark_data$Volatility)
all_rets <- c(Summary_ESG_Beta_df$Avg_Realized_Return, benchmark_data$Avg_Realized_Return)

x_lim <- range(all_vols, na.rm = TRUE)
y_lim <- range(all_rets, na.rm = TRUE)

# --- 3. CREATE THE COMPARATIVE PLOT ---
plot(NULL, xlim = x_lim, ylim = y_lim,
     main = "Task 8: Final Efficient Frontier Comparison",
     sub = "Baseline (Beta Only) vs. ESG-Constrained Portfolios",
     xlab = "Realized Volatility (Risk)",
     ylab = "Realized Excess Return",
     las = 1)

grid(lty = "dotted", col = "gray")

# A. Add the ESG Lines (Colored)
esg_levels <- c(-4, 0, 2)
colors <- c("-4" = "red", "0" = "blue", "2" = "darkgreen")

for (esg in esg_levels) {
  sub_data <- subset(Summary_ESG_Beta_df, Target_ESG == esg)
  lines(sub_data$Volatility, sub_data$Avg_Realized_Return, 
        col = colors[as.character(esg)], lwd = 2, type = "b", pch = 16)
}

# B. Add the Beta-Only Benchmark (Thick Black Dashed Line)
lines(benchmark_data$Volatility, benchmark_data$Avg_Realized_Return, 
      col = "black", lwd = 3, lty = 2, type = "b", pch = 17)

# --- 4. ADD THE LEGEND ---
legend("bottomright", 
       legend = c("Low ESG (-4)", "Medium ESG (0)", "High ESG (2)", "Unconstrained (Beta-Only)"),
       col = c("red", "blue", "darkgreen", "black"), 
       lwd = c(2, 2, 2, 3), 
       lty = c(1, 1, 1, 2), 
       pch = c(16, 16, 16, 17), 
       bty = "n", cex = 0.8)