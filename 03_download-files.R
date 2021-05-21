#-----------------------------------------------------------------------------------------------------------------#
#                                                                                                                 #
# PROJECT: MEDICAID DRUG UTILIZATION		                                                                          #
# AUTHOR: MICHAEL MAGUIRE, MS, DMA II                                                                             #
# INSTITUTION: UNIVERSITY OF FLORIDA, COLLEGE OF PHARMACY                                                         #
# DEPARTMENT: PHARMACEUTICAL OUTCOMES AND POLICY                                                                  #
# SUPERVISORS: AMIE GOODIN, PHD, MPP | JUAN HINCAPIE-CASTILLO, PHARMD, PHD, MS                                    #
# SCRIPT: 03_download-files.R                                                                			                #
#                                                                                                                 #
#                                                                                                                 #
# Notes:                                                                                                          #
# This script is intended to pull fresh data sets from HHS's website.                                             #
# This should only be done if 02_create-examine-date-metadata.R indicates that new data sets are available.       #
# I decided to keep the downloading in its own script since it is a long process.                                 #
#                                                                                                                 #
#-----------------------------------------------------------------------------------------------------------------#

library(tidyverse)
library(tidylog)

## Store years in a vector.

years <-
  c(2020:2000)

## Create vector of file names with each year.

fileNames <-
  paste0(
    "./data/raw/us-medicaid-data-",
    years, 
    ".csv"
  )

## Create function that downloads file from each URL and saves each to data/raw directory.

dl <-
  safely(
    ~ download.file(.x, .y, mode = "wb")
  )

## Call the function.

walk2(
  urls,
  fileNames,
  dl
)
