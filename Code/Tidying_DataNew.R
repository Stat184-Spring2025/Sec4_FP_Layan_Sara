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
view(MoviesMainRaw)
view(MoviesSubRaw)



# Tidying Movies Gross Data ----
MoviesSubTidy <- MoviesSubRaw %>%
  select(-c("released","budget","gross","genre","runtime"))

#Tidy the movie data----
MoviesMainTidy <- MoviesMainRaw%>%
  select(-c("X","popularity", "release_date", "vote_average",
            "vote_count","Number_Genres"))

#Merging other two datasets----
MoviesJ <- MoviesMainTidy%>%
  inner_join(MoviesSubTidy, by = c("title"="name","production_companies"="company") )%>%
  rename(
    Budget = budget,
    Genre = genres,
    Company = `production_companies`,
    Revenue = revenue,
    `Run Time`= runtime,
    Title = title,
    `Age Rating`= rating,
    Year = year,
    Rating = score,
    `Rating Count` = votes,
    Director = director,
    Writer = writer,
    Star = star,
    Country = country,
  )

view(MoviesJ)