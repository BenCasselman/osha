# Wage and hour violations data: https://enforcedata.dol.gov/views/data_summary.php

library(readr)
library(tidyr)
library(dplyr)
library(httr)
library(ggplot2)
library(lubridate)

# WHD 
temp <- tempfile()
set_config(config(ssl_verifypeer = 0L))
url <- "https://enfxfr.dol.gov/data_catalog/WHD/whd_whisard_20170314.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
whd <- read_csv(unzip(temp, file))

url <- "https://enfxfr.dol.gov/data_catalog/WHD/whd_data_dictionary_20170314.csv.zip"
GET(url, write_disk(temp, overwrite=TRUE))
file <- as.character(unzip(temp, list = T)[1])
whd_dictionary <- read_csv(unzip(temp, file))


whd %>% 
  filter(!is.na(bw_atp_amt), year(findings_start_date) >= 1980) %>% 
  mutate(month = as.Date(cut(findings_start_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(fine = sum(bw_atp_amt)) %>% 
  ggplot(., aes(month, fine)) + geom_bar(stat = "identity") +
  ggtitle("Total WHD back wages")
