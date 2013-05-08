gvisGeoChart2 <- function (data, locationvar = "", colorvar = "", sizevar = "", 
          numvar = "",
          options = list(), chartid) 
{
  my.type <- "GeoChart"
  dataName <- deparse(substitute(data))
  my.options <- list(gvis = modifyList(list(width = 556, height = 347), 
                                       options), 
              dataName = dataName, 
              data = list(locationvar = locationvar,
                colorvar = colorvar, sizevar = sizevar, 
                allowed = c("number", "string")))
  checked.data <- googleVis:::gvisCheckGeoChartData(data, my.options)
  if (any("numeric" %in% lapply(checked.data[, 1], class))) {
    my.options <- modifyList(list(gvis = list()), my.options)
  }
  output <- googleVis:::gvisChart(type = my.type, checked.data = checked.data, 
                      options = my.options, chartid = chartid)
  return(output)
}

df <- data[1:10,]
df$Provider.Name <- as.character(df$Provider.Name)
reg <- "US"
sizevar <- "Total.Discharges"
labelvar <- "Provider.Name"
xx <-     gvisGeoChart(df,  locationvar="locationvar", colorvar="Average.Total.Payments",
                       sizevar=sizevar,
                       options=list(region=reg, resolution= "provinces",  dataMode="markers", 
                                    width=500, height=400,
                                    colorAxis="{colors:['#FFFFFF', '#FF0000']}"
                       ), chartid="7")   
xxx <- xx

xx <- xxx

x <- strsplit(xx$html$chart[2], "\\n")
x <- x$jsData
pushers <- grepl(pattern="[", x=x, fixed=TRUE)
pushers <- which(pushers)[-1]
x[pushers+2] <- paste0(x[pushers+2], "\n", paste0("'", df$Provider.Name, "',"))
addcol <- grep(paste0("data.addColumn('number','Longitude');"), x=x, fixed=TRUE)
x <- c(x[1:addcol], paste0("data.addColumn('string', 'DESCRIPTION', '", labelvar, "');"), x[(addcol+1):length(x)])


x <- paste0(x, collapse="\n")
xx$html$chart[2] <- x
plot(xx)
xx