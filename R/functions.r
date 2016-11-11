package_stats <- function(from_date,to_date,package_name){
  
  # Here's an easy way to get all the URLs in R
  library(lubridate)
  ##
  start <- ymd(from_date)
  today <- ymd(to_date)
  
  all_days <- seq(start, today, by = 'day')
  years <- year(all_days)
  
  ##Create regex for package name
  pattern <- paste0(",",package_name,",.{1,},.{1,}$")
  
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
}