# ==============================================================================
# 03_STANDARDIZE_Z.R
# ==============================================================================

# Note, the for loop is from Gemini
# the temp variables are used to temporarily safe
# variables. those get overwritten in every new run

# Define the agency suffixes for the loop
agencies <- c("A", "B", "C", "D", "E", "F")

for (k in agencies) {
  
  # 1. Fetch the raw data for the current agency (e.g., ESG_Rating_A_df)
  temp_raw_df <- get(paste0("ESG_Rating_", k, "_df"))
  
  # 2. Staging area: Isolate the Year and the 500 company return columns
  temp_years_vec <- temp_raw_df[, 1]
  temp_comp_mat  <- as.matrix(temp_raw_df[, 2:501])
  
  # 3. Apply the Z-score calculation row-wise (Year by Year)
  # scale() executes the standardization formula in two steps:
  #   - Centering: Subtracts the mean (avg) of the 500 companies so the new mean is 0.
  #   - Scaling: Divides by the standard deviation so the new spread is 1 unit.
  # This makes different agency scales (e.g., 0-100 vs 1-5) directly comparable.
  temp_z_mat <- t(apply(temp_comp_mat, 1, scale))
  
  # 4. Implement the Equation (6) exception for Agency A
  # The leading minus sign ensures high Z-scores always signal good performance.
  if (k == "A") {
    temp_z_mat <- -1 * temp_z_mat
  }
  
  # 5. Reconstruct the output with 'Year' as the first column
  temp_final_df <- as.data.frame(cbind(Year = temp_years_vec, temp_z_mat))
  
  # 6. Re-apply the original company names to the new columns
  colnames(temp_final_df)[2:501] <- colnames(temp_raw_df)[2:501]
  
  # 7. Assign to a permanent variable name (Z_A, Z_B, etc.) and save to environment
  assign(paste0("Z_", k), temp_final_df)
}

# Clean up temporary "workbench" variables to keep the environment tidy
rm(list = ls(pattern = "temp_"), agencies, k)

#message("Task 3.2 done; removing unnessessary dataframes")
rm(ESG_Rating_A_df, ESG_Rating_B_df, ESG_Rating_C_df, 
   ESG_Rating_D_df, ESG_Rating_E_df, ESG_Rating_F_df)

# The task states having a 25x500 matrix for each esg company
  # the 501 is the same as in 3.1. first column is the years
  
  # however the 26 comes from the fact that r counts from 2000 to 2025
  # usually you would say "sure those are 25 years but you forget to count
  # the start/end point. therefore you have 26 rows :P