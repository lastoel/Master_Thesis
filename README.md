# Master_Thesis
General repository for MSBBSS master's thesis

**Title:** Assessing the Application of Two-Step Bayesian Propensity Score Analysis to Causal Questions of National Educational Policy

**Abstract:**
The goal of this thesis is to evaluate the applicability of two-step Bayesian propensity score analysis (BPSA-2), the core methodology in Kaplan’s approach to causal inference, to address causal questions of national educational policy (Kaplan, 2016; Kaplan & Chen, 2012). Some of such policy questions require BPSA-2 to be theoretically extended to facilitate the appropriate analyses. Two extensions are proposed in this paper. Furthermore, addressing questions in which the policy varies at the national level requires the use of international, large scale data. Hence, this paper evaluates the feasibility of applying BPSA-2 and the two proposed extensions to an international, large-scale assessment dataset, namely PISA. An important result is that application of BPSA-2 to the selected dataset is computationally infeasible, when the matching algorithm specified to optimal full matching. The discussion section is dedicated to examining why this is the case and outlines a research agenda to mitigate this problem in the future.

## Structure of this repository

```
├── Analyes
|   ├── Data                          <- How to find the data used for these analyses
│   ├── Figures                       <- Figures for the manuscript 
|   ├── Scripts                       <- The scripts used for these analyses
│   └── Workspaces                    <- Output from the scripts fed to subsequent scripts
|       └── Matched partial datasets  <- Large nr. of partial datasets output by matching algorithm
├── .gitignore                        <- Omitted files
├── CITATION.md                       <- How to cite the code in this repository
├── LICENSE                           <- License for my project
├── README.md                         <- The document you are reading right now
├── Requirements.txt                  <- The packages needed to run the scripts
└── STOEL_FETC_Approval.pdf           <- Proof of ethical approval
```

## How to obtain the data used for this study
For this study, I used data from PISA 2018. These data are publicly available in the PISA database on the OECD website. Please surf to https://www.oecd.org/pisa/data/2018database/ and scroll to the header "SPSS (TM) Data Files (compressed)". Then click on the following links: 

- "Student questionnaire data file (489 MB)", which downloads a file named "SPSS-QQQ/CY07_MSU_STU_QQQ.sav"
- "Cognitive item data file (466 MB)", which downloads a file named "SPSS-COG/CY07_MSU_STU_COG.sav"

Save this files in the empty "Data" folder and keep their file names. The scripts that need these data files will call on them if placed in the right folder. 

## Guide on how to reproduce the results from this study

Run the scripts in this order: 

|Run order| File name                         | Description of functionality |
||-----------------------------------|----------------------|
|1. | `Data import.Rmd`                 | Reads in the student questionnaire and cognitive item data. Enriches those data with country level selection information. Outputs `QQQbook1_math.Rdata` and `sel_age.Rdata`. |
|2. | `Data pre-processing.Rmd`         | Calls on `QQQbook1_math.Rdata` and  `sel_age.Rdata` and processes those to create the main data frame used for step 1, outputting `step1_dat.Rdata`. Contains code for Table 1 and Table B1 from the manuscript. Computes the plausible values needed for step 2 in advance, saved as `PVs.Rdata`. |
|3. | `Step 1 - Propensity score estimation`  | Calls on `step1_dat.Rdata`. Checks pre-matching balance and performs the calculations necessary for step 1 of BPSA-2. Contains code for Table 2, Table B2, Figure 1, Figure 2 and Figures C1-C3 in Appendix C from the manuscript. Outputs four `prop_scores_xx.Rdata` files, one for each treatment assignment. |
|4. | `Intermediate - Matching Age 12 - 1-500 by 25.R` | Calls on `prop_scores_12.Rdata` and `step1_dat.Rdata` and runs the optimal full matching algorithm on the data in chunks of 25 rows of propensity scores. Outputs 20 matched datasets to the folder "Matched_partial_dataset" and the time it took to compute the matches as `comptime_fullmatch_p12_all`.|
|~ alternative| `Intermediate - Matching Ages 11-14-15 by 25.R` | Script performing the matching procedure for the three remaining treatment assignments. Not used for the manuscript due to computational time restrictions. |
|~ alternative| `Intermediate - Matching - FULL - Serverscript.Rmd`  | Script performing the matching procedure all at once across all treatment assignments. Not used for the manuscript, but made available here for those who want to run the full analysis and have a virtual machine at their disposal. Bypasses the chunks of 25 iterations. |
|5. | `Intermediate - Balance checks post matching.Rmd`  |  Imports all partial matched datasets and combines them back into one called `fullmatchdat_p12_all`. Contains code to recreate balance statistics based on old TEST data. This code can also be found in Appendix D of the manuscript. Also contains code for Table 3 from the manuscript.| 
|6. | `Step 2 - Outcome Model.Rmd`      | Calls on `fullmatchdat_p12_all.Rdata` and `PVs.Rdata` to create `step2_dat`. Estimates the outcome model, resulting in a posterior called `posterior_treat_full_p12` and stores computation time as `comptime_posterior_12`.  Also contains code for the convergence check and Table 4 of the manuscript. |
7. | `Step 2 - Outcome Model with Interaction` | Calls on the same data as `Step 2 - Outcome Model.Rmd`. Script first centers the variables and then estimates the outcome model including an interaction effect, resulting in a posterior called `posterior_treat_full_p12_int` and stores computation time as `comptime_posterior_12_int`.  Also contains code for the convergence check and Table 5 of the manuscript. |


## Ethics
Approval for the use of these data and execution of this research was granted by Utrecht University’s Faculty Ethics assessment Committee (FETC), case number 21-1939. You can find the confirmation of approval in the repository under `STOEL_FETC_Approval.pdf`


## Ownership of the repository and contact information

This study was conducted under the supervision of Marieke van Onna and Remco Feskens at Cito. This repository is and will remain publicly accessible and is managed by the author L.A. Stoel. The manuscript of this study is not yet published, but is availble on request. If you have any questions about this repository, the code or if you wish to submit a request to receive the manuscript, feel free to contact me at l.a.stoel@students.uu.nl. 


