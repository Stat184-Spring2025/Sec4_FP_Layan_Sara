# Create and inspect some visualizations for our hypotheses ----

# Load packages: -----
library(dplyr)
library(ggplot2)

# Read/load the joined dataset: -----
url <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/MoviesJoined.csv"
MoviesJoined <- read.csv(url, header = TRUE)
view(MoviesJoined)


## Bar Chart -----
# Which of the top 15 movie Stars have the most movies in the list?
# Find top 15 Stars 
DirectorCount <- MoviesJoined %>%
  count(Star, sort = TRUE) %>%
  slice_max(order_by = n, n = 15)   # Keep top 15 Star

# Plot: Bar chart of number of movies by stars
DirectorCount %>%
  ggplot(aes(x = reorder(Star, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 15 Stars by Number of Movies",
    x = "Star",
    y = "Number of Movies"
  ) +
  theme_minimal()


## Box Plot -----
# Do the Top 5 most common genres show differences in their average ratings?
# Find the top 5 genres by count
TopGenres <- MoviesJoined %>%
  count(Genre, sort = TRUE) %>%
  slice_max(order_by = n, n = 5) %>%
  pull(Genre)

# Filter data for only the Top 5 genres
MoviesJoined %>%
  filter(Genre %in% TopGenres) %>%
  # Create the box plot
  ggplot(aes(x = Genre,
             y = Rating)) +
  geom_boxplot(fill = "lightpink") +
  coord_flip() +
  labs(
    title = "Distribution of Ratings for Top 5 Genres",
    x = "Top Genres",
    y = "Rating"
  ) +
  theme_minimal()


# Plot Chart -------
# Do movies with higher RunTime tend to receive higher audience ratings?
  ggplot(MoviesJoined, aes(x = RunTime, y = Rating)) +
  geom_point(alpha=0.7) +
  labs(
    title = "Relationship Between Movie Runtime and Audience Rating",
    x = "Runtime (minutes)",
    y = "Rating"
  ) +
  theme_minimal()

# RatingCount and Rating
ggplot(MoviesJoined, aes(x = RatingCount, y = Rating)) +
  geom_point(alpha = 0.8, size = 1.5) +
  labs(
    title = "Relationship Between Rating Count and Audience Rating",
    x = "Number of Ratings (in Thousands)",
    y = "Audience Rating"
  ) +
  theme_minimal()






