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



###################################################################
#### --> Stats for All packages over a range of dates
dates <- seq(ymd("2016-10-06"),ymd("2016-10-07"),by="day")

stats_cran <- sapply(dates,function(x) cran_stats_by_day(x))

#Combine results from all extracted days

if (class(stats_cran) == "matrix"){
  stats_cran_df <- as.data.frame(stats_cran)
  stats_cran_df$Package <- row.names(stats_cran_df)
  row.names(stats_cran_df) <- NULL
  names(stats_cran_df) <- c("Count","Package")
  stats_cran_df <- stats_cran_df[,c(2,1)]
  } else{
  stats_cran_df <- c()
  for (i in 1:length(stats_cran)){
    stats_cran_df <- rbind(stats_cran_df,
                                  as.data.frame(unlist(stats_cran[[i]])))
  }
  names(stats_cran_df) <- c("Package","Count")
}
  

head(stats_cran_df)

#Summarize the counts of each package
stats_cran_df_sum <- ddply(stats_cran_df,"Package",summarise, 
                                  Sum=sum(Count),
                                  Appearances=length(Count),
                                  Average=round(mean(Count),0)
                                  )

kable(head(stats_cran_df_sum,15))
subset(stats_cran_df_sum,Package==package_name)
###################################################################