library(ggplot2)

sjp.setTheme(theme = "539", axis.angle.x = 90)
ggplot(mydf, aes(x = date.short, y = n)) +
  geom_bar(stat = "identity", width = .5, alpha = .5, fill = "#3399cc") +
  scale_y_continuous(expand = c(0, 0), breaks = seq(250, 1500, 250)) +
  labs(x = sprintf("Monthly CRAN-downloads of sjPlot package since first 
                   release until 4th March (total download: %i)", 
                   sum(mydf$n)), y = NULL)