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
# Outputs: plot2.png
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
# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
#    from 1999 to 2008? Use the base plotting system to make a plot answering this question.
#
#
library(sqldf)
png(file = "plot2.png")
BaltimoreEmission <- sqldf("select sum(Emissions) as PM25_Baltimore, year 
                           from NEI where fips == '24510' group by year")
with(BaltimoreEmission, plot(PM25_Baltimore~year, ylab = "Total Emissions from PM2.5 (tons)"))
title(main="Total Emissions from PM2.5 \nDecreased in the Baltimore City, Maryland \nfrom 1999 to 2008")
par (cex=.8)
reg2 <- with(BaltimoreEmission, lm(PM25_Baltimore~year))
abline(reg2)
dev.off()
