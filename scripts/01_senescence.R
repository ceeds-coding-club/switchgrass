#code from weekly_meetings/week1/BOG_background.qmd

#Selected 
library(tidyverse)
library(here)
library(readxl)

#read data

BOG_sen <- read_excel(here("BOG_Senescence/BOG_Senescence.xls"),
                              na = "NA"
) %>%
  pivot_longer(-(pop:popblock)) %>%
  mutate(across(pop:popblock, as_factor)) %>%
  rename(date = name, senesc = value) %>%
  mutate(date = as.Date(as.numeric(date), origin = "1899-12-30"),
         day_of_year = julian(date, origin = as.Date("2014-01-01"))
  )

head(BOG_sen)

#plot data

BOG_sen %>%
  ggplot(aes(day_of_year, senesc)) +
  geom_point() +
  facet_wrap(~pop) +
  geom_smooth()


#read switchgrass population information, source/ploidy/etc.

BOG_sen_details <- left_join(
  BOG_sen,
  readxl::read_excel(here("BOG_senescence/BOG_geoloc_ecot_ploid_SaraH.xlsx")) %>%
    rename(pop = population)
)

#summarise out pseudoreps (subplots a & b)

BOG_sen_summ <- BOG_sen_details %>%
  select(clone, day_of_year, pop, ecotype, ploidy, lat, lon, senesc) %>%
  group_by(clone, day_of_year, pop, ecotype, ploidy, lat, lon) %>%
  summarise(senesc = median(senesc, na.rm = TRUE))

#Plot the improved and corrected dataset using information about latitude

BOG_sen_summ %>%
  ggplot(aes(day_of_year, senesc, colour = lat)) +
  geom_point() +
  facet_wrap(~reorder(pop, lat)) +
  geom_smooth()
