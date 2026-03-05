message("Start ESG Uncertainty Sorting")

## over all this code is almost the same as in 4_1
## only difference is now we rank with esgu scores and not
## the beta.
## the weight rebalancing still happens with the excess return

### so for detailed explaination check 4_1


# --- 1. DATA ALIGNMENT ---
# Signal: ESG Uncertainty/Standard Deviation (2000-2024)
signal_unc_df <- ESGU_combined_df[ESGU_combined_df$Year >= 2000 & 
                                   ESGU_combined_df$Year <= 2024, ]

# Performance: Stock Excess Returns (2001-2025)
performance_returns_df <- stock_excess_return_df[stock_excess_return_df$Year >= 2001 & 
                                                   stock_excess_return_df$Year <= 2025, ]

# --- 2. INITIALIZATION ---
unc_port_matrix <- matrix(NA, nrow = 25, ncol = 5)
colnames(unc_port_matrix) <- c("P1_Low_Unc", "P2", "P3", "P4", "P5_High_Unc")

# --- 3. THE SORTING LOOP ---
for (i in 1:25) {
  
  # Step A: Get the Uncertainty signal (Standard Deviation) from year t-1
  temp_unc_signal <- as.numeric(signal_unc_df[i, -1])
  
  # Step B: Get the actual returns for the following year t
  temp_returns_performance <- as.numeric(performance_returns_df[i, -1])
  
  # Step C: Rank stocks from 1 (Consensus) to 500 (Highest Disagreement)
  temp_ranks <- rank(temp_unc_signal, ties.method = "first")
  
  # Step D: Allocate stocks into 5 Portfolios
  for (p in 1:5) {
    lower_bound <- (p - 1) * 100 + 1
    upper_bound <- p * 100
    
    # Identify indices
    temp_stock_indices <- which(temp_ranks >= lower_bound & temp_ranks <= upper_bound)
    
    # Step E: Calculate Equal-Weighted average return
    unc_port_matrix[i, p] <- mean(temp_returns_performance[temp_stock_indices], na.rm = TRUE)
  }
}

# --- 4. FINAL OUTPUT ---
Sorted_Uncertainty_Portfolio_Results_df <- cbind(Year = performance_returns_df$Year, 
                                       as.data.frame(unc_port_matrix))

# Cleanup
rm(list = ls(pattern = "temp_"), i, p, lower_bound, upper_bound, signal_unc_df, 
   performance_returns_df, unc_port_matrix)

# Task expects us to have a 25x5 matrix
  # as to why i have a 25x6 see 4.1