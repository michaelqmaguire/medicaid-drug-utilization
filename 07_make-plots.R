#-----------------------------------------------------------------------------------------------------------------#
#                                                                                                                 #
# PROJECT: MEDICAID DRUG UTILIZATION		                                                                          #
# AUTHOR: MICHAEL MAGUIRE, MS, DMA II                                                                             #
# INSTITUTION: UNIVERSITY OF FLORIDA, COLLEGE OF PHARMACY                                                         #
# DEPARTMENT: PHARMACEUTICAL OUTCOMES AND POLICY                                                                  #
# SUPERVISORS: AMIE GOODIN, PHD, MPP | JUAN HINCAPIE-CASTILLO, PHARMD, PHD, MS                                    #
# SCRIPT: 07_make-plots.R                                                        			                            #
#                                                                                                                 #
#                                                                                                                 #
# Notes:                                                                                                          #
# This script makes nice pretty plots of every possible iteration that I think could be useful.                   #
#                                                                                                                 #
#-----------------------------------------------------------------------------------------------------------------#

library(data.table)
library(tidyverse)
library(tidylog)

sdudFinal <-
  fread(
    "./data/clean/03_sdud-redbook-final.csv",
    colClasses = c("proper_ndc" = "character")
  )

sdudFinal[
  i = ,
  j = .(
    RowCount = .N,
    TotalRx = sum(numberrx)
  )
]

## Aggregate by year - record counts and number of prescriptions.

sdudAggYear <- 
  sdudFinal[
    i  = ,
    j  = .(
      RowCount = .N,
      TotalRx  = sum(numberrx, na.rm = TRUE),
      FakeDate = lubridate::ymd(year, truncated = 2L)
    ),
    by = year
  ][order(year)]

sdudAggYear

## Aggregate by quarter and year - record counts and number of prescriptions.

sdudAggQtrYear <- 
  sdudFinal[
    i  = ,
    j  = .(
      RowCount = .N,
      TotalRx  = sum(numberrx, na.rm = TRUE),
      FakeDate = lubridate::ymd(year, truncated = 2L)
    ),
    by = c("year", "quarter")
  ][order(year, quarter)]

sdudAggQtrYear

## Aggregate by state and year - record counts and number of prescriptions.

sdudAggStateYear <-
  sdudFinal[
    i  = ,
    j  = .(
      RowCount = .N,
      TotalRx  = sum(numberrx, na.rm = TRUE),
      FakeDate = lubridate::ymd(year, truncated = 2L)
    ),
    by = c("year", "state")
  ]

## Aggregate by state, year, and quarter - record counts and number of prescriptions.

sdudAggQtrStateYear <-
  sdudFinal[
    i  = ,
    j  = .(
      RowCount = .N,
      TotalRx  = sum(numberrx, na.rm = TRUE),
      FakeDate = lubridate::ymd(year, truncated = 2L)
    ),
    by = c("quarter", "year", "state")
  ]

## Plot record count by year.

plotYearRecordCount <-
  sdudAggYear %>%
    ggplot() +
    geom_col(
      aes(
        x    = FakeDate,
        y    = RowCount,
        fill = FakeDate
      ),
      color = "black"
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      expand      = c(.01, .01)
    ) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_viridis_c() + 
    theme_ipsum_rc(grid = "XY") +
    xlab("Year") +
    ylab("Number of Records") +
    labs(caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html") +
    ggtitle("Number of Records by Year - 2000 to 2020") +
    theme(
      axis.title.x    = element_text(color = "black"),
      axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5),
      axis.title.y    = element_text(color = "black"),
      axis.text.y     = element_text(color = "black"),
      legend.position = "none"
    )

plotYearRecordCount

## Plot summed number of prescriptions by year.

plotYearRxSum <-
  sdudAggYear %>%
    ggplot() +
    geom_col(
      aes(
        x    = FakeDate,
        y    = TotalRx,
        fill = FakeDate
      ),
      color = "black"
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      expand      = c(.01, .01)
    ) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_viridis_c() + 
    theme_ipsum_rc(grid = "XY") +
    xlab("Year") +
    ylab("Number of Prescriptions (sum)") +
    labs(caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html") +
    ggtitle("Summed Number of Prescriptions by Year - 2000 to 2020") +
    theme(
      axis.title.x    = element_text(color = "black"),
      axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5),
      axis.title.y    = element_text(color = "black"),
      axis.text.y     = element_text(color = "black"),
      legend.position = "none"
    )

plotYearRxSum

## Plot record counts by quarter and year.

plotQtrYearRecordCount <-
  sdudAggQtrYear %>%
    ggplot() +
    geom_col(
      aes(
        x    = FakeDate,
        y    = RowCount,
        fill = factor(quarter)
      ),
    color = "black"
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      expand      = c(.01, .01)
    ) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_viridis_d() + 
    theme_ipsum_rc(grid = "XY") +
    xlab("Year") +
    ylab("Number of Records") +
    labs(
      caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html",
      fill = "Quarter"
    ) +
    ggtitle("Number of Records by Quarter and Year - 2000 to 2020") +
    theme(
      axis.title.x    = element_text(color = "black"),
      axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5),
      axis.title.y    = element_text(color = "black"),
      axis.text.y     = element_text(color = "black")
    )

plotQtrYearRecordCount

## Plot summed number of prescriptions by quarter and year.

plotQtrYearRxSum <-
  sdudAggQtrYear %>%
    ggplot() +
    geom_col(
      aes(
        x    = FakeDate,
        y    = TotalRx,
        fill = factor(quarter)
      ),
    color = "black"
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      expand      = c(.01, .01)
    ) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_viridis_d() + 
    theme_ipsum_rc(grid = "XY") +
    xlab("Year") +
    ylab("Number of Prescriptions (sum)") +
    labs(
      caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html",
      fill = "Quarter"
    ) +
    ggtitle("Summed Number of Prescriptions by Quarter and Year - 2000 to 2020") +
    theme(
      axis.title.x    = element_text(color = "black"),
      axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5),
      axis.title.y    = element_text(color = "black"),
      axis.text.y     = element_text(color = "black")
    )

plotQtrYearRxSum

## Plot number of records by state and year.

plotStateYearRecordCount <-
  sdudAggStateYear %>%
    ggplot() +
    geom_col(
      aes(
        x    = FakeDate,
        y    = RowCount,
        fill = FakeDate
      ),
    color = "black"
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      expand      = c(.01, .01)
    ) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_viridis_c() + 
    facet_wrap(~state) +
    theme_ipsum_rc(grid = "XY") +
    xlab("Year") +
    ylab("Number of Records") +
    labs(caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html") +
    ggtitle("Number of Records by State and Year - 2000 to 2020") +
    theme(
      axis.title.x    = element_text(color = "black"),
      axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5, size = 8),
      axis.title.y    = element_text(color = "black"),
      axis.text.y     = element_text(color = "black"),
      legend.position = "none"
    )

plotStateYearRecordCount

## Plot summed number of prescriptions by state and year.

plotStateYearRxSum <-
  sdudAggStateYear %>%
    ggplot() +
    geom_col(
      aes(
        x    = FakeDate,
        y    = TotalRx,
        fill = FakeDate
      ),
    color = "black"
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      expand      = c(.01, .01)
    ) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_viridis_c() + 
    facet_wrap(~state) +
    theme_ipsum_rc(grid = "XY") +
    xlab("Year") +
    ylab("Number of Prescriptions (sum)") +
    labs(caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html") +
    ggtitle("Summed Number of Prescriptions by State and Year - 2000 to 2020") +
    theme(
      axis.title.x    = element_text(color = "black"),
      axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5, size = 8),
      axis.title.y    = element_text(color = "black"),
      axis.text.y     = element_text(color = "black"),
      legend.position = "none"
    ) 

plotStateYearRxSum

## Remove outliers and re-plot.

plotStateYearRxSumRmOutliers <-
  sdudAggStateYear %>%
  filter(
    !(
      (state == "WA" & year == 2006) |
        (state == "SD" & year == 2007) |
        (state == "TN") & year %in% c(2003:2006)
    )
  ) %>%
  ggplot() +
  geom_col(
    aes(
      x    = FakeDate,
      y    = TotalRx,
      fill = FakeDate
    ),
  color = "black"
  ) +
  scale_x_date(
    date_breaks = "1 year",
    date_labels = "%Y",
    expand      = c(.01, .01)
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_viridis_c() + 
  facet_wrap(~state) +
  theme_ipsum_rc(grid = "XY") +
  xlab("Year") +
  ylab("Number of Prescriptions (sum)") +
  labs(caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html \n Outliers identified (WA 2006, SD 2007, TN 2003 - 2006)") +
  ggtitle("Summed Number of Prescriptions by State and Year with Outliers Removed - 2000 to 2020") +
  theme(
    axis.title.x    = element_text(color = "black"),
    axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5, size = 8),
    axis.title.y    = element_text(color = "black"),
    axis.text.y     = element_text(color = "black"),
    legend.position = "none"
  )

plotStateYearRxSumRmOutliers

## Plot number of records by quarter, state, and year.

plotQtrStateYearRecordCount <-
  sdudAggQtrStateYear %>%
  ggplot() +
  geom_col(
    aes(
      x    = FakeDate,
      y    = RowCount,
      fill = factor(quarter)
    ),
    color = "black"
  ) +
  scale_x_date(
    date_breaks = "1 year",
    date_labels = "%Y",
    expand      = c(.01, .01)
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_viridis_d() + 
  facet_wrap(~state) +
  theme_ipsum_rc(grid = "XY") +
  xlab("Year") +
  ylab("Number of Records") +
  labs(
    caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html",
    fill = "Quarter"
  ) +
  ggtitle("Number of Records by Quarter, State, and Year - 2000 to 2020") +
  theme(
    axis.title.x    = element_text(color = "black"),
    axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5, size = 8),
    axis.title.y    = element_text(color = "black"),
    axis.text.y     = element_text(color = "black")
  )

plotQtrStateYearRecordCount

## Plot summed number of prescriptions by quarter, state, and year.

plotQtrStateYearRxSum <-
  sdudAggQtrStateYear %>%
  ggplot() +
  geom_col(
    aes(
      x    = FakeDate,
      y    = TotalRx,
      fill = factor(quarter)
    ),
    color = "black"
  ) +
  scale_x_date(
    date_breaks = "1 year",
    date_labels = "%Y",
    expand      = c(.01, .01)
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_viridis_d() + 
  facet_wrap(~state) +
  theme_ipsum_rc(grid = "XY") +
  xlab("Year") +
  ylab("Number of Prescriptions (sum)") +
  labs(
    caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html",
    fill = "Quarter"
  ) +
  ggtitle("Summed Number of Prescriptions by Quarter, State, and Year - 2000 to 2020") +
  theme(
    axis.title.x    = element_text(color = "black"),
    axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5, size = 8),
    axis.title.y    = element_text(color = "black"),
    axis.text.y     = element_text(color = "black")
  )

plotQtrStateYearRxSum

## Remove outliers and re-plot.

plotQtrStateYearRxSumRmOutliers <-
  sdudAggQtrStateYear %>%
    filter(
      !(
        (state == "WA" & year == 2006 & quarter == 3) |
          (state == "SD" & year == 2007 & quarter == 3) |
          (state == "TN") & year %in% c(2003:2006)
      )
    ) %>%
    ggplot() +
    geom_col(
      aes(
        x    = FakeDate,
        y    = TotalRx,
        fill = factor(quarter)
      ),
      color = "black"
    ) +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      expand      = c(.01, .01)
    ) +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_viridis_d() + 
    facet_wrap(~state) +
    theme_ipsum_rc(grid = "XY") +
    xlab("Year") +
    ylab("Number of Prescriptions (sum)") +
    labs(
      caption = "Source: https://www.medicaid.gov/medicaid/prescription-drugs/state-drug-utilization-data/index.html \n Outliers identified (WA 2006 Q3, SD 2007 Q3, TN 2003-2006)",
      fill = "Quarter"
    ) +
    ggtitle("Summed Number of Prescriptions by Quarter, State, and Year with Outliers Removed - 2000 to 2020") +
    theme(
      axis.title.x    = element_text(color = "black"),
      axis.text.x     = element_text(color = "black", angle = 90, vjust = 0.5, size = 8),
      axis.title.y    = element_text(color = "black"),
      axis.text.y     = element_text(color = "black")
    ) 

plotQtrStateYearRxSumRmOutliers

## Output all plots as png files.

png("./plots/01_year-record-counts.png", width = 16, height = 9, units = "in", res = 1200)
plotYearRecordCount
dev.off()

png("./plots/02_year-number-of-prescriptions.png", width = 16, height = 9, units = "in", res = 1200)
plotYearRxSum
dev.off()

png("./plots/03_quarter-year-record-counts.png", width = 20, height = 12, units = "in", res = 1200)
plotQtrYearRecordCount
dev.off()

png("./plots/04_quarter-year-number-of-prescriptions.png", width = 20, height = 12, units = "in", res = 1200)
plotQtrYearRxSum
dev.off()

png("./plots/05_state-year-record-counts.png", width = 16, height = 9, units = "in", res = 1200)
plotStateYearRecordCount
dev.off()

png("./plots/06_state-year-number-of-prescriptions.png", width = 16, height = 9, units = "in", res = 1200)
plotStateYearRxSum
dev.off()

png("./plots/07_state-year-number-of-prescriptions-no-outliers.png", width = 16, height = 9, units = "in", res = 1200)
plotStateYearRxSumRmOutliers
dev.off()

png("./plots/08_quarter-state-year-record-counts.png", width = 20, height = 12, units = "in", res = 1200)
plotQtrStateYearRecordCount
dev.off()

png("./plots/09_quarter-state-year-number-of-prescriptions.png", width = 20, height = 12, units = "in", res = 1200)
plotQtrStateYearRxSum
dev.off()

png("./plots/10_quarter-state-year-number-of-prescriptions-no-outliers.png", width = 20, height = 12, units = "in", res = 1200)
plotQtrStateYearRxSumRmOutliers 
dev.off()

# Output as all into single PDF.

Cairo::CairoPDF("./plots/11_import-and-concatenate-plots.pdf", width = 20, height = 12, onefile = TRUE)
plotYearRecordCount 
plotYearRxSum
plotQtrYearRecordCount
plotQtrYearRxSum
plotStateYearRecordCount
plotStateYearRxSum
plotStateYearRxSumRmOutliers
plotQtrStateYearRecordCount
plotQtrStateYearRxSum
plotQtrStateYearRxSumRmOutliers
dev.off()