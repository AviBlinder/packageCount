library(lubridate)
library(dplyr)
#library(plyr)
library(knitr)
library(ggplot2)

rm(list=ls())

#package_name <- "sparklyr"
sel_package_name <- "RNeo4j"
#sel_package_name <- "sparklyr"
from_date <- '2016-09-24'
#to_date <- '2016-11-03'
##Usually there is a delay of two days in the upload of the latest log
to_date <- today() - days(2)

#load functions
source("R/functions.r")
###################################################################
##Read range of dates and summarize stats by package
## --> Stats for One package over a range of dates
## Returns a data frame with results
package_stats <- cran_stats_by_package(from_date,to_date , package_name)
head(package_stats)
file_name <- paste0("data/",sel_package_name,"_Stats")
saveRDS(package_stats,file_name)

###################################################################
#Read CRAN by specific date
## --> Stats for All package over One Date
stats_2016_11_01 <- cran_stats_by_day("2016-11-01")
head(stats_2016_11_01)
