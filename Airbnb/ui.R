library(shiny)
library(dplyr)
library(shinyWidgets)
library(shinythemes)
library(leaflet)
# Read the major dataset we used for our project
listings2_df <- read.csv("./data/listings 2.csv", stringsAsFactors = FALSE)
neighbourhood_distinct <- distinct(listings2_df, neighbourhood_group_cleansed, keep_all = FALSE)

var1 <- c(
  "Is superhost?" = "host_is_superhost",
  "House Type" = "property_type",
  "Room Type" = "room_type",
  "Price" = "price",
  "Rating" = "review_scores_rating"
)

var2 <- c(
  "Don't show size" = "none",
  "Price" = "price",
  "Rating" = "review_scores_rating"
)

# ui design for the project
shinyUI(fluidPage(
  navbarPage(inverse = F,
             fluid = T,
             theme = shinytheme("flatly"),
             "Aribnb in Seattle",
             
             # introduction of our app
             tabPanel("Home", 
                      tags$h3("Welcome"),
                      p("We are glad to see you here！At this page, we will guide you through to explore our website.
                        Airbnb in Seattle is your ultimate solution to find/host a Airbnb in Greater Seattle Area.
                        We are an independent, non-commercial set of tools and data that allows you to explore how Aribnb is really being used in the city.
                        For travelers, no matter what type of homes you are looking for, there is always a home for you.
                        If you are a host/potential host, feel free to check our website to see what you could expect to be a Superhost!"),
                      tags$h3("About our Dataset"),
                      p("Our target audience would be travelers and property owners. As users of Airbnb in daily life, 
                        we focused on the deep relationship between users and housing hosts. Airbnb shows a wide variety of accommodation 
                        online and has the dataset prepared for a global audience to accommodate their needs. 
                        To travelers who wish to find a place to stay in any city, there’s always a place for everyone. 
                        For travelers, the direction we were interested in is the choice they preferred to make in common situations. 
                        For the property owner, Airbnb in Seattle provides them with a deep analysis of their performance, 
                        which allows them to optimize and earn as much as possible."),
                      tags$h3("Getting Started"),
                      p("With Airbnb in Seattle, you could ask fundamental questions about Airbnb in any neighbourhood or across the city as a whole.
                        Quesitions such as:"),
                      p("- How many listings are there in my neighbourhood and where are they?"),
                      p("- Do different features of Airbnb affect their price or rating? (eg. Are prices higher for Airbnb hosted by superhosts?)"),
                      p("- How do Airbnbs differ between different regions? (eg. Are there more apartment style Airbnb in downtown than in other areas?)"),
                      p("The tools are presented simply as a interactive map, dataset with filter and text/plot analysis."),
                      tags$h3("Technical Stuff"),
                      p("We used a Shiny App to document our investigation and analysis of the data. In most parts, we used ‘dplyr’, 
                        ‘ggplot2’, and ‘leaflet’ to produce the outputs we wanted. In order to improve our surface much more concise, 
                        we created and wrote many datasets and stored them in the repository. A challenge we faced was creating a map 
                        including every housing information inside. This was solved by debugging again and again."),
                      tags$h3("Disclaimer"),
                      p("- This site is nor associated with or endorsed by Airbnb or any of Airbnb's competitors."),
                      p("- The data utilizes public information compiled online including the availibility calendar for 365 in the future,
                        and reviews for each listing. Data is verified, cleansed, analyzed and aggregated"),
                      p("- No private information is being used, including names, photographs, 
                        listings and review details are all publicly displayed on the aribnb site"),
                      p("- Accuracy of the information compiled from the Aribnb site is not the responsibility of 'Airbnb in Seattle'")
                      ),
             
             
             # Seattle Map Panel
             tabPanel(title = "Seattle's Map", 
                      div(class="outer",
                          tags$head(
                            # Include custom CSS
                            includeCSS("style.css")
                          ),
                          
                          leafletOutput("map", width = "100%", height = "100%"),
                          
                          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                        draggable = FALSE, top = 60, left = "auto", right = 20, bottom = "auto",
                                        width = "auto", height = "auto",
                                        
                                        h3("Airbnb listings explorer"),
                                        uiOutput("neighbourhood"),
                                        selectInput("color", "Color", var1),
                                        selectInput("size", "Size", var2)
                          )
                      )),
             # Deep analysis panel
             tabPanel(title = "Analysis", sidebarLayout(
               # House type analysis, returns a bar plot of percentage stats
               sidebarPanel(
                 tags$h3("House Type"),
                 p("Airbnb hosts can list many types of homes, most common ones are houses and apartments.
                   Depending on your needs, you could easily see if there are sufficient type of home which you need;
                   meanwhile, hosts/potential hosts are able to see the competivity of each type of home in their local market.
                   All the statistics are in percentage(%)"),
                 uiOutput("Neighbor")),
               
               mainPanel(plotOutput("housetype"))),
               
               sidebarLayout(
                 # Room Type analysis, returns a bar plot of percentage stats
                 sidebarPanel(
                   tags$h3("Room Type"),
                   p("Airbnb hosts can list many different types of rooms, including entire home/apt, private room and shared room.
                     Depending on your need, you could easily see if there are sufficient type of room which you need;
                     meanwhile, hosts/potential hosts are able to see the competivity of each type of room in their local market."),
                   uiOutput("Neighbour")
                   ),
                 mainPanel(plotOutput("roomtype"))),
               sidebarLayout(
                 # Price range analysis, returns a bar plot of frequencies in different price range 
                 sidebarPanel(tags$h3("Price Range"),
                              p("Airbnb hosts can set a specific price for their listing properties. Travellers are able to see the price
                                range in Seattle Airbnb market, so they could predict and adjust their expectations on spending. Hosts/potential hosts are 
                                welcomed to compare their property price to the market price, and get to know how competitive their prices are, and how much
                                they could expect to earn on a daily basis."),
                              uiOutput("price"),
                              uiOutput("house_type")),
                 mainPanel(plotOutput("Price"))
                 )),         
             # More information of our app
             navbarMenu("More",
                        tabPanel("Q&A",
                                 tags$h3("Through the investigation of ours we want to help"),
                                 p("- Using mapping to show specific information about each house"),
                                 p("- The ratio of room types in Seattle"),
                                 p("- The ratio of number of accommodates in Seattle"),
                                 p("- The ratio of house types in Seattle"),
                                 tags$h3("Technical Issues"),
                                 p("We used a Shiny App to document our investigation and analysis of the data. In most parts,
                                   we used ‘dplyr’, ‘ggplot2’, and ‘leaflet’ to produce the outputs we wanted.
                                   In order to improve our surface much more concise, we created and wrote many datasets and stored them in the repository."),
                                 p("A challenge we faced was creating a map including every housing information inside. This was solved by debugging again and again."),
                                 tags$h3("Link to the data set we used:"),
                                 p(a("http://insideairbnb.com/get-the-data.html", href="http://insideairbnb.com/get-the-data.html")),
                                 tags$h3("Link to the example we referenced:"),
                                 p(a("http://insideairbnb.com/seattle/", href="http://insideairbnb.com/seattle/")),
                                 p(a("https://shiny.rstudio.com/gallery/superzip-example.html", href="https://shiny.rstudio.com/gallery/superzip-example.html"))
                                 ),
                        tabPanel("Contact Us",
                                 p("We are more than happy to hear from you. For any concern or comments on our project, feel free to email us."),
                                 tags$h3("Team members"),
                                 p("Yongzhi Li: yongzhi@uw.edu"),
                                 p("Siyao Zhang: siyaoz3@uw.edu"),
                                 p("Vanessa Lin: lint272@uw.edu"),
                                 p("Kairui Liu: liuk25@uw.edu")
                        )
                        
                        )
               )
               )
             )
