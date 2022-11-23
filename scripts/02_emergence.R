

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


#read data
BOG_emr <- read_excel("data/BOG_Emergence.xls", na = "NA") %>%
  pivot_longer(cols = -(pop:popblock),names_to = "date", values_to = "senesc") %>%
  mutate(across(pop:popblock, as_factor),
         date = as.Date(as.numeric(date), origin = "1899-12-30"),
         day_of_year = julian(date, origin = as.Date("2014-01-01"))
  )

head(BOG_sen)
summary(BOG_sen)

# Rucha


BOG_emerge <- read_excel("data/BOG_Emergence.xls",na = "NA") %>%
  group_by(block,type) %>% 
  pivot_longer(cols = (new051508:new061512),
               names_to = "interval", values_to = "emerge") 
