#-----------------------------------------------------------------------------------------------------------------#
#                                                                                                                 #
# PROJECT: MEDICAID DRUG UTILIZATION		                                                                          #
# AUTHOR: MICHAEL MAGUIRE, MS, DMA II                                                                             #
# INSTITUTION: UNIVERSITY OF FLORIDA, COLLEGE OF PHARMACY                                                         #
# DEPARTMENT: PHARMACEUTICAL OUTCOMES AND POLICY                                                                  #
# SUPERVISORS: AMIE GOODIN, PHD, MPP | JUAN HINCAPIE-CASTILLO, PHARMD, PHD, MS                                    #
# SCRIPT: 05_sdud-join-with-redbook.R                                                        			                #
#                                                                                                                 #
#                                                                                                                 #
# Notes:                                                                                                          #
# This script is intended to provide normalized drug information using IBM's RedBook.                             #
#                                                                                                                 #
#-----------------------------------------------------------------------------------------------------------------#

library(data.table)
library(hrbrthemes)
library(tidyverse)

redbook <-
  fread(
    "./data/clean/redbook2019.csv"
  )

sapply(redbook, FUN = function(x) sum(is.na(x)))

redbook

redbook %>%
  summarize(
    n = n(),
    ndc_distinct = n_distinct(NDCNUM)
  )

sdudWant %>%
  summarize(
    n = n(),
    ndc_distinct = n_distinct(proper_ndc)
  )

setkey(redbook, "NDCNUM")
setkey(sdudWant, "proper_ndc")

sdudRedbook <-
  merge.data.table(
    x = sdudWant,
    y = redbook[ , -c("ORGBKCD","ORGBKFG","EXCLDRG","EXCDGDS","ORGBKDS","MANFNME","ROACD","ROADS","DEACTDT","REACTDT","ACTIND")],
    by.x = "proper_ndc",
    by.y = "NDCNUM",
    all.x = TRUE
  )

sdudRedbook %>%
  summarize(
    checkDistinctSeqID = n_distinct(seqidAll)
  )

setnames(sdudRedbook, tolower(names(sdudRedbook)))

fwrite(sdudRedbook, "./data/clean/01_sdud-redbook-joined-on-ndc.csv")

## Remove to free up RAM.

rm(sdudRedbook)
rm(sdudWant)
