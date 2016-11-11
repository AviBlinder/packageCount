rm(list=ls())
# Here's an easy way to get all the URLs in R
library(lubridate)
library(tidyr)
library(dplyr)
library(ggplot2)
##
start <- as.Date('2016-10-01')
today <- today()
all_days <- seq(start, today, by = 'day')
years <- year(all_days)

package_name <- "survival"
##Create regex for package name
pattern <- paste0(",",package_name,",.{1,},.{1,}$")
pattern


urls <- paste0('http://cran-logs.rstudio.com/', years, '/', all_days, '.csv.gz')

package_stats <- c()
for (i in 1:length(urls)) {
  stats_df <- c()
  tmp <- tempfile()
  download.file(urls[i], tmp)
  unzipped_file <- read.csv( gzfile(tmp), sep="\t",header=TRUE, 
                             stringsAsFactors=FALSE)
  #remove header    
  unzipped_file1 <- unzipped_file[-1,]
  #sum all accurances of package
  sum_pck_found <- sum(grepl(pattern,unzipped_file1))
  #extract date from first row
  file_date <- substr(unzipped_file[1,1],1,10)
  stats_df <- cbind(file_date=file_date,sum_pck_found=sum_pck_found)    
  package_stats <- rbind(package_stats,stats_df)     
  rm(tmp)
}
#####
package_stats_df <- data.frame(package_stats)

names(package_stats_df) <- c("pck_date","pck_count")
package_stats_df

####
package.df <- data.frame()
library(dplyr)
pb <- txtProgressBar(min=0, max=length(urls), style=3)

for (i in 1:length(urls)) {
  df.csv <- read.csv(sprintf("~/Desktop/rstats/temp%i.csv", i))
  pack <- tolower(as.character(df.csv$package))
  my.package <- which(pack == "tsSelect")
  if (length(my.package) > 0 ) {
    dummy.df <- df.csv %>% dplyr::slice(my.package) %>% dplyr::select(date, package, version, country)
    package.df <- dplyr::bind_rows(package.df, dummy.df)
  }
  setTxtProgressBar(pb, i)
}
close(pb)
package.df$date.short <- strftime(package.df$date, format="%Y-%m")

#library(sjPlot)
library(ggplot2)

mydf <- package.df %>% dplyr::count(date.short)

sjp.setTheme(theme = "539", axis.angle.x = 90)
ggplot(mydf, aes(x = date.short, y = n)) +
  geom_bar(stat = "identity", width = .5, alpha = .5, fill = "#3399cc") +
  scale_y_continuous(expand = c(0, 0), breaks = seq(250, 1500, 250)) +
  labs(x = sprintf("Monthly CRAN-downloads of sjPlot package since first 
                   release until 4th March (total download: %i)", 
                   sum(mydf$n)), y = NULL)