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

#Across the United States, how have emissions from 
#coal combustion-related sources changed from 1999–2008?
#use whatever you want

library(dplyr)
#SCC number that are related to coal AND combustion are filtered
coalandCombustion <-    codeBook %>%
                        select(SCC, Short.Name) %>%
                        filter(grepl("Coal", Short.Name) & grepl("Comb", Short.Name)) %>%
                        select(SCC) %>%
                        sapply(as.character) %>%
                        as.character

#filter for SCC according to selected variables from the codebook, 
#select appropriate columns
#group them by year and sum the Emissions according to
#the four different years
year <-     pm25emissions %>% 
            filter(SCC %in% coalandCombustion) %>% 
            select(year, Emissions) %>%
            group_by(year) %>%
            summarize(pm25 = sum(Emissions))

library(ggplot2)
#plotting the emissions accordingly to years 
#and saving file to plot4.png
png(file="plot4.png")
ggplot(year, aes(x = year, y = pm25)) +
      geom_histogram(stat = "identity", colour = "blue", fill = "darkblue") +
      labs(y = "Emission (in tons)", x = "Year") +
      ggtitle("U.S. : Total Emission from 1999 - 2008\nFrom Coal Combustion-Related Sources")
dev.off()
 