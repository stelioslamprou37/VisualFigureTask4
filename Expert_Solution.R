# GO Enrichment Bar Chart Recreation
# Script to recreate the GO enrichment analysis plot from digitalized data
# Updated with high-resolution measurements

# Load required libraries
library(ggplot2)
library(dplyr)

# Read the digitalized data
data <- read.csv("digitalized_go_enrichment_data.csv", stringsAsFactors = FALSE)

# Convert Category to factor with specific order
data$Category <- factor(data$Category, levels = c("BP", "CC", "MF"))

# Reorder GO terms by category and value for better visualization
data$GO_Term <- factor(data$GO_Term, levels = data$GO_Term)

# Create the horizontal bar chart
p <- ggplot(data, aes(x = neg_log10_pvalue, y = GO_Term, fill = q_value)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(low = "#CC0000", high = "#0000CC", 
                      name = "q value",
                      breaks = c(0.025, 0.050, 0.075),
                      labels = c("0.025", "0.050", "0.075")) +
  facet_grid(Category ~ ., scales = "free_y", space = "free_y",
             labeller = labeller(Category = c(BP = "BP", CC = "CC", MF = "MF"))) +
  labs(x = NULL, y = NULL) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 9, hjust = 1, color = "black"),
    axis.text.x = element_text(size = 10, color = "black"),
    axis.title.x = element_text(size = 11, face = "bold"),
    legend.position = "right",
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9),
    strip.text = element_text(size = 11, face = "bold", hjust = 0.5),
    strip.background = element_rect(fill = "grey90", color = NA),
    panel.spacing = unit(0.3, "lines"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "grey80", size = 0.3),
    panel.border = element_rect(color = "black", fill = NA, size = 0.5)
  ) +
  scale_x_continuous(breaks = seq(0, 5, 1), limits = c(0, 5))

# Display the plot
print(p)

# Save the plot
ggsave("recreated_go_enrichment_plot.png", plot = p, width = 10, height = 12, dpi = 300)

cat("\n✓ Plot saved as 'recreated_go_enrichment_plot.pdf' and 'recreated_go_enrichment_plot.png'\n")

# Display summary statistics
cat("\nSummary of digitalized data:\n")
cat("Total GO terms:", nrow(data), "\n")
cat("BP terms:", sum(data$Category == "BP"), "\n")
cat("CC terms:", sum(data$Category == "CC"), "\n")
cat("MF terms:", sum(data$Category == "MF"), "\n")
cat("\nRange of -log10(p-value):", min(data$neg_log10_pvalue), "-", max(data$neg_log10_pvalue), "\n")
cat("Range of q-value:", min(data$q_value), "-", max(data$q_value), "\n")

# Display top enriched terms by category
cat("\n=== Top enriched terms by category ===\n")
cat("\nBP (Biological Process):\n")
bp_top <- data %>% filter(Category == "BP") %>% arrange(desc(neg_log10_pvalue)) %>% head(3)
print(bp_top[, c("GO_Term", "neg_log10_pvalue", "q_value")])

cat("\nCC (Cellular Component):\n")
cc_top <- data %>% filter(Category == "CC") %>% arrange(desc(neg_log10_pvalue)) %>% head(3)
print(cc_top[, c("GO_Term", "neg_log10_pvalue", "q_value")])

cat("\nMF (Molecular Function):\n")
mf_top <- data %>% filter(Category == "MF") %>% arrange(desc(neg_log10_pvalue)) %>% head(3)
print(mf_top[, c("GO_Term", "neg_log10_pvalue", "q_value")])

