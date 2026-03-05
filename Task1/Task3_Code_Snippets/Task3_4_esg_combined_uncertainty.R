# ==============================================================================
# 04_FINAL_ESG_METRICS.R
# ==============================================================================

# Note, this code snippet comes from Gemini

# if some coments look confusing, the reason for that
# is that gemini did redundant work in script 3.3 and here
# therefore i just deleted the redundant part 

#ESG Uncertainty (Equation 10) ---

# We need the standard deviation across the 6 agencies for each company-year cell.
# We stack the matrices into a 3D array to calculate SD across the 'agency' dimension
## seems like instead of using reduce() as in equation 8 hiere building a cube
## is better.
## reduce() is for sequentilal math.
temp_array <- simplify2array(list(as.matrix(Z_A[,-1]), as.matrix(Z_B[,-1]), 
                                  as.matrix(Z_C[,-1]), as.matrix(Z_D[,-1]), 
                                  as.matrix(Z_E[,-1]), as.matrix(Z_F[,-1])))

## what essentially happens here is now we dont need an average as stated
## and just the standard deviation across the rating agencies
## gemini therefore deducted by using a cube and overlaying all z matrixes
## and using the apply, it takes a lot of work off our shoulders

### here we are looking for the spread of the normal distribution
### equation 8 looked for the middle of the stack (normalverteilung)

# apply(..., c(1,2), sd) calculates SD across the 6 agencies for every cell
## standard deviation of z-scores across rating agencies
temp_u_mat <- apply(temp_array, c(1, 2), sd)

# Create final uncertainty dataframe
ESGU_combined_df <- as.data.frame(cbind(Year = Z_A$Year, temp_u_mat))
colnames(ESGU_combined_df)[2:501] <- colnames(Z_A)[2:501]

# Final Cleanup
rm(list = ls(pattern = "temp_"))

message("Task 3.4 done; removing unnecessary dataframes")
# Note: Per your code, this removes the rating dataframes
rm(Z_A, Z_B, Z_C, Z_D, Z_E, Z_F)
# also gonna clean the current values in cache after finishing a whole task
rm(all_ratings_vector, current_year, i, keep_market_exret_columns, unique_years)

# Task states having a 25x500 matrix
  # as to why i have a 26x501 see explaination in 3.2