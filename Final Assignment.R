library(tidyverse)
library(knitr)
library(bslib)
library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

#Gets data from CSV
df <- read_csv("McDaniel/ANA 515/StormEvents_details-ftp_v1.0_d2012_c20221216.csv")

#Creates filter and removes necessary columns and rows
filtered <- df %>% 
  select(BEGIN_YEARMONTH, EPISODE_ID, STATE, STATE_FIPS, CZ_NAME, CZ_TYPE, CZ_FIPS, EVENT_TYPE) %>%
  arrange(STATE)%>%
  filter(CZ_TYPE != "C") %>%
  select(-CZ_TYPE)

  
#Renames columns, creates new colums
filtered$STATE = str_to_title(filtered$STATE)
filtered$STATE_FIPS = str_pad(filtered$STATE_FIPS, width = 3, side = "left", pad = "0" )
filtered$CZ_FIPS = str_pad(filtered$CZ_FIPS, width = 3, side = "left", pad = "0" )
filtered$FIPS = paste(filtered$STATE_FIPS, filtered$CZ_FIPS, sep = "")
filtered = rename_all(filtered, tolower)


state_data = data.frame(state=state.name, region=state.region, area=state.area)


newset = data.frame(table(state = filtered$state))
merged = merge(x=newset,y=state_data,by.x="state", by.y="state")


frequency_plot = ggplot(merged, aes(x= area, y=Freq)) + geom_point(aes(color=region)) + labs(x = "Land Area (sq. miles)", y = "# of storms in 2012")
frequency_plot
