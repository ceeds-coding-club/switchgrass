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

alldata.ed <- emerg %>% 
              pivot_longer(cols = (3:13),
                           names_to = "interval", 
                           values_to = "emerge") %>%                                 #pivot data to long format
              mutate(cat = substr(interval, 1,3),                                    #using the first 3 character of column name as a category: old & new
                     date = parse_date(substr(interval, 4, 9), format = "%m%y%d"),   #using the last 6 character of column name and converting to date format
                     day_of_year = as.numeric(format(date, "%j")),                   #data of the year (1-365) based on date column
                     type = toupper(type), block = toupper(block),
                     clone = paste0(type, substr(block, 1, 1)),
                     popblock = paste0(type, block)) %>%                             #adding var 'popblock' as in BOG_sen
              rename(plot = block) %>%  rename(pop = type) %>%                       #rename columns to match with BOG_sen
              full_join(BOG_sen) %>%                                                 #senesc data is from 2014 and emerg data is from 2014. lots of NAs were included when merged
              left_join((BOG_sen_details %>% select(popblock, ecotype, lat, lon)))
  
  
# rearranging columns
alldata.ed <- alldata.ed[,c(2,1,9,8,6,10,4,7,5,11:13)]

# checking
head(alldata.ed)





