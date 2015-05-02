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

# These four variables are more meanigful than the single character
# values the plots take. They also make it easy to change the plots
# without having to change each plot call.
no_data <- "n"
no_border <- "n"
line_style <- "l"
line_type <- 1

# Create and write the plots
with(feb_pwr, {
  # Four plots, in column order
  par(mfcol = c(2, 2))
  
  # Upper left plot is just like plot2.png
  plot(Date_time, 
       Global_active_power, 
       type=line_style, 
       xlab="", ylab="Global Active Power")
  
  # Lower left plot is like plot3.png, but constructed more compactly
  # First the empty plot is created
  plot(Date_time, 
       Sub_metering_1, 
       type=no_data, 
       xlab="", ylab="Energy sub metering")
  # Now add the sub metering data one at a time in a loop
  # Using the loop and these two character vectors ensures the data point
  # colors and legend are in sync, while the colors to be easily changed
  # If more, or fewer, data points were desired, only the two character
  # vectors would need to be updated; the code for the plot would remain the same
  # sub_metering <- labels(feb_pwr)[[2]][6:8]
  sub_metering <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
  sub_meter_colors <- c("black", "red", "blue")  
  for(ds in seq_along(sub_metering)) {
    points(Date_time, 
           feb_pwr[[sub_metering[ds]]], 
           type=line_style, col=sub_meter_colors[ds])}
  # Finally add the legend
  legend("topright", lty = line_type, bty=no_border, 
         legend = sub_metering, col = sub_meter_colors)
  
  
  # The plots for the right column are constructed just like the upper
  # left plot, using a different variable for the y axis
  plot(Date_time, 
       Voltage, 
       type = line_style, 
       xlab = "datetime", ylab = "Voltage")
  
  plot(Date_time,
       Global_reactive_power,
       type = line_style, 
       xlab = "datetime", ylab = "Global_reactive_power")
  
})

# Close the file
dev.off()
