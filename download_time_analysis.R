library(ggplot2)
library(ggthemes)
library(lubridate)

args <- commandArgs(trailingOnly = TRUE)

df <- read.csv(file=args[1],sep="\t",head=F)
df$dates <- as.POSIXct(df$V1)

df$hour <- hour(df$dates)
df$weekday <- weekdays(df$dates)
df$weekday <- factor(df$weekday,levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
p <- ggplot(df,aes(hour,fill=weekday)) + geom_histogram(binwidth=1) + facet_grid(weekday ~ .) + theme_minimal() + scale_y_continuous("Download Count") + scale_x_continuous("Hour")
ggsave("graphs/download_time.pdf", width = 594, height = 220, units = "mm")
ggsave("graphs/download_time.png", width = 594, height = 220, units = "mm")
