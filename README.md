# Heart Failure Survival Analysis

![Stata](https://img.shields.io/badge/Stata-MP%2017.0-1F77B4)
![Method](https://img.shields.io/badge/Method-Kaplan--Meier%20%26%20Cox%20Regression-0B6E4F)
![Domain](https://img.shields.io/badge/Domain-Biostatistics%20%26%20Public%20Health-2E8B57)
![Code License](https://img.shields.io/badge/Code-MIT-yellow.svg)
![Content License](https://img.shields.io/badge/Content-CC%20BY%204.0-lightgrey.svg)

A reproducible Stata project analyzing time to death among patients with heart failure using Kaplan–Meier estimation, log-rank tests, and Cox proportional hazards regression.

**Author:** Mohammad Maliki Rafli  
**Program:** Master of Public Health, Universitas Airlangga

## Project overview

The event of interest is death during follow-up, while patients without a recorded death are treated as censored. The project estimates survival probabilities, compares survival curves across clinical groups, fits univariable and multivariable Cox models, and evaluates the proportional hazards assumption.

## Research objectives

1. Describe the demographic and clinical characteristics of patients.
2. Estimate overall survival using Kaplan–Meier analysis.
3. Compare survival curves using log-rank tests.
4. Estimate crude and adjusted hazard ratios using Cox regression.
5. Assess the proportional hazards assumption using Schoenfeld residuals.

## Repository structure

```text
.
├── 02_Script/
│   └── Heart_Failure_Survival_Analysis.do
├── 03_Data/
│   └── README.md
├── .gitignore
├── CITATION.cff
├── LICENSE
├── LICENSE-CONTENT.md
└── README.md
```

The complete project package also contains the analytical report, source dataset, Stata logs, and Kaplan–Meier figures.

## Dataset

The analysis uses the **Heart Failure Clinical Records** dataset from the UCI Machine Learning Repository. It contains 299 patient records and 13 variables, including follow-up time and death-event status.

Dataset citation:

> UCI Machine Learning Repository. (2020). *Heart Failure Clinical Records* [Dataset]. https://doi.org/10.24432/C5Z89R

Associated publication:

> Chicco, D., & Jurman, G. (2020). Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone. *BMC Medical Informatics and Decision Making, 20*, 16. https://doi.org/10.1186/s12911-020-1023-5

Place the dataset in `03_Data/heart_failure_clinical_records.csv` before running the analysis.

## Analytical workflow

1. Import and validate the dataset.
2. Check missing values and duplicate records.
3. Create clinically interpretable grouping variables.
4. Declare survival-time data using `stset`.
5. Estimate Kaplan–Meier survival probabilities.
6. Perform log-rank tests.
7. Fit univariable Cox models.
8. Fit full and parsimonious multivariable Cox models.
9. Test the proportional hazards assumption.
10. Export logs, cleaned data, and survival figures.

## Key results

| Measure | Result |
|---|---:|
| Patients | 299 |
| Deaths | 96 (32.11%) |
| Censored observations | 203 (67.89%) |
| Median follow-up | 115 days |
| Median survival | Not reached |

Final multivariable Cox model:

| Predictor | Adjusted HR | 95% CI | p-value |
|---|---:|---:|---:|
| Age, per year | 1.045 | 1.027–1.063 | <0.001 |
| Anaemia | 1.562 | 1.025–2.381 | 0.038 |
| CPK, per 100 mcg/L | 1.021 | 1.002–1.041 | 0.033 |
| Ejection fraction, per 1% | 0.954 | 0.935–0.973 | <0.001 |
| High blood pressure | 1.643 | 1.081–2.498 | 0.020 |
| Serum creatinine, per 1 mg/dL | 1.369 | 1.196–1.567 | <0.001 |
| Serum sodium, per 1 mEq/L | 0.955 | 0.913–1.000 | 0.050 |

The global Schoenfeld-residual test did not indicate a proportional hazards violation in the final model (`p = 0.3447`).

## Reproducing the analysis

```bash
git clone https://github.com/mohmalikirafli/heart-failure-survival-analysis.git
cd heart-failure-survival-analysis
```

Place the UCI CSV file at:

```text
03_Data/heart_failure_clinical_records.csv
```

Then run in Stata:

```stata
do "02_Script/Heart_Failure_Survival_Analysis.do"
```

Generated files will be written to `04_Output/`.

## Interpretation

Older age, anaemia, higher CPK, high blood pressure, and higher serum creatinine were associated with a higher hazard of death. Higher ejection fraction was associated with a lower hazard. These estimates describe associations within this dataset and should not be interpreted as causal effects or as a validated clinical prognostic model.

## Limitations

- The dataset contains only 299 records and 96 events.
- The analysis uses secondary observational data.
- Continuous predictors were modeled linearly.
- The parsimonious model was not externally validated.
- Dichotomized variables were used only for descriptive Kaplan–Meier comparisons.
- Results must not be used for diagnosis, prognosis, or treatment decisions.

## License

- Source code: [MIT License](LICENSE)
- Original repository content: [CC BY 4.0](LICENSE-CONTENT.md)
- UCI dataset: governed by its original CC BY 4.0 license and attribution requirements

---

This repository is intended for academic and portfolio purposes in biostatistics, epidemiology, and health data science.
