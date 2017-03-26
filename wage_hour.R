# Wage hour data: https://enforcedata.dol.gov/views/data_summary.php
library(readr)
library(tidyr)
library(dplyr)
library(httr)

# Get data
temp <- tempfile()
set_config(config(ssl_verifypeer = 0L))
url <- "https://enfxfr.dol.gov/data_catalog/WHD/whd_whisard_20170314.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
whd <- read_csv(unzip(temp, file))
save(whd, file = "whd.RData")

# Data dictionary
url <- "https://enfxfr.dol.gov/data_catalog/WHD/whd_data_dictionary_20170314.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
whd_dictionary <- read_csv(unzip(temp, file))
save(whd_dictionary, file = "whd_dictionary.RData")
