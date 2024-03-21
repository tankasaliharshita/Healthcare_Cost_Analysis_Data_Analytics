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
ui <- fluidPage(theme = shinytheme("slate"),
                navbarPage(
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
                           
                  ), 
                  tabPanel("Confusion Matrix", verbatimTextOutput("con")
                  ),
                  
                  tabPanel("Result",verbatimTextOutput("Res")),
                  tabPanel("Sensitivity",verbatimTextOutput("sen")),
                  tabPanel("Exploratory Analysis",
                           sidebarLayout(
                             sidebarPanel(
                               radioButtons("dist", "Type of Graph:",
                                            c("Bar Graph" = "Bar",
                                              "Scatter Plot" = "Sca",
                                              "Box Plot" = "Box")
                                            ),
                                          ),
                            mainPanel(
                              tabsetPanel(type = "tabs",
                                          tabPanel("Age",plotOutput("age")),
                                          tabPanel("BMI",plotOutput("bmi")),
                                          tabPanel("Yearly_physical",plotOutput("yp")),
                                          tabPanel("Location",plotOutput("Loc")),
                                          tabPanel("Smoker", plotOutput("smo")),
                                          tabPanel("Hypertension", plotOutput("st")),
                                          tabPanel("Exercise", plotOutput("ex")),
                                          tabPanel("Gender", plotOutput("gen")),
                                          tabPanel("Married", plotOutput("mar")),
                                          tabPanel("Education Level", plotOutput("edu"))
                                          )
                                    )
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
  
  
  d <- function(type){
    dist <- switch(input$dist,
                    Bar= geom_bar(stat="identity"),
                   Sca = geom_jitter(),
                   Box = geom_boxplot())
  }
  output$bmi<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=bmi,y=cost,color=bmi)+d()
    h})
  output$yp<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=yearly_physical,y=cost,color=yearly_physical)+d()
    h})
  output$Loc<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=location,y=cost,color=location)+d()
  h})
  output$smo<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=smoker,y=cost,color=smoker)+d()
  h})
  output$edu<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=education_level,y=cost,color=education_level)+d()
    h})
  output$mar<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=married,y=cost,color=married)+d()
    h})
  output$gen<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=gender,y=cost,color=gender)+d()
    h})
  output$ex<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=exercise,y=cost,color=exercise)+d()
    h})
  output$st<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=hypertension,y=cost,color=hypertension)+d()
    h})
  output$age<-renderPlot({
    dist<-input$dist
    h<-ggplot(File1)+aes(x=age,y=cost,color=age)+d()
    h})
  
}

# server


# Create Shiny object
shinyApp(ui = ui, server = server)