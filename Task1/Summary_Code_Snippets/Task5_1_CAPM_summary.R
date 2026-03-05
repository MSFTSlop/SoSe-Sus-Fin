# SUMMARY TABLE ---

CAPM_Summary <- data.frame(
  Portfolio = c("Beta", "ESG", "Uncertainty"),
  Alpha     = c(res_beta$coef[1], res_esg$coef[1], res_unc$coef[1]),
  t_Alpha   = c(res_beta$t[1],    res_esg$t[1],    res_unc$t[1]),
  Beta      = c(res_beta$coef[2], res_esg$coef[2], res_unc$coef[2]),
  t_Beta    = c(res_beta$t[2],    res_esg$t[2],    res_unc$t[2])
)

# Decision Rule: Is Alpha significant?
CAPM_Summary$CAPM_Fails <- ifelse(abs(CAPM_Summary$t_Alpha) > 2, "YES", "NO")

print(CAPM_Summary)

# Cleanup
rm(res_beta, res_esg, res_unc)