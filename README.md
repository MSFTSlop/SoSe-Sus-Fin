# SoSe-Sus-Fin
Assignment1

# ESG-Beta Portfolio Optimization

> [!WARNING]
> **DISCLAIMER:** This entire program was essentially **vibe-coded**. While it follows the rigorous Lagrangian optimization frameworks found in quantitative finance, the author built this through a series of highly caffeinated architectural decisions and late-night debugging sessions. Take the results with a grain of salt (or perhaps a whole lime's worth).

## Overview
This project implements a multi-period portfolio choice problem that balances **Expected Excess Returns**, **Market Neutrality (Beta)**, and **ESG (Environmental, Social, and Governance) Targets**. 

The model uses a series of rolling-window optimizations from **2001 to 2025**, utilizing a covariance matrix ($\Sigma$) and expected returns ($\mu$) derived from historical data (1927–2000).

## Key Features
* **The 4x4 System:** Solves for optimal weights by constrained Lagrangian optimization across four dimensions: Return, ESG, Beta, and Full Investment.
* **The 3x3 Baseline:** Provides a "Beta-Only" benchmark to measure the performance impact (the "ESG tax") of sustainability constraints.
* **Robust Data Alignment:** A custom preprocessing engine that synchronizes 500+ stocks across mismatched datasets, handling suffix variations (e.g., `_excess`) and converting row-names to proper temporal columns automatically.
* **Realized Frontier Visualization:** Generates efficient frontiers based on *realized* annual performance rather than just theoretical backtests.

## Mathematical Framework
The core of the optimization relies on finding the Lagrange multipliers ($\psi$) for the system by solving:

$$c = \Gamma \psi$$

Where:
* **$c$** is the vector of targets (Return, ESG, Beta, 1).
* **$\Gamma$** is the matrix of scalars representing the intersections of stock characteristics through the Inverse Covariance Matrix ($\Sigma^{-1}$).
* Optimal weights are then derived as: 
  $$w_t
