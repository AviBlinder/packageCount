library(lubridate)

rm(list=ls())

package_name <- "tsSelect"
from_date <- '2016-10-01'
to_date <- today()

pck <- package_stats(from_date,to_date , package_name)

