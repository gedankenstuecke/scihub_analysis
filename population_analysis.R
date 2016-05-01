library(ggplot2)
library(ggrepel)
library(ggthemes)

# now revised for the better mapping and world bank data

# read scihub aggregate data
sh <- read.csv(file="downloads_country.csv",sep="\t",stringsAsFactors=FALSE)
sh$Country <- trimws(sh$Country)

# read country mapping
mapping <- read.csv(file="mapping_countrynames_iso_3166.csv",sep="\t",stringsAsFactors=FALSE)
mapping$ISO.3166.1.alpha.3 <- trimws(mapping$ISO.3166.1.alpha.3)

# read worldbank data
wb <- read.csv(file="worldbank_2014_data.csv",sep=",",stringsAsFactors=FALSE)

# merge all 3
sh <- merge(sh,mapping,by.x=c("Country"),by.y=c("Country.Name.SciHub"))
sh <- merge(sh,wb,by.x=c("ISO.3166.1.alpha.3"),by.y=c("Country.Code"))
sh$Downloads.per.capita <- sh$Downloads/sh$Total.Population
sh$Downloads.per.1000capita <- sh$Downloads.per.capita * 1000
# general plot

p <- ggplot(sh,aes(x=sh$Total.Population,y=sh$Downloads,label=sh$Country)) + stat_smooth(method="glm")+ geom_point(color="red") + geom_text_repel() + scale_x_log10("Population Size (log10)") + scale_y_log10("# of Downloads (log10)") + theme_minimal() + ggtitle("# of Sci-Hub Downloads / 2014 Population Size (data from worldbank.org)")
ggsave("graphs/downloads_per_population.pdf", width = 594, height = 210, units = "mm")
ggsave("graphs/downloads_per_population.png", width = 594, height = 210, units = "mm")

# residuals

sh$residuals_population <- residuals(glm(sh$Downloads ~ sh$Total.Population))
p <- ggplot(sh,aes(x = reorder(Country, -residuals_population), y=residuals_population,fill=Country)) + geom_bar(stat="identity") + theme_minimal() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_y_continuous("Residuals (difference observed downloads from predicted downloads)") + scale_fill_discrete(guide = FALSE) + scale_x_discrete("Countries, sorted by ∆ in residuals")

ggsave("graphs/downloads_per_population_residuals.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/downloads_per_population_residuals.png", width = 594, height = 220, units = "mm")

# sorted by downloads / 1.000 inhabitants

p <- ggplot(sh,aes(x=reorder(Country, -Downloads.per.capita),y=Downloads.per.capita)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_x_discrete("Country, sorted by Rank") + scale_y_continuous("Downloads / Inhabitants")

ggsave("graphs/downloads_per_population_ranked.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/downloads_per_population_ranked.png", width = 594, height = 220, units = "mm")

# correlation downloads per 1000 capita / life expectancy

p <- ggplot(sh,aes(x=Life.Expectancy.at.Birth,y=Downloads.per.capita,label=Country)) + stat_smooth(method="glm") + geom_point(color="red") + geom_text_repel() + scale_x_log10("Life Expectancy at Birth") + scale_y_log10("Downloads per 1000 Capita") + theme_minimal() + ggtitle("# of Sci-Hub Downloads per 1000 Capita / Life Expectancy at Birth (data from World Bank)")
ggsave("graphs/normalized_downloads_life_expectancy.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/normalized_downloads_life_expectancy.png", width = 594, height = 220, units = "mm")

# correlation downloads per 1000 capita / internet users amongst 100 people

p <- ggplot(sh,aes(x=Internet.Users..per.100.People.,y=Downloads.per.capita,label=Country)) + stat_smooth(method="glm") + geom_point(color="red") + geom_text_repel() + scale_x_log10("Internet Users per 100 People") + scale_y_log10("Downloads per 1000 Capita") + theme_minimal() + ggtitle("# of Sci-Hub Downloads per 1000 Capita / Internet Users per 100 People (data from World Bank)")
ggsave("graphs/normalized_downloads_internet_users.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/normalized_downloads_internet_users.png", width = 594, height = 220, units = "mm")

# correlation downloads per 1000 capita / % unemployed workforce
p <- ggplot(sh,aes(x=Total.Unemployment..,y=Downloads.per.capita,label=Country)) + stat_smooth(method="glm") + geom_point(color="red") + geom_text_repel() + scale_x_log10("Percent Unemployed Workforce") + scale_y_log10("Downloads per 1000 Capita") + theme_minimal() + ggtitle("# of Sci-Hub Downloads per 1000 Capita / Percent Unemployed Workforce (data from World Bank)")
ggsave("graphs/normalized_downloads_unemployment.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/normalized_downloads_unemployment.png", width = 594, height = 220, units = "mm")

# correlation downloads per 1000 capita / GDP per Capita
p <- ggplot(sh,aes(x=GDP.per.capita..current.USD.,y=Downloads.per.capita,label=Country)) + stat_smooth(method="glm") + geom_point(color="red") + geom_text_repel() + scale_x_log10("GDP per Capita") + scale_y_log10("Downloads per 1000 Capita") + theme_minimal() + ggtitle("# of Sci-Hub Downloads per 1000 Capita / GDP per Capita (data from World Bank)")
ggsave("graphs/normalized_downloads_gdp.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/normalized_downloads_gdp.png", width = 594, height = 220, units = "mm")

# internet users / GDP
p <- ggplot(sh,aes(x=GDP.per.capita..current.USD.,y=Internet.Users..per.100.People.,label=Country)) + stat_smooth(method="glm") + geom_point(color="red") + geom_text_repel() + scale_x_log10("GDP per Capita") + scale_y_log10("Internet Users per 100 Capita") + theme_minimal() + ggtitle("# of Internet Users amongst 100 People / GDP per Capita (data from World Bank)")
ggsave("graphs/gdp_vs_internet.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/gdp_vs_internet.png", width = 594, height = 220, units = "mm")
