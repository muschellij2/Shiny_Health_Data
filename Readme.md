Shiny_Health_Data
=================

Shiny Application using CMS Health data spatially.  server.R and ui.R are the shiny applications and the Rda is the file.  CSV is from the medicaid data set.

server.R - uses googleVis and shiny to read in the data and create the sidebar panels and the plot
ui.R - adds the paragraphs and html markups of the doc and lays out the interface
geocoded.csv - used [http://www.findlatitudeandlongitude.com/batch-geocode/#.UYq-sCvR3P0](http://www.findlatitudeandlongitude.com/batch-geocode/#.UYq-sCvR3P0) to batch geocode the hospitals (and used Google Maps to touch up the 4 that didn't convert) - contains address, lat and long
Medicare_Data.Rda -  csv from .zip file, compressed to Rda
IPPS_DRG_CSV - from [https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/index.html](https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/index.html) - where the csv is located.
make_lat_long - used to make Medicare_Data.Rda (need to unzip IPPS_DRG_CSV)
