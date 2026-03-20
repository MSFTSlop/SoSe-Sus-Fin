# =========================================================================
# EXPORT ALL TABLES TO CSV (DIRECT METHOD)
# =========================================================================

# 1. Export the Master Summary Tables
write.csv(Final_Summary_Table, "Exported_Results/Final_Summary_Table.csv", row.names = FALSE)
write.csv(Alpha_Summary_Table, "Exported_Results/Alpha_Summary_Table.csv", row.names = FALSE)

# 2. Export the 7 Long-Short Sorted DataFrames
write.csv(ESG_Combined_LS_Sorted, "Exported_Results/ESG_Combined_LS_Sorted.csv", row.names = FALSE)
write.csv(Environment_LS_Sorted, "Exported_Results/Environment_LS_Sorted.csv", row.names = FALSE)
write.csv(Social_LS_Sorted, "Exported_Results/Social_LS_Sorted.csv", row.names = FALSE)
write.csv(Governance_LS_Sorted, "Exported_Results/Governance_LS_Sorted.csv", row.names = FALSE)
write.csv(Log_CO2_LS_Sorted, "Exported_Results/Log_CO2_LS_Sorted.csv", row.names = FALSE)
write.csv(CO2_to_Rev_LS_Sorted, "Exported_Results/CO2_to_Rev_LS_Sorted.csv", row.names = FALSE)
write.csv(CO2_Change_LS_Sorted, "Exported_Results/CO2_Change_LS_Sorted.csv", row.names = FALSE)

# Print a confirmation and tell us where they saved!
print(paste("All CSVs successfully saved"))