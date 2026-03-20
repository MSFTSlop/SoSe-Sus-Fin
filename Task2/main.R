# install packages

# activate packages

# set your working directory MANUALLY to where main.R is located

# import csv data
message("importing given Datasets")
ROA_base_df <- read.csv("data/ROA.csv")
Stock_Return_base_df <- read.csv("data/StockReturns.csv")
Div_Yield_base_df <- read.csv("data/Valuation_Related/DividendYield.csv")
Market_Book_base_df <- read.csv("data/Valuation_Related/MarketBook.csv")
ROE_base_df <- read.csv("data/Profitability_Related/ROE.csv")
ROIC_base_df <- read.csv("data/Profitability_Related/ROIC.csv")
OP_Margin_base_df <- read.csv("data/Profitability_Related/OperatingMargin.csv")
CO2_base_df <- read.csv("data/ESG_Related/CO2.csv")
CO2_to_Rev_base_df <- read.csv("data/ESG_Related/CO2toRevenue.csv")
Environment_base_df <- read.csv("data/ESG_Related/Environment.csv")
Governance_base_df <- read.csv("data/ESG_Related/Governance.csv")
Social_base_df <- read.csv("data/ESG_Related/Social.csv")
ESG_Combined_base_df <- read.csv("data/ESG_Related/ESG_Combined.csv")

## the FF file had annual and monthly data -_- so AI supported me in 
## correctly exporting the necessary data while adding a "date" title
## to the first column (so that R doesnt give me an error)

# 1. Read the file as text lines to find where the split happens
lines <- readLines("data/FamaFrench5Factors.csv")

# Dynamically find the row number where the "Annual" data starts
split_idx <- grep("Annual", lines)[1]

# 2. Read the Monthly data
# skip = 3 ignores the top 3 lines of metadata. 
# nrows calculates exactly how many rows to read before hitting the blank line.
FF5_Factors_monthly_base_df <- read.csv("data/FamaFrench5Factors.csv", skip = 3, nrows = split_idx - 6)

# Rename the first column (which R usually imports as "X" due to the blank header) to "date"
colnames(FF5_Factors_monthly_base_df)[1] <- "date"

# 3. Read the Annual data
# skip = split_idx skips everything up to and including the "Annual" text row
FF5_Factors_annual_base_df <- read.csv("data/FamaFrench5Factors.csv", skip = split_idx)

# Rename the first column to "date"
colnames(FF5_Factors_annual_base_df)[1] <- "date"

# (Optional) Clean up any stray trailing blank rows at the bottom of the file
FF5_Factors_annual_base_df <- na.omit(FF5_Factors_annual_base_df)

# initial data processing
message("Start the initial Data cleanup from 2002-2023")
source("Task1_Code/Date_formatting.R")
message("Continue with the remaining data processing tasks")
source("Task1_Code/Data_preparation.R")

# starting task work
message("Looking for Trends in ESG combined and CO2 Emissions relative to rev")
source("Task2_Code/Task2_1_Code.R")
message("Portfolio Sort on Combined ESG Score, environment, social, governance, CO2, co2 to rev")
# =========================================================================
# 1. EXPLICITLY CREATE THE CHARACTERISTIC LISTS
# Run this first so R knows exactly what these objects are!
# =========================================================================
char_t_dfs <- list(
  MB_Ratio = Market_Book_cleaned_df,
  DY = Div_Yield_cleaned_df
)

char_t1_dfs <- list(
  ROE = ROE_cleaned_df,
  ROIC = ROIC_cleaned_df,
  OP_Margin = OP_Margin_cleaned_df,
  Excess_Return = Stock_Excess_Return_cleaned_df
)
## activate the function
source("Task2_Code/Task2_2_1_to_2.R")
# =========================================================================
# 3. RUN SORTS AND BUILD SUMMARY TABLE (Passing the lists explicitly)
# =========================================================================
Final_Summary_Table <- data.frame(
  Combined_ESG = test_null_ls(ESG_Combined_cleaned_df, "ESG_Combined", char_t_dfs, char_t1_dfs),
  Environment  = test_null_ls(Environment_cleaned_df, "Environment", char_t_dfs, char_t1_dfs),
  Social       = test_null_ls(Social_cleaned_df, "Social", char_t_dfs, char_t1_dfs),
  Governance   = test_null_ls(Governance_cleaned_df, "Governance", char_t_dfs, char_t1_dfs),
  Log_CO2      = test_null_ls(CO2_cleaned_df, "Log_CO2", char_t_dfs, char_t1_dfs),
  CO2_to_Rev   = test_null_ls(CO2_to_Rev_cleaned_df, "CO2_to_Rev", char_t_dfs, char_t1_dfs)
)

Final_Summary_Table <- round(Final_Summary_Table, 4)

print("Final Long-Short Portfolio Summary Table:")
print(Final_Summary_Table)

message("Special Portfolio sort for the change in LN(Co2)")
source("Task2_Code/Task2_2_3.R")
# 1. Put ALL characteristics into one list (since we treat them all as Year T now)
co2_chars_list <- list(
  ROE = ROE_cleaned_df,
  ROIC = ROIC_cleaned_df,
  OP_Margin = OP_Margin_cleaned_df,
  Excess_Return = Stock_Excess_Return_cleaned_df,
  MB_Ratio = Market_Book_cleaned_df,
  DY = Div_Yield_cleaned_df
)

# 2. Run the Analysis for CO2 Change
CO2_Change_Results <- test_null_ls_contemporaneous(
  sort_df = CO2_Change_cleaned_df, 
  sort_name = "CO2_Change", 
  all_chars_list = co2_chars_list
)

# 3. View the Results
print(CO2_Change_Results)

## short cleanup
message("Cleaning up workspace before starting into 2.3")
rm(avg_co2_rev, avg_esg, lines, n_years, split_idx, stock_cols, t, y_limits, years, 
   char_t_dfs, char_t1_dfs, Trend_Analysis_df, ROA_cleaned_df, FF5_Factors_monthly_cleaned_df,
   CO2_cleaned_df, CO2_Change_cleaned_df, CO2_to_Rev_cleaned_df, Div_Yield_cleaned_df,
   Environment_cleaned_df, Governance_cleaned_df, Social_cleaned_df, ESG_Combined_cleaned_df,
   co2_chars_list, Market_Book_cleaned_df, OP_Margin_cleaned_df, ROE_cleaned_df, ROIC_cleaned_df,
   Stock_Return_cleaned_df, Stock_Excess_Return_cleaned_df)

rownames(CO2_Change_LS_Sorted) <- NULL
rownames(CO2_to_Rev_LS_Sorted) <- NULL
rownames(Environment_LS_Sorted) <- NULL
rownames(ESG_Combined_LS_Sorted) <- NULL
rownames(Governance_LS_Sorted) <- NULL
rownames(Log_CO2_LS_Sorted) <- NULL
rownames(Social_LS_Sorted) <- NULL

# trying to find a significant alpha relative to existing factors
message("Trying to find a significant alpha in our LS-Portfolios")
source("Task2_Code/Task2_3.R")

message("Final Cleanup")
# =========================================================================
# WORKSPACE CLEANUP
# =========================================================================

# 1. Define exactly what we want to KEEP
objects_to_keep <- c(
  # The 7 Long-Short Portfolio DataFrames
  "ESG_Combined_LS_Sorted",
  "Environment_LS_Sorted",
  "Social_LS_Sorted",
  "Governance_LS_Sorted",
  "Log_CO2_LS_Sorted",
  "CO2_to_Rev_LS_Sorted",
  "CO2_Change_LS_Sorted",
  
  # The Final Result & Summary Tables
  "Final_Summary_Table",
  "Alpha_Summary_Table",
  "CO2_Change_Results",
  
  # The Master Functions (good to keep around just in case!)
  "test_null_ls",
  "test_null_ls_contemporaneous"
)

# 2. Remove everything else from the global environment
rm(list = setdiff(ls(), objects_to_keep))

# 3. Optional: Run garbage collection to free up RAM
# gc()

message("Activating CSV Exporter")
source("Exported_Results/Exporter.R")