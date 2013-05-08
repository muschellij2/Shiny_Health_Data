rm(list=ls())
library(RCurl)
library(RJSONIO)
library(dismo)
# setwd("~/Dropbox/Computing_Club/Shiny_Health_Data/")
construct.geocode.url <- function(address, return.call = "json", sensor = "false") {
  root <- "http://maps.google.com/maps/api/geocode/"
  u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
  return(URLencode(u))
}

gGeoCode <- function(address,verbose=FALSE) {
  if(verbose) cat(address,"\n")
  u <- construct.geocode.url(address)
  doc <- getURL(u)
  x <- fromJSON(doc,simplify = FALSE)
  if(x$status=="OK") {
    lat <- x$results[[1]]$geometry$location$lat
    lng <- x$results[[1]]$geometry$location$lng
    return(c(lat, lng))
  } else {
    return(c(NA,NA))
  }
}

data <- read.csv("Medicare_Provider_Charge_Inpatient_DRG100_FY2011.csv")
data$address <- paste0(data$Provider.Street.Address, ", ", data$Provider.City, ", ", data$Provider.State)
adds <- unique(data[, c("address", "Provider.Id")])
lat.longs <- read.csv("geoCoded.csv")
colnames(lat.longs) <- c("address", "lat", "long")

# 
# lat.longs <- matrix(NA, nrow=NROW(adds), ncol=2)
# iadd <- 1
# for (iadd in 1:NROW(adds)) {
#   lat.longs[iadd,] <- gGeoCode(adds$address[iadd])
#   print(iadd)
# }
# 
# 
# colnames(lat.longs) <- c("lat", "long")
# lat.longs <- data.frame(lat.longs, stringsAsFactors=FALSE)
# redo <- which(is.na(lat.longs$lat) | is.na(lat.longs$long))
# while(length(redo) > 1){
#   print(length(redo))
#   redo <- which(is.na(lat.longs$lat) | is.na(lat.longs$long))
#   
#   areNA <- FALSE
#   for (iadd in redo) {
#     lat.longs[iadd,] <- gGeoCode(adds$address[iadd])
#     areNA <- any(is.na(lat.longs[iadd,]))
#     if (areNA) {
#       print("sleeping")
#       Sys.sleep(5) 
#     }
#     print(iadd)
#   }
# }
# 
# lat.longs <- cbind(lat.longs, adds)
# 
ldata <- merge(data, lat.longs,  all.x=TRUE)
if (nrow(ldata) != nrow(data)) stop("Merge went wrong")
wrong <- ldata[ is.na(ldata$lat) | is.na(ldata$long), ]
if (any(is.na(ldata$lat)) | any(is.na(ldata$long))) stop("lat/long went wrong")

data <- ldata
save(data, file="Medicare_Data.Rda")