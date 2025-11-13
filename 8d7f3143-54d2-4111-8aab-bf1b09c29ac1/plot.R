#!/usr/bin/env Rscript

# ============================================================================
# GO Enrichment Bar Chart - Plot Generation
# Reads: extracted_solution.csv (GO enrichment data)
# Outputs: extracted_solution.jpg (multi-panel faceted bar chart)
# ============================================================================

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
})

# Read the GO enrichment data from current directory
data <- read.csv("extracted_solution.csv", stringsAsFactors = FALSE)

cat("Loaded GO enrichment data:\n")
cat("  Total terms:", nrow(data), "\n")
cat("  Categories:", paste(unique(data$Category), collapse = ", "), "\n\n")

# Convert Category to factor with specific order
data$Category <- factor(data$Category, levels = c("BP", "CC", "MF"))

# Reorder GO terms within each category by neg_log10_pvalue (descending)
# This ensures bars are ordered by significance within each panel
data <- data %>%
  group_by(Category) %>%
  arrange(Category, desc(neg_log10_pvalue)) %>%
  ungroup()

# Create factor with the ordered levels to maintain order in plot
data$GO_Term <- factor(data$GO_Term, levels = rev(data$GO_Term))

# Create the horizontal bar chart with facets
p <- ggplot(data, aes(x = neg_log10_pvalue, y = GO_Term, fill = q_value)) +
  geom_bar(stat = "identity", width = 0.7) +

  # Color gradient: blue (low q-value/high significance) to red (high q-value/low significance)
  scale_fill_gradient(
    low = "#0000CC",    # Blue for significant (low q-value)
    high = "#CC0000",   # Red for less significant (high q-value)
    name = "q value",
    breaks = c(0.025, 0.050, 0.075),
    labels = c("0.025", "0.050", "0.075")
  ) +

  # Facet by Category (BP, CC, MF) with free y-axis scales
  facet_grid(Category ~ ., scales = "free_y", space = "free_y",
             labeller = labeller(Category = c(BP = "BP", CC = "CC", MF = "MF"))) +

  # Labels
  labs(x = NULL, y = NULL) +

  # Theme customization
  theme_minimal(base_size = 11) +
  theme(
    # Axis text
    axis.text.y = element_text(size = 9, hjust = 1, color = "black"),
    axis.text.x = element_text(size = 10, color = "black"),

    # Legend
    legend.position = "right",
    legend.title = element_text(size = 10, face = "bold"),
    legend.text = element_text(size = 9),

    # Facet strips (panel labels)
    strip.text = element_text(size = 11, face = "bold", hjust = 0.95),
    strip.background = element_rect(fill = "grey90", color = "black", linewidth = 0.5),

    # Panel spacing and grid
    panel.spacing = unit(0.3, "lines"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "grey80", linewidth = 0.3),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5),

    # Plot margins
    plot.margin = margin(10, 10, 10, 10)
  ) +

  # X-axis scale
  scale_x_continuous(breaks = seq(0, 5, 1), limits = c(0, 5))

# Save the plot as JPG
ggsave(
  "extracted_solution.jpg",
  plot = p,
  width = 10,
  height = 12,
  dpi = 300,
  device = "jpeg"
)

cat("\n✓ Generated extracted_solution.jpg\n")

# Print summary statistics
cat("\nSummary by category:\n")
summary_stats <- data %>%
  group_by(Category) %>%
  summarise(
    n_terms = n(),
    avg_log10p = mean(neg_log10_pvalue),
    max_log10p = max(neg_log10_pvalue)
  )
print(summary_stats)
