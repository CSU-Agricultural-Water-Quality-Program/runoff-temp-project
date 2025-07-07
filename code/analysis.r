# Analysis of Simulated Tillage Runoff Temperature Data
# Created by AJ Brown
# 7 Jul 2025

library(ggplot2)
library(dplyr)

source("data_sim.r") # Load the data simulation function

run_sim_data <- simulate_tillage_temp_data(
  n_rep = 3,
  tillages = c("CT", "MT", "ST"),
  mean_inflow = 15,
  sd_inflow = 1,
  delta_temp_effect = c(1.5, 1.0, 0.5), # CT, MT, ST effects, respecively
  sd_delta = 0.3,
  data_path = "../data/sim_data.csv",
  summary_path = "../docs/sim_data_summary.txt",
  seed = 1337
)

# Extract sim data and check
sim_data <- run_sim_data$sim_data
# sim_data <- read.csv("../data/real_data.csv") # if you have real data, upload it as a csv here
str(sim_data)
head(sim_data)

# Extract summary stats
sumstats <- run_sim_data$summary_table
sumstats

# Boxplot of delta_temp by tillage treatment
p1 <- ggplot(sim_data, aes(x = tillage, y = delta_temp, fill = tillage)) +
        geom_boxplot(alpha = 0.6) +
        labs(title = "Runoff Temperature Change by Tillage",
             x = "Tillage Treatment",
             y = "Delta Temperature (°C)") +
        theme_minimal() +
        theme(legend.position = "none")
p1
ggsave("../docs/boxplot_delta_temp.png", p1, width = 5, height = 4, dpi = 300)

# One-way ANOVA
anova_fit <- aov(delta_temp ~ tillage, data = sim_data)
summary(anova_fit)

# Check ANOVA assumptions: residuals
par(mfrow = c(1, 2))
plot(anova_fit, which = 1) # Residuals vs Fitted
plot(anova_fit, which = 2) # Normal Q-Q

# Save images
# Anova residuals vs fitted
png("../figs/anova_residuals_vs_fitted.png", width = 700, height = 500)
plot(anova_fit, which = 1, main = "Residuals vs Fitted")
dev.off()
# Anova normal Q-Q plot
png("../figs/anova_normal_qq.png", width = 700, height = 500)
plot(anova_fit, which = 2, main = "Normal Q-Q Plot")
dev.off()

# Post-hoc Tukey HSD for pairwise comparison
tukey <- TukeyHSD(anova_fit)
print(tukey)
# Tukey HSD plot (base R)
par(mfrow = c(1, 1)) # Reset graphics layout)
plot(tukey, las = 1, col = "dodgerblue")
# Save Tukey plot
png("../figs/tukey_hsd_plot.png", width = 700, height = 500)
plot(tukey, las = 1, col = "dodgerblue")
dev.off()

# Save ANOVA and tukey results
capture.output(summary(anova_fit), file = "../docs/anova_results.txt")
capture.output(tukey, file = "../docs/tukey_hsd.txt")

# If assumptions not met (e.g., heavy tails, unequal variances), consider Kruskal-Wallis:
# kruskal.test(delta_temp ~ tillage, data = sim_data)
# # Dunn test alternative (dunn.test package)
# if (!requireNamespace("dunn.test", quietly = TRUE)) install.packages("dunn.test")
# library(dunn.test)
# dunn_results2 <- dunn.test::dunn.test(sim_data$delta_temp, sim_data$tillage, method = "bonferroni")
# print(dunn_results2)
# capture.output(dunn_results2, file = "docs/dunn_test.txt")
