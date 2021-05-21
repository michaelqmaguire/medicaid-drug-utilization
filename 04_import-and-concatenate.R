#-----------------------------------------------------------------------------------------------------------------#
#                                                                                                                 #
# PROJECT: MEDICAID DRUG UTILIZATION		                                                                          #
# AUTHOR: MICHAEL MAGUIRE, MS, DMA II                                                                             #
# INSTITUTION: UNIVERSITY OF FLORIDA, COLLEGE OF PHARMACY                                                         #
# DEPARTMENT: PHARMACEUTICAL OUTCOMES AND POLICY                                                                  #
# SUPERVISORS: AMIE GOODIN, PHD, MPP | JUAN HINCAPIE-CASTILLO, PHARMD, PHD, MS                                    #
# SCRIPT: 04_import-and-concatenate.R                                                        			                #
#                                                                                                                 #
#                                                                                                                 #
# Notes:                                                                                                          #
# This script is intended to read in the datasets and combine them into a single dataset.                         #
# I will also provide some general plots regarding the data.                                                      #
#                                                                                                                 #
#-----------------------------------------------------------------------------------------------------------------#

library(data.table)
library(hrbrthemes)
library(tidyverse)

## Create function to read all data sets and select columns.

sdudFreadColsSuppression <-
  function(x) {
    grep(x = colnames(fread(x)), pattern = "Suppression")
  }

sdudFreadColumnNames <-
  function(x) {
    colnames(fread(x))
  }

sapply(fileNames, sdudFreadColsSuppression)
lapply(fileNames, sdudFreadColumnNames)

sdudFreadFx <-
  function (x) {
      fread(
        x,
        check.names = TRUE,
        select = c(
          "Utilization Type" = "character",
          "Year" = "double",
          "Quarter" = "double",
          "State" = "character",
          "Suppression Used" = "logical",
          "Supression Used" = "logical", # incorrect spelling in 2020
          "NDC" = "character",
          "ndc" = "character", # case sensitivity issue,
          "Labeler Code" = "character",
          "Product Code" = "character",
          "Package Size" = "character",
          "Number of Prescriptions" = "integer"
        )
      )
  }

## Read and combine all data sets.
## Warnings are expected. Misspelling and case sensitivity issues are the reasons.

sdud <-
  rbindlist(
    lapply(
      fileNames, FUN = sdudFreadFx
    ),
    fill = TRUE
  )

warnings()

sdud

summary(sdud)

sdud[is.na(Suppression.Used)]

sdudWant <-
  sdud[
    i = (State != "XX" & Year >= 2000)
  ]

## Normalize 'Suppression' field and Convert NA's to 0 in Number of Prescriptions field.

sdudWant[
  i = ,
  j = `:=` (
    Suppression = fcase(
      Suppression.Used == "TRUE" | Supression.Used == "TRUE", "T",
      Suppression.Used == "FALSE" | Supression.Used == "FALSE", "F",
      default = "N"
    ),
    NDC = fcoalesce(
      NDC, ndc
    ),
    NumberRx = fifelse(
      !is.na(Number.of.Prescriptions),
      Number.of.Prescriptions,
      0
    ),
    labeler_code_length = nchar(Labeler.Code),
    product_code_length = nchar(Product.Code),
    package_size_length = nchar(Package.Size),
    # Drop these variables as they're no longer needed.
    Suppression.Used = NULL,
    Supression.Used = NULL,
    ndc = NULL,
    Number.of.Prescriptions = NULL
  )
][, ndc_structure := paste0(labeler_code_length, product_code_length, package_size_length)]

sdudWant[
  i = ,
  j = unique(ndc_structure)
]

sdudWant[
  i = ndc_structure == "520",
]

janitor::tabyl(sdudWant, ndc_structure)

sdudWant[
  i = ,
  j = `:=` (proper_ndc = fcase(
    ndc_structure == "542", NDC,
    ndc_structure == "541", paste0(
      Labeler.Code, 
      Product.Code, 
      paste0("0", Package.Size)
    ),
    ndc_structure == "520", paste0(
      Labeler.Code, 
      paste0("00", Product.Code),
      "00"
    ),
    ndc_structure == "530", paste0(
      Labeler.Code,
      paste0("0", Product.Code),
      "00"
    ),
    ndc_structure == "540", paste0(
      Labeler.Code,
      Product.Code,
      "00"
    ),
    ndc_structure == "532", paste0(
      Labeler.Code,
      paste0("0", Product.Code),
      Package.Size
    )
  ),
  seqidAll = seq(.N),
  Labeler.Code = NULL,
  Product.Code = NULL,
  Package.Size = NULL,
  labeler_code_length = NULL,
  product_code_length = NULL,
  package_size_length = NULL,
  NDC = NULL,
  ndc_structure = NULL
  )
][i = , j = `:=` (seqidNDC = .GRP), by = proper_ndc]

## Examine data.

sdudWant

max(sdudWant$seqidAll)
max(sdudWant$seqidNDC)

# Remove this from global environment to free up RAM.

rm(sdud)
