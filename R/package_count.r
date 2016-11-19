library(lubridate)
library(dplyr)
library(plyr)
library(tidyr)
library(knitr)
library(ggplot2)

#conflicts() 

rm(list=ls())

#sel_package_name <- "RNeo4j"
#sel_package_name <- "sparklyr"
sel_package_name <- "mongolite"



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
package_stats <- cran_stats_by_package(from_date,to_date , sel_package_name)
head(package_stats)
file_name <- paste0("data/",sel_package_name,"_Stats")
saveRDS(package_stats,file_name)

source("R/plot_results.r")
###################################################################
#Read CRAN by specific date
## --> Stats for All package over One Date
stats_2016_11_01 <- cran_stats_by_day("2016-11-01")
head(stats_2016_11_01)
#############################################################################
#############################################################################
sel_package_name <- c("RNeo4j","sparklyr","mongolite","rmongodb","RMongo")
from_date <- today() - days(4)
to_date <- today() - days(2)
package_name
from_date;to_date

packages_stats <- cran_stats_by_packages(from_date,to_date , sel_package_name)
head(packages_stats)
table(packages_stats$package_name)
