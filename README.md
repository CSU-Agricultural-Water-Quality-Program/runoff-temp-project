# Tillage Impacts on Agricultural Runoff Water Temperature

**Author:** Abigail Coney and [AJ Brown](https://github.com/ansleybrown1337) <br/>
**Date:** 7 July 2025

---

## Project Overview

This project investigates the impact of different tillage practices on the temperature of agricultural runoff water. The goal is to understand how varying tillage systems affect runoff water temperature, which is a significant factor in water management and environmental health.

The project includes a data simulation component that generates synthetic runoff temperature data based on specified tillage practices. This allows for rapid testing of statistical methods such as ANOVA and nonparametric tests to assess the effects of tillage on water temperature.

The simulation mimics an experiment comparing three tillage systems:
- CT: Conventional Tillage
- MT: Minimum Tillage
- ST: Strip Tillage

For each tillage level, the model generates inflow and outflow water temperatures for a specified number of replicate plots. The resulting synthetic dataset allows rapid exploration of ANOVA and nonparametric methods for detecting tillage effects.

This framework allows the user to test various statistical methods on simulated data, which can be adapted to the final, real-world data for final analysis and interpretation.

---

## How to Use

### 1. Clone or Download the Repository

Download the repository files to your local machine and set your R working directory to the project root.

---

### 2. Install Required R Packages

Open R or RStudio and install dependencies (if not already installed):

```r
install.packages(c("dplyr", "ggplot2"))
# For optional nonparametric tests:
# install.packages("FSA")
```
### 3. Run the Data Simulation Script
The `analysis.r` script simulates the data and performs the analysis. You can run it directly in R or RStudio:

```r
source("code/data_sim.r")
run_sim_data <- simulate_tillage_temp_data(
  n_rep = 1000,  # Replicates per treatment
  tillages = c("CT", "MT", "ST"),
  mean_inflow = 15,
  sd_inflow = 1,
  delta_temp_effect = c(1.5, 1.0, 0.5), # CT, MT, ST effects, respecively
  sd_delta = 0.3,
  data_path = "data/sim_data.csv",
  summary_path = "docs/sim_data_summary.txt",
  seed = 1337
)

... run the rest of the code
```
### 4. Run the analysis with real data
If you have real runoff temperature data, simply ensure that you have a CSV file named `real_data.csv` in the `data/` directory, and modify the `analysis.r` script to read this file instead of the simulated data by uncommenting line 24:

```r
# sim_data <- read.csv("../data/real_data.csv") # if you have real data, upload it as a csv here
```
The `analysis.r` script will then perform the analysis on your real data and generate outputs in the `docs/` directory.

## Analysis Methods

- **One-way ANOVA:** Tests for differences in runoff temperature change (`delta_temp`) across tillage treatments.
- **Post-hoc Tukey HSD:** Pairwise contrasts between tillage groups, with tabular and visual outputs.
- **Nonparametric alternative:** (Optional) Kruskal-Wallis test and Dunn pairwise comparisons for robustness when assumptions are violated.

---

## Reproducibility & Notes

- All simulation parameters (replicates, mean effects, SD, etc.) are user-defined and documented in the outputs.
- Analysis is fully scriptable and modular; results are reproducible.
- Assumptions for ANOVA (normality, equal variance) are checked. If violated, use the nonparametric workflow.

---

## Contact

For questions or contributions, contact **AJ Brown**  
✉️ Ansley.Brown@colostate.edu

