message("Start ESG Sorting")

# --- 1. DATA ALIGNMENT ---
# Signal: Combined ESG Ratings (2000-2024)
signal_esg_df <- ESG_combined_df[ESG_combined_df$Year >= 2000 & 
                                       ESG_combined_df$Year <= 2024, ]

# Performance: Stock Excess Returns (2001-2025)
performance_returns_df <- stock_excess_return_df[stock_excess_return_df$Year >= 2001 & 
                                                   stock_excess_return_df$Year <= 2025, ]

# --- 2. INITIALIZATION ---
# Matrix for 5 portfolios across 25 years
esg_port_matrix <- matrix(NA, nrow = 25, ncol = 5)
colnames(esg_port_matrix) <- c("P1_Low_ESG", "P2", "P3", "P4", "P5_High_ESG")

# --- 3. THE SORTING LOOP ---
for (i in 1:25) {
  
  # Step A: Get the consensus ESG signal from the previous year (t-1)
  temp_esg_signal <- as.numeric(signal_esg_df[i, -1])
  
  # Step B: Get the actual returns for the following year (t)
  temp_returns_performance <- as.numeric(performance_returns_df[i, -1])
  
  # Step C: Rank stocks from 1 (Worst ESG) to 500 (Best ESG)
  temp_ranks <- rank(temp_esg_signal, ties.method = "first")
  
  # Step D: Allocate stocks into 5 Portfolios (Quintiles)
  for (p in 1:5) {
    lower_bound <- (p - 1) * 100 + 1
    upper_bound <- p * 100
    
    # Find the indices of the 100 stocks in this ESG bucket
    temp_stock_indices <- which(temp_ranks >= lower_bound & temp_ranks <= upper_bound)
    
    # Step E: Calculate Equal-Weighted average return
    esg_port_matrix[i, p] <- mean(temp_returns_performance[temp_stock_indices], na.rm = TRUE)
  }
}

# --- 4. FINAL OUTPUT ---
Sorted_ESG_Portfolio_Results_df <- cbind(Year = performance_returns_df$Year, 
                                      as.data.frame(esg_port_matrix))

# Cleanup
rm(list = ls(pattern = "temp_"), i, p, lower_bound, upper_bound, signal_esg_df, esg_port_matrix)

# Task expects us to have a 25x5 matrix
  # as to why i have a 25x6 see 4.1