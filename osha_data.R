# Enforcement data: https://enforcedata.dol.gov/views/data_summary.php
library(readr)
library(tidyr)
library(dplyr)
library(httr)

# Accidents
set_config(config(ssl_verifypeer = 0L))
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_accident_20170322.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
accidents <- read_csv(unzip(temp, file))

# Violations
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
violations <- read_csv(unzip(temp, file))

# Inspections
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_inspection_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
inspections <- read_csv(unzip(temp, file))

# Data dictionary
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_data_dictionary_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
dictionary <- read_csv(unzip(temp, file))
