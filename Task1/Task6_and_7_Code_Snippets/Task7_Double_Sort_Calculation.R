# ==============================================================================
# TASK 7.1: GENERATING DOUBLE-SORTED PORTFOLIOS
# ==============================================================================
# Base: Data from Task 3 (Returns, Betas, and Scores)

# --- PART 1: THE REUSABLE SORTING ENGINE ---
# This logic creates the 25 portfolios annually and extracts the Long-Short return
generate_ls_portfolio <- function(target_factor_mx, beta_mx, return_mx) {
  ls_time_series <- numeric(25)
  
  for (t in 1:25) {
    # Per instructions: Sort on year t (previous year), return in t+1
    betas_t   <- beta_mx[t, ]
    factors_t <- target_factor_mx[t, ]
    rets_next <- return_mx[t, ]
    
    # 1. First Sort: 5 Groups based on Beta (100 stocks each)
    b_ranks <- rank(betas_t, ties.method = "first")
    beta_groups <- cut(b_ranks, breaks = 5, labels = FALSE)
    
    high_groups <- numeric(5) # To hold Portfolio 5 (High Factor) from each Beta group
    low_groups  <- numeric(5)  # To hold Portfolio 1 (Low Factor) from each Beta group
    
    # 2. Second Sort: Within each of the 5 Beta groups, sort by Factor
    for (g in 1:5) {
      idx <- which(beta_groups == g) # The 100 stocks in Beta Quintile 'g'
      
      # Perform the sub-sort into 5 portfolios (20 stocks each)
      sub_factor_ranks <- rank(factors_t[idx], ties.method = "first")
      f_ranks <- cut(sub_factor_ranks, breaks = 5, labels = FALSE)
      
      # Store the returns of the extremes for the Long-Short calculation
      high_groups[g] <- mean(rets_next[idx][f_ranks == 5]) # High Factor
      low_groups[g]  <- mean(rets_next[idx][f_ranks == 1])  # Low Factor
    }
    
    # 3. Create the single long-short portfolio for year t
    # Long: Equal weighted average of the 5 high sub-groups
    # Short: Equal weighted average of the 5 low sub-groups
    ls_time_series[t] <- mean(high_groups) - mean(low_groups)
  }
  return(ls_time_series)
}

# --- PART 2: EXECUTION FOR BOTH FACTOR SETS ---

# Set A: ESG Consensus Double Sort
# Generates the 25 portfolios and returns the Long-Short series
ls_esg_returns <- generate_ls_portfolio(ESG_combined_mx, stock_beta_mx, stock_excess_return_mx)

# Set B: ESG Uncertainty (ESGU) Double Sort
# Generates the 25 portfolios and returns the Long-Short series
ls_esgu_returns <- generate_ls_portfolio(ESGU_combined_mx, stock_beta_mx, stock_excess_return_mx)