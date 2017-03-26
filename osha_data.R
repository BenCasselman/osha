# OSHA enforcement data: https://enforcedata.dol.gov/views/data_summary.php
library(readr)
library(tidyr)
library(dplyr)
library(httr)

# Accidents
temp <- tempfile()
set_config(config(ssl_verifypeer = 0L))
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_accident_20170322.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
accidents <- read_csv(unzip(temp, file))
save(accidents, file = "accidents.RData")

# Accidents abstract
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_accident_abstract_20170322.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
acc_abs <- read_csv(unzip(temp, file))
save(acc_abs, file = "acc_abs.RData")
rm(acc_abs)

# Injury
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_accident_injury_20170322.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
injury <- read_csv(unzip(temp, file))
save(injury, file = "injury.RData")
rm(injury)

# Inspections
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_inspection_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
inspections <- read_csv(unzip(temp, file))

# Optional info
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_optional_info_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
optional <- read_csv(unzip(temp, file))
save(optional, file = "optional.RData")
rm(optional)

# Related activity
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_related_activity_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
related <- read_csv(unzip(temp, file))
save(related, file = "related.RData")
rm(related)

# Strategic codes
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_strategic_codes_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
strategic <- read_csv(unzip(temp, file))
save(strategic, file = "strategic.RData")
rm(strategic)

# Violations
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
violations <- read_csv(unzip(temp, file))

# Violation events
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_event_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
viol_event <- read_csv(unzip(temp, file))
save(viol_event, file = "viol_event.RData")
rm(viol_event)

# Gen duty
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_gen_duty_std_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
gen_duty <- read_csv(unzip(temp, file))
save(gen_duty, file = "gen_duty.RData")
rm(gen_duty)

# Data dictionary
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_data_dictionary_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
dictionary <- read_csv(unzip(temp, file))

library(ggplot2)
library(lubridate)
ggplot(inspections, aes(open_date)) + geom_bar()

inspections %>% 
  mutate(month = as.Date(cut(open_date, breaks = "month"))) %>% 
  ggplot(., aes(month)) + geom_bar()

violations %>% 
  filter(!is.na(current_penalty)) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(fine = sum(current_penalty)) %>% 
  ggplot(., aes(month, fine)) + geom_bar(stat = "identity")


violations %>% 
  filter(!is.na(current_penalty)) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(fine = sum(current_penalty)) %>% View()
  arrange(desc(fine))

violations %>% 
  mutate(month = as.Date(cut(fta_issuance_date, breaks = "month"))) %>% 
  filter(month == as.Date("1992-02-01")) 