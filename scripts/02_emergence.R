##make sure workspace is set up with the senescence dataset and packages
# we can potentially replace this with a master script later...
source('scripts/01_senescence.R')

## Read in Emergence dataset
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
                     day_of_year = as.numeric(format(date, "%j")),                   #date of the year (1-365) based on date column
                     type = toupper(type), block = toupper(block),                   #editions to match data between data.frames
                     clone = paste0(type, substr(block, 1, 1)),
                     popblock = paste0(type, block)) %>%                             #adding var 'popblock' as in BOG_sen
              rename(plot = block) %>%  rename(pop = type) %>%                       #rename columns to match with BOG_sen
              full_join(BOG_sen) %>%                                                 #senesc data is from 2014 and emerg data is from 2015. lots of NAs were included when merged
              left_join((BOG_sen_details %>% select(popblock, ecotype, lat, lon) %>% 
                           distinct()))
  
  
# rearranging columns
alldata.ed <- alldata.ed[,c(2,1,9,8,6,10,4,7,5,11:13)]

# checking
head(alldata.ed)


##### Sam, working from Leo's code #####

BOG_emerg <- emerg %>% #longer name, explicit about what object is and uses colnames
  pivot_longer(cols = !(block:type),    #using colnames reference - more explicit
                                        #and ?less likely to fail if data changes slightly?
               names_to = "interval", 
               values_to = "tillers"    #a tiller is a single growing point on a grass plant ~stem
               ) %>%  #pivot data to long format
  mutate(old_new = substr(interval, 1,3),                               #using the first 3 character of column name as a category: old_new
         date = parse_date(substr(interval, 4, 9), format = "%m%y%d"),  #using the last 6 character of column name and converting to date format
         #year = as.numeric(format(date, "%Y")),                        #add year to make merge more effective
         day_of_year = as.numeric(format(date, "%j")),                  #date of the year (1-365) based on date column
         type = toupper(type),
         block = toupper(block),                                        #edits to match data between data.frames
         clone = paste0(type, substr(block, 1, 1)),
         popblock = paste0(type, block)) %>%                            #adding var 'popblock' as in BOG_sen
  rename(plot = block, pop = type) %>%                                  #rename columns to match with BOG_sen
  #removing this line because in retrospect this merge makes little sense
  #full_join(BOG_sen) %>%            #senesc data is from 2014 and emerg data is from 2015. lots of NAs were included when merged
  left_join(BOG_sen_details %>%
              select(c(popblock, ecotype:lon, ploidy)) %>%
              distinct()  #left join doesn't trim duplicates from the y dataset,
                          #so we need to do that pre-join
              )

##Add in the same summary step as for senesc to remove duplicated clones
BOG_eme_summ <- BOG_emerg %>% 
group_by(clone, day_of_year, pop, ecotype, ploidy, lat, lon, old_new) %>%
  summarise(tillers = median(tillers, na.rm = TRUE))
   # relocate()                          #rearrange columns 

#Adapting JR's plot from senesce
BOG_eme_summ %>%
  ggplot(aes(day_of_year, tillers, colour = old_new, shape = ploidy)) +
  geom_point(alpha = 0.5) +                            # alpha = making points slightly transparent (MH)
  facet_wrap(~ reorder(pop, lat)) +
  geom_smooth() +
  xlab("Day of year") + ylab("Tillers (count)") +# customise axis titles
  labs(colour = "new or previous year's growth")    # specifying legend title
  #scale_y_continuous(breaks = seq(0,10, 2))

#Version using colour by lat (because this is not necc. very continuous)
BOG_eme_summ %>%
  ggplot(aes(day_of_year, tillers, colour = lat, fill = old_new)) +
  geom_point(shape = 21) +                            # alpha = making points slightly transparent (MH)
  facet_wrap(~ reorder(pop, lat)) +
  geom_smooth(se = FALSE, show.legend = FALSE) +
  xlab("Day of year") + ylab("Tillers (count)") +# customise axis titles
  labs(colour = "latitude of origin",
       fill = "new versus previous year's growth"
         ) +
  scale_colour_gradient(low = "orange", high = "blue") + #colours to imply temperature ~ lat
  scale_fill_discrete(type = c(gray(0.7), gray(1)))
