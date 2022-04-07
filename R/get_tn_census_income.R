# Load required libraries

repo_path <- "tennessee-ev-chargers"
suppressWarnings(suppressMessages(source(paste0(repo_path, "/manifest.R"))))


# In order to use the tidycensus package, the user needs to register an API 
# Key on the census data website. 
# After obtaining your key, use the **census_api_key()** function to set the key 
# as an environment variable.
census_key <- Sys.getenv()
census_api_key(key = census_key$CENSUS_API_KEY)

# The latest available data is in 2019
tn_wide <- get_acs(
   geography = "county",
   state = "Tennessee",
   variables = c(medinc = "B19013_001"),
   output = "wide",
   year = 2019
 )

readr::write_csv(tn_wide, paste0(repo_path, "/data/tn_medianincome_2019.csv"))

# Get more glanular data i.e median income at the census tract level
tn_wide_census <-
  get_acs(geography = "tract",
          state = "Tennessee",
          variables = c(medinc = "B19013_001"),
          output = "wide",
          year = 2019)

readr::write_csv(tn_wide_census,
                 paste0(repo_path, "/data/tn_censustrack_medianincome_2019.csv"))