# Violinplot ANOVA + Tukey

`generate_violinplots.R` is an end‑to‑end R script that:

- Reads every `.xlsx` file in an `input/` folder
- Runs ANOVA (and Tukey’s HSD) on `value ~ genotype * treatment` (or `value ~ genotype`)
- Generates combined violin‑box plots (TIFF) into an `output/` folder

---

## 📂 Repository Structure

```
violinplot-anova-tukey/
├─ generate_violinplots.R    # Main Rscript (executable)
├─ README.md                 # This file
├─ .gitignore                # Excludes input/, output/, *.tiff
├─ input/                    # Sample Excel files go here
└─ output/                   # Generated plots will appear here
```

## 🛠️ Prerequisites

- R (≥ 4.0)
- The script will auto‑install any missing packages from CRAN:
  `readxl`, `dplyr`, `ggplot2`, `multcompView`, `tidyr`, `tibble`, `tools`

---

## ⚡ Usage

1. **Add your data**: Drop one or more `.xlsx` files into `input/`.
2. **Prepare output folder** (the script creates it if missing):
   ```bash
   mkdir -p output
   ```
3. **Run the script**:
   ```bash
   Rscript generate_violinplots.R
   ```
4. **Check results**: TIFF plots will be in `output/`, named `<input_basename>_violinplot.tiff`.

---

## 🔍 Data Requirements

- Each Excel sheet must have at least:
  - A `genotype` column (text/levels)
  - A `value` column (numeric)
- Optional: a `treatment` column to stratify by treatment. If missing, all data are treated as a single group.

---

## 📝 Example

```bash
# Copy sample files into input/
cp examples/sample1.xlsx input/
cp examples/sample2.xlsx input/

# Run analysis
a Rscript generate_violinplots.R

# View output plots
ls output/*.tiff
```

---

## 📜 License

MIT © DibinBaby
