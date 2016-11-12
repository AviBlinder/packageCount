library(lubridate)

rm(list=ls())

#package_name <- "tsSelect"
sel_package_name <- "RNeo4j"
from_date <- '2016-10-01'
to_date <- '2016-10-03'
#to_date <- today() - days(2)


#load functions
source("R/functions.r")
###################################################################
##Read range of dates and summarize stats by package
## --> Stats for One package over a range of dates
## Returns a data frame with results
pck <- cran_stats_by_package(from_date,to_date , package_name)
head(pck)
countries_table <- table(pck$country)
countries_table


library(knitr)
kable(countries_table)

###################################################################
#Read CRAN by specific date
## --> Stats for All package over One Date
stats_2016_11_01 <- cran_stats_by_day("2016-11-01")
head(stats_2016_11_01)
