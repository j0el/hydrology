library(tidyverse)
library(psych)
library(data.table)
library(lubridate)
 
source("http://www.sthda.com/upload/rquery_cormat.r")

# sensorPlacement <-
#   data.frame(
#     name = c(062553, 062554, 062555, 062556),
#     age = c("Seabridge-6", "Seabridge-6", "Westport-7", "Westport-7")
#   )


################################################################################
#                                                                              #
# Find files in rawData directory with raw.csv as part of filename             #
# Read those csv files into dataframe                                          #
################################################################################
filenames <-
  list.files("./rawData", pattern = "\\.csv", full.names = TRUE) # get names
sensorData <- lapply(filenames, function(i) {                    # read
  read.csv(i, header = TRUE, as.is = TRUE)
})
#
# Extract the sensor number from filename
#

filenames <- substring(filenames, regexpr("/", filenames) + 1)
filenames <- substring(filenames, regexpr("/", filenames) + 1)
filenames <- gsub("\\..*", "", filenames)



# Put sensor number into table as location
#

for (x in 1:length(filenames)) {
  sensorData[[x]]$location <- as.integer(filenames[x])
}
################################################################################
################################################################################
#
# Manually locate as Seabridge and Westport 
#
################################################################################

sensorData[[1]]$location <- "Seabridge"
sensorData[[2]]$location <- "Seabridge"
sensorData[[3]]$location <- "Westport"
sensorData[[4]]$location <- "Westport"

#
# Now combine into one large dataset
#

sensorData <- bind_rows(sensorData)
setDT(sensorData)  # Data tables are a bit more performant than frames
sensorData$time <- as.POSIXct(sensorData$time)
sensorData <- subset(sensorData, select = -temperature3)


# Reshape into wide data

sensorData <- melt(data = sensorData,
                        id.vars = c("time", "location"),
                        variable.name = "sensor",
                        value.name = "reading")
sensorData$sensor <- paste(sensorData$location,"-",sensorData$sensor)
sensorData <- subset(sensorData,select = -location)
# sensorData <- dcast(sensorData, time ~ sensor, value.var = 'reading', fun.aggregate = NULL)

#####################  Begin Analysis ##########################################












