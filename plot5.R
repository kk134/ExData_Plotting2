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
# Outputs: plot5.png
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
# 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
#
library(sqldf)
png(file = "plot5.png")
#### Get all SCC related to vehicle
SCC_vehicle <- sqldf("select SCC from SCC where SCC_Level_Two LIKE '%vehicle%'")
vehicle_Emission <-
  sqldf("select sum(Emissions) as PM25_Emission_sum, year from NEI where fips == '24510' AND 
        SCC in (select SCC from SCC_vehicle) group by year")
with(vehicle_Emission, plot(PM25_Emission_sum~year, ylab = "Total Emissions from PM2.5 (tons)"))
title(main="Emissions from Motor Vehicle Sources \nDecreased from 1999–2008 in Baltimore City")
par (cex=.8)
reg4 <- with(vehicle_Emission, lm(PM25_Emission_sum~year))
abline(reg4)
dev.off()
