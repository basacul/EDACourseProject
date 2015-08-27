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

#Compare emissions from motor vehicle sources in 
#Baltimore City with emissions from motor vehicle 
#sources in Los Angeles County, 
#California (fips == "06037"). 
#Which city has seen greater changes over time in motor 
#vehicle emissions?

library(dplyr)
#SCC number that are related to vehicles 
vehicle <-   codeBook %>%
      select(SCC, Short.Name) %>%
      filter(grepl("Veh", Short.Name)) %>%
      select(SCC) %>%     
      sapply(as.character) %>%
      as.character

#Filtering for Baltimore City and Los Angeles County and 
#only type == ON-ROAD
#and from the codeBook related SCC to motor vehicles
#select approrpiate columns, 
#group them by year and fips and sum the Emissions according to
#the four different years and fips
year <-     pm25emissions %>% 
            filter(fips %in% c("06037", "24510"), type %in% c("ON-ROAD", "OFF-ROAD"), SCC %in% vehicle) %>% 
            select(year, fips, Emissions) %>%
            group_by(year, fips) %>%
            summarize(pm25 = sum(Emissions))

#fips from integer to appropriate labels
for(i in 1:8){
      if(year[i,2] == "06037"){
            year[i,2] <- "Los Angeles County"
      }else{
            year[i,2] <- "Baltimore City"
      }
}

#rename columns
names(year) <- c("Year", "Region", "pm25")


library(ggplot2)
#plotting of the emissions according to region (alias fips)
#and years and saving to plot6.R
png(file = "plot6.png")
ggplot(year, aes(x = Year, y = pm25, fill = Region)) +
geom_bar(stat="identity") + 
facet_grid(.~Region, scales = "free") +
labs(x = "Year", y = "Emission (in tons)") +
ggtitle("Total Emission Trom 1999 To 2008 \nComparison Of Two Regions") +
theme(axis.text.x=element_text(angle=-90))
dev.off()