if (!require('shiny')) install.packages('shiny'); library('shiny')
if (!require('plotly')) install.packages('plotly'); library('plotly')
if (!require('COVID19')) install.packages('COVID19'); library('COVID19')
if (!require('ggplot2')) install.packages('ggplot2'); library('ggplot2')
if (!require('thematic')) install.packages('thematic'); library('thematic')
if (!require('ggstance')) install.packages('ggstance'); library('ggstance')
if (!require('broom.mixed')) install.packages('broom.mixed'); library('broom.mixed')
if (!require('car')) install.packages('car'); library('car')

server <- function(input, output) {
    
    observeEvent(input$reset, {
        shinyjs::reset("country") 
        shinyjs::reset("type") 
        shinyjs::reset("level") 
        shinyjs::reset("date") 
        shinyjs::reset("plotType")
        
    })
    
    newData <- reactive({
        mydataset <- covid19(country = input$country, level = input$level,
                start = input$date[1], end = input$date[2])
    })
    
##############################################
# Scatter plot
    
    output$plot1 <- renderPlotly({ 
        if(!is.null(input$country)){
            
            mydata <- newData()
            
            color <- paste0("administrative_area_level_", input$level)
         
            if (input$plotType == "plots") {
                
                fig <- plot_ly(x = mydata[["date"]], y = mydata[[input$type]], 
                               color = mydata[[color]])
                
                m <- list(l = 50, r = 50, b = 100, t = 100, pad = 4)
                f14 <- list(family = "sans serif", size = 14, color = 'Black')
                f12 <- list(family = "sans serif", size = 12, color = 'Black')
                
                fig <- fig %>% layout(title = 'Covid19 Cases for All Countries and Regions by Date (Scatter plot)',
                                      xaxis = list(title = 'Date', font = f12),
                                      yaxis = list(title = 'Number of cases', font = f12), 
                                      font = f14, margin = m)
                
                fig
            }
        }
    })

    
##############################################
# Bar plot
    
    output$plot2 <- renderPlotly({

        if(!is.null(input$country)){
            
            mydata <- newData()
            color <- paste0("administrative_area_level_", input$level)

            if (input$plotType == "plots") {
                
                Countries <- mydata[[color]]
                
                p <- ggplot(mydata, aes(x=mydata[["date"]], y=mydata[[input$type]], fill = Countries)) + 
                    geom_bar(stat='identity') + coord_flip() + theme_minimal() +
                    ggtitle("Covid19 Cases for All Countries and Regions by Date (Bar plot)") +
                    xlab("Date") + ylab("Number of observations")

                p + theme(
                    plot.margin = margin(2, 2, 0, 0, "cm"),
                    plot.title = element_text(family = "sans serif", size = 14, color = 'Black'),
                    axis.title.x = element_text(family = "sans serif", size = 12, color = 'Black'),
                    axis.title.y = element_text(family = "sans serif", size = 12, color = 'Black') 
                ) 
            }
        }
    })
    
    
##############################################
# Regression Analysis   
    
    output$summary <- renderPrint({
        
        if (input$plotType == "RegressionAnalysis") {
            
            mydata <- newData()

            m1 <- lm(confirmed ~ school_closing + workplace_closing + 
                         cancel_events + gatherings_restrictions + transport_closing + 
                         stay_home_restrictions + internal_movement_restrictions + 
                         international_movement_restrictions + information_campaigns + 
                         testing_policy + contact_tracing, data = mydata)
            
            summary(m1)
        }
    })

    
##############################################
# References & why this porject is meaningful
    
    output$Reference <- renderText({ 
        paste("The dataset used in this project is from package'COVID19'. This project visualize the various kinds of cases of Covid-19 for all countries and regions.
              It also presents the relation of cases and the government policies 
              which gives us a clear view of the efficiency of the related policies in covid-19 prevention.")
    })
    
}
