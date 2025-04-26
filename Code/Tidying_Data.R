# Tidy the two datasets: ----
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

# Tidy the IMDB Rating data ----
IMDBRatingTidy <- IMDBRatingRaw %>%
  #Remove the unwanted junk columns 
  select(-c("X", "IMDB.link", "Duration")) %>%
  #Take the first 3 genres of the movies to make it simpler 
  separate(Genre, into = c("main_genre", "Subgenre 1", "Subgenre 2"), 
           sep = "\\|", fill = "right", extra = "drop") %>%
  #Remove extra spaces between genres 
  mutate(across(
    c("main_genre", "Subgenre 1", "Subgenre 2"),
    ~ trimws(.))) %>%
  separate(Origin, into = c("main_origin", NA, NA),
           sep = "\\|", extra = "drop", fill = "right") %>%
  mutate(main_origin = trimws(main_origin))


# Megring the two datasets -----
JoinedIMDB <- IMDBRatingTidy %>%
  left_join(MoviesGrossTidy, by = c("Title" = "name", "Year" = "year")) %>%
  filter(!is.na(runtime)) %>%
  filter(!is.na(budget))

# View the joined and tidy data
#View(JoinedIMDB)

# Create a csv file and save it ----
write.csv(
  JoinedIMDB,
  file = "JoinedIMDB.csv",
  row.names = FALSE
)





