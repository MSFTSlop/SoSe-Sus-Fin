#install packages

#load packages

#set WD (do it manually for now via R-Studio)

#import data
message("Importing relevant data")
market_return_df <- read.csv("Return/Market return.csv")
stock_return_df <- read.csv("Return/Stock return.csv")
rfr_df <- read.csv("Factors_Beta_RFR/Risk-free rate.csv")
ESG_Rating_A_df <- read.csv("ESG_Rating/ESG rating agency A.csv")
ESG_Rating_B_df <- read.csv("ESG_Rating/ESG rating agency B.csv")
ESG_Rating_C_df <- read.csv("ESG_Rating/ESG rating agency C.csv")
ESG_Rating_D_df <- read.csv("ESG_Rating/ESG rating agency D.csv")
ESG_Rating_E_df <- read.csv("ESG_Rating/ESG rating agency E.csv")
ESG_Rating_F_df <- read.csv("ESG_Rating/ESG rating agency F.csv")
stock_beta_df <- read.csv("Factors_Beta_RFR/Stock beta.csv")
cov_factors_df <- read.csv("Factors_Beta_RFR/Covariance_Factors.csv")

message("Start Task 3.1")
source("Task3_Code_Snippets/Task3_1_excess_ret.R")

message("Start Task 3.2")
source("Task3_Code_Snippets/Task3_2_z_score.R")

message("Start Task 3.3")
source("Task3_Code_Snippets/Task3_3_esg_combination.R")
source("Summary_Code_Snippets/Task3_3_std_dev_mean.R")

message("Task 3.3 done; Starting Task 3.4")
source("Task3_Code_Snippets/Task3_4_esg_combined_uncertainty.R")

# before going into task 4 and 5 it ssems like the data on market excess
# as well as stock excess was still from 1927. so data prep is needed

# stock excess return is needed as a 2000 to 2025 since Task 4 deals with
# a datalag to get results between 2001 and 2025
# market excess return is shortened to 2001 since in task 5 we probably
# need to do a matrix multiplication so it would be wise to get the data
# cut off and set between 2001 and 2025

# ---- Add in ------
  # due to task 8 neeeding data from 1927 to 2000 i need to create a new dataframe before shorting the old one
stock_excess_return_pre_2000_df <- stock_excess_return_df[stock_excess_return_df$Year >= 1927 & 
                                                       stock_excess_return_df$Year <= 2000, ]
# --------------------

stock_excess_return_df <- stock_excess_return_df[stock_excess_return_df$Year >= 2000 & 
                                                   stock_excess_return_df$Year <= 2025, ]
market_excess_return_df <- market_excess_return_df[market_excess_return_df$Year >= 2001 & 
                                                   market_excess_return_df$Year <= 2025, ]

message("Start Task 4 Portfolio Building")

source("Task4_Sorting_Code_Snippets/Task4_1_beta_sorting.R")
source("Summary_Code_Snippets/Task4_1_beta_summary.R")

source("Task4_Sorting_Code_Snippets/Task4_2_esg_sorting.R")
source("Summary_Code_Snippets/Task4_2_esg_summary.R")

source("Task4_Sorting_Code_Snippets/Task4_3_esgu_sorting.R")
source("Summary_Code_Snippets/Task4_3_esgu_summary.R")

message("Prepare for Task 5")
source("Task5_Code_Snippets/Task5_Data_Prep.R")

source("Task5_Code_Snippets/Task5_1_CAPM_Regression.R")
source("Summary_Code_Snippets/Task5_1_CAPM_summary.R")

source("Task5_Code_Snippets/Task5_2_ESG_Risk_Factor.R")
source("Summary_Code_Snippets/Task5_2_ESG_Risk_summary.R")

source("Task5_Code_Snippets/Task5_3_Three_Factor_Estimate.R")
source("Summary_Code_Snippets/Task5_3_Plot.R")
source("Summary_Code_Snippets/Task5_3_Stats_summary.R")

source("Task5_Code_Snippets/Task5_4_Cost_of_Capital.R")
source("Summary_Code_Snippets/Task5_4_3F_vs_CAPM.R")

message("Start Task 6 ESG News Vs Returns")
source("Task6_and_7_Code_Snippets/Task6_ESG_and_ESGU_News_Impact.R")
source("Summary_Code_Snippets/Task6_News_vs_Lamda_Risk_Premium.R")

message("Cleared out unnecessary Data and Values; Double Sort Task 7 can now start")
source("Task6_and_7_Code_Snippets/Task7_Double_Sort_Calculation.R")
source("Summary_Code_Snippets/Task7_Stats_Plots_Correlation.R")

message("Prepare for Task 8 Portfolio Choice")
source("Task8_Code_Snippets/Task8_1_Excess_Ret_Cov_mx.R")
message("Small Verification of numbers before solving the Portfolio choice")
source("Summary_Code_Snippets/Task8_1_Verification.R")

message("Start Task 8.2 solve the Portfolio Choice")
source("Task8_Code_Snippets/Task8_2_1_Portfolio_Choice_Prep.R")
source("Task8_Code_Snippets/Task8_2_2_Portfolio_Choice_ESG_Beta.R")
source("Task8_Code_Snippets/Task8_2_3_Portfolio_Choice_Beta_Only.R")
source("Summary_Code_Snippets/Task8_2_2_ESG_Beta_Summary.R")
source("Summary_Code_Snippets/Task8_2_3_Beta_Summary.R")
