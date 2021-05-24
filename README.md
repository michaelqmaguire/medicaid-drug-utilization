# Medicaid State Drug Utilization, 2000-2020

This project seeks to normalize the state drug utilization data that is publicly available on the Centers for Medicare & Medicaid Services' website (https://data.medicaid.gov/)

# Data Sources

1. https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html (publicly available)
2. https://www.ibm.com/products/micromedex-red-book (license required)

# Methodology

1. All analyses are conducted in R using the following packages: 
```
library(anytime)
library(data.table)
library(hrbrthemes)
library(rvest)
library(tidyverse)
library(tidylog)
```
2. Scripts are ordered sequentially. *These folders are visible only if they (1) are not in the .gitignore file and (2) contain any files.*

- **01_create-directories.R** 
  - Creates standardized set of directories used across projects.
    - /data: contains subdirectories for the following
      - /data/raw: raw data pulled directly from website or supervisor recommendations. *These files are not available on GitHub due to space consideration.*
      - /data/clean: final datasets containing aggregated information. *These files are not available on GitHub due to space consideration.*
      - /data/metadata-archive: contains files archiving when HHS updates or creates new datasets. 
    - /functions: directory containing functions used in scripts.
    - /output: directory containing output, usually in the form of reports.
    - /plots: directory containing plots visualizing general relationships in the dataset.

- **02_create-examine-date-metadata.R**: 
  - Pulls created date and updated date from each dataset's webpage. This picks up on whether a fresh extract needs to be pulled.
 
- **03_download-files.R**
  - Script containing function to iteratively download each dataset into raw directory.

- **04_import-and-concatenate.R**
  - Script that reads each dataset in and compiles it into a single data.table object. 
  - Also contains bulk of cleaning done on the data set.
    - Following cleaning occurs here:
      - Coalesce `Suppression Used` and `Suppression` fields. CMS has issue in recent dataset where the `Suppression Used` field is misspelled as `Supression Used`. I create a new variable,         `Suppression` which combines the columns using `fcase` from `data.table`.
      - Coalesce `NDC` and `ndc` fields. Similar to the issue above, one of the field names is in lowercase, and the fields will not combine since R is case-sensitive. I'm sure there's a way to handle this, but I could not find a solution after hours of searching on Stack Overflow and the `data.table` documentation. Accordingly, the fields are coalesced.
      - Create `NumberRx` field. This field makes any `NA` field become 0, and any non-missing field default to the existing value.
      - Create `labeler_code_length` field. This field counts the number of characters in the `Labeler.Code` field in the CMS datasets. This is done to create a standardized NDC code.
      - Create `product_code_length` field. This field counts the number of characters in the `Product.Code` field in the CMS datasets. This is done to create a standardized NDC code.
      - Create `package_size_length` field. This field counts the number of characters in the `Package.Size` field in the CMS datasets. This is done to create a standardized NDC code.
      - Create `ndc_sructure` field. This field creates a variable containing the number of digits in each `labeler_code_length`, `product_code_length`, `package_size_length`. Any deviations from the standard 5-4-2 structure of an NDC code are identified and corrected to generate a standardized NDC for the match to IBM's Micromedex Red Book.
      - Create `proper_ndc` field. This field is the standardized NDC for the entire dataset. Given that leading zeroes are truncated when reading in .csv files, the `proper_ndc` field contains leading zeroes based on the `ndc_structure`.
      - Create `seqidAll` field, which represents a sequence ID for the entire dataset.
      - Create `seqidNDC` field, which represents a sequence ID for each drug.

- **05_sdud-join-with-redbook.R**
  - Script that reads in redbook file and joins it to the SDUD dataset based on `proper_ndc` and the `NDCNUM` in IBM's Red Book.

- **06_parse-final-files.R**
  - Script that brings in the final dataset and separates the joined file based on missing values. If the file has missing values on generic name, then it was in the SDUD dataset but not in Red Book. Likewise, if it's not missing, then it was present in both Redbook and the SDUD dataset.
  - This script also creates the `rxInfo` dataset, which is the dataset that I will provide you if you request any data from this dataset. This provides the NDC's for each drug in the SDUD dataset that matched to IBM's Red Book. I intentionally enclose the `proper_ndc` field in quotation marks, and I provide the `seqidNDC` to provide a simple identifier that you will send back to me.
    - This is done to minimize confusion and provide a streamlined/programmatic way for me to pull the information from the final SDUD dataset.

- **07_make-plots.R**
  - Script that plots some basic information from the final SDUD dataset. This contains a lot of aggregate information broken down by year, year and quarter, year quarter and state, etc.

- **08_create-rmarkdown-report.Rmd**
  - This .Rmd document is largely adapted from **07_make-plots.R**. Its purpose is to create the **08_create_rmarkdown_report.md** document, which provides a friendly interface to viewing the plots on GitHub.

- **08_create-rmarkdown-report.md**
  - This document provides a friendly interface to the code and plots in the dataset. It is what I will send you if you need to get a general overview of what is contained in the      dataset.

3. Disclaimer

- I am constantly tweaking and improving these scripts for efficiency and usefulness. If you notice an issue or think something can be added, please contact me via email at <michaelqmaguire2@cop.ufl.edu>.
- Exactly when CMS releases new data extracts is unclear, but it seems as though they attempt to do it quarterly. I occasionally check the status with the **02_create-examine-date-metadata.R** script or by manually checking the website. This script will alert me if the metadata has changed, and I will download the most recent.
- This document and all scripts are subject to change. 
