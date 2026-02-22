# ==============================================================================
# 04_COMBINE_ESG.R
# ==============================================================================

# Note, this codepart is also from Gemini

# 1. Create a list of just the numeric parts (excluding Year) of your 6 Z-matrices
# We use columns 2:501 for each dataframe created in the previous step
temp_z_list <- list(Z_A[, 2:501], Z_B[, 2:501], Z_C[, 2:501], 
                    Z_D[, 2:501], Z_E[, 2:501], Z_F[, 2:501])

# 2. Calculate the average across agencies (Equation 8)
# Reduce(+) sums the dataframes element-wise; then we divide by 6
temp_s_matrix <- Reduce("+", temp_z_list) / 6

# 3. Final Normalization (Equation 9)
# We apply scale() row-wise again to ensure the final aggregate is a Z-score
# This ensures mean = 0 and SD = 1 for the final combined rating
temp_combined_z <- t(apply(temp_s_matrix, 1, scale))

# 4. Construct the final dataframe with Year in the first column
ESG_combined_df <- as.data.frame(cbind(Year = Z_A$Year, temp_combined_z))

# 5. Restore company names
colnames(ESG_combined_df)[2:501] <- colnames(Z_A)[2:501]

# Final Cleanup - removing the individual agency Z-scores to free up RAM
# message("Task 3.3 done")
rm(list = ls(pattern = "temp_"))

# Task states having one matrix of 25x500. 
  # for explaination as to why i have 26x501 check notes in 3.2
