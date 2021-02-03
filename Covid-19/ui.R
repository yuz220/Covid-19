if (!require('shiny')) install.packages('shiny'); library('shiny')
if (!require('plotly')) install.packages('plotly'); library('plotly')
if (!require('COVID19')) install.packages('COVID19'); library('COVID19')
if (!require('ggplot2')) install.packages('ggplot2'); library('ggplot2')
if (!require('thematic')) install.packages('thematic'); library('thematic')
if (!require('ggstance')) install.packages('ggstance'); library('ggstance')
if (!require('broom.mixed')) install.packages('broom.mixed'); library('broom.mixed')
if (!require('shinyjs')) install.packages('shinyjs'); library('shinyjs')

ui <- fluidPage(
    
    useShinyjs(),
    actionButton("reset", "Clear"), 
    
    titlePanel("Covid-19 Geographic Analytics"),
    
    sidebarLayout(
        sidebarPanel(
            
            h4("Introduction"),
            p("This is a Covid-19 analytics by all countries and regions in 2020. 
              Please check all Selectboxes below to get the resulting plots or analysis:"),
            
            radioButtons("plotType", label = h3("Plot Type"),
                         c(Plots = "plots",  RegressionAnalysis = "RegressionAnalysis")),
            
            selectInput("country", label = "Country", multiple = TRUE,
                        choices = unique(covid19()$administrative_area_level_1),
                        selected = "Canada"),

            conditionalPanel(
                condition = "input.plotType == 'plots'", 
                
                selectInput("type", label = "Type of Cases",
                                choices = c("confirmed", "deaths", "tests", "recovered")),
                
                selectInput("level", label = "Granularity", 
                                choices = c("Country" = 1, "Region" = 2), selected = 1)
            ),
            
            dateRangeInput("date", label = "Date", start = "2020-06-01", end = "2020-08-31")
        ),
        
        mainPanel(
            tabsetPanel(type = "tabs",
                        
                        tabPanel("Scatter Plot", plotlyOutput("plot1")),
                        tabPanel("Bar Plot", plotlyOutput("plot2")),

                        tabPanel(
                            "Regression Analysis", 
                            conditionalPanel(
                                condition = "input.plotType == 'RegressionAnalysis'",
                                verbatimTextOutput("summary")),
                        ), 
                        
                        tabPanel("Reference", textOutput("Reference"))
                
            )
        )
    )
)

