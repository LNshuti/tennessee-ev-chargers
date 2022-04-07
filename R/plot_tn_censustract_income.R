# Load required libraries

repo_path <- "tennessee-ev-chargers"
suppressWarnings(suppressMessages(source(paste0(repo_path, "/manifest.R"))))

tn_censustract_inc <-
  read_csv(paste0(repo_path, "/data/tn_censustrack_medianincome_2019.csv")) %>% 
  janitor::clean_names() %>%
  mutate(geoid = paste0(geoid)) 

tn_census_shape <- 
  read_sf(paste0(repo_path,
                 "/data/tl_2017_47_tract/tl_2017_47_tract.shp")) %>% 
  st_transform(crs = 4326) %>% 
  janitor::clean_names() %>% 
  left_join(tn_censustract_inc, "geoid")

# Census tracts
n_census_income_plt <-
  ggplot(data = tn_census_shape, geom_sf(aes(fill = medinc_e))) +
  scale_fill_gradient2(low = scales::muted("blue"),
                       mid = "white",high = scales::muted("red"),
                       midpoint = 49520,limits = c(0,250000)) +
  coord_sf(datum=NA) +
  labs(fill="") +
  ggtitle("Tennessee Median Income by census tract, 2019") +
  ggthemes::theme_tufte(base_family = "Gill Sans")

ggsave(tn_census_income_plt,
       filename = paste0(repo_path, "/output/tn_census_income_plt_2019.png"),
       width = 8, height = 4)