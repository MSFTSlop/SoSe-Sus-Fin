# ==============================================================================
# SCRIPT 3: BETA ONLY CONSTRAINED OPTIMIZATION (3x3 SYSTEM)
# ==============================================================================

Portfolio_Opt_Beta_Only_df <- data.frame()

for (yr in optimization_years_val) {
  
  beta_t <- as.numeric(Beta_aligned_df[Beta_aligned_df$Year == (yr - 1), -1])
  
  # Scalars for 3x3 System
  A1  <- as.numeric(t(mu_final) %*% Sigma_inv %*% mu_final)
  A3  <- as.numeric(t(mu_final) %*% Sigma_inv %*% beta_t)
  A4  <- as.numeric(t(mu_final) %*% Sigma_inv %*% unit_vector_weights_sum)
  A8  <- as.numeric(t(beta_t) %*% Sigma_inv %*% beta_t)
  A9  <- as.numeric(t(beta_t) %*% Sigma_inv %*% unit_vector_weights_sum)
  A10 <- as.numeric(t(unit_vector_weights_sum) %*% Sigma_inv %*% unit_vector_weights_sum)
  
  # Reduced Gamma Matrix
  Gamma_red <- matrix(c(A1, A3, A4, 
                        A3, A8, A9, 
                        A4, A9, A10), nrow = 3, byrow = TRUE)
  
  for (target_mu in target_returns_val) {
    c_red <- c(target_mu, target_beta_val, target_investment_val)
    psi   <- solve(Gamma_red) %*% c_red
    
    # Weights without ESG term
    w_t <- Sigma_inv %*% (psi[1]*mu_final + psi[2]*beta_t + psi[3]*unit_vector_weights_sum)
    
    actual_rets  <- as.numeric(Ret_aligned_df[Ret_aligned_df$Year == yr, -1])
    realized_ret <- sum(w_t * actual_rets)
    
    Portfolio_Opt_Beta_Only_df <- rbind(Portfolio_Opt_Beta_Only_df, data.frame(
      Year = yr, Target_Ret = target_mu, Realized_Ret = realized_ret
    ))
  }
}
message("Portfolio Choice Loops done; final step: Summary and Plotting")