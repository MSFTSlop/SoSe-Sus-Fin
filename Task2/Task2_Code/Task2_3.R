# =========================================================================
# 2.3 SIGNIFICANT ALPHA RELATIVE TO EXISTING FACTORS?
# =========================================================================
# TASK: Regress the excess returns of the 7 long-short portfolios on 
# three specific asset pricing models to see if existing risk factors 
# can explain the portfolios' returns.

# --- STEP 1: Define the Target Portfolios ---
# Per instruction: "regress the excess returns of the 7 long-short portfolios"
ls_portfolios <- c(
  "ESG_Combined_LS_Sorted", "Environment_LS_Sorted", "Social_LS_Sorted", 
  "Governance_LS_Sorted", "Log_CO2_LS_Sorted", "CO2_to_Rev_LS_Sorted", "CO2_Change_LS_Sorted"
)

# --- STEP 2: Prepare the Factor Data ---
# Load the Fama-French factor dataset. 
ff_data <- FF5_Factors_annual_cleaned_df
colnames(ff_data)[colnames(ff_data) == "date"] <- "Year" # Standardize key for merging

# Build a master dataset combining all 7 LS returns with the FF factors
master_reg_data <- ff_data

for (port in ls_portfolios) {
  df <- get(port)
  # Extract only the Year and the LS Excess Return
  temp_df <- df[, c("Year", "Excess_Return_LS")]
  colnames(temp_df)[2] <- port # Rename column to the portfolio name
  
  # --- THE CRITICAL FIX: YEAR ALIGNMENT ---
  # For tasks 2.2.1 and 2.2.2, we sorted in year t and held the portfolio in year t+1. 
  # We must shift the Year + 1 so it merges with the Fama-French factors of the year 
  # the return ACTUALLY occurred.
  # Task 2.2.3 (CO2_Change) was sorted and evaluated in the SAME year, so it needs no offset.
  if (port != "CO2_Change_LS_Sorted") {
    temp_df$Year <- temp_df$Year + 1
  }
  # ----------------------------------------
  
  # Merge into the master factor dataset by Year
  master_reg_data <- merge(master_reg_data, temp_df, by = "Year", all.x = TRUE)
}

# --- STEP 3: Run the Regressions ---
# Create an empty list to store the results
results_list <- list()

# Loop through each of the 7 portfolios to run the 3 requested models
for (port in ls_portfolios) {
  
  # MODEL 1: CAPM
  # Instruction: "(1) the 'MKT' factor (market excess return), i.e. the CAPM"
  f_capm <- as.formula(paste(port, "~ Mkt.RF"))
  m_capm <- lm(f_capm, data = master_reg_data)
  
  # Extract the Alpha (Intercept) and its p-value to check for significance
  a_capm <- summary(m_capm)$coefficients[1, "Estimate"]
  p_capm <- summary(m_capm)$coefficients[1, "Pr(>|t|)"]
  
  # MODEL 2: Fama-French 3-Factor (FF3)
  # Instruction: "(2) the 'MKT', 'SMB'... and 'HML' factors"
  f_ff3 <- as.formula(paste(port, "~ Mkt.RF + SMB + HML"))
  m_ff3 <- lm(f_ff3, data = master_reg_data)
  
  a_ff3 <- summary(m_ff3)$coefficients[1, "Estimate"]
  p_ff3 <- summary(m_ff3)$coefficients[1, "Pr(>|t|)"]
  
  # MODEL 3: Fama-French 5-Factor (FF5)
  # Instruction: "(3) 'MKT', 'SMB', 'HML', 'RMW'... and 'CMA'"
  f_ff5 <- as.formula(paste(port, "~ Mkt.RF + SMB + HML + RMW + CMA"))
  m_ff5 <- lm(f_ff5, data = master_reg_data)
  
  a_ff5 <- summary(m_ff5)$coefficients[1, "Estimate"]
  p_ff5 <- summary(m_ff5)$coefficients[1, "Pr(>|t|)"]
  
  # Save the Alpha and p-values in a temporary dataframe for this portfolio
  results_list[[port]] <- data.frame(
    Portfolio = port,
    Alpha_CAPM = round(a_capm, 4), pval_CAPM = round(p_capm, 4),
    Alpha_FF3  = round(a_ff3, 4),  pval_FF3  = round(p_ff3, 4),
    Alpha_FF5  = round(a_ff5, 4),  pval_FF5  = round(p_ff5, 4)
  )
}

# --- STEP 4: Format and Report the Findings ---
# Instruction: "Report your findings in tables"
# do.call() is a function that says to R: 
# "Open up this list, take every single item inside it, and feed them all into this function as separate arguments."
Alpha_Summary_Table <- do.call(rbind, results_list)
rownames(Alpha_Summary_Table) <- NULL

# --- STEP 5: Answer the Core Question ---
# Instruction: "Do any of the models explain the average excess return?"
# Statistical Logic: If a model perfectly explains the portfolio's returns, 
# the intercept (Alpha) will be zero. If the p-value is > 0.05, we fail to 
# reject the null hypothesis that Alpha = 0, meaning the model EXPLAINS the return.
# If p-value < 0.05, Alpha is significant, meaning the portfolio has excess 
# returns the model CANNOT explain.

Alpha_Summary_Table$CAPM_Explains <- ifelse(Alpha_Summary_Table$pval_CAPM > 0.05, "Yes (Alpha=0)", "No (Sig Alpha)")
Alpha_Summary_Table$FF3_Explains  <- ifelse(Alpha_Summary_Table$pval_FF3 > 0.05, "Yes (Alpha=0)", "No (Sig Alpha)")
Alpha_Summary_Table$FF5_Explains  <- ifelse(Alpha_Summary_Table$pval_FF5 > 0.05, "Yes (Alpha=0)", "No (Sig Alpha)")

# Display the final summary table
# View(Alpha_Summary_Table)