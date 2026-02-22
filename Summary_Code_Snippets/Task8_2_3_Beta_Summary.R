# ==============================================================================
# SCRIPT 5: RE-FIXED BETA ONLY SUMMARY (ORDER BY TARGET)
# ==============================================================================

# 1. Aggregation
avg_rets_beta <- aggregate(Realized_Ret ~ Target_Ret, 
                           data = Portfolio_Opt_Beta_Only_df, FUN = mean)
vols_beta <- aggregate(Realized_Ret ~ Target_Ret, 
                       data = Portfolio_Opt_Beta_Only_df, FUN = sd)

Summary_Beta_Only_df <- merge(avg_rets_beta, vols_beta, by = "Target_Ret")
colnames(Summary_Beta_Only_df) <- c("Target_Ret", "Avg_Ret", "Vol")

# --- THE FIX: SORT BY TARGET RETURN ---
# Instead of Vol, sort by the Target Return to follow the optimization path
Summary_Beta_Only_df <- Summary_Beta_Only_df[order(Summary_Beta_Only_df$Target_Ret), ]

# 2. Plotting with a restricted Y-axis to focus on the "frontier"
par(mar = c(5, 5, 4, 2))
plot(Summary_Beta_Only_df$Vol, Summary_Beta_Only_df$Avg_Ret,
     type = "b",      # Connects with lines and points
     pch = 16, 
     lwd = 2, 
     col = "black",
     main = "Realized Efficient Frontier (Beta-Only Baseline)",
     xlab = "Annualized Realized Volatility (Std. Dev)",
     ylab = "Average Annual Realized Excess Return",
     las = 1)

grid(lty = "dotted", col = "lightgray")
legend("bottomright", legend = "Beta-Only (Benchmark)", 
       col = "black", lwd = 2, pch = 16, bty = "n")