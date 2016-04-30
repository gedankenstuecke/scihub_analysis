library(ggplot2)
library(ggrepel)
library(ggthemes)

countrywise <- read.csv(file="country_downloads_population.csv",sep="\t",head=TRUE)

# general plot

p <- ggplot(countrywise,aes(x=countrywise$population,y=countrywise$downloads,label=countrywise$country)) + geom_point(color = 'red') + geom_text_repel() + scale_x_log10("Population Size (log10)") + scale_y_log10("# of Downloads (log10)") + stat_smooth(method="glm") + theme_minimal() + ggtitle("# of Sci-Hub Downloads / 2014 Population Size (data from worldbank.org)")
ggsave("graphs/downloads_per_population.pdf", width = 594, height = 210, units = "mm")
ggsave("graphs/downloads_per_population.png", width = 594, height = 210, units = "mm")

# residuals
res <- glm(countrywise$downloads ~ countrywise$population)
countrywise$residuals_glm <- residuals(res)
p <- ggplot(countrywise,aes(x = reorder(country, -residuals_glm),y=residuals_glm,fill=country)) + geom_bar(stat="identity") +theme_minimal() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_y_continuous("Residuals (difference observed downloads from predicted downloads)") + scale_fill_discrete(guide = FALSE) + scale_x_discrete("Countries, sorted by ∆ in residuals")

ggsave("graphs/downloads_per_population_residuals.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/downloads_per_population_residuals.png", width = 594, height = 220, units = "mm")

# sorted by downloads / 1.000 inhabitants
countrywise$downloadperthousandcapita <- countrywise$downloads / countrywise$population
p <- ggplot(countrywise,aes(x = reorder(country, -downloadperthousandcapita),y=downloadperthousandcapita)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_x_discrete("Country, sorted by Rank") + scale_y_continuous("Downloads / 1,000 Inhabitants")
ggsave("graphs/downloads_per_population_ranked.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/downloads_per_population_ranked.png", width = 594, height = 220, units = "mm")
