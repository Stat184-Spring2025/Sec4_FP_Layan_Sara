# Creating summary and frequency tables ------

# Loading packages----
library(dplyr)
library(janitor)
library(knitr)
library(kableExtra)


# Reading the Joined Data ------
basePart <- "https://raw.githubusercontent.com/Stat184-Spring2025/"
mainPart <- "Sec4_FP_Layan_Sara/main/Data/MoviesJoined.csv"
url <- paste0(basePart,mainPart)
MoviesJoined <- read.csv(url, header = TRUE)
#View(MoviesJoined)


# 1.Creating a frequency table ----
# What are the most popular genres throughout the decades.

#Getting the top 5 genres
TopGenres <- MoviesJoined %>%
  count(Genre, sort = TRUE) %>%
  slice_head(n = 5) %>%
  pull(Genre)

# Creating a Decade column
MoviesJoined <- MoviesJoined %>%
  mutate(Decade = (Year %/% 10) * 10)

#Creating Frequency Table for Genre
GenreTable <- MoviesJoined %>%
  filter(Genre %in% TopGenres) %>%
  tabyl(Genre, Decade) %>%         #make freq using TopGenres and Decades
  adorn_totals(where = c("row", "col")) %>%     #add total col and row
  adorn_percentages(denominator = "all") %>%
  adorn_pct_formatting(digits = 2) %>%   
  adorn_title(               #get the row/column title
    placement = "combined",
    row_name = "Top Genres",
    col_name = "Decade"
  ) %>%
  adorn_ns(position = "front")

# Styling and costumizing the freq table
GenreTable %>%
  kable(
    caption = "Top 5 Genres Distribution Over The Decades",
    booktabs = TRUE,
    align = c("l", rep("c", 6))
  ) %>%
  kableExtra::kable_styling(
    bootstrap_options = c("striped", "condensed"),
    font_size =  12
  ) %>%
  row_spec(0, bold=TRUE, background = "lightblue" )



# 2.Creating a summary table for Companies Budget ----
# Finding the Budget for Diff Companies

#Creating the summary table for company budget
budget_summary <- MoviesJoined%>%
  group_by(Company)%>%   #groups the data by company name
  summarise(       #summarizes the data by the 8 statistics
    film_count = n(),
    min_budget = min(Budget, na.rm = TRUE),
    Q1_budget = quantile(Budget, 0.25, na.rm = TRUE),
    median_budget = median(Budget, na.rm = TRUE),
    Q3_budget = quantile(Budget, 0.75, na.rm = TRUE),
    mean_budget = mean(Budget, na.rm = TRUE),
    max_budget = max(Budget, na.rm = TRUE),
    sd_budget = sd(Budget, na.rm = TRUE)
  ) %>%
  arrange(desc(film_count))%>%  #arranges data by film count
  slice_head(n=4)

#Styling the summary table----
budget_summary%>%
  kable(
    caption = "Budget Summary By Company",
    booktabs = TRUE,
    align = c("l", rep("c",7))
  )%>%
  kableExtra::kable_styling(
    bootstrap_options = c("striped","hover"),
    font_size = 16
  )%>%
  row_spec(0, bold = TRUE, background = "lightyellow")%>%
  column_spec(1, italic = TRUE, background = "lightgrey")


# 3.Creating a summary table for Genres Rating----
# Do Specific Genres affect the Movie Rating

Genre_summary <- MoviesJoined%>%
  group_by(Genre)%>%      # Groups the data by Genre column
  summarise(           # Calculates summary statistics for each genre
    FilmCount = n(),      # Number of films in each genre
    MinRating = min(Rating, na.rm = TRUE),   #Minimum rating (ignores NA values)
    Q1Rating = quantile(Rating, 0.25, na.rm = TRUE),  # First quartile
    MedianRating = median(Rating, na.rm = TRUE),      # Median rating
    Q3Rating = quantile(Rating, 0.75, na.rm = TRUE),  # Third quartile
    MeanRating = mean(Rating, na.rm = TRUE),     # Mean (average) rating
    MaxRating = max(Rating, na.rm = TRUE),      # Maximum rating
    SdRating = sd(Rating, na.rm = TRUE)        # Standard deviation of ratings
  ) %>%
  arrange(desc(FilmCount))%>%          # Sorts the genres by film count
  slice_head(n=5)       # Selects the top 5 movie genres with the most films

#Styling the summary table----
Genre_summary%>%
  kable(
    caption = "Rating Summary By Genre",   # Adds a table caption
    booktabs = TRUE,                    
    align = c("l", rep("c",8)) # Left-aligns the first column, centers the rest
  )%>%
  kableExtra::kable_styling(
    bootstrap_options = c("striped","hover"),
    font_size = 16          # Sets font size of the table
  )%>%
  row_spec(0, bold = TRUE, background = "lightpink")%>%  # Styles the header
  column_spec(1, italic = TRUE, background = "lightgrey") # Styles the 1 column



# Summary table for Top Stars and Success
star_summary <- MoviesJoined %>%
  group_by(Star) %>%
  summarise(
    Movie_Count = n(),
    Avg_Rating = mean(Rating, na.rm = TRUE),
    SD_Rating = sd(Rating, na.rm = TRUE),
    Avg_Profit = mean(Profit, na.rm = TRUE)
  ) %>%
  arrange(desc(Movie_Count))%>%
  slice_head(n=5)%>%
  mutate(across(where(is.numeric), round, 2))

# Display the table
star_summary %>%
  kable(caption = "Summary Statistics for Top Stars",
        booktabs = TRUE,
        col.names = c("Star", "Movie Count", "Avg. Rating", "Rating SD", "Avg. Profit"),
        align = c("l", rep("c", 4))
  )%>%
  kableExtra::kable_styling(
    font_size = 16,          # Sets font size of the table
    bootstrap_options = c("striped","hover")
  )%>%
  row_spec(0, bold = TRUE)  # Styles the header
        
