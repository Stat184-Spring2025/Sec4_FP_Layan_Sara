# Create and inspect some visualizations for our hypotheses ----

# Load packages: -----
library(dplyr)
library(ggplot2)

# Read/load the joined dataset: -----
url <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/MoviesJoined.csv"
MoviesJoined <- read.csv(url, header = TRUE)
view(MoviesJoined)


## Bar Chart -----
# Which of the top 12 movie Stars have the most movies in the list?
# Find top 12 Stars 
DirectorCount <- MoviesJoined %>%
  count(Star, sort = TRUE) %>%
  slice_max(order_by = n, n = 12)   # Keep top 12 Star

# Plot: Bar chart of number of movies by stars
DirectorCount %>%
  ggplot(aes(x = reorder(Star, n), y = n)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 12 Stars by Number of Movies",
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


#Which production companies have the highest average profit.
#Tidying data to create a bar chart
CompanyProfit <- MoviesJoined%>%
  group_by(Company)%>%
  summarise(
    AverageProfit = mean(Profit, na.rm = TRUE),
    MovieCount = n()
  )%>%
  filter(MovieCount >= 5) %>%
  arrange(desc(AverageProfit)) # Sorting by AverageProfit in descending order 
#view(CompanyProfit)

#Visualization.
CompanyProfit %>%
  slice_max(AverageProfit, n = 15) %>%
  ggplot(aes(x = reorder(Company, AverageProfit), y = AverageProfit)) +
  geom_col(fill = "dodgerblue") +
  coord_flip() +
  labs(
    title = "Top 15 Production Companies by Average Profit",
    x = "Production Company",
    y = "Average Profit (USD)"
  ) +
  theme(
    axis.title = element_text(face = "bold"),  # Make axis titles bold
    axis.text = element_text(face = "bold")    # Make axis tick labels bold
  )+
  theme_minimal()