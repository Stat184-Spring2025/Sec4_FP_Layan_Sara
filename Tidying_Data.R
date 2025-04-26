# Load packages 
library(tidyverse)
library(dplyr)

# Read the data 
url1 <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/IMDB%20Gross.csv"
IMDB_Gross <- read.csv(url1, header = TRUE)

url2 <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/imdb_top_250_cost.csv"
IMDB_RatingRaw <- read.csv(url2, header = TRUE)

# View and inspect the data
#view(IMDB_Gross)
#view(IMDB_RatingRaw)
#print(colnames(IMDB_Gross))
#print(colnames(IMDB_RatingRaw))

# Remove unwanted columns/rows
IMDB_Gross <- IMDB_Gross %>%
  select(-c("Release.Date", "Domestic.Weekend.Gross", "Domestic.Weekend",
            "Domestic.Weekend.Gross.Date"))


# Tidy the IMDB Rating data ----
IMDB_Rating <-IMDB_RatingRaw %>%
  #Remove the unwanted junk columns 
  select(-c("X", "IMDB.link")) %>%
  #Take the first 3 genres of the movies to make it simpler 
  separate(Genre, into = c("Main_Genre", "Subgenre 1", "Subgenre 2"), 
           sep = "\\|", fill = "right", extra = "drop") %>%
  #Remove extra spaces between genres 
  mutate(across(
    c("Main_Genre", "Subgenre 1", "Subgenre 2"),
    ~ trimws(.))) %>%
  #Separate the Origin country and take upto 3 origin countries
  separate(Origin, into = c("Main_Origin", "Suborigin 1", "Suborigin 2"), 
           sep = "\\|", fill = "right", extra = "drop") %>%
  #Remove extra spaces between genres
  mutate(across(c("Main_Origin", "Suborigin 1", "Suborigin 2"), 
                ~ trimws(.))) %>%
  #Convert Duration to total minutes instead of hours and minutes
  mutate(
    #extract hours before 'h'
    Hours = str_extract(Duration, "\\d+h") %>% str_remove("h") %>% 
      as.numeric(),
    #extract minutes before 'min'
    Minutes = str_extract(Duration, "\\d+min") %>% str_remove("min") %>% 
      as.numeric(),
    Hours = ifelse(is.na(Hours), 0, Hours),      # if no hours, set to 0
    Minutes = ifelse(is.na(Minutes), 0, Minutes),  # if no minutes, set to 0
    Duration_min = Hours * 60 + Minutes             # total minutes
  ) %>%
  select(-Duration, -Hours, -Minutes, )


