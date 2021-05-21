#-----------------------------------------------------------------------------------------------------------------#
#                                                                                                                 #
# PROJECT: MEDICAID DRUG UTILIZATION		                                                                          #
# AUTHOR: MICHAEL MAGUIRE, MS, DMA II                                                                             #
# INSTITUTION: UNIVERSITY OF FLORIDA, COLLEGE OF PHARMACY                                                         #
# DEPARTMENT: PHARMACEUTICAL OUTCOMES AND POLICY                                                                  #
# SUPERVISORS: AMIE GOODIN, PHD, MPP | JUAN HINCAPIE-CASTILLO, PHARMD, PHD, MS                                    #
# SCRIPT: 06_parse-final-files.R                                                        			                    #
#                                                                                                                 #
#                                                                                                                 #
# Notes:                                                                                                          #
# This script cleans up the final data set. Need to clear out environment due to memory capacity.                 #
#                                                                                                                 #
#-----------------------------------------------------------------------------------------------------------------#

library(data.table)
library(tidyverse)

sdudRedbookJoin <-
  fread(
    "./data/clean/01_sdud-redbook-joined-on-ndc.csv",
    colClasses = c("proper_ndc" = "character")
  )

sdudRedbookFinalDrops <-
  sdudRedbookJoin[
    i = gennme == ""
  ]

sdudRedbookFinal <-
  sdudRedbookJoin[
    i = gennme != ""
  ]

rxInfo <-
  unique(sdudRedbookFinal, by = "proper_ndc") %>%
  select(-c("utilization.type", "year", "quarter", "state", "suppression", "numberrx", "seqidall")) %>%
  mutate(proper_ndc = str_pad(proper_ndc, width = 13, side = "both", pad = "'")) %>%
  relocate(c("gennme", "prodnme"), .before = deaclas) %>%
  arrange(gennme) %>%
  relocate(seqidndc, .before = proper_ndc) %>%
  arrange(seqidndc)


fwrite(sdudRedbookFinalDrops, "./data/clean/02_sdud-redbook-dropped-records.csv")
fwrite(sdudRedbookFinal, "./data/clean/03_sdud-redbook-final.csv")
fwrite(rxInfo, "./data/clean/04_sdud-redbook-ndc-info.csv")
