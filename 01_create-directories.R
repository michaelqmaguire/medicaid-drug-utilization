#-----------------------------------------------------------------------------------------------------------------#
#                                                                                                                 #
# PROJECT: MEDICAID DRUG UTILIZATION		                                                                          #
# AUTHOR: MICHAEL MAGUIRE, MS, DMA II                                                                             #
# INSTITUTION: UNIVERSITY OF FLORIDA, COLLEGE OF PHARMACY                                                         #
# DEPARTMENT: PHARMACEUTICAL OUTCOMES AND POLICY                                                                  #
# SUPERVISORS: AMIE GOODIN, PHD, MPP | JUAN HINCAPIE-CASTILLO, PHARMD, PHD, MS                                    #
# SCRIPT: 01_create-directories.R                                                                          			  #
#                                                                                                                 #
# Notes:                                                                                                          #
# This script creates directories from the top-level directory.                                                   #
# It assumes that the user creates a new project in R studio.                                                     #
# If downloaded from GitHub, this does not need to be run.                                                        #
#-----------------------------------------------------------------------------------------------------------------#

## Create data directory if it doesn't exist.

if (dir.exists("./data")) {
  print("Directory already exists!")
} else {
  dir.create("./data")
}

## Create clean data sub-directory if it doesn't exist.

if (dir.exists("./data/clean/")) {
  print("Directory already exists!")
} else {
  dir.create("./data/clean/")
}

## Create raw data sub-directory if it doesn't exist.

if (dir.exists("./data/raw/")) {
  print("Directory already exists!")
} else {
  dir.create("./data/raw/")
}

## Create metadata sub-directory if it doesn't exist.

if (dir.exists("./data/metadata-archive/")) {
  print("Directory already exists!")
} else {
  dir.create("./data/metadata-archive/")
}

## Create output directory if it doesn't exist.

if (dir.exists("./output")) {
  print("Directory already exists!")
} else {
  dir.create("./output")
}

## Create functions directory if it doesn't exist.

if (dir.exists("./functions")) {
  print("Directory already exists!")
} else {
  dir.create("./functions")
}

## Create plots directory if it doesn't exist.

if (dir.exists("./plots")) {
  print("Directory already exists!")
} else {
  dir.create("./plots")
}