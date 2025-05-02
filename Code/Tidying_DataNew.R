# Tidy the two datasets: ----

# Load Packages ----
library(tidyverse)
library(dplyr)

# Read Data ----
url1 <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/Budget_Revnue.csv"
MoviesSubRaw <- read.csv(url1, header = TRUE)

url2 <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/Movie.csv"
MoviesMainRaw <- read.csv(url2, header = TRUE)

#View data
#view(MoviesMainRaw)
#view(MoviesSubRaw)


# Tidying Secondary Movies data ----
MoviesSubTidy <- MoviesSubRaw %>%
  select(-c("released","budget","gross","genre","runtime"))

#Tidy the Main Movie data----
MoviesMainTidy <- MoviesMainRaw%>%
  select(-c("X","popularity", "release_date", "vote_average",
            "vote_count","Number_Genres"))

#Merging other two datasets----
MoviesJoined <- MoviesMainTidy%>%
  inner_join(MoviesSubTidy, by = c("title"="name","production_companies"="company") )%>%
  rename(
    Title = title,
    Genre = genres,
    Company = `production_companies`,
    AgeRating= rating,
    Year = year,
    Rating = score,
    RatingCount = votes,
    Director = director,
    Writer = writer,
    Star = star,
    Budget = budget,
    Revenue = revenue,
    RunTime= runtime,
    Country = country
  ) %>%
  # Re-order the columns 
  select(Title, Genre, Company, AgeRating, Year,
         Rating, RatingCount, Director, Writer, Star, Budget, Revenue,
         RunTime, Country) %>%
  # Found two movies with revenues that are not in millions
  mutate(
    Revenue = ifelse(Title == "Chasing Liberty", 12000000, Revenue),
    Revenue = ifelse(Title == "Death at a Funeral", 46000000, Revenue)
  ) %>%
  # Replace 0 with NA in Budget and Revenue
  mutate(
    Budget = ifelse(Budget == 0, NA, Budget),
    Revenue = ifelse(Revenue == 0, NA, Revenue)
  ) %>%
  # Make a Profit column
  mutate(Profit = Revenue-Budget) %>%
  # Replace "Not Rated" and "Unrated" in AgeRating with NA
  mutate(
    AgeRating = ifelse(AgeRating %in% c("Not Rated", "Unrated"), NA, AgeRating)
  ) %>%
  # Drop rows with missing Budget, Revenue, or AgeRating
  drop_na(Budget, Revenue, AgeRating)
  
#view(MoviesJoined)

# Create a csv file and save it ----
write.csv(
  MoviesJoined,
  file = "MoviesJoined.csv",
  row.names = FALSE
)

