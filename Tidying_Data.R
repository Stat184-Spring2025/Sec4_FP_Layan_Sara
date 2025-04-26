# Load Packages ----
library(tidyverse)
library(dplyr)


# Read Data ----
url1 <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/Budget_Revnue.csv"
MoviesGrossRaw <- read.csv(url1, header = TRUE)

url2 <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/imdb_top_250_cost.csv"
IMDBRatingRaw <- read.csv(url2, header = TRUE)


# View and inspect data ----
#view(MoviesGrossRaw)
#view(IMDB_RatingRaw)

#print(colnames(IMDBGrossRaw))
#print(colnames(IMDBRatingRaw))


# Tidying Movies Gross Data ----
MoviesGrossTidy <- MoviesGrossRaw %>%
  select(-c("genre","released","score","votes","director","country"))

#view(MoviesGrossTidy)


# Tidy the IMDB Rating data ----
IMDBRatingTidy <- IMDBRatingRaw %>%
  #Remove the unwanted junk columns 
  select(-c("X", "IMDB.link", "Duration")) %>%
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
                ~ trimws(.)))


# Megring the two datasets -----

