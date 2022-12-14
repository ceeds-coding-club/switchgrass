#code from weekly_meetings/week1/BOG_background.qmd

#Selected 
library(tidyverse)
library(readxl)

theme_set(theme_classic())   # getting rid of ggplot defaults (e.g. grey background) (MH)


#read data
BOG_sen <- read_excel("data/BOG_Senescence.xls",na = "NA") %>%
  pivot_longer(cols = -(pop:popblock),names_to = "date", values_to = "senesc") %>%
  mutate(across(pop:popblock, as_factor),
         date = as.Date(as.numeric(date), origin = "1899-12-30"),
         day_of_year = julian(date, origin = as.Date("2014-01-01"))
  )

head(BOG_sen)
summary(BOG_sen)

#plot data

BOG_sen %>%
  ggplot(aes(day_of_year, senesc)) +
  geom_point() +
  facet_wrap(~pop) +
  geom_smooth()


#read switchgrass population information, source/ploidy/etc.

BOG_sen_details <- left_join(
  BOG_sen,
  read_excel("data/BOG_geoloc_ecot_ploid_SaraH.xlsx") %>%
    rename(pop = population)
)

#summarise out pseudoreps (subplots a & b)

BOG_sen_summ <- BOG_sen_details %>%
  group_by(clone, day_of_year, pop, ecotype, ploidy, lat, lon) %>%
  summarise(senesc = median(senesc, na.rm = TRUE))

#Plot the improved and corrected dataset using information about latitude

BOG_sen_summ %>%
  ggplot(aes(day_of_year, senesc, colour = lat)) +
  geom_point(alpha=0.5) +                            # alpha = making points slightly transparent (MH)
  facet_wrap(~reorder(pop, lat)) +
  geom_smooth() +
  xlab("Day of year") + ylab("Senescence (units?)") +# customise axis titles (MH)
  labs(colour = "Latitude")                          # specifying legend title (MH)


## JR - looking at latitudinal spread of ploidy (change colour = ploidy)
## ploidy 8 more common in high latitude vs. ploidy 4 in low latitude..confounding?
## Also need to fix ploidy = NA for one population
BOG_sen_summ %>%
  ggplot(aes(day_of_year, senesc, colour = ploidy)) +
  geom_point(alpha=0.5) +                            # alpha = making points slightly transparent (MH)
  facet_wrap(~reorder(pop, lat)) +
  geom_smooth() +
  xlab("Day of year") + ylab("Senescence") +# customise axis titles
  labs(colour = "Ploidy")    +                      # specifying legend title
  scale_y_continuous(breaks=seq(0,10, 2))

## Explore the effect of ecotype  
BOG_sen_summ %>%
  ggplot(aes(day_of_year, senesc, colour = pop)) +
  geom_point(alpha=0.5) +                            
  facet_wrap(~ecotype) +
  geom_smooth() +
  xlab("Day of year") + ylab("Senescence (units?)") +
  labs(colour = "pop")  


##### RK
BOG_emerge <- read_excel("data/BOG_Emergence.xls",na = "NA")

