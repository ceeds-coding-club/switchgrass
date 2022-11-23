## Read in Emergence dataset
source('scripts/01_senescence.R')

# Block = same as BOG_sen_details, but lower case letter
# Type = same as BOG_sen_details, but lower case letters

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





##### Leo #####

emerg_ed <- emerg %>% 
              group_by(block,type) %>% 
              pivot_longer(cols = (3:13),
                           names_to = "interval", values_to = "emerge") %>% 
              mutate(cat = substr(interval, 1,3),
                     date = parse_date(substr(interval, 4, 9), format = "%m%y%d"),
                     popblock = toupper(paste0(type, block)))

# rearranging columns
emerg_ed <- emerg_ed[,c(1:3,7,5,6,4)]

  



