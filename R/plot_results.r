#Read countries table
countries <- read.csv("data/GeoLite2-Country-Locations-en.csv",header = TRUE,
                      stringsAsFactors = FALSE)
head(countries)


package_stats2 <- merge(package_stats,countries,by.x = "country",by.y="country_iso_code") 
head(package_stats2)

stats1 <- sort(table(package_stats2$country_name),decreasing = TRUE)
stats1
head(package_stats2)

#in case of conflict between plyr and dplyr, detach plyr
#detach("package:plyr", unload=TRUE) 

package_stats2 %>% group_by(continent_name)  %>%
    dplyr::summarise(count=n()) %>%
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
