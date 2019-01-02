library(shinydashboard)
library(shinythemes)
library(tidyverse)
library(ggplot2)
library(magrittr)

# load datsets
overdoses <- readRDS('data/overdoses.RDS')
opiates <- readRDS('data/opiates.RDS')
state_stats <- readRDS('data/state_stats.RDS') %>% select(-Deaths,-Population,-RxPer100k)
overdose_map <- readRDS('data/overdose_map.RDS')
usa <- readRDS('data/usa.RDS')
opioids_prescribed <- readRDS('data/opioids_prescribed.RDS')
opioid_prescribers <- readRDS('data/opioid_prescribers.RDS')
prescribers_w_opioids <- readRDS('data/prescribers_w_opioids.RDS')

#create years in numerical order for dropdown
years <- as.data.frame(state_stats) %>%
  select(Year) %>%
  unique()
years <- sort(years$Year)

# create a list of quantities that can be shown on the map
quantities <- colnames(state_stats)[4:7]