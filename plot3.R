#for downloading the dataset if plot1.R was not run yet
#
#     fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#     download.file(fileUrl, destfile = "data", mode = "wb")
#     unzip("data")
#     file.remove("data")
#     rm("fileUrl")
#

pm25emissions <- readRDS(file = "summarySCC_PM25.rds")
#codeBook <- readRDS(file = "Source_Classification_Code.rds")

#Of the four types of sources indicated by the type 
#(point, nonpoint, onroad, nonroad) variable, which of these 
#four sources have seen decreases in emissions 
#from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? 
#Use the ggplot2 plotting system to make a plot answer 
#this question.

library(dplyr)
#filter for Baltimore City, select appropriate columns
#group them by year and type and sum the Emissions according to
#the four different years and types
year <- pm25emissions %>% 
      filter(fips == "24510") %>% 
      select(year, type, Emissions) %>%
      group_by(type, year) %>%
      summarize(pm25 = sum(Emissions))


library(ggplot2)
#plotting the emissions accordingly to years and types
#and saving file to plot3.png
png(file = "plot3.png")
ggplot(year, aes(x = year, y = pm25, fill = type)) +
      geom_bar(stat="identity") + 
      facet_grid(.~type, scales = "free") +
      labs(y = "Emission (in tons)", x = "Year") +
      ggtitle("Baltimore City : Total Emission from 1999 - 2008") +
      theme(axis.text.x=element_text(angle=-90))
dev.off()