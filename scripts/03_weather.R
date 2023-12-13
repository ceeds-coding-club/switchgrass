#Challenge -
# 1) merge BOG_..._DegDays.csv weather station outputs
# and summarise to produce a single time series of daily values:
# - max
# - min
# mean (max+min/2)

#There are four separate weather station outputs...
# and there may be some overlapping timestamps
list.files("data", pattern = "BOG.+10313906")

#here's a bit of code to read in the data and do a simple merge...
# but
#  naming is terrible
#  it's not clean
#  and it's not summarised...
#pull the repository, edit locally, push changes
BOG_met <- map(list.files("data", pattern = "BOG.+10313906"),
    \(x) read.csv(str_c("data/", x), row.names = 1, skip = 1)
    ) |>
  reduce(full_join)


# 2) plot the temperature series against data from 02_emergence
# goal is to visualise whether switchgrass genotypes differ in daily mean T
# at which emergence happens,
# and establish if the temperature dataset overlaps with the emergence data
# sufficiently to determine this

# 3) having chosen a daily mean T for emergence, plot:
# log of emergence ~ cumulative T
# Does rate of emergence have similar temperature dependence in all genotypes?
