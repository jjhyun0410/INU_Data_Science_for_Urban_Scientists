# Chicago Open Data - Crime Data API Example

# Install and load packages
install.packages("RCurl")
install.packages("rjson")
install.packages("dplyr")

library(RCurl)
library(jsonlite)

# ----------------------------------------
# Chicago crime data API endpoint
# Page: https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2
api_url = "https://data.cityofchicago.org/resource/crimes.json"


# Read JSON data and convert them to dataframe
df = fromJSON(getURL(api_url))

nrow(df)
head(df)
View(df)

# ----------------------------------------
# Only extract 2005 crime data
api_url2 = "https://data.cityofchicago.org/resource/crimes.json?year=2005"

# Read JSON data
df2 = fromJSON(getURL(api_url2))

nrow(df2)
head(df2)
View(df2)

     
