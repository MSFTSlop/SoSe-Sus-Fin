## Code Snippet provided by gemini
# 1. Grab all objects ending in "_base_df"
all_dfs <- ls(pattern = "_base_df$")

# 2. Define the "Do Not Touch" list
exclusions <- c("Stock_Return_base_df", 
                "FF5_Factors_annual_base_df", 
                "FF5_Factors_monthly_base_df")

# 3. Filter the list to only include what we want to clean
target_dfs <- all_dfs[!(all_dfs %in% exclusions)]

for (df_name in target_dfs) {
  
  # Pull the dataframe from the environment
  temp_df <- get(df_name)
  
  # 4. Filter for years 2002 - 2023
  # Assumes the first column is numeric or can be treated as a year
  temp_df <- temp_df[temp_df[[1]] >= 2002 & temp_df[[1]] <= 2023, ]
  
  # 5. Create the "_cleaned_df" name
  new_name <- gsub("_base_df", "_cleaned_df", df_name)
  
  # 6. Assign to the new name and remove the old one
  assign(new_name, temp_df)
  rm(list = df_name)
}

# Final cleanup of the loop variables
rm(temp_df, df_name, target_dfs, all_dfs, new_name, exclusions)

## code snippet provided by AI
# 1. Define the specific two dataframes
special_dfs <- c("Stock_Return_base_df", "FF5_Factors_annual_base_df")

for (df_name in special_dfs) {
  
  # Pull the dataframe
  temp_df <- get(df_name)
  
  # 2. Identify the year column (it's either the first column or named Year/Date)
  # We'll use a regex to find which column name contains 'year' or 'date' (case insensitive)
  year_col_idx <- grep("year|date", names(temp_df), ignore.case = TRUE)[1]
  
  # 3. Extract the year and filter
  # If the column is a full date (e.g., 2002-01-01), we take the first 4 chars
  years <- as.numeric(substr(as.character(temp_df[[year_col_idx]]), 1, 4))
  
  temp_df <- temp_df[years >= 2002 & years <= 2023, ]
  
  # 4. Rename to _cleaned_df
  new_name <- gsub("_base_df", "_cleaned_df", df_name)
  
  # 5. Save and delete the old one
  assign(new_name, temp_df)
  rm(list = df_name)
}

# Cleanup loop variables
rm(temp_df, df_name, special_dfs, years, year_col_idx, new_name)

## code snippet provided by AI
# 1. Target the monthly dataframe
df_name <- "FF5_Factors_monthly_base_df"
temp_df <- get(df_name)

# 2. Extract the year from YYYYMM 
# If 200201, (200201 %/% 100) = 2002
# We use grep to find the date/year column index just in case
date_idx <- grep("year|date", names(temp_df), ignore.case = TRUE)[1]
years <- temp_df[[date_idx]] %/% 100

# 3. Filter for 2002 - 2023
# This should result in 264 observations (22 years * 12 months)
temp_df <- temp_df[years >= 2002 & years <= 2023, ]

# 4. Rename and Clean up the Environment
new_name <- "FF5_Factors_monthly_cleaned_df"
assign(new_name, temp_df)
rm(FF5_Factors_monthly_base_df)

# Optional: Clean up loop variables
rm(temp_df, years, date_idx, new_name, df_name)