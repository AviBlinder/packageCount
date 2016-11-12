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
package_stats <- cran_stats_by_package(from_date,to_date , package_name)
head(package_stats)
#######
#Read countries table
countries <- read.csv("data/GeoLite2-Country-Locations-en.csv",header = TRUE,
                        stringsAsFactors = FALSE)
head(countries)


package_stats2 <- merge(package_stats,countries,by.x = "country",by.y="country_iso_code") 
head(package_stats2)

stats1 <- sort(table(package_stats2$country_name),decreasing = TRUE)
stats1

library(plyr)
stats_by_continent <- ddply(package_stats2,"continent_name",summarise,
                    Count=length(continent_name))


###################################################################
#Read CRAN by specific date
## --> Stats for All package over One Date
stats_2016_11_01 <- cran_stats_by_day("2016-11-01")
head(stats_2016_11_01)
