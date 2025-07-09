# Violinplot ANOVA + Tukey

This repository contains `generate_violinplots.R`, an end-to-end R script that:

- Reads every `.xlsx` in `input/`
- Runs ANOVA + Tukey’s HSD
- Outputs violin-boxplots as TIFFs into `output/`

## Prerequisites

R packages (installed automatically by the script):


## Usage

1. Drop your Excel files into `input/`  
2. Make sure an empty `output/` folder exists (the script will create it if not):  
   ```bash
   mkdir -p output
Rscript generate_violinplots.R
