# --- SECTION 6: IMPACT OF ESG NEWS ON RETURNS ---

# 1. Calculate ESG and ESGU News (Eq. 34 & 35)
# We subtract the score at time t (2000-2024) from t+1 (2001-2025)
# This results in a 25-row matrix representing news for 2001-2025
ESG_News_df  <- ESG_combined_df[2:26, ] - ESG_combined_df[1:25, ]
ESGU_News_df <- ESGU_combined_df[2:26, ] - ESGU_combined_df[1:25, ]

# 2. Setup storage for regression coefficients (b_k,t)
# We need 25 rows (one for each year) and 2 columns (b_ESG and b_ESGU)
b_storage <- matrix(NA, nrow = 25, ncol = 2)
colnames(b_storage) <- c("b_ESG", "b_ESGU")

# 3. Run Contemporaneous Cross-Sectional Regressions (Eq. 36)
for (t in 1:25) {
  # Realized Excess Returns for year t (2001-2025)
  # Ensure your returns_matrix corresponds to the same 25-year window
  y_ret <- stock_excess_return_mx[t, ]
  
  # News variables for year t
  x1_news <- as.numeric(ESG_News_df[t, ])
  x2_news <- as.numeric(ESGU_News_df[t, ])
  
  # Regression: R_i,t+1 = b0 + b_esg*ESGNews + b_esgu*ESGUNews + error
  model_news <- lm(y_ret ~ x1_news + x2_news)
  
  # Save the two coefficients (coefficients 2 and 3)
  b_storage[t, ] <- coef(model_news)[2:3]
}

# 4. Calculate Time-Series Average of Coefficients (Eq. 37)
mean_b <- colMeans(b_storage)

# 5. Calculate Associated T-Stats (Eq. 38)
# Formula: sqrt(T) * (Mean / SD)
sd_b <- apply(b_storage, 2, sd)
t_stats_b <- sqrt(25) * (mean_b / sd_b)

# 6. Create Results Table
News_Impact_Summary <- data.frame(
  Factor = c("ESG News", "ESG Uncertainty News"),
  Mean_Coefficient = mean_b,
  T_Statistic = t_stats_b,
  Significant = ifelse(abs(t_stats_b) > 2, "Yes", "No")
)

