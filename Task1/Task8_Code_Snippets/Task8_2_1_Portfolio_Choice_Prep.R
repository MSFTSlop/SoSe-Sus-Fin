# ==============================================================================
# SCRIPT 1: OPTIMIZATION TARGETS AND DATA ALIGNMENT
# ==============================================================================

# --- 1. DEFINE TARGETS ---
target_returns_val    <- seq(-0.10, 0.20, by = 0.01) 
target_esgs_val       <- c(-4, 0, 2)                 
target_beta_val       <- 1                           
target_investment_val <- 1 

# --- 2. STANDARDIZE DATA STRUCTURES ---
# This function ensures Years are a column and tickers match the Sigma format
standardize_to_sigma <- function(df, master_names) {
  df_new <- as.data.frame(df)
  
  # A. Handle Years: If 'Year' isn't a column, move Row Names to a 'Year' column
  if (!"Year" %in% colnames(df_new)) {
    df_new$Year <- as.numeric(rownames(df_new))
  }
  
  # B. Handle Suffixes: Ensure all stock columns have the "_excess" suffix
  # Strip existing suffixes first to avoid "Stock.1_excess_excess"
  current_cols <- colnames(df_new)
  tickers_only <- gsub("_excess", "", current_cols)
  
  # Re-apply suffix to everything except the Year column
  colnames(df_new) <- ifelse(tickers_only == "Year", "Year", paste0(tickers_only, "_excess"))
  
  # C. Reorder: Select only the stocks that exist in Sigma, in the correct order
  # This prevents the "undefined columns" error by checking intersection first
  valid_tickers <- intersect(master_names, colnames(df_new))
  df_aligned    <- df_new[, c("Year", valid_tickers)]
  
  return(df_aligned)
}

# --- 3. EXECUTE ALIGNMENT ---
asset_names_master <- colnames(Sigma)

ESG_aligned_df  <- standardize_to_sigma(ESG_combined_df, asset_names_master)
Beta_aligned_df <- standardize_to_sigma(stock_beta_df, asset_names_master)
Ret_aligned_df  <- standardize_to_sigma(stock_excess_return_df, asset_names_master)

# --- 4. TRIM SIGMA & MU ---
# Ensure we only use stocks present in ALL datasets
common_assets <- intersect(colnames(ESG_aligned_df)[-1], colnames(Beta_aligned_df)[-1])
common_assets <- intersect(common_assets, colnames(Ret_aligned_df)[-1])

ESG_aligned_df  <- ESG_aligned_df[, c("Year", common_assets)]
Beta_aligned_df <- Beta_aligned_df[, c("Year", common_assets)]
Ret_aligned_df  <- Ret_aligned_df[, c("Year", common_assets)]

# Update math tools to match the final asset count
Sigma_final <- Sigma[common_assets, common_assets]
mu_final    <- exp_excess_ret_mu[common_assets]

# --- 5. MATHEMATICAL TOOLS ---
optimization_years_val  <- 2001:2025
unit_vector_weights_sum <- rep(1, length(common_assets))
Sigma_inv               <- solve(Sigma_final)

message(paste("Alignment Successful! Using", length(common_assets), "stocks. Initiating Portfolio Choice."))