# =========================================================================
# 2. THE UPGRADED MASTER FORMULA (With P1-P4 Audit Dataframes & Volatility)
# =========================================================================
test_null_ls <- function(sort_df, sort_name, chars_t, chars_t1) {
  
  years <- sort_df$Year
  n_years <- length(years) - 1 
  var_names <- c("ROE", "ROIC", "OP_Margin", "Excess_Return", "MB_Ratio", "DY")
  
  # --- UPGRADE: Create dynamic column names for the 30-column Master Audit Matrix ---
  # This generates columns like: "ROE_P1", "ROE_P2" ... "ROE_LS" for all 6 variables
  audit_cols <- c()
  for(v in var_names) {
    audit_cols <- c(audit_cols, paste0(v, "_P1"), paste0(v, "_P2"), 
                    paste0(v, "_P3"), paste0(v, "_P4"), paste0(v, "_LS"))
  }
  
  # Matrix to store the detailed portfolio stats for each year
  audit_matrix <- matrix(NA, nrow = n_years, ncol = length(audit_cols))
  colnames(audit_matrix) <- audit_cols
  
  # PROFESSOR'S INSTRUCTION: "sort stocks into portfolios... in year t"
  for (i in 1:n_years) {
    sort_vals <- as.numeric(sort_df[i, -1])
    names(sort_vals) <- colnames(sort_df)[-1]
    
    valid_stocks <- names(sort_vals)[!is.na(sort_vals)]
    if (length(valid_stocks) < 4) next 
    
    # Sort the remaining valid stocks from lowest to highest score
    sorted_stocks <- names(sort(sort_vals[valid_stocks], na.last = NA))
    
    Nt <- length(sorted_stocks)
    Kt <- floor(Nt / 4)
    
    # --- UPGRADE: Explicitly defining P1, P2, P3, P4 to prevent data pollution ---
    ## see formula above to calculate Kt
    p1_stocks <- sorted_stocks[1:Kt]
    p2_stocks <- sorted_stocks[(Kt + 1):(2 * Kt)]
    p3_stocks <- sorted_stocks[(2 * Kt + 1):(3 * Kt)]
    ## essentially the rest
    p4_stocks <- sorted_stocks[(3 * Kt + 1):Nt]
    
    # PROFESSOR'S INSTRUCTION: "calculate the roe, roic... of each portfolio"
    
    # 1. Variables at t+1 (We use row [i+1] and the chars_t1 list)
    # ROE
    audit_matrix[i, "ROE_P1"] <- mean(as.numeric(chars_t1$ROE[i+1, p1_stocks]), na.rm=TRUE)
    audit_matrix[i, "ROE_P2"] <- mean(as.numeric(chars_t1$ROE[i+1, p2_stocks]), na.rm=TRUE)
    audit_matrix[i, "ROE_P3"] <- mean(as.numeric(chars_t1$ROE[i+1, p3_stocks]), na.rm=TRUE)
    audit_matrix[i, "ROE_P4"] <- mean(as.numeric(chars_t1$ROE[i+1, p4_stocks]), na.rm=TRUE)
    audit_matrix[i, "ROE_LS"] <- audit_matrix[i, "ROE_P4"] - audit_matrix[i, "ROE_P1"]
    
    # ROIC
    audit_matrix[i, "ROIC_P1"] <- mean(as.numeric(chars_t1$ROIC[i+1, p1_stocks]), na.rm=TRUE)
    audit_matrix[i, "ROIC_P2"] <- mean(as.numeric(chars_t1$ROIC[i+1, p2_stocks]), na.rm=TRUE)
    audit_matrix[i, "ROIC_P3"] <- mean(as.numeric(chars_t1$ROIC[i+1, p3_stocks]), na.rm=TRUE)
    audit_matrix[i, "ROIC_P4"] <- mean(as.numeric(chars_t1$ROIC[i+1, p4_stocks]), na.rm=TRUE)
    audit_matrix[i, "ROIC_LS"] <- audit_matrix[i, "ROIC_P4"] - audit_matrix[i, "ROIC_P1"]
    
    # OP_Margin
    audit_matrix[i, "OP_Margin_P1"] <- mean(as.numeric(chars_t1$OP_Margin[i+1, p1_stocks]), na.rm=TRUE)
    audit_matrix[i, "OP_Margin_P2"] <- mean(as.numeric(chars_t1$OP_Margin[i+1, p2_stocks]), na.rm=TRUE)
    audit_matrix[i, "OP_Margin_P3"] <- mean(as.numeric(chars_t1$OP_Margin[i+1, p3_stocks]), na.rm=TRUE)
    audit_matrix[i, "OP_Margin_P4"] <- mean(as.numeric(chars_t1$OP_Margin[i+1, p4_stocks]), na.rm=TRUE)
    audit_matrix[i, "OP_Margin_LS"] <- audit_matrix[i, "OP_Margin_P4"] - audit_matrix[i, "OP_Margin_P1"]
    
    # Excess_Return
    audit_matrix[i, "Excess_Return_P1"] <- mean(as.numeric(chars_t1$Excess_Return[i+1, p1_stocks]), na.rm=TRUE)
    audit_matrix[i, "Excess_Return_P2"] <- mean(as.numeric(chars_t1$Excess_Return[i+1, p2_stocks]), na.rm=TRUE)
    audit_matrix[i, "Excess_Return_P3"] <- mean(as.numeric(chars_t1$Excess_Return[i+1, p3_stocks]), na.rm=TRUE)
    audit_matrix[i, "Excess_Return_P4"] <- mean(as.numeric(chars_t1$Excess_Return[i+1, p4_stocks]), na.rm=TRUE)
    audit_matrix[i, "Excess_Return_LS"] <- audit_matrix[i, "Excess_Return_P4"] - audit_matrix[i, "Excess_Return_P1"]
    
    # 2. Variables at t (We use row [i] and the chars_t list)
    # MB_Ratio
    audit_matrix[i, "MB_Ratio_P1"] <- mean(as.numeric(chars_t$MB_Ratio[i, p1_stocks]), na.rm=TRUE)
    audit_matrix[i, "MB_Ratio_P2"] <- mean(as.numeric(chars_t$MB_Ratio[i, p2_stocks]), na.rm=TRUE)
    audit_matrix[i, "MB_Ratio_P3"] <- mean(as.numeric(chars_t$MB_Ratio[i, p3_stocks]), na.rm=TRUE)
    audit_matrix[i, "MB_Ratio_P4"] <- mean(as.numeric(chars_t$MB_Ratio[i, p4_stocks]), na.rm=TRUE)
    audit_matrix[i, "MB_Ratio_LS"] <- audit_matrix[i, "MB_Ratio_P4"] - audit_matrix[i, "MB_Ratio_P1"]
    
    # DY
    audit_matrix[i, "DY_P1"] <- mean(as.numeric(chars_t$DY[i, p1_stocks]), na.rm=TRUE)
    audit_matrix[i, "DY_P2"] <- mean(as.numeric(chars_t$DY[i, p2_stocks]), na.rm=TRUE)
    audit_matrix[i, "DY_P3"] <- mean(as.numeric(chars_t$DY[i, p3_stocks]), na.rm=TRUE)
    audit_matrix[i, "DY_P4"] <- mean(as.numeric(chars_t$DY[i, p4_stocks]), na.rm=TRUE)
    audit_matrix[i, "DY_LS"] <- audit_matrix[i, "DY_P4"] - audit_matrix[i, "DY_P1"]
  }
  
  # USER INSTRUCTION: "...expand and save the values of each individual long 
  # short sort as a separate dataframe... with an add on of LS_Sorted"
  ls_df <- as.data.frame(audit_matrix)
  ls_df <- cbind(Year = years[1:n_years], ls_df) 
  
  new_df_name <- paste0(sort_name, "_LS_Sorted")
  assign(new_df_name, ls_df, envir = .GlobalEnv)
  
  # PROFESSOR/USER INSTRUCTION: "...test the null hypothesis that the mean 0"
  results_col <- c()
  row_labels <- c()
  
  for (v in var_names) {
    ls_col_name <- paste0(v, "_LS")
    clean_ts <- audit_matrix[, ls_col_name][!is.na(audit_matrix[, ls_col_name])]
    
    if (length(clean_ts) > 1) {
      tt <- t.test(clean_ts, mu = 0)
      m_est <- tt$estimate
      v_est <- sd(clean_ts)  # --- UPGRADE: Explicitly extracting Volatility ---
      t_stat <- tt$statistic
    } else {
      m_est <- NA
      v_est <- NA
      t_stat <- NA
    }
    
    results_col <- c(results_col, m_est, v_est, t_stat)
    row_labels <- c(row_labels, paste0("Mean_LS_", v), paste0("Vol_LS_", v), paste0("t_stat_", v))
  }
  
  names(results_col) <- row_labels
  return(results_col)
}