# Master_Thesis
General repository for MSBBSS master's thesis

**Title:** Assessing the Application of Two-Step Bayesian Propensity Score Analysis to Causal Questions of National Educational Policy

**Abstract:**
The goal of this thesis is to evaluate the applicability of two-step Bayesian propensity score analysis (BPSA-2), the core methodology in Kaplan’s approach to causal inference, to address causal questions of national educational policy (Kaplan, 2016; Kaplan & Chen, 2012). Some of such policy questions require BPSA-2 to be theoretically extended to facilitate the appropriate analyses. Two extensions are proposed in this paper. Furthermore, addressing questions in which the policy varies at the national level requires the use of international, large scale data. Hence, this paper evaluates the feasibility of applying BPSA-2 and the two proposed extensions to an international, large-scale assessment dataset, namely PISA. An important result is that application of BPSA-2 to the selected dataset is computationally infeasible, when the matching algorithm specified to optimal full matching. The discussion section is dedicated to examining why this is the case and outlines a research agenda to mitigate this problem in the future.

## Structure of this repository

```
├── Analyes
|   ├── Data                      <- How to find the data used for these analyses
│   ├── Figures                   <- Figures for the manuscript 
|   ├── Scripts                   <- The scripts used for these analyses
│   └── Workspaces                <- Output from the scripts fed to subsequent scripts
├── src                           <- Source code for this project (HW)
├── .gitignore                    <- Files that are not taken into account when commiting (RO)
├── CITATION.md                   <- How to cite the code in this repository
├── LICENSE.md                    <- License for my project
├── README.md                     <- The document you are reading right now
└── requirements.txt              <- The packages needed to run the scripts

```

## How to obtain the data used for this study
For this study, I used data from PISA 2018. These data are publicly available in the PISA database on the OECD website. Please surf to https://www.oecd.org/pisa/data/2018database/ and scroll to the header "SPSS (TM) Data Files (compressed)". Then click on the following links: 

- "Student questionnaire data file (489 MB)", which downloads a file named "SPSS-QQQ/CY07_MSU_STU_QQQ.sav"
- "Cognitive item data file (466 MB)", which downloads a file named "SPSS-COG/CY07_MSU_STU_COG.sav"

Save this files in the empty "Data" folder and keep their file names. The scripts that need these data files will call on them if placed in the right folder. 

## Guide on how to reproduce the results from this study

