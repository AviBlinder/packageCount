cran_stats_by_package <- function(from_date,to_date,sel_package_name){
  
  ##
  start_date <- ymd(from_date)
  end_date <- ymd(to_date)
  
  all_days <- seq(start_date, end_date, by = 'day')
  years <- year(all_days)
  
  urls <- paste0('http://cran-logs.rstudio.com/', years, '/', all_days, '.csv.gz')
  
  package_stats <- c()
  for (i in 1:length(urls)) {
    stats_df <- c()
    tmp <- tempfile()
    download.file(urls[i], tmp)
    unzipped_file <- read.csv( gzfile(tmp), sep="\t",header=TRUE, 
                               stringsAsFactors=FALSE)
    rm(tmp)
#
    names(unzipped_file) <- "ConcatCol"
    unzipped_file_df <- separate(unzipped_file,ConcatCol,sep = ",",
                                 into = c("date","time","size","r_version","r_arch","r_os",
                                          "package_name","package_version","country","ip_id"))
    unzipped_file_df_pck <- subset(unzipped_file_df,package_name == sel_package_name)
    package_stats <- rbind(package_stats,unzipped_file_df_pck)     
  }
  package_stats
}
######################################################################################
cran_stats_by_day <- function(Date){

  start <- ymd(Date)

  
  ##Create regex for package name
  urls <- paste0('http://cran-logs.rstudio.com/', year(start), '/', start, '.csv.gz')
  
  package_stats <- c()
  stats_df <- c()
  tmp <- tempfile()
  download.file(urls, tmp)
  unzipped_file <- read.csv( gzfile(tmp), sep="\t",header=TRUE, 
                               stringsAsFactors=FALSE)
  rm(tmp)
  #remove header    
  names(unzipped_file) <- "ConcatCol"
  unzipped_file_df <- separate(unzipped_file,ConcatCol,sep = ",",
                               into = c("date","time","size","r_version","r_arch","r_os",
                                        "package_name","package_version","country","ip_id"))
}
#######################################################################################
cran_stats_by_packages <- function(from_date,to_date,sel_package_name){
  

  ##
  start_date <- ymd(from_date)
  end_date <- ymd(to_date)
  
  all_days <- seq(start_date, end_date, by = 'day')
  years <- year(all_days)
  
  urls <- paste0('http://cran-logs.rstudio.com/', years, '/', all_days, '.csv.gz')
  
  package_stats <- c()
  for (i in 1:length(urls)) {
    stats_df <- c()
    tmp <- tempfile()
    download.file(urls[i], tmp)
    unzipped_file <- read.csv( gzfile(tmp), sep="\t",header=TRUE, 
                               stringsAsFactors=FALSE)
    rm(tmp)
    #
    names(unzipped_file) <- "ConcatCol"
    unzipped_file_df <- separate(unzipped_file,ConcatCol,sep = ",",
                                 into = c("date","time","size","r_version","r_arch","r_os",
                                          "package_name","package_version","country","ip_id"))
    unzipped_file_df_pck <- subset(unzipped_file_df,package_name %in% sel_package_name)
    package_stats <- rbind(package_stats,unzipped_file_df_pck)     
  }
  package_stats
}
