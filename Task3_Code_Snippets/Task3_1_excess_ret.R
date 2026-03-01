# ==============================================================================
# 02_EXCESS_RETURNS.R
# ==============================================================================

# prepare market excess return
#message("calculating the market excess return")
## market excess return is the return of one stock - risk free rate
## used merge to do vector calculation
temp_market_excess_prep <- merge(market_return_df, rfr_df, by="Year")
temp_market_excess_prep$ex_ret <- temp_market_excess_prep$Market - temp_market_excess_prep$Risk.free.rate

#message("calculation done; doing data clean up")
keep_market_exret_columns <- c("Year", "ex_ret")
market_excess_return_df <- temp_market_excess_prep[, keep_market_exret_columns]

# prepare stock excess return
#message("calculating each individual stock excess return")
temp_stock_excess_prep <- merge(stock_return_df, rfr_df, by="Year")

# Vectorized calculation: subtracting the RFR vector from the returns matrix
## started from column two because the first column has the years
## not required in market excess returrn since after merge i just subtract one column
## with the other
stock_excess_return_df <- temp_stock_excess_prep[, 2:501] - temp_stock_excess_prep$Risk.free.rate

#message("Calculation done; doing data clean up")
## added _excess to the columns for clear distinction
## bound year column to it and transformed everything into a dataframe
colnames(stock_excess_return_df) <- paste0(colnames(temp_stock_excess_prep)[2:501], "_excess")
stock_excess_return_df <- cbind(Year = temp_stock_excess_prep$Year, stock_excess_return_df)
stock_excess_return_df <- as.data.frame(stock_excess_return_df)

#message("Task 3.1 done; removing unnecessary dataframes")
rm(temp_market_excess_prep, temp_stock_excess_prep, rfr_df, market_return_df, stock_return_df)

# Task states having two final things at the end
  # one a vector of 99 years(rows) of excess market return
  # two a matrix with 99 years (rows) and 500 companies (columns) of excess stocck returns

  # Ive build a matrix of market excess return since i didnt know at the time if year as a key
  # might be useful so for now its a 99x2 matrix

  # the stock excess return is the same. its a 99x501 matrix due to the year column serving
  # as a potential key