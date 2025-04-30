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


# Tidying Movies Gross Data ----
MoviesSubTidy <- MoviesSubRaw %>%
  select(-c("released","budget","gross","genre","runtime"))

#Tidy the movie data----
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
  )

# Re-order the columns
MoviesJoined <- MoviesJoined %>%
  select(Title, Genre, Company, AgeRating, Year,
         Rating, RatingCount, Director, Writer, Star, Budget, Revenue,
         RunTime, Country)%>%
  mutate(Profit = Revenue-Budget)
#view(MoviesJoined)

# Create a csv file and save it ----
write.csv(
  MoviesJoined,
  file = "MoviesJoined.csv",
  row.names = FALSE
)

