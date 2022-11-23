## Read in Emergence

## Tim's slot



### Leonardo's slot


## Sam

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