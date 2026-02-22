# ==============================================================================
# 14_ZSCORE_VERIFICATION.R
# ==============================================================================
message("Verifying Z-Score Standardization (Target: Mean=0, SD=1)")

# 1. Identify the years in your combined dataset
# Assuming 'ESG_Z_Score_Combined' is the result from Task 3.3
unique_years <- sort(unique(ESG_combined_df$Year))

# 2. Initialize the result dataframe
Z_Verification_Table <- data.frame(
  Year = unique_years,
  Mean_Rating = NA,
  Std_Dev = NA
)

# 3. Calculate metrics for each year across all companies
for (i in 1:length(unique_years)) {
  current_year <- unique_years[i]
  
  # Isolate all stock ratings for the specific year
  # We exclude the 'Year' column itself to calculate across companies
  year_data <- ESG_combined_df[ESG_combined_df$Year == current_year, -1]
  
  # Flatten the data to a single vector to check the total distribution for that year
  all_ratings_vector <- as.numeric(unlist(year_data))
  
  # Calculate mean and sd (ignoring NAs)
  Z_Verification_Table$Mean_Rating[i] <- mean(all_ratings_vector, na.rm = TRUE)
  Z_Verification_Table$Std_Dev[i]     <- sd(all_ratings_vector, na.rm = TRUE)
}

# 4. Final Formatting
# Rounding to 4 decimal places for professional reporting
Z_Verification_Table$Mean_Rating <- round(Z_Verification_Table$Mean_Rating, 4)
Z_Verification_Table$Std_Dev     <- round(Z_Verification_Table$Std_Dev, 4)
rownames(Z_Verification_Table) <- 2000:2025
Z_Verification_Table$Year <- NULL

# Cleanup
rm(year_data)

# --- QUICK CHECK ---
# If Mean_Rating != 0 or Std_Dev != 1, the standardization in 3.3 needs re-running.