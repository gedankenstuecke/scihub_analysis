library(ggplot2)
library(ggrepel)
library(ggthemes)

# read in the data needed to plot nicely
unistats <- read.csv(file="uni-stats-date.tab",sep="\t",head=F)
unistats$V1 <- as.Date(unistats$V1)
unistats$weekday <- weekdays(unistats$V1)
unistats$weekday <- factor(unistats$weekday, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))

p <- ggplot(unistats,aes(x=V1,y=V2)) + geom_point(aes(color=weekday)) + stat_smooth(method="glm") + geom_vline(xintercept=as.numeric(as.Date("2015-12-24"))) + geom_text(aes(x=as.Date("2015-12-20"),y=2.5,label="Christmas Eve")) + theme_minimal() + scale_x_date("Date") + scale_y_continuous("% Downloads from Universities") + ggtitle("% of Sci-Hub Downloads from Universities")

ggsave("graphs/university_downloads_vs_time.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/university_downloads_vs_time.png", width = 594, height = 220, units = "mm")

p <- ggplot(unistats,aes(x=unistats$weekday,y=unistats$V2,fill=unistats$weekday)) + geom_boxplot() + geom_jitter(alpha=0.2) + scale_x_discrete("Weekday") + scale_y_continuous("% Downloads from Universities") + scale_fill_discrete(guide=FALSE) + theme_minimal() + ggtitle("% of Sci-Hub Downloads from Universities per Weekday")

ggsave("graphs/university_downloads_per_weekday.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/university_downloads_per_weekday.png", width = 594, height = 220, units = "mm")


# let's read the country-wise data
uni_country <- read.csv(file="uni-stats-country.tab",sep="\t",head=F)
uni_ag <- aggregate(uni_country$V3,by=list(uni_country$V2),FUN=mean)

# read scihub aggregate data
sh <- read.csv(file="downloads_country.csv",sep="\t",stringsAsFactors=FALSE)
sh$Country <- trimws(sh$Country)
mapping <- read.csv(file="mapping_countrynames_iso_3166.csv",sep="\t",stringsAsFactors=FALSE)
mapping$ISO.3166.1.alpha.3 <- trimws(mapping$ISO.3166.1.alpha.3)
wb <- read.csv(file="worldbank_2014_data.csv",sep=",",stringsAsFactors=FALSE)
sh <- merge(sh,mapping,by.x=c("Country"),by.y=c("Country.Name.SciHub"))
sh <- merge(sh,wb,by.x=c("ISO.3166.1.alpha.3"),by.y=c("Country.Code"))
sh$Downloads.per.Internet.Users..per.100.People. <- sh$Downloads / (sh$Total.Population / sh$Internet.Users..per.100.People.)
enrollment <- read.csv(file="API_SE.TER.ENRR_DS2_en_csv_v2.2012.csv",sep=",",head=T)
shc <- merge(sh,uni_ag,by.x=c("Country"),by.y=c("Group.1"))
shc <- merge(shc,enrollment,by.x=c("ISO.3166.1.alpha.3"),by.y=c("Country.Code"))
shc$enrollment <- shc$X2012
print(colnames(shc))

spending <- read.csv(file="API_GB.XPD.RSDV.GD.ZS_DS2_en_csv_v2.2011.csv",sep=",",head=T)
shc <- merge(shc,spending,by.x=c("ISO.3166.1.alpha.3"),by.y=c("Country.Code"))
shc$research_spending <- shc$X2011

shc_sub <- subset(shc,shc$x > 0)

p <- ggplot(shc_sub,aes(x=as.numeric(as.character(enrollment)),y=x,label=Country)) + stat_smooth(method="glm") + geom_point(aes(size=Downloads),color="red") + geom_text_repel() + scale_x_log10("Gross enrolment ratio, tertiary, both sexes (%)") + scale_y_continuous("% Downloads from universities") + theme_minimal() + ggtitle("% of Sci-Hub Downloads by Gross Enrolment Ratio (tertiary, both sexes)")
ggsave("graphs/university_downloads_per_enrolment.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/university_downloads_per_enrolment.png", width = 594, height = 220, units = "mm")

p <- ggplot(shc_sub,aes(x=as.numeric(as.character(research_spending)),y=x,label=Country)) + stat_smooth(method="glm") + geom_point(aes(size=Downloads),color="red") + geom_text_repel() + scale_x_log10("% GDP spent on Research") + scale_y_continuous("% Downloads from universities") + theme_minimal() + ggtitle("% of Sci-Hub Downloads from Universities by % GDP spent on Research/Development")
ggsave("graphs/university_downloads_per_researchspending.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/university_downloads_per_researchspending.png", width = 594, height = 220, units = "mm")

p <- ggplot(shc_sub,aes(x= reorder(Country, -x),y=x,fill=Country)) + geom_bar(stat="identity")+ theme_minimal() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_fill_discrete(guide = FALSE) + scale_y_continuous("% Downloads from Universities") + scale_x_discrete("Countries by % Downloads from Universities")
ggsave("graphs/university_downloads_ranking.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/university_downloads_ranking.png", width = 594, height = 220, units = "mm")

countries <- read.csv(file="uni-stats-country.replaced.tab",sep="\t",head=F)
countries$date <-  as.Date(as.character(countries$V1))
csub <- subset(countries,as.character(countries$V2) == "Greece" | as.character(countries$V2) == "Germany" | as.character(countries$V2) == "France"| as.character(countries$V2) == "Spain"| as.character(countries$V2) == "Italy"| as.character(countries$V2) =="Belgium"| as.character(countries$V2) =="United Kingdom"| as.character(countries$V2) =="Sweden"| as.character(countries$V2) =="Iran"| as.character(countries$V2) =="Netherlands"| as.character(countries$V2) =="Poland"| as.character(countries$V2) =="Czech Republic"| as.character(countries$V2) =="Austria"| as.character(countries$V2) =="Switzerland"| as.character(countries$V2) =="Israel"| as.character(countries$V2) =="China"| as.character(countries$V2) == "United States")
p <- ggplot(csub,aes(x=date,y=V3,color=V2)) + geom_line() + scale_color_discrete(guide=FALSE) + theme_minimal() + scale_x_date("Date") + scale_y_continuous("% Academic Downloads") + geom_text_repel(data = subset(csub, csub$date == min(date)|csub$date == max(date)),aes(label=V2))
ggsave("graphs/university_downloads_country_per_time.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/university_downloads_country_per_time.png", width = 594, height = 220, units = "mm")
