/****************************************************************************************
 UAS SURVIVAL ANALYSIS - HEART FAILURE DATASET
 Nama  : Mohammad Maliki Rafli
 NIM   : 291251025
 Prodi : S2 Kesehatan Masyarakat - Peminatan Biostatistika
 Dosen : Sigit A. Saputro, S.KM., M.Kes. Ph.D. (D.Sc.H)
 Dataset: 03_Data/heart_failure_clinical_records.csv

 Catatan penting:
 1. Karena NIM 291251025 adalah NIM gasal, dataset yang digunakan adalah Heart Failure.
 2. Jalankan do-file dari root folder repository agar seluruh path relatif berfungsi.
 3. Do-file menyimpan data hasil cleaning, grafik, dan log SMCL di folder 04_Output.
 4. File SMCL akan muncul setelah do-file dijalankan di Stata:
    04_Output/heart_failure_survival_analysis.smcl
****************************************************************************************/

clear all
set more off
capture log close

capture mkdir "04_Output"
log using "04_Output/heart_failure_survival_analysis.smcl", replace smcl

import delimited "03_Data/heart_failure_clinical_records.csv", clear varnames(1) case(preserve)
capture rename DEATH_EVENT death_event
compress

describe
count
misstable summarize
duplicates report

label variable age "Age in years"
label variable anaemia "Anaemia: 1=yes, 0=no"
label variable creatinine_phosphokinase "Creatinine phosphokinase (mcg/L)"
label variable diabetes "Diabetes: 1=yes, 0=no"
label variable ejection_fraction "Ejection fraction (%)"
label variable high_blood_pressure "High blood pressure: 1=yes, 0=no"
label variable platelets "Platelets"
label variable serum_creatinine "Serum creatinine (mg/dL)"
label variable serum_sodium "Serum sodium (mEq/L)"
label variable sex "Sex: 1=male, 0=female"
label variable smoking "Smoking: 1=yes, 0=no"
label variable time "Follow-up time in days"
label variable death_event "Death event: 1=dead, 0=censored/alive"

label define yesno 0 "No" 1 "Yes", replace
label define sexlbl 0 "Female" 1 "Male", replace
label values anaemia yesno
label values diabetes yesno
label values high_blood_pressure yesno
label values smoking yesno
label values death_event yesno
label values sex sexlbl

generate cpk_100 = creatinine_phosphokinase/100
label variable cpk_100 "Creatinine phosphokinase per 100 mcg/L"
generate platelets_100k = platelets/100000
label variable platelets_100k "Platelets per 100,000"

generate age_ge60 = age >= 60 if !missing(age)
label variable age_ge60 "Age >=60 years"
label values age_ge60 yesno

generate ef_low40 = ejection_fraction < 40 if !missing(ejection_fraction)
label variable ef_low40 "Ejection fraction <40%"
label values ef_low40 yesno

generate creatinine_high = serum_creatinine > 1.5 if !missing(serum_creatinine)
label variable creatinine_high "Serum creatinine >1.5 mg/dL"
label values creatinine_high yesno

generate sodium_low135 = serum_sodium < 135 if !missing(serum_sodium)
label variable sodium_low135 "Serum sodium <135 mEq/L"
label values sodium_low135 yesno

save "04_Output/heart_failure_clean.dta", replace

summarize age creatinine_phosphokinase ejection_fraction platelets serum_creatinine serum_sodium time, detail

tabulate anaemia
tabulate diabetes
tabulate high_blood_pressure
tabulate sex
tabulate smoking
tabulate death_event

tabstat age creatinine_phosphokinase ejection_fraction platelets serum_creatinine serum_sodium time, by(death_event) statistics(n mean sd median p25 p75 min max) columns(statistics)

foreach x in anaemia diabetes high_blood_pressure sex smoking {
    tabulate `x' death_event, row column chi2
}

stset time, failure(death_event==1)
stsum
stci
sts list, at(30 60 90 180 270)

sts graph, survival title("Kaplan-Meier Survival Curve - Heart Failure") xtitle("Follow-up time (days)") ytitle("Survival probability") name(km_overall, replace)
graph export "04_Output/km_overall_heart_failure.png", replace width(2000)

foreach x in anaemia diabetes high_blood_pressure sex smoking age_ge60 ef_low40 creatinine_high sodium_low135 {
    sts graph, survival by(`x') title("Kaplan-Meier Curve by `x'") xtitle("Follow-up time (days)") ytitle("Survival probability") name(km_`x', replace)
    graph export "04_Output/km_`x'.png", replace width(2000)
    sts test `x'
}

foreach x in age anaemia cpk_100 diabetes ejection_fraction high_blood_pressure platelets_100k serum_creatinine serum_sodium sex smoking {
    stcox `x', efron
}

stcox age anaemia cpk_100 diabetes ejection_fraction high_blood_pressure platelets_100k serum_creatinine serum_sodium sex smoking, efron
estimates store full_model
estat phtest, detail
estat phtest

stcox age anaemia cpk_100 ejection_fraction high_blood_pressure serum_creatinine serum_sodium, efron
estimates store final_model
estat phtest, detail
estat phtest

log close
