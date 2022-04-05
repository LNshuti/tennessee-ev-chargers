# Davidson County EV Chargers

App showing interactive map of EV charging infrastructure in Davidson county, utilising Shiny and Leaflet in R. In addition to showing exact locations of all EV chargers on the county map, we include the median income by geography to test the hypothesis that the location of chargers is correlated with an area's income.  



```{r}
tn_wide <- get_acs(
  geography = "county",
  state = "Tennessee",
  variables = c(medinc = "B19013_001"),
  output = "wide",
  year = 2019
)
```