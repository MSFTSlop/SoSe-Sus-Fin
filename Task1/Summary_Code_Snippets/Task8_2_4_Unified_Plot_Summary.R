# --- 2. PREPARE THE DATA ---
# Extract exactly what we need from the ESG dataframe
esg_data <- data.frame(
  Target_Ret = Summary_ESG_Beta_df$Target_Ret,
  Target_ESG = paste("ESG Target:", Summary_ESG_Beta_df$Target_ESG),
  Avg_Realized_Return = Summary_ESG_Beta_df$Avg_Realized_Return,
  Volatility = Summary_ESG_Beta_df$Volatility
)

# Do the same for the Beta-Only (Benchmark) dataframe
benchmark_data <- data.frame(
  Target_Ret = Summary_Beta_Only_df$Target_Ret,
  Target_ESG = "Unconstrained (Beta-Only)",
  Avg_Realized_Return = Summary_Beta_Only_df$Avg_Ret, 
  Volatility = Summary_Beta_Only_df$Vol               
)

# Combine both into one master dataframe
master_plot_df <- rbind(esg_data, benchmark_data)

# Sort strictly by Target Return to ensure geom_path draws smoothly from bottom to top
master_plot_df <- master_plot_df[order(master_plot_df$Target_ESG, master_plot_df$Target_Ret), ]

# Factor the Target_ESG column so the legend is in a logical order
master_plot_df$Target_ESG <- factor(master_plot_df$Target_ESG, 
                                    levels = c("ESG Target: -4", 
                                               "ESG Target: 0", 
                                               "ESG Target: 2", 
                                               "Unconstrained (Beta-Only)"))

# --- 3. CREATE THE GGPLOT ---
ggplot(master_plot_df, aes(x = Volatility, y = Avg_Realized_Return, 
                           color = Target_ESG, linetype = Target_ESG, shape = Target_ESG)) +
  
  # THE FIX: Use geom_path instead of geom_line so it traces the optimization path
  geom_path(size = 1.2) +
  geom_point(size = 2.5) +
  
  # Manually set the colors
  scale_color_manual(values = c("ESG Target: -4" = "red", 
                                "ESG Target: 0" = "blue", 
                                "ESG Target: 2" = "darkgreen", 
                                "Unconstrained (Beta-Only)" = "black")) +
  
  # Make only the benchmark line dashed
  scale_linetype_manual(values = c("ESG Target: -4" = "solid", 
                                   "ESG Target: 0" = "solid", 
                                   "ESG Target: 2" = "solid", 
                                   "Unconstrained (Beta-Only)" = "dashed")) +
  
  # Make the benchmark points triangles (17) and the rest circles (16)
  scale_shape_manual(values = c("ESG Target: -4" = 16, 
                                "ESG Target: 0" = 16, 
                                "ESG Target: 2" = 16, 
                                "Unconstrained (Beta-Only)" = 17)) +
  
  # Clean axis titles with the extra line added via \n
  labs(x = "Realized Volatility (Risk)\nBaseline (Beta Only) vs. ESG-Constrained Portfolios",
       y = "Realized Excess Return",
       title = NULL, 
       color = "Portfolio Strategy", 
       linetype = "Portfolio Strategy", 
       shape = "Portfolio Strategy") +
  
  # Apply a clean, professional theme
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",          
    legend.title = element_text(face = "bold"),
    axis.title = element_text(face = "bold"),
    panel.grid.major = element_line(color = "lightgray", linetype = "dotted"),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, size = 1) 
  )