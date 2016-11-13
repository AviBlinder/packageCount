library(lubridate)
library(dplyr)
library(plyr)
library(knitr)
library(ggplot2)

rm(list=ls())

#package_name <- "tsSelect"
sel_package_name <- "RNeo4j"
from_date <- '2016-04-06'
#to_date <- '2016-11-03'
to_date <- today() - days(2)


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


package_stats2 %>% group_by(continent_name) %>%
                  summarise(count=n()) %>%
                  arrange(-count) %>%
                  mutate(cont_order = row_number(),
                         continent_name = factor(continent_name,
                                            levels = continent_name[order(cont_order)])) %>%
                  ggplot(aes(x=continent_name,y=count))+
                  geom_bar(aes(fill=continent_name),stat="identity",
                           show.legend = FALSE) +
                  coord_flip()+
                  geom_text(aes(label=continent_name),
                  y=0.2,
                  hjust=0,
                  angle=0,
                  size=4,
                  color="#222222") +
                  xlab("Continent Name") +
                  ylab("Total Number of Package Installed") +
                  theme(axis.text.y=element_blank(),
                        axis.ticks.y=element_blank())


kable(stats_by_continent)



###################################################################
#Read CRAN by specific date
## --> Stats for All package over One Date
stats_2016_11_01 <- cran_stats_by_day("2016-11-01")
head(stats_2016_11_01)
