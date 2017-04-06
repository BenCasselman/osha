# Tracking inspections activity
library(tidyr)
library(dplyr)
library(ggplot2)
library(lubridate)

# First update data. This function is from "labor_updater" file
daily_data()

load("inspections.RData")
load("violations.RData")

# Overall inspections by month
inspections %>% 
  mutate(month = as.Date(cut(open_date, breaks = "month"))) %>% 
  ggplot(., aes(month)) + geom_bar()

# Inspections by month (color to help see seasonal pattern)
inspections %>% 
  filter(year(open_date) > 2008) %>% # More recent data
  mutate(month = as.Date(cut(open_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(inspec = length(month)) %>% 
  ggplot(., aes(month, inspec, fill = as.factor(month(month)))) + geom_bar(stat = "identity") + ggtitle("OSHA inspections by month")

# Violations by month
violations %>% 
  filter(year(issuance_date) > 2008) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(viols = length(current_penalty)) %>% 
  ggplot(., aes(month, viols)) + geom_bar(stat = "identity") + ggtitle("OSHA violations by month")


# Penalties by month
violations %>% 
  filter(!is.na(current_penalty),
         year(issuance_date) > 2008) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(fine = sum(current_penalty)) %>% 
  ggplot(., aes(month, fine)) + geom_bar(stat = "identity") + ggtitle("OSHA fines by month")

# Look ONLY at federal OSHA inspections
inspections %>% 
  filter(substr(reporting_id, 3, 3) != 5) %>% # Remove state plan states
  filter(year(open_date) > 2008) %>% # More recent data
  mutate(month = as.Date(cut(open_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(inspec = length(month)) %>% 
  ggplot(., aes(month, inspec, fill = as.factor(month(month)))) + geom_bar(stat = "identity") + ggtitle("OSHA federal office inspections by month")

inspections %>% 
  filter(year(open_date) > 2008, substr(reporting_id, 3, 3) != 5) %>% 
  select(activity_nr) %>% 
  inner_join(violations, by = "activity_nr") %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(viols = length(current_penalty)) %>% 
  ggplot(., aes(month, viols)) + geom_bar(stat = "identity") + ggtitle("OSHA federal violations by month")


inspections %>% 
  filter(year(open_date) > 2008, substr(reporting_id, 3, 3) != 5) %>% 
  select(activity_nr) %>% 
  inner_join(violations, by = "activity_nr") %>% 
  filter(!is.na(current_penalty),
         year(issuance_date) > 2008) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(fine = sum(current_penalty)) %>% 
  ggplot(., aes(month, fine, fill = as.factor(month(month)))) + geom_bar(stat = "identity") + ggtitle("OSHA Federal office fines by month")

# Just look at programmatic inspections
# Limit to planned, program related
inspections %>% 
  filter(substr(reporting_id, 3, 3) != 5) %>% # Remove state plan states
  filter(year(open_date) > 2008, insp_type %in% c("H", "I", "K")) %>% # More recent data
  mutate(month = as.Date(cut(open_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(inspec = length(month)) %>% 
  ggplot(., aes(month, inspec, fill = as.factor(month(month)))) + geom_bar(stat = "identity") + ggtitle("OSHA federal office inspections by month")

# By industry
naics <- read_csv("naics_codes_major.csv")
naics <- naics %>% mutate(naics_code = as.character(naics_code))

inspections %>% 
  filter(substr(reporting_id, 3, 3) != 5) %>% # Remove state plan states
  filter(year(open_date) > 2008) %>% # More recent data
  mutate(month = as.Date(cut(open_date, breaks = "month")),
         maj_ind = substr(naics_code, 1, 2)) %>% 
  left_join(naics, by = c("maj_ind" = "naics_code")) %>% 
  group_by(month, major_ind) %>% 
  summarize(inspec = length(month)) %>% 
  ggplot(., aes(month, inspec, fill = as.factor(month(month)))) + geom_bar(stat = "identity") + facet_wrap(~major_ind)

# mining
inspections %>% 
  filter(substr(reporting_id, 3, 3) != 5) %>% # Remove state plan states
  filter(year(open_date) > 2008, # More recent data
         substr(naics_code, 1, 2) == 21) %>% # Mining industry
  mutate(month = as.Date(cut(open_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(inspec = length(month)) %>% 
  ggplot(., aes(month, inspec, fill = as.factor(month(month)))) + geom_bar(stat = "identity") 

violations %>% 
  filter(!is.na(current_penalty)) %>% 
  mutate(month = as.Date(cut(issuance_date, breaks = "month"))) %>% 
  group_by(month) %>% 
  summarize(fine = sum(current_penalty)) %>% View()
arrange(desc(fine))



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

