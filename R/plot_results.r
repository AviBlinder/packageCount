library(ggplot2)
library(scales)      # pairs nicely with ggplot2 for plot label formatting
library(gridExtra)   # a helper for arranging individual ggplot objects
library(ggthemes)    # has a clean theme for ggplot2
library(viridis)     # best. color. palette. evar.
library(lubridate)
library(dplyr)
library(plyr)



##Convert into factor and set sort order
table(multiple_pack_Stats_full$package_name)
multiple_pack_Stats_full$packageName <- ifelse(multiple_pack_Stats_full$package_name %in%
                                                 c("mongolite","RMongo","rmongodb"),
                                               "MongoDB",multiple_pack_Stats_full$package_name)
multiple_pack_Stats_full$packageName <- factor(multiple_pack_Stats_full$packageName,
                                                  levels = c("RNeo4j","sparklyr","MongoDB"))
table(multiple_pack_Stats_full$packageName)

multiple_pack_Stats_full$continent_name <- factor(multiple_pack_Stats_full$continent_name,
                                                  levels=c("Africa","South America",
                                                           "Oceania","Asia","Europe",
                                                           "North America"))
########################################################################
#Find min. date
multiple_pack_Stats_full$date <- ymd(multiple_pack_Stats_full$date)

min_dates_by_pkg <- ddply(multiple_pack_Stats_full,.(packageName), summarize,
      min_date = min(date))
min_dates_by_pkg

min_date <- min_dates_by_pkg[min_dates_by_pkg$min_date == 
                               max(min_dates_by_pkg$min_date),2]
min_date
#####
#Plot 1
concat_title <- paste0("Package Downloads By Continent Between ",min_date," and ", to_date)


ggplot(multiple_pack_Stats_full[multiple_pack_Stats_full$date >= min_date,]
       ,aes(x=packageName,fill=packageName)) +
  geom_bar() +
  facet_wrap(~continent_name,nrow=2,scales = "free")+
  ggtitle(concat_title)+
  scale_x_discrete(breaks=NULL)+
  ylab("Number of Downloads")  +
  xlab(NULL)+
  scale_fill_viridis(name="",discrete = TRUE,
                     alpha = 0.75,option = "inferno") +
  theme_economist(base_size = 8)


ggsave(filename = "./figures/Distribution of Packages by Continent.png")

write.csv(multiple_pack_Stats_full,file = "./data/multiple_pack_Stats_full.csv")
#######################################################################
#Plot 2 - Distribution by Dates

multiple_pack_Stats_full$date <- ymd(multiple_pack_Stats_full$date)

d2 <- dplyr::count(multiple_pack_Stats_full,date, package_name)
d2

#Check distribution within mongoDB packages
ggplot(d2[d2$package_name %in% c("RMongo","mongolite","rmongodb"),],
       aes(date, n,group=package_name,color=package_name)) +
  geom_line() +
  scale_x_date() + xlab("") + ylab("Daily Views") +
  scale_fill_date() +
  xlab(NULL)+
  ylab("Daily Downloads")+
  ggtitle("Daily Downloads of MongoDB Related Packages")+
  theme_economist(base_size = 8)+
  theme(legend.position=c("top"),
        legend.direction= "horizontal",
        legend.title=element_blank(),
        plot.title=element_text(hjust=0.5),
        axis.title.y = element_text(size=9),
        axis.text.x = element_text(angle=45,hjust = 1)
        )

ggsave(filename = "./figures/Daily Downloads of MongoDB Related Packages.png")

##
#Plot 3 - Comparison between packages along dates
d3 <- dplyr::count(multiple_pack_Stats_full,date, packageName)

ggplot(d3, aes(date, n,group=packageName,color=packageName)) +
  geom_line() +
  scale_x_date() + 
  xlab("") + 
  scale_fill_date() +
  ylab("Daily Downloads")+
  ggtitle("Daily Downloads of Selected  Packages")+
  theme_economist(base_size = 8)+
  theme(legend.position=c("top"),
        legend.direction= "horizontal",
        legend.title=element_blank(),
        plot.title=element_text(hjust=0.5),
        axis.title.y = element_text(size=9),
        axis.text.x = element_text(angle=45,hjust = 1)
  )

ggsave(filename = "./figures/Daily Downloads of Selected  Packages.png")
