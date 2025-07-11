#!/usr/bin/env Rscript
# anova_violinplots.R

# Install required packages if missing
packages <- c("readxl","dplyr","ggplot2","multcompView","tidyr","tibble","tools")
install_if_missing <- function(p) {
  if (!requireNamespace(p, quietly = TRUE)) {
    install.packages(p, repos = "https://cran.rstudio.com/")
  }
}
invisible(lapply(packages, install_if_missing))

# Load libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(multcompView)
library(tidyr)
library(tibble)
library(tools)

# --- User-adjustable colors ---
colors <- c(
  "#1f78b4","#33a02c","#e31a1c","#ff7f00","#6a3d9a",
  "#b15928","#a6cee3","#b2df8a","#fb9a99","#fdbf6f"
)
# -------------------------------

# Setup folders
input_dir  <- "input"
output_dir <- "output"
if (!dir.exists(input_dir))  stop(sprintf("Input folder '%s' not found.", input_dir))
if (!dir.exists(output_dir)) dir.create(output_dir)

# Find .xlsx files in input folder
files <- list.files(path = input_dir, pattern = "\\.xlsx$", ignore.case = TRUE)
if (!length(files)) stop("No .xlsx files found in 'input' folder.")

process_file <- function(fname) {
  infile  <- file.path(input_dir, fname)
  outfile <- file.path(output_dir, paste0(file_path_sans_ext(fname), "_violinplot.tiff"))
  
  df <- read_excel(infile) %>% setNames(tolower(names(.)))
  
  # Must have genotype and value
  if (!("genotype" %in% names(df)) || !("value" %in% names(df))) {
    warning(sprintf("Skipping '%s': missing 'genotype' or 'value'.", fname)); return()
  }
  
  # Create dummy treatment if missing
  if (!("treatment" %in% names(df))) df$treatment <- "all"
  
  # Clean and factorize
  df <- df %>% mutate(
    genotype  = factor(genotype),
    treatment = factor(treatment),
    value     = as.numeric(value)
  )
  
  # Determine if multiple treatments exist
  has_tr <- nlevels(df$treatment) > 1
  
  # Define plotting group and custom order
  if (has_tr) {
    df <- df %>% mutate(group = paste(genotype, treatment, sep = ":"))
    df$group <- factor(df$group, levels = c(
      "WT:Fe", "WT:noFe",
      "4A:Fe", "4A:noFe",
      "4B:Fe", "4B:noFe"
    ))
    xlab <- "Genotype:Treatment"
  } else {
    df <- df %>% mutate(group = genotype)
    df$group <- factor(df$group, levels = c("WT", "4A", "4B"))
    xlab <- "Genotype"
  }
  
  # Run ANOVA and Tukey HSD
  if (has_tr) {
    fit   <- aov(value ~ genotype * treatment, data = df)
    tuk   <- TukeyHSD(fit, "genotype:treatment")
    pvals <- tuk[["genotype:treatment"]][, "p adj"]
  } else {
    fit   <- aov(value ~ genotype, data = df)
    tuk   <- TukeyHSD(fit, "genotype")
    pvals <- tuk$genotype[, "p adj"]
  }
  
  # Compact letters
  cl <- multcompLetters(pvals)$Letters
  letter_df <- tibble(group = names(cl), label = cl) %>%
    left_join(
      df %>% group_by(group) %>% summarize(y = max(value, na.rm = TRUE) * 1.05, .groups = "drop"),
      by = "group"
    )
  
  # Fill color setup
  geno_lv <- levels(df$genotype)
  tr_lv   <- levels(df$treatment)
  geno_pal <- setNames(colors[seq_along(geno_lv)], geno_lv)
  tr_pal   <- setNames(colors[seq_along(tr_lv)], tr_lv)
  
  if (has_tr) {
    df$fill <- factor(as.character(df$treatment), levels = names(tr_pal))
    fill_vals <- tr_pal
  } else {
    df$fill <- factor(as.character(df$genotype), levels = names(geno_pal))
    fill_vals <- geno_pal
  }
  
  # Plot
  p <- ggplot(df, aes(x = group, y = value, fill = fill)) +
    geom_violin(trim = FALSE, scale = "width", alpha = 0.6, color = NA) +
    geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.8, color = "gray20") +
    scale_fill_manual(values = fill_vals) +
    labs(x = xlab, y = "Value") +
    theme_classic(base_size = 14, base_family = "Arial") +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
      axis.text.y = element_text(size = 12),
      axis.title  = element_text(size = 14),
      panel.border = element_rect(color = "black", fill = NA)
    ) +
    geom_text(data = letter_df, aes(x = group, y = y, label = label),
              inherit.aes = FALSE, size = 5, vjust = 0)
  
  # Save TIFF
  ggsave(outfile, plot = p, device = "tiff", dpi = 600,
         width = max(6, nlevels(df$group) * 0.5 + 4), height = 5, units = "in")
}

# Run for all input files
invisible(lapply(files, process_file))
