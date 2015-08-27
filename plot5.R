#for downloading the dataset if plot1.R was not run yet
#
#     fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
#     download.file(fileUrl, destfile = "data", mode = "wb")
#     unzip("data")
#     file.remove("data")
#     rm("fileUrl")
#

pm25emissions <- readRDS(file = "summarySCC_PM25.rds")
codeBook <- readRDS(file = "Source_Classification_Code.rds")

#How have emissions from motor vehicle sources changed 
#from 1999–2008 in Baltimore City? 
#whatever you want

library(dplyr)
#SCC number that are related to vehicles 
vehicle <-   codeBook %>%
                  select(SCC, Short.Name) %>%
                  filter(grepl("Veh", Short.Name)) %>%
                  select(SCC) %>%
                  sapply(as.character) %>%
                  as.character

#Filtering for Baltimore City and only type == ON-ROAD
#and from the codeBook related SCC to motor vehicles
#select approrpiate columns, 
#group them by year and sum the Emissions according to
#the four different years
year <-     pm25emissions %>% 
            filter(fips == "24510", type == "ON-ROAD", SCC %in% vehicle) %>% 
            select(year, Emissions) %>%
            group_by(year) %>%
            summarize(pm25 = sum(Emissions))

png(file = "plot5.png")
#plotting the emissions accordingly to years 
#and saving file to plot5.png
par(mfrow = c(1,1))
plot(year$pm25 ~ year$year, type="l", pch = 19, 
     ylab = "Emission (in tons)", xlab = "Year")
title(main = "Baltimore City : Total Emissions from 1999 to 2008 \nfrom Motor Vehicle Sources")
dev.off()