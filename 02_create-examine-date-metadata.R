#-----------------------------------------------------------------------------------------------------------------#
#                                                                                                                 #
# PROJECT: MEDICAID DRUG UTILIZATION		                                                                          #
# AUTHOR: MICHAEL MAGUIRE, MS, DMA II                                                                             #
# INSTITUTION: UNIVERSITY OF FLORIDA, COLLEGE OF PHARMACY                                                         #
# DEPARTMENT: PHARMACEUTICAL OUTCOMES AND POLICY                                                                  #
# SUPERVISORS: AMIE GOODIN, PHD, MPP | JUAN HINCAPIE-CASTILLO, PHARMD, PHD, MS                                    #
# SCRIPT: 02_create-examine-date-metadata.R                                                                			  #
#                                                                                                                 #
#                                                                                                                 #
# Notes:                                                                                                          #
# This script is intended to check whether the files have been updated.                                           #
# If the dates have been updated on the website, the data needs to be refreshed.                                  #
# If it hasn't been updated, data does not need to be refreshed.                                                  #
#                                                                                                                 #
#-----------------------------------------------------------------------------------------------------------------#

## Load packages.

library(anytime)
library(tidyverse)
library(rvest)

## Store URL's in a vector.

urls <-
  c("https://data.medicaid.gov/api/views/va5y-jhsv/rows.csv?accessType=DOWNLOAD", # 2020
    "https://data.medicaid.gov/api/views/qnsz-yp89/rows.csv?accessType=DOWNLOAD", # 2019
    "https://data.medicaid.gov/api/views/e5ds-i36p/rows.csv?accessType=DOWNLOAD", # 2018
    "https://data.medicaid.gov/api/views/3v5r-x5x9/rows.csv?accessType=DOWNLOAD", # 2017
    "https://data.medicaid.gov/api/views/3v6v-qk5s/rows.csv?accessType=DOWNLOAD", # 2016
    "https://data.medicaid.gov/api/views/ju2h-vcgs/rows.csv?accessType=DOWNLOAD", # 2015
    "https://data.medicaid.gov/api/views/955u-9h9g/rows.csv?accessType=DOWNLOAD", # 2014
    "https://data.medicaid.gov/api/views/rkct-3tm8/rows.csv?accessType=DOWNLOAD", # 2013
    "https://data.medicaid.gov/api/views/yi2j-kk5z/rows.csv?accessType=DOWNLOAD", # 2012
    "https://data.medicaid.gov/api/views/ra84-ffhc/rows.csv?accessType=DOWNLOAD", # 2011
    "https://data.medicaid.gov/api/views/mmgn-kvy5/rows.csv?accessType=DOWNLOAD", # 2010
    "https://data.medicaid.gov/api/views/fhmx-iqs3/rows.csv?accessType=DOWNLOAD", # 2009
    "https://data.medicaid.gov/api/views/ny8j-2ymd/rows.csv?accessType=DOWNLOAD", # 2008
    "https://data.medicaid.gov/api/views/q947-frj2/rows.csv?accessType=DOWNLOAD", # 2007
    "https://data.medicaid.gov/api/views/e7is-4a3j/rows.csv?accessType=DOWNLOAD", # 2006
    "https://data.medicaid.gov/api/views/ezjn-vqh8/rows.csv?accessType=DOWNLOAD", # 2005
    "https://data.medicaid.gov/api/views/rn2y-fgjb/rows.csv?accessType=DOWNLOAD", # 2004
    "https://data.medicaid.gov/api/views/66gr-qxnr/rows.csv?accessType=DOWNLOAD", # 2003
    "https://data.medicaid.gov/api/views/5jcx-2xey/rows.csv?accessType=DOWNLOAD", # 2002
    "https://data.medicaid.gov/api/views/t5ct-xf3k/rows.csv?accessType=DOWNLOAD", # 2001
    "https://data.medicaid.gov/api/views/78qv-c4cn/rows.csv?accessType=DOWNLOAD", # 2000
    "https://data.medicaid.gov/api/views/vhg8-v7wa/rows.csv?accessType=DOWNLOAD", # 1999
    "https://data.medicaid.gov/api/views/ykva-ug36/rows.csv?accessType=DOWNLOAD", # 1998
    "https://data.medicaid.gov/api/views/c7wf-ku3w/rows.csv?accessType=DOWNLOAD", # 1997
    "https://data.medicaid.gov/api/views/jqjw-uby8/rows.csv?accessType=DOWNLOAD", # 1996
    "https://data.medicaid.gov/api/views/v83u-wwk3/rows.csv?accessType=DOWNLOAD", # 1995
    "https://data.medicaid.gov/api/views/8uti-96dw/rows.csv?accessType=DOWNLOAD", # 1994
    "https://data.medicaid.gov/api/views/iu8s-z84j/rows.csv?accessType=DOWNLOAD", # 1993
    "https://data.medicaid.gov/api/views/agzs-hwsn/rows.csv?accessType=DOWNLOAD", # 1992
    "https://data.medicaid.gov/api/views/q7kf-kjqz/rows.csv?accessType=DOWNLOAD"  # 1991
  )

## Read in metadata date file if it exists.
## If it doesn't print a message that it doesn't exist.

if (file.exists("./data/clean/url-metadata-info.csv")) {
    message("| ----------------------------------------------- |")
    message("| A metadata file exists! Loading it into memory! |")
    message("| ----------------------------------------------- |")
    existing_url_info <- read_csv(file = "./data/clean/url-metadata-info.csv")
} else {
    message("| ---------------------------------------------------- |")
    message("| A metadata file does NOT exist! One will be created! |")
    message("| ---------------------------------------------------- |")
}

## Get URL without the download link.

urls_truncated <-
  str_extract(urls, pattern = ".*[^rows.csv?accessType=DOWNLOAD]")

## Extract creation date from each HTML page. Combine into data set.

created <-
  urls_truncated %>%
  map(
    .,
    ~ read_html(.x) %>% 
      str_extract(pattern = '(?<="createdAt\" : )\\d*')
  ) %>%
  map_dfr(
    .,
    as_tibble
  )

## Extract updated date from each HTML page. Combine into a data set.

updated <-
  urls_truncated %>%
  map(
    .,
    ~ read_html(.x) %>% 
      str_extract(pattern = '(?<="rowsUpdatedAt\" : )\\d*')
  ) %>%
  map_dfr(
    .,
    as_tibble
  )

## Creating a custom function that converts an epoch time date to a regular date.

convert_to_date <- function(x) {
  as.Date(
    anytime(
      as.numeric(
        as.character(x)
      )
    ),
  format = "%m/%d/%y")
}

## Combine the above data frames along with a year identifier.

updated_and_created <-
  bind_cols(
    created, updated, years = seq(from = 2020, to = 1991, by = -1)
  ) %>%
  rename(
    created_date = value...1,
    updated_date = value...2
  ) %>%
  mutate_if(
    is.character, .funs = convert_to_date
  )

## Check for differences. 

if (exists("existing_url_info")) {
  differences <-
    existing_url_info %>%
      left_join(
        updated_and_created,
        by = "years",
        suffix = c("_old", "_new")
      ) %>%
      mutate(
        created_difference = as.numeric(created_date_old - created_date_new),
        updated_difference = as.numeric(updated_date_old - updated_date_new),
      )
  
  differences
  
  # Create object containing number of differences.
  
  summarized_differences <-
    differences %>%
    filter(created_difference != 0 | updated_difference != 0) %>%
    summarize(n = n())
  
  summarized_differences

} else {
  message("| ----------------------------------- |")
  message("| File does not exist for comparison. |")
  message("| ----------------------------------- |")
}

# If file already exists, conduct comparison.
if (exists("existing_url_info") && summarized_differences$n > 0) {
message("| ------------------------------------------------------------------------------ |")
message("| Differences exist between the previous metadata file and the current metadata. |")
message("| Results from the previous metadata file will be overwritten, and differences   |")
message("| will be documented in the metadata archive directory.                          |")
message("| ------------------------------------------------------------------------------ |")
# Overwrite file if there are differences.
write_csv(updated_and_created, file = "./data/clean/url-metadata-info.csv")
# Write out archived file with differences.
write_csv(differences, file = paste0("./data/metadata-archive/", format(Sys.Date(), "%Y%m%d"), "_url-update-history.csv"))
# If no metadata file exists, create it.
} else if (!exists("existing_url_info")) {
  message("| ------------------------------------------------------------------- |")
  message("| No file to compare. Writing a file to the clean data sub-directory. |")
  message("| ------------------------------------------------------------------- |")
  write_csv(updated_and_created, file = "./data/clean/url-metadata-info.csv")
} else {
  message("| ------------------------------------------------------------------------------------------ |")
  message("| There were no differences between the existing file and the current information available. |")
  message("| No data will be overwritten, and no archive metadata will be written.                      |")
  message("| ------------------------------------------------------------------------------------------ |")
}
