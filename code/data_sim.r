# Data simulation code to test the effect of tillage on runoff temperature
# Created by AJ Brown, Ansley.Brown@colostate.edu
# 7 Jul 2025

library(dplyr)

set.seed(1337) # for reproducibility

#' Simulate tillage runoff temperature data, export CSV and summary
#'
#' @param n_rep Number of replicates per treatment
#' @param tillages Character vector of tillage treatment labels (length must match delta_temp_effect)
#' @param mean_inflow Mean inflow temperature (deg C)
#' @param sd_inflow SD of inflow temperature
#' @param delta_temp_effect Numeric vector of temperature effects, same order as tillages
#' @param sd_delta SD of delta_temp random error
#' @param data_path Output path for simulated CSV (default: 'data/sim_data.csv')
#' @param summary_path Output path for summary TXT (default: 'docs/sim_data_summary.txt')
#' @param seed Random seed for reproducibility (default: 1337)
#'
#' @return Invisibly returns a list with sim_data and summary_table
simulate_tillage_temp_data <- function(
    n_rep = 1000,
    tillages = c("CT", "MT", "ST"),
    mean_inflow = 15,
    sd_inflow = 1,
    delta_temp_effect = c(1.5, 1.0, 0.5),
    sd_delta = 0.3,
    data_path = "data/sim_data.csv",
    summary_path = "docs/sim_data_summary.txt",
    seed = 1337
) {
  stopifnot(length(tillages) == length(delta_temp_effect))
  
  # Ensure output directories exist
  data_dir <- dirname(data_path)
  summary_dir <- dirname(summary_path)
  if (!dir.exists(data_dir)) dir.create(data_dir, recursive = TRUE)
  if (!dir.exists(summary_dir)) dir.create(summary_dir, recursive = TRUE)
  
  set.seed(seed)
  
  # Simulate inflow temps
  inflow_temp <- rnorm(n_rep * length(tillages), mean = mean_inflow, sd = sd_inflow)
  tillage <- rep(tillages, each = n_rep)
  names(delta_temp_effect) <- tillages
  
  # Generate delta_temp per replicate, with random noise
  delta_temp <- sapply(tillage, function(trt) {
    rnorm(1, mean = delta_temp_effect[trt], sd = sd_delta)
  })
  
  outflow_temp <- inflow_temp + delta_temp
  
  sim_data <- data.frame(
    tillage = tillage,
    replicate = rep(1:n_rep, times = length(tillages)),
    inflow_temp = inflow_temp,
    outflow_temp = outflow_temp,
    delta_temp = delta_temp
  )
  
  write.csv(sim_data, file = data_path, row.names = FALSE)
  
  # Summary statistics
  if (!requireNamespace("dplyr", quietly = TRUE)) stop("dplyr package required.")
  library(dplyr)
  summary_table <- sim_data %>%
    group_by(tillage) %>%
    summarise(
      mean_inflow = mean(inflow_temp),
      sd_inflow = sd(inflow_temp),
      mean_outflow = mean(outflow_temp),
      sd_outflow = sd(outflow_temp),
      mean_delta = mean(delta_temp),
      sd_delta = sd(delta_temp),
      .groups = "drop"
    )
  print(summary_table)
  
  # Export summary
  factors_txt <- c(
    "SIMULATION PARAMETERS",
    "---------------------",
    paste("Number of replicates per treatment:", n_rep),
    paste("Tillage treatments:", paste(tillages, collapse = ", ")),
    paste("Mean inflow temp (°C):", mean_inflow),
    paste("SD inflow temp (°C):", sd_inflow),
    "Delta temp effect by treatment (°C):",
    paste(sprintf("  %s = %.2f", tillages, delta_temp_effect), collapse = "\n"),
    paste("SD of delta_temp (°C):", sd_delta),
    paste("Random seed:", seed),
    "",
    "SUMMARY TABLE",
    "-------------"
  )
  
  summary_txt <- c(
    factors_txt,
    capture.output(print(summary_table))
  )
  
  writeLines(summary_txt, summary_path)
  
  invisible(list(sim_data = sim_data, summary_table = summary_table))
}

# Example usage:
# results <- simulate_tillage_temp_data()
# sim_data <- results$sim_data
# head(sim_data)
# sim_data_summary <- results$summary_table
# print(sim_data_summary)
