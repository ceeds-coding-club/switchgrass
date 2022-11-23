

## Read in Emergence
source('scripts/01_senescence.R')

## Old = baseline of stem counts
## New = change in stem counts taken at 3 days
emerg<-read_excel('data/BOG_Emergence.xls')

## Tim's slot
library(tidyverse)
library(readxl)
BOG_emerge <- read_excel("data/BOG_Emergence.xls",na = "NA")
head(BOG_emerge)
view(BOG_emerge)

### Leonardo's slot
BOG_emerg <- read_excel("data/BOG_Emergence.xls",na = "NA")

# Rucha

BOG_emerge <- read_excel("data/BOG_Emergence.xls",na = "NA") %>%
  group_by(block,type) %>% 
  pivot_longer(cols = (new051508:new061512),
               names_to = "interval", values_to = "emerge") 
