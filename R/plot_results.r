library(extrafont)
#font_import()
library(scales)      # pairs nicely with ggplot2 for plot label formatting
library(gridExtra)   # a helper for arranging individual ggplot objects
library(ggthemes)    # has a clean theme for ggplot2
library(viridis)     # best. color. palette. evar.


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

#####
concat_title <- paste0("Distribution of Package Downloads By \nContinent Between ",from_date," and ", to_date)


ggplot(multiple_pack_Stats_full,aes(x=packageName,
                                    fill=packageName)) +
  geom_bar() +
  facet_wrap(~continent_name,nrow=2,scales = "free")+
  ggtitle(concat_title)+
  scale_x_discrete(breaks=NULL)+
  theme(axis.title=element_text(size=8),
        axis.text.x = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_text(size=3),
        plot.title=element_text(size=11,hjust=0.5),
        legend.title=element_text(size=9),
        legend.text=element_text(size=6)) +
  ylab("Number of Downloads")  +
  xlab(NULL)+
  scale_fill_viridis(name="Package Name",discrete = TRUE,alpha = 0.6)+
#  theme_tufte(ticks = TRUE ,base_family = "Arial")
  theme_economist(base_size = 9)


ggsave(filename = "./figures/Distribution of Packages by Continent.png")

#######################################################################
stats1 <- sort(table(package_stats2$country_name),decreasing = TRUE)
stats1
head(package_stats2)




#in case of conflict between plyr and dplyr, detach plyr
#detach("package:plyr", unload=TRUE) 

package_stats2 %>% group_by(continent_name)  %>%
    dplyr::summarise(Count=n())  %>%
    arrange(-Count) %>%
    mutate(cont_order = row_number(Count),  
           continent_name = factor(continent_name,
             levels = continent_name[order(cont_order)]))  %>%
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


######

mongo_stats <- readRDS("./data/mongolite_Stats")
dim(mongo_stats)
spark_stats <- readRDS("./data/sparklyr_Stats")
dim(spark_stats)
neo_stats <- readRDS("./data/RNeo4j_Stats")
dim(neo_stats)
comb_stats <- rbind(mongo_stats,spark_stats,neo_stats)

package_stats2 <- merge(comb_stats,countries,by.x = "country",by.y="country_iso_code") 
head(package_stats2)

package_stats2 %>% 
  mutate(package_name = factor(package_name)) %>%
  group_by(package_name,continent_name)  %>%
  dplyr::summarise(count=n()) %>%
  arrange(-count) %>%
  mutate(cont_order = row_number(),
         continent_name = factor(continent_name,
                                 levels = continent_name[order(cont_order)])) %>%
  ggplot(aes(x=continent_name,y=count))+
  geom_bar(aes(fill=continent_name,=package_name),stat="identity",
           show.legend = FALSE) +
 coord_flip()+
#  facet_grid(~ package_name) +
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
