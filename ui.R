require(shiny)
require(googleVis)
shinyUI(pageWithSidebar(
  headerPanel("Cost of most common medical procedures at US Hospitals based on CMS data"),
  sidebarPanel(
    h3("Select state/procedure"), 
    uiOutput("Controls")    
    #     textInput("address", label="Address", value="615 N Wolfe St, Baltimore, MD"), 
    #     sliderInput("Year", "Election year to be displayed:", 
    #                 min=1932, max=2012, value=2012,  step=4,
    #                 format="###0",animate=TRUE),
  ),
  mainPanel(
    h3(textOutput("add")), 
    htmlOutput("gvis"),
    HTML("This plot shows the average cost (in color) and number of procedures performed (size of circle) 
         for the most popular medical procedures. This data was featured on the <a href='http://www.huffingtonpost.com/2013/05/08/hospital-prices-cost-differences_n_3232678.html'>
         front page of the Huffington Post</a> on May 8, 2013. You can see the raw data <a href='https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/index.html'>here</a>
        from the Centers for Medicare and Medicaid Services. This plot is brought to you by 
         <a href='http://biostat.jhsph.edu/~jmuschel/'>John Muschelli</a> and
         <a href='http://simplystatistics.org'>Simply Statistics</a>. Follow us on Twitter!
         <a href='https://twitter.com/StrictlyStat'>@StrictlyStat</a> and <a href='https://twitter.com/simplystats'>@simplystats</a>.
         Code is located <a href='https://github.com/muschellij2/Shiny_Health_Data'>here</a>.")
  )
  
)
)
