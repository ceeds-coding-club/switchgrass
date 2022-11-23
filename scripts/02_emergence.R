## Read in Emergence dataset
source('scripts/01_senescence.R')

# Block = same as BOG_sen_details, but lower case letter
# Type = same as BOG_sen_details, but lower case letters

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

## Old = baseline of stem counts (with date format MM/YY/DD)
## New = change in stem counts taken at 3 days (with date format MM/YY/DD)
emerg<-read_excel('data/BOG_Emergence.xls', na = "NA")
  
## Things to do:
# trying to replicate the format of BOG_sen (created in scripts/01_scenescence.R)
# clean the ID columns (block, type)
# create columns for date and count
# this will probably need pivot_longer and verbs in the stringr package
head(BOG_sen)
head(emerg)

emerg_long<-emerg %>% 
  group_by(block,type) %>% 
  pivot_longer(cols = (new051508:new061512),
               names_to = "interval", values_to = "emerge") 
