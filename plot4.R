# Load the needed libraries
if(!require("data.table")) {
  stop('Cannot find data.table package')
}
if(!require("dplyr")) {
  stop('Cannot find dplyr package')
}
if(!require("lubridate")) {
  stop('Cannot find lubridate package')
}

# Read the data file, if we haven't already
if(!"read_power_data" %in% ls()) {
  source("read_power_data.R")
}
if(!"feb_pwr" %in% ls()) {
  feb_pwr <- read_power_data("household_power_consumption.txt", 
                           c("1/2/2007", "2/2/2007"))
}

# Open the png file
png(filename = "plot4.png", width = 480, height = 480)

# Create and write the plot
# First create the empty plot, then add the sub metering data one at a time
# Finally add the legend
with(feb_pwr, {
     par(mfcol = c(2, 2))
     plot(feb_pwr$Date_time, 
          feb_pwr$Global_active_power, 
          type="l", xlab="", 
          ylab="Global Active Power")
     plot(feb_pwr$Date_time, 
          feb_pwr$Sub_metering_1, 
          type="n", xlab="", 
          ylab="Energy sub metering")
     points(feb_pwr$Date_time, 
            feb_pwr$Sub_metering_1, 
            type="l", col="black")
     points(feb_pwr$Date_time, 
            feb_pwr$Sub_metering_2, 
            type="l", col="red")
     points(feb_pwr$Date_time, 
            feb_pwr$Sub_metering_3, 
            type="l", col="blue")
     legend("topright", lty = 1, bty = "n",
            legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
            col = c("black", "red", "blue"))
     plot(feb_pwr$Date_time,
          feb_pwr$Voltage, type="l", 
          xlab="datetime", ylab="Voltage")
     plot(feb_pwr$Date_time, type="l",
          feb_pwr$Global_reactive_power,
          xlab="datetime", ylab="Global_reactive_power")

})

# Close the file
dev.off()
