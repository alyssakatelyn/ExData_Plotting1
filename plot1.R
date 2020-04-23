filename <- 'household_power_consumption.txt'
url <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip'
zipfile <- 'data.zip'

# Check if the data is downloaded and download when applicable
if (!file.exists("household_power_consumption.txt")) {
  download.file(url, destfile = zipfile)
  unzip(zipfile)
  file.remove(zipfile)
}

# Read the file
library(data.table)
data <- fread(filename, sep=';', header=TRUE, colClasses=rep('character', 9))

# Convert '?' to NAs
data[data=='?'] <- NA

# Extracting relevant dates
names(data)
table(data$Date)
data$Date <- as.Date(data$Date, format='%d/%m/%Y')
data <- data[data$Date >= ('2007-02-01') & data$Date <= as.Date('2007-02-02'),]

# Convert column to numeric class
names(data)
data$Global_active_power <- as.numeric(data$Global_active_power)

# Plot global active power
png(file='plot1.png', width=480, height=480, unit='px')
hist(data$Global_active_power, col='red', main='Global Active Power', 
     xlab='Global Active Power (kilowatts)')
dev.off()