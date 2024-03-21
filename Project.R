# Load R packages
#install.packages("shinythemes")

library(tidyverse)
library(imputeTS)

df <- "https://intro-datascience.s3.us-east-2.amazonaws.com/HMO_data.csv"
File1 <- read_csv(df)
File1$bmi <- na_interpolation(File1$bmi)
File1$hypertension <- na_interpolation(File1$hypertension)

File1$highcost <- as.factor(File1$cost >= 4775)
library(kernlab)
library(caret)
library(ggplot2)
library(maps)
library(mapproj)
library(dplyr)
set.seed(110)
trainList <- createDataPartition(y=File1$highcost,p=.80,list=FALSE)
trainset <- File1[trainList, ]
testSet <- File1[-trainList, ]

svmFile1 <- ksvm(highcost ~age+bmi+smoker+hypertension+exercise+yearly_physical+education_level,data=trainset, C=5, cross=3, prob.model=TRUE)
svmFile1
svmFile2 <- predict(svmFile1,testSet)

File1$region <- tolower(File1$location)
file2 <- File1 %>% filter(File1$cost<40000)
us <- map_data("state")
mapandfile <- merge(file2,us,by="region")
mapandfile <- mapandfile %>% arrange(order)


library(shiny)
library(shinythemes)
library(shinyWidgets)
x<-data.frame('box_plot','Bar_graph','Scatter_plot')
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  # theme = "cerulean",  # <--- To use a theme, uncomment this
                  "Medical Expenses",
                  tabPanel("Data",
                           sidebarPanel(
                             tags$h3("Input:"),
                             #textInput("txt1", "Given Name:", ""),
                             #textInput("txt2", "Surname:", ""),
                             fileInput("file1", "Choose CSV File test data set", accept=c('text/csv', 
                                                                                          'text/comma-separated-values,text/plain','.csv')),
                             fileInput("file2", "Choose CSV File test validation set", accept=c('text/csv', 
                                                                                                'text/comma-separated-values,text/plain','.csv'))
                             
                           ), # sidebarPanel
                           mainPanel(
                             h1("Test Data View"),
                             tableOutput("dataT"),
                             
                           ) # mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Confusion Matrix", verbatimTextOutput("con")
                  ),
                  
                  tabPanel("Result",verbatimTextOutput("Res")),
                  tabPanel("Sensitivity",verbatimTextOutput("sen")),
                  tabPanel("Exploratory Analysis",
                                          verticalTabsetPanel(
                                            verticalTabPanel("Bar graph",
                                                             icon = icon("house", "fa-2x"),
                                                             tabPanel("Location",plotOutput("Loc")),
                                                             tabPanel("State",plotOutput("sm"))
                                                             ),
                                            verticalTabPanel("Scatter Plot"),
                                            verticalTabPanel("Box Plot"),
                                            color = "#112446",
                                            contentWidth = 9,
                                            menuSide = "left"
                                          )
                           ),
                           
                  tabPanel("Maps",plotOutput("map"))
                  
                 )# navbarPage
) # fluidPage


# Define server function

server <- function(input, output) {
  
  #file
  mydata <- reactive({
    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    read.csv(file$datapath)
  })
  #data_stored <- read.csv(file$datapath)
  mydata2 <- reactive({
    file <- input$file2
    ext <- tools::file_ext(file$datapath)
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    read.csv(file$datapath)
  })

  output$Res <- renderPrint({
    sol <- predict(svmFile1,mydata())
    sol
  })
  
  output$con <- renderPrint({
    confusionMatrix(svmFile2,testSet$highcost)
  })
  output$sen <- renderPrint({
    sol <- predict(svmFile1,mydata())
    act <- mydata2()$expensive
    con <- table(sol,act)
    sensitivity(con)
  })
  output$map<-renderPlot({
    map2 <- ggplot(mapandfile, aes(map_id=location)) + aes(x=long, y=lat, group=group)+
      geom_polygon(aes(fill=cost))+scale_fill_viridis_c(option="D")+
      coord_fixed(ratio = 1.5) +
      scale_y_continuous(expand = c(0,0))
    map2
  })
  output$dataT <- renderTable({
    mydata()
  })
  output$Loc<-renderPlot({h<-ggplot(File1)+aes(x=location,y=cost,fill=location)+geom_bar(stat="identity")
  h})
  output$Sm<-renderPlot({h<-ggplot(File1)+aes(x=smoker,y=cost,fill=smoker)+geom_bar(stat="identity")
  h})
 
}

 # server


# Create Shiny object
shinyApp(ui = ui, server = server)