# Analisis Survival pada Dataset Heart Failure

**Nama:** Mohammad Maliki Rafli  
**NIM:** 291251025  
**Program Studi:** S2 Kesehatan Masyarakat  
**Peminatan:** Biostatistika  
**Perangkat lunak:** Stata/MP 17.0

## 1. Pendahuluan

Analisis survival digunakan untuk mengevaluasi waktu sampai terjadinya suatu kejadian dengan mempertimbangkan observasi tersensor. Pada analisis ini, kejadian yang diamati adalah kematian pada pasien heart failure, sedangkan waktu survival dinyatakan sebagai lama follow-up dalam hari. Pasien yang tidak mengalami kematian sampai akhir pengamatan diperlakukan sebagai observasi tersensor.

Tujuan analisis adalah mendeskripsikan karakteristik pasien, mengestimasi probabilitas survival menggunakan Kaplan-Meier, membandingkan kurva survival melalui log-rank test, dan mengidentifikasi prediktor kematian menggunakan regresi Cox proportional hazards.

## 2. Data dan Metode

Dataset Heart Failure Clinical Records terdiri dari 299 pasien dan 13 variabel. Variabel `time` digunakan sebagai waktu follow-up, sedangkan `DEATH_EVENT` digunakan sebagai indikator kejadian kematian. Pemeriksaan awal menunjukkan tidak terdapat missing value maupun data duplikat.

Variabel turunan yang digunakan untuk visualisasi Kaplan-Meier meliputi usia >=60 tahun, ejection fraction <40%, serum creatinine >1,5 mg/dL, dan serum sodium <135 mEq/L. Analisis dilakukan melalui statistik deskriptif, Kaplan-Meier, log-rank test, simple Cox regression, multivariable Cox regression, dan pemeriksaan proportional hazards menggunakan Schoenfeld residual.

## 3. Hasil

### 3.1 Karakteristik pasien

Rerata usia pasien adalah 60,83 tahun dengan standar deviasi 11,89 tahun. Median waktu follow-up adalah 115 hari dengan rentang 4-285 hari. Selama follow-up terdapat 96 kematian (32,11%) dan 203 observasi tersensor (67,89%).

| Variabel numerik | Mean | SD | Median | IQR | Min-Max |
|---|---:|---:|---:|---:|---:|
| Age | 60.83 | 11.89 | 60 | 51-70 | 40-95 |
| Creatinine phosphokinase | 581.84 | 970.29 | 250 | 115-582 | 23-7861 |
| Ejection fraction | 38.08 | 11.83 | 38 | 30-45 | 14-80 |
| Serum creatinine | 1.39 | 1.03 | 1.10 | 0.90-1.40 | 0.50-9.40 |
| Serum sodium | 136.63 | 4.41 | 137 | 134-140 | 113-148 |
| Follow-up time | 130.26 | 77.61 | 115 | 73-205 | 4-285 |

### 3.2 Kaplan-Meier

Total waktu observasi adalah 38.948 patient-days dengan incidence rate kematian sekitar 2,46 per 1.000 patient-days. Median survival tidak tercapai karena probabilitas survival tetap berada di atas 0,50 sampai akhir pengamatan.

| Hari follow-up | Survival probability | 95% CI |
|---:|---:|---:|
| 30 | 0.8823 | 0.8399-0.9140 |
| 60 | 0.8172 | 0.7682-0.8569 |
| 90 | 0.7627 | 0.7092-0.8076 |
| 180 | 0.6543 | 0.5892-0.7117 |
| 270 | 0.5757 | 0.4919-0.6507 |

![Kurva Kaplan-Meier keseluruhan](../04_Output/km_overall_heart_failure.svg)

### 3.3 Log-rank test

| Variabel kelompok | Chi-square | p-value | Interpretasi |
|---|---:|---:|---|
| Anaemia | 2.73 | 0.0987 | Tidak signifikan |
| Diabetes | 0.04 | 0.8405 | Tidak signifikan |
| High blood pressure | 4.41 | 0.0358 | Signifikan |
| Sex | 0.00 | 0.9498 | Tidak signifikan |
| Smoking | 0.00 | 0.9640 | Tidak signifikan |
| Age >=60 years | 8.56 | 0.0034 | Signifikan |
| Ejection fraction <40% | 9.47 | 0.0021 | Signifikan |
| Serum creatinine >1.5 mg/dL | 39.61 | <0.001 | Signifikan |
| Serum sodium <135 mEq/L | 15.65 | 0.0001 | Signifikan |

### 3.4 Final multivariable Cox model

| Prediktor | Adjusted HR | 95% CI | p-value |
|---|---:|---:|---:|
| Age, per year | 1.045 | 1.027-1.063 | <0.001 |
| Anaemia | 1.562 | 1.025-2.381 | 0.038 |
| CPK, per 100 mcg/L | 1.021 | 1.002-1.041 | 0.033 |
| Ejection fraction, per 1% | 0.954 | 0.935-0.973 | <0.001 |
| High blood pressure | 1.643 | 1.081-2.498 | 0.020 |
| Serum creatinine, per 1 mg/dL | 1.369 | 1.196-1.567 | <0.001 |
| Serum sodium, per 1 mEq/L | 0.955 | 0.913-1.000 | 0.050 |

Setiap peningkatan usia satu tahun berkaitan dengan peningkatan hazard kematian sekitar 4,5%. Pasien dengan anaemia memiliki hazard kematian sekitar 56,2% lebih tinggi. Setiap peningkatan ejection fraction 1% berkaitan dengan penurunan hazard sekitar 4,6%, sedangkan setiap peningkatan serum creatinine 1 mg/dL berkaitan dengan peningkatan hazard sekitar 36,9%.

### 3.5 Asumsi proportional hazards

| Model | Chi-square | df | p-value global | Kesimpulan |
|---|---:|---:|---:|---|
| Model penuh | 9.46 | 11 | 0.5792 | Asumsi terpenuhi secara global |
| Model akhir | 7.86 | 7 | 0.3447 | Asumsi terpenuhi secara global |

Tidak terdapat bukti pelanggaran asumsi proportional hazards secara global.

## 4. Pembahasan

Usia merupakan prediktor konsisten dalam simple dan multivariable Cox regression. Ejection fraction yang lebih tinggi berkaitan dengan hazard kematian yang lebih rendah, sedangkan serum creatinine yang lebih tinggi berkaitan dengan hazard yang lebih besar. Pola ini juga konsisten dengan kurva Kaplan-Meier dan log-rank test.

High blood pressure, anaemia, CPK, dan serum sodium memberikan informasi prognostik tambahan pada model multivariabel. Diabetes, jenis kelamin, smoking, dan platelets tidak menunjukkan hubungan bermakna setelah dikontrol oleh prediktor klinis lain dalam dataset ini.

Hasil harus dibaca sebagai asosiasi pada dataset sekunder, bukan hubungan kausal atau model prognosis yang telah tervalidasi.

## 5. Kesimpulan

Dari 299 pasien heart failure, terdapat 96 kematian selama follow-up. Probabilitas survival menurun dari 0,8823 pada hari ke-30 menjadi 0,5757 pada hari ke-270, sedangkan median survival tidak tercapai.

Model akhir mempertahankan usia, anaemia, CPK, ejection fraction, high blood pressure, serum creatinine, dan serum sodium. Asumsi proportional hazards terpenuhi secara global.

## 6. Keterbatasan

- Jumlah sampel dan event relatif terbatas untuk pengembangan model kompleks.
- Data bersifat observasional dan sekunder.
- Bentuk hubungan nonlinear pada prediktor kontinu belum dievaluasi.
- Model akhir belum divalidasi secara eksternal.
- Kategorisasi prediktor kontinu hanya digunakan untuk visualisasi Kaplan-Meier dan dapat mengurangi informasi.
- Hasil tidak ditujukan untuk diagnosis, prognosis klinis, atau pengambilan keputusan terapi.

## 7. Reproduksibilitas

Analisis dapat direproduksi dengan menjalankan:

```stata
do "02_Script/Heart_Failure_Survival_Analysis.do"
```

Do-file menggunakan path relatif dan membaca dataset dari `03_Data/heart_failure_clinical_records.csv`.