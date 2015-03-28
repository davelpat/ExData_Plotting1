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

# read_power_data takes the name of a data file and a list of dates to extract from it
# then replaces the Date and Time variables with a Date_time instance and a weekday
#name variable. The numerical data is coerce to type numeric.
read_power_data <- function(data_file, date_list) {
  # Verify the data file exists
  if(!(file.exists(data_file))) {
    stop('Cannot find ', data_file)
  }
  # Read in the requested data and replace the Date and Time variables
  power_data <- tbl_df(fread(data_file, header = T, sep = ";", colClasses = rep("character", 9), nrows = 70000)) %>%
    filter(Date %in% date_list) %>%
    mutate(Date_time = dmy_hms(paste(Date, Time))) %>%
    mutate(Weekday = wday(Date_time,label = TRUE)) %>%
    select(Date_time, Weekday, (3:9))

  # Coerce the numerical data
  power_data[,3:9] <- lapply(power_data[,3:9], as.numeric)
  # Return the tidy data
  power_data
}
