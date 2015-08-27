#Downloading and preparing data frame
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "data", mode = "wb")
unzip("data")
file.remove("data")
rm("fileUrl")

pm25emissions <- readRDS(file = "summarySCC_PM25.rds")
#codeBook <- readRDS(file = "Source_Classification_Code.rds")

#Have total emissions from PM2.5 decreased in the United States 
#from 1999 to 2008?
#base plot

library(dplyr)
#select columns year and Emissions and group them by year
pm25_year <- select(pm25emissions, year, Emissions)
year <- group_by(pm25_year, year)
year <- summarize(year, pm25 = sum(Emissions))

#plotting of emissions to year and saving plot1.png
png(filename = "plot1.png")
par(mfrow = c(1,1))
plot(year$pm25 ~ year$year, type="l",
     ylab = "PM25 Emission (in tons)", xlab = "Year",
     main = "U.S. : Total Emission of pm25 from 1999 to 2008")
dev.off()