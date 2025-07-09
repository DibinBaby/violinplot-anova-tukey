ANOVA Violin Plot Script (R)
============================

This script generates violin + box plots for genotype and treatment comparisons,
and automatically performs ANOVA + Tukey HSD, displaying group letters on the plot.

Folder Structure
----------------

Place everything inside a project folder like this:

  your_project_folder/
  ├── input/               # Put your .xlsx files here
  ├── output/              # Plots will be saved here (auto-created)
  ├── anova_violinplots.R  # The script
  └── README.txt           # This file

Input Format
------------

Each .xlsx file should contain one sheet with columns:

Type 1 – With genotype + treatment (e.g., sample1.xlsx):

    genotype   value   treatment
    --------   -----   ---------
    WT         2       Fe
    WT         4       Fe
    4A         6       Fe
    4B         7       noFe

→ The script will:
- Perform two-way ANOVA (genotype * treatment)
- Display Tukey HSD groupings above violins
- Plot x-axis in this order:
    WT:Fe, WT:noFe, 4A:Fe, 4A:noFe, 4B:Fe, 4B:noFe

Type 2 – Only genotype and value (e.g., sample2.xlsx):

    genotype   value
    --------   -----
    WT         3
    4A         5
    4B         6

→ The script performs one-way ANOVA (genotype) and plots:
    WT, 4A, 4B

Type 3 – Has treatment column but only one level (e.g., sample3.xlsx):

    genotype   value   treatment
    --------   -----   ---------
    WT         3       Fe
    4A         5       Fe
    4B         6       Fe

→ Script detects only one treatment level and switches to one-way ANOVA.

How to Run
----------

Open a terminal or RStudio terminal and run:

    Rscript anova_violinplots.R

Plots will be saved in the output/ folder as high-resolution .tiff files.

Customizing Plot Order
----------------------

To change the order of samples on the x-axis (for multi-treatment input),
edit this line in the script:

    df$group <- factor(df$group, levels = c(
      "WT:Fe", "WT:noFe",
      "4A:Fe", "4A:noFe",
      "4B:Fe", "4B:noFe"
    ))

If your input only has genotypes (no treatment), edit this instead:

    df$group <- factor(df$group, levels = c("WT", "4A", "4B"))

Changing Colors
---------------

Colors are defined near the top of the script:

    colors <- c("#1f78b4", "#33a02c", "#e31a1c", ...)

Add or remove hex color codes if you want to customize the palette.

Required R Packages
-------------------

The script automatically installs these if they are missing:

- readxl
- dplyr
- ggplot2
- multcompView
- tidyr
- tibble
- tools

written by: Dibin Baby