## code provided by AI
message("Preparing stock excess returns")
# 1. Create the new dataframe as a copy of the stock returns
Stock_Excess_Return_cleaned_df <- Stock_Return_cleaned_df

# 2. Identify the stock columns (all columns except the first one, 'Year')
# We exclude column 1 so we don't subtract the risk-free rate from the year itself!
stock_cols <- 2:ncol(Stock_Excess_Return_cleaned_df)

# 3. Subtract the Risk-Free rate (RF) from the stock returns
# R will subtract the RF vector row-by-row from each stock column
Stock_Excess_Return_cleaned_df[, stock_cols] <- Stock_Return_cleaned_df[, stock_cols] - FF5_Factors_annual_cleaned_df$RF

# 4. (Optional) Quick verification
# Let's check a known NA spot (like Meta in 2002) to ensure it's still NA
# head(Stock_Excess_Return_cleaned_df[, c("Year", "META.PLATFORMS.A")])

message("Transforming CO2 Emissions")
# Target columns (2 to end, excluding 'Year')
stock_cols <- 2:ncol(CO2_cleaned_df)

for (j in stock_cols) {
  # Formula (1): ln(CO2_i,t) = ln(1 + CO2_i,t) if non-missing
  # Formula (2): ln(CO2_i,t) = NA if missing
  
  # We use the standard log(1 + x) for better readability
  # R's log() is the natural logarithm (ln)
  CO2_cleaned_df[[j]] <- log(1 + CO2_cleaned_df[[j]])
}

# The loop naturally preserves NAs because log(1 + NA) = NA

message("Filter out outliers in ROE ROIC and Ops margin")
# List of dataframes requiring outlier removal
outlier_dfs <- c("ROE_cleaned_df", "ROIC_cleaned_df", "OP_Margin_cleaned_df")

for (df_name in outlier_dfs) {
  temp_df <- get(df_name)
  stock_cols <- 2:ncol(temp_df)
  
  for (j in stock_cols) {
    # Replace any value > 500 or < -500 with NA
    # This addresses the extreme observations mentioned in your instructions
    temp_df[[j]][temp_df[[j]] > 500 | temp_df[[j]] < -500] <- NA
  }
  
  # Save the cleaned version back to the environment
  assign(df_name, temp_df)
}

# Cleanup loop variables to keep the environment tidy
rm(temp_df, df_name, outlier_dfs, stock_cols, j)

message("manipulating MB ratios")
# 1. Target the stock columns (excluding the 'Year' column)
stock_cols <- 2:ncol(Market_Book_cleaned_df)

# 2. Replace all negative values with NA
# This looks at every cell in the stock columns and checks if it is < 0
Market_Book_cleaned_df[, stock_cols][Market_Book_cleaned_df[, stock_cols] < 0] <- NA

# 3. Quick check: find how many negative values were replaced
# (Should return 0 if the code worked)
# sum(Market_Book_cleaned_df[, stock_cols] < 0, na.rm = TRUE)

message("Creating the Change lnCO2 dataframe")
# 1. Create a new dataframe to store the changes
# We keep CO2_cleaned_df (which contains ln values) untouched
CO2_Change_cleaned_df <- CO2_cleaned_df

# 2. Identify stock columns (2 to 504)
stock_cols <- 2:ncol(CO2_Change_cleaned_df)

# -------------------------------------------------------------------------
# IMPLEMENTING FORMULAS (3) AND (4)
# -------------------------------------------------------------------------

# Formula (3): Delta ln CO2_{i, t+1} = ln CO2_{i, t+1} - ln CO2_{i, t}
# We use indexing to align 'current year' (rows 2 to 22) with 'previous year' (rows 1 to 21)

CO2_Change_cleaned_df[-1, stock_cols] <- CO2_cleaned_df[-1, stock_cols] - 
  CO2_cleaned_df[-nrow(CO2_cleaned_df), stock_cols]

# Formula (4): Delta ln CO2_{i, t+1} = NA if either ln CO2 values are missing
# NOTE: R's subtraction naturally returns NA if any input is NA. 
# No extra code is needed to satisfy Formula (4).

# -------------------------------------------------------------------------

# 3. Handle the Boundary Condition (The first year)
# Since we don't have data for 2001, the change for 2002 is undefined.
CO2_Change_cleaned_df[1, stock_cols] <- NA

# 4. (Optional) Sanity Check
# View the first 5 columns for the first 5 years
print("Year 2002 should be all NA")