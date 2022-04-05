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

# Import TN county shapefile
sf_county <-
  read_sf(paste0(repo_path,
                 "/data/county/01_county-shape-file.shp")) %>% 
  st_transform(crs = 4326) %>% 
  filter(statefp == "47") %>% 
  left_join(tn_wide, by = "geoid")
  
   sf_county %>%
  ggplot() + 
  geom_sf(aes(fill = medinc_e)) +
  scale_fill_gradient2(low = scales::muted("blue"),
                       mid = "white",high = scales::muted("red"),
                       midpoint = 44122,limits = c(0,150000)) + 
  coord_sf(datum=NA) + 
  labs(fill="Median Income, 2019") + 
  ggtitle("Tennessee Median Income by county") + 
  ggthemes::theme_tufte(base_family = "Gill Sans")
```

Plot baseline Tennessee Map showing the distribution of median income by county. 


![](/Users/leoncenshuti/Desktop/portfolio/tennessee-ev-chargers/output/tn_income_2019.png)


