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