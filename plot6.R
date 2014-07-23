###################################################################################
# Project: EDA Project 2 - Fine particulate matter
# Date: July 21, 2014
# Create by: Walter Kung
#
# Inputs:
#       https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#       is unzipped in directory .\exdata_data_NEI_data\.
#       1. Source_Classification_Code.rds
#       2. summarySCC_PM25.rds
# Data Source:
#   http://www.epa.gov/ttn/chief/eiinformation.html
#
# Outputs: plot6.png
#
# Requirements:
# 1.  Construct the plot and save it to a PNG file.
# 2.  Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the corresponding plot,
#     i.e. code in plot1.R constructs the plot1.png plot. Your code file should include code for
#     reading the data so that the plot can be fully reproduced. You should also include the code that
#     creates the PNG file. Only include the code for a single plot (i.e. plot1.R should only include
#     code for producing plot1.png)
# 3.  Upload the PNG file on the Assignment submission page
# 4.  Copy and paste the R code from the corresponding R file into the text box at the appropriate point
#     in the peer assessment.
###################################################################################
# Read in Data
dirIn <- ".//exdata_data_NEI_data//"
fNEI <- paste(dirIn, "summarySCC_PM25.rds", sep="")
fSCC <- paste(dirIn, "Source_Classification_Code.rds",sep="")
NEI <- readRDS(fNEI)
SCC <- readRDS(fSCC)

# Research Question
# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources
#    in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time
#    in motor vehicle emissions?
#

library(sqldf)
library(ggplot2)
png(file = "plot6.png")
SCC_vehicle <- sqldf("select SCC from SCC where SCC_Level_Two LIKE '%vehicle%'")
vehicle_Emission <-
  sqldf("select sum(Emissions) as PM25_Emission_sum, year, 
                CASE when fips == '24510' THEN 'Baltimore City' ELSE 'Los Angeles County' END as fipDesc  
        from NEI 
        where fips in ('24510', '06037') AND
              SCC in (select SCC from SCC_vehicle) group by year, fips")
g<-ggplot(vehicle_Emission, aes(year, PM25_Emission_sum))
g + geom_point() + facet_grid(.~fipDesc ) + geom_smooth(method='lm') +
  labs(y="Total Emissions from PM2.5 (tons)") + 
  ggtitle("Los Angeles County Has Greater Positive Changes\n Over Time in Motor Vehicle Emissions")
dev.off()
