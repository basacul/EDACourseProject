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

#Have total emissions from PM2.5 decreased in the Baltimore City, 
#Maryland (fips == "24510") from 1999 to 2008?
#base plot

library(dplyr)
#filter for Baltimore City, select appropriate columns
#group them by year and sum the Emissions according to
#the four different years
year <- pm25emissions %>% 
        filter(fips == "24510") %>% 
        select(year, Emissions) %>%
        group_by(year) %>%
        summarize(emission = sum(Emissions))


#plotting of emissions to year and saving plot2.png
png(filename = "plot2.png")
par(mfrow = c(1,1))
plot(year$emission ~year$year, type="l",
     ylab = "PM25 Emission (in tons)", xlab = "Year", 
     main = "Baltimore City : Total Emission of pm25 from 1999 to 2008")
dev.off()