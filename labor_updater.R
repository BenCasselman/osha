# Update OSHA and wage and hour data

daily_data <- function() {
  setwd("/data/osha")
  library(readr)
  library(httr)
  library(lubridate)
  
  temp <- tempfile()
  set_config(config(ssl_verifypeer = 0L))
  
  # Inspections
  date <- Sys.Date()
  url <- paste0("https://enfxfr.dol.gov/data_catalog/OSHA/osha_inspection_", year(date), sprintf("%02d", month(date)), sprintf("%02d", day(date)), ".csv.zip")
  GET(url, write_disk(temp, overwrite=TRUE))
  file <- as.character(unzip(temp, list = T)[1])
  df <- read_csv(unzip(temp, file))
  load("inspections.RData")
  if (nrow(df) > nrow(inspections)) {
    inspections <- df
    save(inspections, file = "inspections.RData") }
  rm(df, inspections)
  
  # Optional info
  url <- paste0("https://enfxfr.dol.gov/data_catalog/OSHA/osha_optional_info_", year(date), sprintf("%02d", month(date)), sprintf("%02d", day(date)), ".csv.zip")
  GET(url, write_disk(temp, overwrite=TRUE))
  file <- as.character(unzip(temp, list = T)[1])
  df <- read_csv(unzip(temp, file))
  load("optional.RData")
  if (nrow(df) > nrow(optional)) {
    optional <- df
    save(optional, file = "optional.RData") }
  rm(df, optional)
  
  # Related
  url <- paste0("https://enfxfr.dol.gov/data_catalog/OSHA/osha_related_activity_", year(date), sprintf("%02d", month(date)), sprintf("%02d", day(date)), ".csv.zip")
  GET(url, write_disk(temp, overwrite=TRUE))
  file <- as.character(unzip(temp, list = T)[1])
  df <- read_csv(unzip(temp, file))
  load("related.RData")
  if (nrow(df) > nrow(related)) {
    related <- df
    save(related, file = "related.RData") }
  rm(df, related)
  
  # Violations
  url <- paste0("https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_", year(date), sprintf("%02d", month(date)), sprintf("%02d", day(date)), ".csv.zip")  
  GET(url, write_disk(temp, overwrite=TRUE))
  file <- as.character(unzip(temp, list = T)[1])
  df <- read_csv(unzip(temp, file))
  load("violations.RData")
  if (nrow(df) > nrow(violations)) {
    violations <- df
    save(violations, file = "violations.RData") }
  rm(df, violations)
  
  # Violation event
  url <- paste0("https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_event_", year(date), sprintf("%02d", month(date)), sprintf("%02d", day(date)), ".csv.zip")  
  GET(url, write_disk(temp, overwrite=TRUE))
  file <- as.character(unzip(temp, list = T)[1])
  df <- read_csv(unzip(temp, file))
  load("viol_event.RData")
  if (nrow(df) > nrow(viol_event)) {
    viol_event <- df
    save(viol_event, file = "viol_event.RData") }
  rm(df, viol_event)
  
  # Gen duty
  url <- paste0("https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_gen_duty_std_", year(date), sprintf("%02d", month(date)), sprintf("%02d", day(date)), ".csv.zip")  
  GET(url, write_disk(temp, overwrite=TRUE))
  file <- as.character(unzip(temp, list = T)[1])
  df <- read_csv(unzip(temp, file))
  load("gen_duty.RData")
  if (nrow(df) > nrow(gen_duty)) {
    gen_duty <- df
    save(gen_duty, file = "gen_duty.RData") }
  rm(df, gen_duty)
  
}

daily_data()
