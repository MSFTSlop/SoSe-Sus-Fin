# 1.1 Overwrite/Convert directly to a Matrix
# This satisfies Equation 19: Column 1 is 1s, Column 2 is Returns
X <- as.matrix(cbind(
  Alpha = 1, 
  Mkt_Ex = market_excess_return_df$ex_ret
))

# Extract the vector for the plotting code
# We filter for 2001-2025 to match the 25 rows of lambda_3f_storage
mkt_excess_v <- market_excess_return_df$ex_ret[market_excess_return_df$Year >= 2001]

# 1.2 Check dimensions (Must be 25 x 2)
if(!all(dim(X) == c(25, 2))) stop("X matrix dimensions are incorrect!")

# 2. Calculating each portfolio's Long Short (Inside the DF first)
Sorted_Beta_Portfolio_Results_df$LS_P5_minus_P1_Beta <- Sorted_Beta_Portfolio_Results_df$P5_High_Beta - Sorted_Beta_Portfolio_Results_df$P1_Low_Beta
Sorted_ESG_Portfolio_Results_df$LS_P5_minus_P1_ESG <- Sorted_ESG_Portfolio_Results_df$P5_High_ESG - Sorted_ESG_Portfolio_Results_df$P1_Low_ESG
Sorted_Uncertainty_Portfolio_Results_df$LS_P5_minus_P1_UNC <- Sorted_Uncertainty_Portfolio_Results_df$P5_High_Unc - Sorted_Uncertainty_Portfolio_Results_df$P1_Low_Unc

# 3. Creating individual 1-column matrices (Keeps names and dimensions)
Sorted_Beta_v <- as.matrix(Sorted_Beta_Portfolio_Results_df$LS_P5_minus_P1_Beta)
Sorted_ESG_v  <- as.matrix(Sorted_ESG_Portfolio_Results_df$LS_P5_minus_P1_ESG)
Sorted_Unc_v  <- as.matrix(Sorted_Uncertainty_Portfolio_Results_df$LS_P5_minus_P1_UNC)

# 4. Assigning Names (Rownames for Years, Colnames for the Factor)
year_labels <- 2001:2025
rownames(Sorted_Beta_v) <- year_labels; colnames(Sorted_Beta_v) <- "LS_Beta"
rownames(Sorted_ESG_v)  <- year_labels; colnames(Sorted_ESG_v)  <- "LS_ESG"
rownames(Sorted_Unc_v)  <- year_labels; colnames(Sorted_Unc_v)  <- "LS_Unc"

# Expand the file to prepare for 5.2 the dataframes ESG combined, ESGU combined and stock excess return
rownames(ESG_combined_df) <- 2000:2025
rownames(ESGU_combined_df) <- 2000:2025
rownames(stock_beta_df) <- 2000:2025
rownames(stock_excess_return_df) <- 2000:2025


ESG_combined_df$Year <- NULL
ESGU_combined_df$Year <- NULL
stock_beta_df$Year <- NULL
stock_excess_return_df$Year <- NULL


# Cleanup
rm(Sorted_Beta_Portfolio_Results_df, Sorted_ESG_Portfolio_Results_df, 
   Sorted_Uncertainty_Portfolio_Results_df,
   Z_Verification_Table, Sorted_Beta_Results_Summary_df,
   Sorted_ESG_Results_Summary_df, Sorted_Uncertainty_Results_Summary_df)