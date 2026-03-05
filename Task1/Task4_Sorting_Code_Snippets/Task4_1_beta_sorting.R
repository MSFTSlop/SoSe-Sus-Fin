message("Start Beta Sorting")

# --- 1. DATA ALIGNMENT (The "Muppet" Check) ---
# We have data from 2000 to 2025 (26 rows).
# To follow the 'previous year' rule:
#   - We need signals from 2000 to 2024 (25 years)
#   - We need returns from 2001 to 2025 (25 years)

## to be honest, even when going through it again it is 
## still not 100% clear how the dataframe should have
## been constructed
## as stated the base is the prevous years beta which are sorted
## the weighting comes from the returns on that year

# Extracting the 25 years of signals (t-1)
# We take rows 1 to 25 of the Beta data (Year 2000 to 2024)
signal_betas_df <- stock_beta_df[stock_beta_df$Year >= 2000 & stock_beta_df$Year <= 2024, ]

# Extracting the 25 years of performance (t)
# We take rows that match 2001 to 2025
performance_returns_df <- stock_excess_return_df[stock_excess_return_df$Year >= 2001 & stock_excess_return_df$Year <= 2025, ]


# --- 2. INITIALIZATION ---
# Create a matrix to hold returns for 5 portfolios across 25 years
beta_port_matrix <- matrix(NA, nrow = 25, ncol = 5)
colnames(beta_port_matrix) <- c("P1_Low_Beta", "P2", "P3", "P4", "P5_High_Beta")


# --- 3. THE SORTING LOOP ---
for (i in 1:25) {
  
  # Step A: Get the signal from the previous year (e.g., Year 2000)
  # We remove column 1 (the Year) to get only the 500 stock betas
  ## according to gemini the i,-1 is telling r, give me everything EXCEPT
  ## col 1
  temp_betas_signal <- as.numeric(signal_betas_df[i, -1])
  
  # Step B: Get the actual returns for the following year (e.g., Year 2001)
  temp_returns_performance <- as.numeric(performance_returns_df[i, -1])
  
  # Step C: Rank the stocks from 1 to 500 based on the signal
  # ties.method = "first" ensures we always have exactly 100 stocks per bucket
  ## interesting, here the re ranking happens since each year the portfolio 
  ## composition may change depending on the change of their respective betas
  ## thats why we use the beta signal
  temp_ranks <- rank(temp_betas_signal, ties.method = "first")
  
  # Step D: Allocate stocks into 5 Portfolios (Quintiles)
  for (p in 1:5) {
    # Define the "Bucket" (1-100, 101-200, etc.)
    lower_bound <- (p - 1) * 100 + 1
    upper_bound <- p * 100
    
    # Find the indices of the 100 stocks that belong in this bucket
    temp_stock_indices <- which(temp_ranks >= lower_bound & temp_ranks <= upper_bound)
    
    # Step E: Calculate the Equal-Weighted average return for these 100 stocks
    ## at this point you use the equal weighting, saying the excess return on a portfolio
    ## in a given year will simply be the average excess return on the 100 stocks 
    ## that enter that portfolio in that year
    beta_port_matrix[i, p] <- mean(temp_returns_performance[temp_stock_indices], na.rm = TRUE)
  }
}


# --- 4. FINAL OUTPUT ---
# Combine the Year from our performance dataframe with the results
Sorted_Beta_Portfolio_Results_df <- cbind(Year = performance_returns_df$Year, as.data.frame(beta_port_matrix))

# Clean up temporary "workbench" variables
rm(list = ls(pattern = "temp_"), i, p, lower_bound, upper_bound, signal_betas_df, performance_returns_df, beta_port_matrix)

# Taks states having 5 portffolios with 25 years of excess returns
  # Well now due to the lag we go from 2001 to 2025 therefore we have 
  # a 25 row matrix. 
  # However i have 6 columns since one colum has the years included in case
  # i need it for later coding