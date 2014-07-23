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
# Outputs: plot4.png
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
# 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
#
library(sqldf)
png(file = "plot4.png")
#### Get all SCC related to combustion and coal
SCC_coal_combustion <- 
  sqldf("select SCC from SCC where SCC_Level_One LIKE '%combustion%' AND SCC_Level_Three LIKE '%coal%'")
coal_combustion_Emission <-
  sqldf("select sum(Emissions) as PM25_Emission_sum, year from NEI where SCC in (select SCC from SCC_coal_combustion) group by year")
with(coal_combustion_Emission, plot(PM25_Emission_sum~year, ylab = "Total Emissions from PM2.5 (tons)"))
title(main="Across the United States, \nEmissions from Coal Combustion-related Sources\nDecreased from 1999–2008")
par (cex=.8)
reg3 <- with(coal_combustion_Emission, lm(PM25_Emission_sum~year))
abline(reg3)
dev.off()