# Medicaid State Drug Utilization, 1991 to 2020

This project seeks to normalize the state drug utilization data that is publicly available on the Department of Health and Human Service's website (https://data.medicaid.gov/)

# Data Sources

1. https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html (publicly available)
2. https://www.ibm.com/products/micromedex-red-book (purchase required)

# Methodology

1. All analyses are conducted in R using the following packages: 
```
library(anytime)
library(dplyr)
library(ggplot2)
library(haven)
library(janitor)
library(purrr)
library(readr)
library(rvest)
library(stringr)
library(tidylog)
```
2. Scripts are ordered sequentially.
- 01_create-directories.R: Creates standardized set of directories used across projects.
- 02_create-examine-date-metadata.R: Pulls created date and updated date from each dataset's webpage. This picks up on whether a fresh extract needs to be pulled.
