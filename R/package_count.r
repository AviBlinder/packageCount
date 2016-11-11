library(lubridate)

rm(list=ls())

package_name <- "tsSelect"
from_date <- '2016-10-01'
to_date <- today() - days(2)

source("R/functions.r")
pck <- cran_stats_by_package(from_date,to_date , package_name)


stats_2016_11_01 <- cran_stats_by_day("2016-11-01")



