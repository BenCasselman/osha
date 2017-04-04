# Enforcement data: https://enforcedata.dol.gov/views/data_summary.php
library(readr)
library(tidyr)
library(dplyr)
library(httr)

# Updated periodically:
# Accidents
temp <- tempfile()
set_config(config(ssl_verifypeer = 0L))
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_accident_20170322.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
accidents <- read_csv(unzip(temp, file))
save(accidents, file = "accidents.RData")

# Accident abstract
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_accident_abstract_20170322.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
acc_abs <- read_csv(unzip(temp, file))
save(acc_abs, file = "acc_abs.RData")

# Injury 
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_accident_injury_20170322.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
injury <- read_csv(unzip(temp, file))
save(injury, file = "injury.RData")

# UPDATED DAILY
# Inspections
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_inspection_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
inspections <- read_csv(unzip(temp, file))
save(inspections, file = "inspections.RData")

# Optional info
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_optional_info_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
optional <- read_csv(unzip(temp, file))
save(optional, file = "optional.RData")

# Related
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_related_activity_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
related <- read_csv(unzip(temp, file))
save(related, file = "related.RData")

# Violations
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
violations <- read_csv(unzip(temp, file))
save(violations, file = "violations.RData")

# Violation event
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_event_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
viol_event <- read_csv(unzip(temp, file))
save(viol_event, file = "viol_event.RData")

# Gen duty
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_violation_gen_duty_std_20170325.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
gen_duty <- read_csv(unzip(temp, file))
save(gen_duty, file = "gen_duty.RData")

# Data dictionary
url <- "https://enfxfr.dol.gov/data_catalog/OSHA/osha_data_dictionary_20170324.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
dictionary <- read_csv(unzip(temp, file))

dictionary %>% 
  filter(Table_Name == "osha_accident") %>% 
  View("dictionary")

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


load("violations.RData")


# Fines
violations %>% 
  filter(!is.na(current_penalty), year(issuance_date) > 2012) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(fine = sum(current_penalty)) %>% 
  ggplot(., aes(month, fine)) + geom_bar(stat = "identity") + ggtitle("OSHA fines issued per month")

violations %>% 
  filter(!is.na(current_penalty), year(issuance_date) > 2012) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(fine = sum(current_penalty)) %>% View("fines")


violations %>% 
  filter(year(issuance_date) > 2012) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(viols = length(current_penalty)) %>% 
  ggplot(., aes(month, viols)) + geom_bar(stat = "identity") + ggtitle("OSHA violations by month")

violations %>% 
  filter(year(issuance_date) > 2012) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(viols = length(current_penalty)) %>% View("violations")

violations %>% filter(issuance_date > as.Date("2017-03-01")) %>% arrange(desc(issuance_date))


violations %>% 
  filter(year(issuance_date) > 2012) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(viols = length(current_penalty)) %>% 
  ggplot(., aes(month, viols)) + geom_bar(stat = "identity") + ggtitle("OSHA violations by month")

rm(violations)
load("inspections.RData")

# Inspections by month (color to help see seasonal pattern)
inspections %>% 
  filter(year(open_date) > 2008) %>% 
  mutate(month = as.Date(cut(open_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(inspec = length(month)) %>% 
  ggplot(., aes(month, inspec, fill = as.factor(month(month)))) + geom_bar(stat = "identity") + ggtitle("OSHA inspections by month")