# Create and inspect some visualizations for our hypotheses ----

# Load packages: -----
library(dplyr)
library(ggplot2)

# Readl/load the joined dataset: -----
url <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/JoinedIMDB.csv"
JoinedIMDB <- read.csv(url, header = TRUE)
view(JoinedIMDB)



# Do movies with higher budgets tend to generate higher worldwide gross earnings?
# Create a scatter plot of Budget vs Worldwide Gross
JoinedIMDB %>%
  ggplot(aes(x = budget, y = gross)) +
  geom_point(alpha = 0.7) +                  # scatter points
  geom_smooth(method = "lm", se = FALSE, color = "blue") +  # add a linear regression line
  labs(
    title = "Relationship Between Budget and Worldwide Gross",
    x = "Budget (in dollars)",
    y = "Worldwide Gross (in dollars)"
  ) +
  theme_minimal()




# Which of the top 10 directors have the most movies in the list?
# Finde top 10 Directors 
DirectorCount <- JoinedIMDB %>%
  count(Director, sort = TRUE) %>%
  slice_max(order_by = n, n = 10)   # Keep top 10 directors

# Plot: Bar chart of number of movies by director
DirectorCount %>%
  ggplot(aes(x = reorder(Director, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 15 Directors by Number of Movies in IMDB",
    x = "Director",
    y = "Number of Movies"
  ) +
  theme_minimal()




# Are certain genres (top 5) associated with higher average ratings?
# Find the top 5 genres by count
TopGenres <- JoinedIMDB %>%
  count(main_genre, sort = TRUE) %>%
  slice_max(order_by = n, n = 5) %>%
  pull(main_genre)

# Filter data for only the Top 5 genres
JoinedIMDB %>%
  filter(main_genre %in% TopGenres) %>%
  ggplot(aes(x = main_genre,
             y = IMDB.rating)) +
  geom_boxplot(fill = "lightpink") +
  coord_flip() +
  labs(
    title = "Distribution of IMDB Ratings for Top 5 Genres",
    x = "Main Genre",
    y = "IMDB Rating"
  ) +
  theme_minimal()

