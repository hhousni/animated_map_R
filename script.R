# This is a code to create to creat an animated map
# Code developed by Housni Hassani


library(dplyr)
library(tmap) 
library(gganimate)
library(readxl)
library(ggplot2)
library(magick) 
library(ozmaps) # contains Australian's Map Data


# Read input

COVID_19_Cases <- read_excel("COVID-19 Cases.xlsx", sheet = "COVID-19 Confirmed",
                             col_types = c("text","numeric", "numeric", "date", 
                                           "text", "text", "text", "numeric", 
                                           "numeric","numeric"))



# Extract Australian data 
oz_covid <- COVID_19_Cases %>% filter(Country_Region=="Australia")


# Converting date in good format
oz_covid$Date <-as.Date(oz_covid$Date,"%m/%d/%Y")


# Extract Australian map Data from Oz map. 
ozmap <- ozmap()


# Join COVID-19 data_base to Ozmap data 
oz_covid_map <- right_join (ozmap,oz_covid, by =c("NAME"="Province_State"))

# Generate the map 
cov_animated <- tm_shape(oz_covid_map) +
  tm_fill(col="lightblue")+
  tm_borders(col = "azure", lwd=0.3)+
  tm_text("NAME", size=0.25,col = "grey",ymod=-0.35, alpha = 0.5) +
  tm_layout(frame = FALSE) +
  tm_shape(oz_covid_map) +
  tm_text("Cases", size=0.4,col="sienna4",ymod = .3) +
  tm_dots (size = "Cases",
           col = "red",
           border.lwd=NA,
           legend.size.is.portrait = FALSE,
           alpha=0.5,
           labels="Cases",
           legend.size.show = FALSE,
           legend.shape.show = FALSE) +
  tm_facets(along= "Date", free.coords = FALSE) 

# save the map
tmap_animation(cov_animated, filename="covid_animated.gif",width=800, delay=20) #animated map save on the computer 

