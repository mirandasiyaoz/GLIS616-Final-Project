# the server file
library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(R.utils)

listings2_df <- data.table::fread("./data/listings 2.csv", stringsAsFactors = FALSE)

shinyServer(function(input,output) {
  output$welcome <- renderText({
    paste0("We want to read a file here")
  })
  
  output$Summary <- renderText({
    paste0("Here is a short summary of our website")
  })
  
  # Render UI of neighbourhood_group 
  output$neighbourhood <- renderUI ({
    neighbourhood_distinct <- distinct(listings2_df, neighbourhood_group_cleansed, keep_all = FALSE)
    selectInput("neighbourhood_group", "Neighbourhood Group", c("All", as.list(select(neighbourhood_distinct, neighbourhood_group_cleansed))))
    
  }) 
  
  # Reactive expression for the data subsetted to what the user selected
  filtered_Neighbourhood <- reactive({
    if (input$neighbourhood_group == "All"){
      listings2_df
    } else {
      filter(listings2_df, neighbourhood_group_cleansed == input$neighbourhood_group)
    }
  })
  
  source("./script/apartment_func.R")
  
  # Create the map
  output$map <- renderLeaflet({
    df <- filtered_Neighbourhood()
    if(input$color == "host_is_superhost"){
      colorData <- ifelse(df$host_is_superhost == "t", "yes", "no")
      pal <- colorFactor(c("#80b1d3", "#fb8072"), colorData)
    }else if(input$color == "property_type"){
      colorData <- house_type(df$property_type)
      #colorData <- df[[input$color]]
      pal <- colorFactor(c('#fb8072','#ffffb3','#bebada','#8dd3c7','#80b1d3','#fdb462'), 
                         colorData)
    }else if(input$color == "room_type"){
      colorData <- df[[input$color]]
      pal <- colorFactor(c("#80b1d3", "#fb8072", "#8dd3c7"), colorData)
    }else{
      if(input$color == "price"){
        df$price[] <- lapply(df$price, gsub, pattern = "\\$", replacement="")
        df$price <- as.numeric(df$price)
      }
      colorData <- df[[input$color]]
      pal <- colorBin("RdYlBu", colorData, 4, pretty = FALSE)
    }
    
    if(input$size == "none"){
      radius <- 25
    }else{
      if(input$size == "price"){
        df$price[] <- lapply(df$price, gsub, pattern = "\\$", replacement="")
        df$price <- as.numeric(df$price)
      }
      radius <- df[[input$size]] / 5 #max(df[[input$size]]) * 50
    }
    
    leaflet(data = df) %>%
      addTiles(
        urlTemplate = "https://{s}.basemaps.cartocdn.com/rastertiles/voyager_labels_under/{z}/{x}/{y}{r}.png'",
        attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="https://carto.com/attributions">CARTO</a>'
      ) %>%  # Add default OpenStreetMap map tiles
      setMaxBounds(min(df$longitude), min(df$latitude), max(df$longitude), max(df$latitude)) %>%
      addCircles(lng = ~longitude, lat = ~latitude, layerId = ~id, radius = radius,
                 weight = 8, fillOpacity = 0.5, stroke = FALSE, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=input$color,
                layerId="colorLegend")
    
    
  })
  
  # Show a popup at the given listing
  showListingPopup <- function(listing, lat, lng) {
    df <- filtered_Neighbourhood()
    
    selectedListing <- filter(df, id == listing)
    
    content <- paste(paste0("<a href = \"", selectedListing$listing_url, "\">", tags$h3(selectedListing$name), "</a>"), 
                     as.character(tagList(
                       tags$strong(HTML(sprintf("%s, %s, %s",
                                                selectedListing$neighbourhood_cleansed, selectedListing$property_type, selectedListing$room_type
                       ))), tags$br(),
                       sprintf("Rating Score: %d", as.integer(selectedListing$review_scores_rating)), tags$br(),
                       sprintf("Price/night: %s", selectedListing$price), tags$br(),
                       sprintf("Bedrooms: %s", selectedListing$bedrooms), tags$br(),
                       sprintf("Bathrooms: %s", selectedListing$bathrooms), tags$br(),
                       sprintf("Beds: %s", selectedListing$beds), tags$br(),
                       sprintf("Accommadates: %d people", selectedListing$accommodates), tags$br()
                     )))
    
    leafletProxy("map") %>% addPopups(lng, lat,  content,
                                      options = popupOptions(closeButton = TRUE))
  }
  
  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    isolate({
      showListingPopup(event$id, event$lat, event$lng)
    })
  })
  
  # Make a select input UI for House Type
  output$Neighbor <- renderUI ({
    Neighbor_distinct <- distinct(listings2_df, neighbourhood_group_cleansed, keep_all = FALSE)
    selectInput("Neighbor1", "Select a Neighbourhood", c("All", as.list(select(Neighbor_distinct, neighbourhood_group_cleansed))))
    
  }) 
  
  # Reactive expression for the data subsetted to what the user selected
  filtered_Neighbor <- reactive({
    if (input$Neighbor1 == "All"){
      listings2_df
    } else {
      filter(listings2_df, neighbourhood_group_cleansed == input$Neighbor1)
    }
  })
  
  # returns a bar plot funtion of analysis on house type percentage
  output$housetype <- renderPlot({
    newlisting2 <- filtered_Neighbor()
    count_type <- count(newlisting2, property_type)
    other_type <- filter(count_type, property_type != "Apartment" & property_type != "House")
    othersum <- sum(other_type$n)
    plot_table <- filter(count_type,property_type == "Apartment" | property_type == "House")
    plot_table$property_type <- as.character(plot_table$property_type)
    plot_table <- rbind(plot_table, "3" = c("Others", othersum))
    plot_table$n <- as.numeric(plot_table$n)
    plot_table = mutate(plot_table, sum_percent = n / sum(n) * 100)
    plot_table$sum_percent <- as.integer(plot_table$sum_percent)
    ggplot(plot_table, aes(property_type, sum_percent)) +
      geom_bar(stat = "identity", width = 0.4, color = "white", fill = "cadetblue", size = 3) +
      theme_set(theme_gray()) +
      geom_text(label = plot_table$sum_percent) +
      labs(x = "House Types", y = "Percentage(%)", subtitle = "House Types in Seattle Airbnb Market")
  })
  
  
  # Make a select input UI for House Type
  output$Neighbour <- renderUI ({
    Neighbour_distinct <- distinct(listings2_df, neighbourhood_group_cleansed, keep_all = FALSE)
    selectInput("Neighbour1", "Select a Neighbourhood", c("All", as.list(select(Neighbour_distinct, neighbourhood_group_cleansed))))
    
  }) 
  
  # Reactive expression for the data subsetted to what the user selected(house type)
  filtered_Neighbour <- reactive({
    if (input$Neighbour1 == "All"){
      listings2_df
    } else {
      filter(listings2_df, neighbourhood_group_cleansed == input$Neighbour1)
    }
  })
  
  # returns a bar plot funtion of analysis on room type percentage
  output$roomtype <- renderPlot({
    newlisting1 <- filtered_Neighbour()
    room_type <- count(newlisting1, room_type)
    room_type = mutate(room_type, percent = n / sum(n) * 100)
    room_type$percent <- as.integer(room_type$percent)
    room_type$room_type <- as.character(room_type$room_type)
    ggplot(room_type, aes(room_type, percent)) +
      geom_bar(stat = "identity", width = 0.4, color = "white", fill = "cadetblue", size = 3) +
      theme_set(theme_gray()) +
      geom_text(label = room_type$percent) +
      labs(x = "Room Type", y = "Percentage(%)", subtitle = "Room Types in Seattle Airbnb Market")
  })
  
  # make a select input for room type
  output$price <- renderUI ({
    price_distinct <- distinct(listings2_df, neighbourhood_group_cleansed, keep_all = FALSE)
    selectInput("price", "Select a Neighbourhood", c("All", as.list(select(price_distinct, neighbourhood_group_cleansed))))
    
  }) 
  
  #make a select input for house type in price range analysis
  output$house_type <- renderUI ({
    house_type_distinct <- distinct(listings2_df, property_type, keep_all = FALSE)
    selectInput("house_type", "Select a House Type", c("All", as.list(select(house_type_distinct, property_type))))
    
  }) 
  
  # Reactive expression for the data subsetted to what the user selected in price range 
  filtered_price <- reactive({
    if (input$price == "All" & input$house_type == "All"){
      listings2_df
    } else if (input$price == "All" & input$house_type != "All") {
      filter(listings2_df, property_type == input$house_type)
    } else if(input$price != "All" & input$house_type == "All"){
      filter(listings2_df, neighbourhood_group_cleansed == input$price)
    } else {
      filter(listings2_df, neighbourhood_group_cleansed == input$price & property_type == input$house_type)
    }
  })
  
  # returns the bar plot in price range analysis
  output$Price <- renderPlot({
    df_price <- filtered_price()
    df_price$price <- as.character(df_price$price)
    df_price[] <- lapply(df_price, gsub, pattern = "\\$", replacement="")
    df_price$price <- as.numeric(df_price$price)
    pricelow <- filter(df_price, price <= 100)
    pricelow_num <- nrow(pricelow)
    pricemed <- filter(df_price, price > 100 & price <= 150)
    pricemed_num <- nrow(pricemed)
    pricehigh <- filter(df_price, price > 150)
    pricehigh_num <- nrow(pricehigh)
    pricerange <- c("0-100", "100-150", "above 150")
    frequency <- c(pricelow_num, pricemed_num, pricehigh_num)
    priceall <- data.frame(pricerange, frequency)
    ggplot(priceall, aes(pricerange, frequency)) + 
      geom_bar(stat = "identity", width = 0.4, color = "white", fill = "cadetblue", size = 3) +
      theme_set(theme_gray()) +
      geom_text(label = priceall$frequency) +
      labs(x = "Price Range", y = "Frenquency", subtitle = "Price Range in Seattle Airbnb Market")
  })
})
