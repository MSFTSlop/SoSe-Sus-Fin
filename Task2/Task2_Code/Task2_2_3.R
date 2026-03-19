# =========================================================================
# 2.2.3 CONTEMPORANEOUS MASTER FUNCTION (Same-Year Sort)
# =========================================================================
test_null_ls_contemporaneous <- function(sort_df, sort_name, all_chars_list) {
  
  # Filter for 2003 onwards as per professor's instruction
  sort_df <- sort_df[sort_df$Year >= 2003, ]
  years <- sort_df$Year
  n_years <- length(years)
  
  var_names <- names(all_chars_list)
  
  # Prepare the Audit Matrix (30 columns for P1-P4 + LS for all 6 vars)
  audit_cols <- c()
  for(v in var_names) {
    audit_cols <- c(audit_cols, paste0(v, "_P1"), paste0(v, "_P2"), 
                    paste0(v, "_P3"), paste0(v, "_P4"), paste0(v, "_LS"))
  }
  
  audit_matrix <- matrix(NA, nrow = n_years, ncol = length(audit_cols))
  colnames(audit_matrix) <- audit_cols
  
  for (i in 1:n_years) {
    sort_vals <- as.numeric(sort_df[i, -1])
    names(sort_vals) <- colnames(sort_df)[-1]
    
    valid_stocks <- names(sort_vals)[!is.na(sort_vals)]
    if (length(valid_stocks) < 4) next 
    
    sorted_stocks <- names(sort(sort_vals[valid_stocks], na.last = NA))
    Nt <- length(sorted_stocks)
    Kt <- floor(Nt / 4)
    
    # Quartile Assignment
    p1_stocks <- sorted_stocks[1:Kt]
    p2_stocks <- sorted_stocks[(Kt + 1):(2 * Kt)]
    p3_stocks <- sorted_stocks[(2 * Kt + 1):(3 * Kt)]
    p4_stocks <- sorted_stocks[(3 * Kt + 1):Nt]
    
    # CALCULATE ALL VARIABLES AT YEAR T (Contemporaneous)
    for (v in var_names) {
      char_df <- all_chars_list[[v]]
      
      # Match the year in the characteristic DF to the year in the sort DF
      year_idx <- which(char_df$Year == years[i])
      
      if(length(year_idx) > 0) {
        val_p1 <- mean(as.numeric(char_df[year_idx, p1_stocks]), na.rm=TRUE)
        val_p4 <- mean(as.numeric(char_df[year_idx, p4_stocks]), na.rm=TRUE)
        
        audit_matrix[i, paste0(v, "_P1")] <- val_p1
        audit_matrix[i, paste0(v, "_P2")] <- mean(as.numeric(char_df[year_idx, p2_stocks]), na.rm=TRUE)
        audit_matrix[i, paste0(v, "_P3")] <- mean(as.numeric(char_df[year_idx, p3_stocks]), na.rm=TRUE)
        audit_matrix[i, paste0(v, "_P4")] <- val_p4
        audit_matrix[i, paste0(v, "_LS")] <- val_p4 - val_p1
      }
    }
  }
  
  # Save the Audit Dataframe
  ls_df <- cbind(Year = years, as.data.frame(audit_matrix))
  assign(paste0(sort_name, "_LS_Sorted"), ls_df, envir = .GlobalEnv)
  
  # Generate Summary Statistics (Mean, Vol, T-stat)
  results_col <- c()
  row_labels <- c()
  
  for (v in var_names) {
    ls_col <- audit_matrix[, paste0(v, "_LS")]
    clean_ts <- ls_col[!is.na(ls_col)]
    
    if (length(clean_ts) > 1) {
      tt <- t.test(clean_ts, mu = 0)
      results_col <- c(results_col, tt$estimate, sd(clean_ts), tt$statistic)
    } else {
      results_col <- c(results_col, NA, NA, NA)
    }
    row_labels <- c(row_labels, paste0("Mean_", v), paste0("Vol_", v), paste0("t_", v))
  }
  
  names(results_col) <- row_labels
  return(results_col)
}