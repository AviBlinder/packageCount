cran_stats_by_package <- function(from_date,to_date,package_name){
  
  # Here's an easy way to get all the URLs in R
  library(lubridate)
  library(tidyr)
  ##
  start <- ymd(from_date)
  today <- ymd(to_date)
  
  all_days <- seq(start, today, by = 'day')
  years <- year(all_days)
  
  ##Create regex for package name
#  pattern <- paste0(",",package_name,",.{1,},.{1,}$")
  
  urls <- paste0('http://cran-logs.rstudio.com/', years, '/', all_days, '.csv.gz')
  
  package_stats <- c()
  for (i in 1:length(urls)) {
    stats_df <- c()
    tmp <- tempfile()
    download.file(urls[i], tmp)
    unzipped_file <- read.csv( gzfile(tmp), sep="\t",header=TRUE, 
                               stringsAsFactors=FALSE)
    rm(tmp)
    #remove header    
#    unzipped_file1 <- unzipped_file[-1,]
    #sum all accurances of package
#    sum_pck_found <- sum(grepl(pattern,unzipped_file1))
    #extract date from first row
#    file_date <- substr(unzipped_file[1,1],1,10)
    names(unzipped_file) <- "ConcatCol"
    unzipped_file_df <- separate(unzipped_file,ConcatCol,sep = ",",
                                 into = c("date","time","size","r_version","r_arch","r_os",
                                          "package_name","package_version","country","ip_id"))
    unzipped_file_df_pck <- subset(unzipped_file_df,package_name == sel_package_name)
    package_stats <- rbind(package_stats,unzipped_file_df_pck)     
  }
  #####
#  package_stats_df <- data.frame(package_stats)
  
#  names(package_stats_df) <- c("pck_date","pck_count")
#  package_stats_df$pck_count <- as.integer(package_stats_df$pck_count)
  package_stats
}
######################################################################################
cran_stats_by_day <- function(Date){
  
  # Here's an easy way to get all the URLs in R
  library(lubridate)
  ##
  start <- ymd(Date)

  
  ##Create regex for package name
  pattern <- "^.{1,},.{1,},.{1,},.{1,},.{1,},(.{1,}),.{1,},.{1,},.{1,}$"
  pattern
  urls <- paste0('http://cran-logs.rstudio.com/', year(start), '/', start, '.csv.gz')
  
  package_stats <- c()
  stats_df <- c()
  tmp <- tempfile()
  download.file(urls, tmp)
  unzipped_file <- read.csv( gzfile(tmp), sep="\t",header=TRUE, 
                               stringsAsFactors=FALSE)
  rm(tmp)
  #remove header    
  unzipped_file1 <- unzipped_file[-1,]
  #sum all accurances of package
  packages_found <- sapply(unzipped_file1,function(x) gsub(pattern,"\\1",x))
  #extract date from first row
  packages_found_tbl <- sort(table(packages_found),decreasing = TRUE)
}
######################################################################################
cran_stats_by_day_parsed <- function(Date){
  
  # Here's an easy way to get all the URLs in R
  library(lubridate)
  ##
  start <- ymd(Date)
  
  
  ##Create regex for package name
  pattern <- "^.{1,},.{1,},.{1,},.{1,},.{1,},(.{1,}),(.{1,}),(.{1,}),(.{1,})$"
  pattern
  urls <- paste0('http://cran-logs.rstudio.com/', year(start), '/', start, '.csv.gz')
  
  package_stats <- c()
  stats_df <- c()
  tmp <- tempfile()
  download.file(urls, tmp)
  unzipped_file <- read.csv( gzfile(tmp), sep="\t",header=TRUE, 
                             stringsAsFactors=FALSE)
  rm(tmp)
  #remove header    
  unzipped_file1 <- unzipped_file[-1,]
  #sum all accurances of package
  packages_found <- sapply(unzipped_file1,function(x) gsub(pattern,"\\1,\\3",x))
  #extract date from first row
  packages_found_tbl <- sort(table(packages_found),decreasing = TRUE)
}