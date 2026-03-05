# ==============================================================================
# CAPM_REGRESSION_ANALYSIS.R
# ==============================================================================
# VARIABLE DEFINITIONS:
# X         : Design Matrix (25x2). Col 1 = 1s (Alpha), Col 2 = Market Excess.
# Y_vector  : The Long-Short portfolio return vector (25x1).
# B_hat     : Coefficients. [1] = Alpha, [2] = Beta.
# sig2      : Residual Variance (using T - K = 23 degrees of freedom).
# t_stat    : T-statistics for the coefficients.
# ==============================================================================

# after A LOT of back and forth, gemini kinda understood what i wanted
# for a better explaination what happens in the general engine go to the
# corespoinding file Regression_engine_explaination

## we check here if capm is enough or we need another model which
## includes esg

message("Starting 5.1 CAPM Regression for Beta, ESG and ESGU")

# --- PART 1: THE GENERAL MATH ENGINE ---

run_matrix_regression <- function(Y_vector, X_matrix) {
  # B_hat = (X'X)^-1 * X'Y
  ## essentially equation 21 is being solved
  ## xtx inv just takes care of the ivnerse part
  XTX_inv <- solve(t(X_matrix) %*% X_matrix)
  ## bhat is the final vector of equation 21
  ## bhat(1) is the alpha
  ## bhat(2) is the beta
  B_hat   <- XTX_inv %*% t(X_matrix) %*% Y_vector
  
  # Residuals and Variance
  ## equation 18 is being solve here. you isolate the error term
  ## part of the return not explainable by the market
  E    <- Y_vector - (X_matrix %*% B_hat)
  ## here we have equation 23. the sum of all squared 
  ## error terms is being devided by 23 (degree of freedom adjustment)
  ## check quant from 1st semester
  sig2 <- as.numeric((t(E) %*% E) / (nrow(X_matrix) - ncol(X_matrix)))
  
  # Standard Errors and T-stats
  ## se covers equation 22 we calculate the square root of
  ## the covariance matrix (var(a,b))
  ## this is a matrix multiplication (task is a bit mixed in its explaination)
  ## aka order of formulas
  ## ok so that results in a 2x2 matrix with var(a) on 1,1
  ## and var(b) on 2,2. those are needed in equation 24 and 25
  se     <- sqrt(diag(sig2 * XTX_inv))
  ## this last formula uses vectors to calculate 24 and
  ## 25 in one go
  t_stat <- B_hat / se
  
  return(list(coef = B_hat, t = t_stat))
}

# --- PART 2: EXECUTION ---

## Sorted_x_v are the different vectors related to 
## equation 18 (our long short vectors)
## x is a design matrix with 25 rows and two columns
## first column is just 1
## second column has the market excess returns 

## some values are prepared in the data prep file. such as
## the x matrix and preparation of all the vectors and data
## manipulation (just check the file)

# Run the three regressions
res_beta <- run_matrix_regression(Sorted_Beta_v, X)
res_esg  <- run_matrix_regression(Sorted_ESG_v, X)
res_unc  <- run_matrix_regression(Sorted_Unc_v, X)
