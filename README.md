# Airbnb in Seattle Shiny App

A link to the shiny app can be found [here.](https://lint272.shinyapps.io/Airbnb/)

# Welcome

We are glad to see you here！At this page, we will guide you through to explore our website. Airbnb in Seattle is your ultimate solution to find/host a Airbnb in Greater Seattle Area. We are an independent, non-commercial set of tools and data that allows you to explore how Aribnb is really being used in the city. For travelers, no matter what type of homes you are looking for, there is always a home for you. If you are a host/potential host, feel free to check our website to see what you could expect to be a Superhost!

# About our Dataset

Our project works with “Inside Airbnb -Adding data to the debate” data set of information created and maintained by Insideairbnb. Inside Airbnb is a professional and comprehensive data set of classifying the data in Airbnb into hosting ID, room types, neighborhoods, reviews and etc. This data set includes 86 cities and 602 data files (csv.gz, csv, geojson) around the world. The dataset we used in our project is a collection containing an overall summary of all the home listings in Seattle with entire descriptions and other information. This data represents the records and the future calendar of each home starts from 10/11/2018-09/13/2019.

# About our Audience and Investigation

Our target audience would be travelers and property owners. As users of Airbnb in daily life, we focused on the deep relationship between users and housing hosts. Airbnb shows a wide variety of accommodation online and has the dataset prepared for a global audience to accommodate their needs. To travelers who wish to find a place to stay in any city, there’s always a place for everyone. For travelers, the direction we were interested in is the choice they preferred to make in common situations.
For the property owner, Airbnb provides them with a deep analysis of their performance, which allows them to optimize and earn as much as possible.

# Through the Investigation of ours We want to help

With Airbnb in Seattle, you could ask fundamental questions about Airbnb in any neighbourhood or across the city as a whole. Quesitions such as:

* How many listings are there in my neighbourhood and where are they?

* Do different features of Airbnb affect their price or rating? (eg. Are prices higher for Airbnb hosted by superhosts?)

* How do Airbnbs differ between different regions? (eg. Are there more apartment style Airbnb in downtown than in other areas?)

The tools are presented simply as a interactive map, dataset with filter and text/plot analysis.

# About Map and Analysis

In our map, there are two categories in Airbnb listing explorer: Neighbourhood Group & Color. In the neighborhood group, users can choose which area they want to find a place to live. In color, it divides into price & rating, each of both has some intervals to represent the difference. For example, if users choose to see the housing price information in Downtown, they can click to choose "Downtown", "Price", all the information in that area will show up on the map, and houses with different price intervals will show in different colors on the map. Moreover, every point in the map has its own hyperlink related to Airbnb for users to get information.

For our analysis, we created some histograms to investigate the ratio of many aspects in different areas in Seattle, including room types, house types and price range. The main idea for our analysis is to provide more general data for travelers and property owners to check some factors may influence their housing choices or price setting.

# Understanding of Our Dataset and Project

After discovering our dataset by using mapping and histograms, we found that most housing listings' reviewing scores in Seattle is higher than 60, which means most travelers experienced comfortable environments in Seattle's housing listings. Moreover, the ratio of apartment, house, and others(condominium, guest suite etc.) has similar rates in Seattle (35%, 33%, 30% each), it shows that housing types in Seattle are evenly distributed.

We also found some "different" data that can be considered as "Outliers". In Downtown area, there is no "house" housing type, "apartment" has 77% in that area. It represents that there are some factors may influence property owners in Downtown don't rent their houses, for example, they prefer to stay by themselves, or there is no house in Downtown because of prices.

About the price, different price level in Seattle has the similar amount of listings. However, in Downtown and University District, the situations are extreme. In University District, most housing price is lower than $100/day. In Downtown, the most price is higher than $150/day. Different locations are the main factor has an influence on many aspects. Price is the most representative.

In a nutshell, Airbnb in Seattle has its own situation, and most parts are positive. Travelers can find the most suitable place to live very easily. Also, for property owners, there are many factors can influence their price setting(housing types, room type, locations etc.) We hope our Shiny App can make a brief introduction for our audience to get information about Airbnb in Seattle easily and conveniently.  

# Disclaimer

* This site is nor associated with or endorsed by Airbnb or any of Airbnb's competitors.

* The data utilizes public information compiled online including the availibility calendar for 365 in the future, and reviews for each listing. Data is verified, cleansed, analyzed and aggregated

* No private information is being used, including names, photographs, listings and review details are all publicly displayed on the aribnb site

* Accuracy of the information compiled from the Aribnb site is not the responsibility of 'Airbnb in Seattle'

# Technical Stuff

We used a Shiny App to document our investigation and analysis of the data. In most parts, we used ‘dplyr’, ‘ggplot2’, and ‘leaflet’ to produce the outputs we wanted. In order to improve our surface much more concise, we created and wrote many datasets and stored them in the repository.
A challenge we faced was creating a map including every housing information inside. This was solved by debugging again and again.

# Team Members

* Yongzhi Li: yongzhi@uw.edu

* Siyao Zhang: siyaoz3@uw.edu

* Vanessa Lin: lint272@uw.edu

* Kairui Liu: liuk25@uw.edu

# Link to the data set we used:
* http://insideairbnb.com/get-the-data.html

# Link to the examples we referenced:
* http://insideairbnb.com/seattle/
* https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example
