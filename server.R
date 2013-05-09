# John Muschelli, May 2013
require(googleVis)
require(shiny)
require(RCurl)
require(RJSONIO)
require(dismo)
require(maps)
require(XML)
library(datasets)

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

gGeoState <- function(address,verbose=FALSE) {
  if(verbose) cat(address,"\n")
  u <- construct.geocode.url(address)
  doc <- getURL(u)
  x <- fromJSON(doc,simplify = FALSE)
  if(x$status=="OK") {
    return(x)
  } else {
    return(NULL)
  }
}
# $address_components[[5]]$short_name



load("Medicare_Data.Rda")

proc <- sort(unique(data$DRG.Definition))

data$locationvar <- paste0(data$lat, ":", data$long)
df <- data

allstates <- state.abb

shinyServer(function(input, output) {
  
  #   print(input$proc)
  dataset <- reactive({
    print(input$proc)
    df <- data[data$DRG.Definition == input$proc, ]
  })
  
  #   myYear <- reactive({
  #     input$Year
  #   })
  
  
  output$add <- renderText({
    paste("Hospitals in", input$state)
  })
  
  output$para <- renderText({
    "Text"
  })
  
  
  output$Controls <- renderUI({
#     df <- dataset()
#     ra <- range(df$Average.Total.Payments, na.rm=TRUE)
#     if (all(is.na(ra)) | all(is.infinite(ra))) ra <- c(0, 1)
#     print(ra)
    list(
      selectInput("state", "Select State", c("USA", allstates), selected="USA"),
      selectInput("proc", "Please Select Procedure Category", proc, selected=proc[1])
    )
  })
  
  output$Ranges <- renderUI({
    df <- dataset()
    ra <- range(df$Average.Total.Payments, na.rm=TRUE)
    if (all(is.na(ra)) | all(is.infinite(ra))) ra <- c(0, 1)
    print(ra)
    list(
      numericInput("minrange", "Minimum Average Payments ($)", ra[1], min = ra[1], max = ra[2],
                   step = 1000),
      numericInput("maxrange", "Maximum Average Payments ($)", ra[2], min = ra[1], max = ra[2],
                   step = 1000)
    )
  })
  
  
  
  output$gvis <- renderGvis({
    df <- dataset()
    # print(head(df))
    #     print(input$address)
    #     dd <- gGeoState(input$address)
    #     print(head(dd))
    #      state <- ifelse(is.null(dd), NA, dd$address_components[[5]]$short_name)
    #     
    #     print(state)
    state <- input$state
    reg <- "US"
    if (!is.null(state)){
      if (state != "USA") {
        df <- df[ df$Provider.State == input$state, ]
        reg <- paste0("US-", state)
      }
    }
#     print(head(df$Provider.State))
#     print(head(df$Average.Total.Payments))
    df <- df[order(df$Provider.State, -df$Average.Total.Payments), ]
    df <- df[ df$Average.Total.Payments >= input$minrange & df$Average.Total.Payments <= input$maxrange, ]
      print(input$minrange)
    #     reg <- ifelse(!is.na(state), state, "US")
    #     gvisGeoMap(df,
    #                  locationvar="locationvar", numvar="Average.Total.Payments",
    #                  options=list(region=reg, dataMode="Markers", 
    #                               width=500, height=400,
    #                               colorAxis="{colors:['#FFFFFF', '#FF0000']}"
    #                        ))     
    
    xx <- gvisGeoChart(df,  locationvar="locationvar", colorvar="Average.Total.Payments",
                       sizevar="Total.Discharges",
                       options=list(region=reg, resolution= "provinces",  dataMode="markers", 
                                    width=500, height=400,
                                    colorAxis="{colors:['#FFFFFF', '#FF0000']}"
                       ), chartid="costchart")   
    xxx <- xx
    
    xx <- xxx
    labelvar <- "Provider.Name"
    sx <- strsplit(xx$html$chart[2], "\\n")
    x <- sx$jsData
    pushers <- grepl(pattern="[", x=x, fixed=TRUE)
    pushers <- which(pushers)[-1]
    x[pushers+2] <- paste0(x[pushers+2], "\n", paste0('"', df$Provider.Name, '",'))
    addcol <- grep(paste0("data.addColumn('number','Longitude');"), x=x, fixed=TRUE)
    colx <- c(x[1:addcol], paste0("data.addColumn('string', 'DESCRIPTION', '", labelvar, "');"), x[(addcol+1):length(x)])
    
    
    x <- paste0(colx, collapse="\n")
    ssx <- strsplit(x, "\\n")
    
    xx$html$chart[2] <- x
    xx
    #     gvisMap(df,
    #                locationvar="locationvar", tipvar="Average.Total.Payments")       
  })
})
