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
data$Date <- as.Date(data$Date, format='%d/%m/%Y')
data <- data[data$Date >= ('2007-02-01') & data$Date <= as.Date('2007-02-02'),]

# Join date and time
data$datetime <- as.POSIXct(strptime(paste(data$Date, data$Time, sep = " "),
                                     format = "%Y-%m-%d %H:%M:%S"))

# Convert column to numeric class
data$Global_active_power <- as.numeric(data$Global_active_power)

# Plot global active power
png(file='plot4.png', width=480, height=480, units='px')
par(mfrow = c(2, 2))

# Plot1
with(data, plot(datetime, Global_active_power, type='l', xlab='', ylab='Global Active Power'))

# Plot2
with(data, plot(datetime, Voltage, type='l', ylab='Voltage'))

# Plot3
with(data, plot(datetime, Sub_metering_1, type='l', xlab='', ylab='Engergy sub metering'))
lines(data$datetime, data$Sub_metering_2, type="l", col="red")
lines(data$datetime, data$Sub_metering_3, type="l", col="blue")
legend('topright', col=c('black', 'blue', 'red'), 
       legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), lty=1)

# Plot4
with(data, plot(datetime, Global_reactive_power, type='l'))

dev.off()
