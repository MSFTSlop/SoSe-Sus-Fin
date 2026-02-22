# ==============================================================================
# SCRIPT 2: ESG & BETA CONSTRAINED OPTIMIZATION (4x4 SYSTEM)
# ==============================================================================

Portfolio_Opt_ESG_Beta_df <- data.frame()

for (yr in optimization_years_val) {
  
  # 1. CHARACTERISTICS (Start of year 'yr' uses data from end of 'yr-1')
  esg_t  <- as.numeric(ESG_aligned_df[ESG_aligned_df$Year == (yr - 1), -1])
  beta_t <- as.numeric(Beta_aligned_df[Beta_aligned_df$Year == (yr - 1), -1])
  
  # 2. CALCULATE THE 10 SCALARS (Eq 62-71)
  A1  <- as.numeric(t(mu_final) %*% Sigma_inv %*% mu_final)
  A2  <- as.numeric(t(mu_final) %*% Sigma_inv %*% esg_t)
  A3  <- as.numeric(t(mu_final) %*% Sigma_inv %*% beta_t)
  A4  <- as.numeric(t(mu_final) %*% Sigma_inv %*% unit_vector_weights_sum)
  A5  <- as.numeric(t(esg_t) %*% Sigma_inv %*% esg_t)
  A6  <- as.numeric(t(esg_t) %*% Sigma_inv %*% beta_t)
  A7  <- as.numeric(t(esg_t) %*% Sigma_inv %*% unit_vector_weights_sum)
  A8  <- as.numeric(t(beta_t) %*% Sigma_inv %*% beta_t)
  A9  <- as.numeric(t(beta_t) %*% Sigma_inv %*% unit_vector_weights_sum)
  A10 <- as.numeric(t(unit_vector_weights_sum) %*% Sigma_inv %*% unit_vector_weights_sum)
  
  # 3. CONSTRUCT GAMMA MATRIX (Eq 76)
  Gamma_t <- matrix(c(A1, A2, A3, A4, 
                      A2, A5, A6, A7, 
                      A3, A6, A8, A9, 
                      A4, A7, A9, A10), nrow = 4, byrow = TRUE)
  
  # 4. LOOP THROUGH TARGETS
  for (target_mu in target_returns_val) {
    for (target_esg in target_esgs_val) {
      
      # Constraint Vector c
      c_vec <- c(target_mu, target_esg, target_beta_val, target_investment_val)
      
      # Solve for Lagrange Multipliers (psi)
      psi <- solve(Gamma_t) %*% c_vec 
      
      # Calculate Optimal Weights (Eq 57)
      w_t <- Sigma_inv %*% (psi[1]*mu_final + psi[2]*esg_t + 
                              psi[3]*beta_t + psi[4]*unit_vector_weights_sum)
      
      # 5. REALIZED PERFORMANCE (Year 'yr' returns)
      actual_rets  <- as.numeric(Ret_aligned_df[Ret_aligned_df$Year == yr, -1])
      realized_ret <- sum(w_t * actual_rets)
      
      Portfolio_Opt_ESG_Beta_df <- rbind(Portfolio_Opt_ESG_Beta_df, data.frame(
        Year = yr, Target_Ret = target_mu, Target_ESG = target_esg, Realized_Ret = realized_ret
      ))
    }
  }
}
message("ESG and Beta constrained Portfolio Choice cleared; Next Step: Removing ESG constraint and redo calculation")