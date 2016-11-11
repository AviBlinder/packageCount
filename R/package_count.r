library(lubridate)

rm(list=ls())

package_name <- "tsSelect"
from_date <- '2016-10-01'
to_date <- today() - days(2)

source("R/functions.r")
pck <- cran_stats_by_package(from_date,to_date , package_name)
library(knitr)
kable(pck)

##
stats_2016_11_01 <- cran_stats_by_day("2016-11-01")

dates <- seq(ymd("2016-10-06"),ymd("2016-10-11"),by="day")

stats_mid_october <- sapply(dates,function(x) cran_stats_by_day(x))


###Combine results from all extracted days
stats_mid_october_df <- c()
for (i in 1:length(stats_mid_october)){
  stats_mid_october_df <- rbind(stats_mid_october_df,
                                as.data.frame(unlist(stats_mid_october[[i]])))
}
names(stats_mid_october_df) <- c("Package","Count")

#Summarize the counts of each package
stats_mid_october_df_sum <- ddply(stats_mid_october_df,Package,summarise, 
                                  Sum=sum(Count),
                                  Appearances=length(Count),
                                  Average=round(mean(Count),0)
                                  )

kable(head(stats_mid_october_df_sum,15))
subset(stats_mid_october_df_sum,Package==package_name)
