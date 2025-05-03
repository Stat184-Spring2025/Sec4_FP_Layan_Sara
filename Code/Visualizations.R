# Create and inspect some visualizations for our hypotheses ----

# Load packages: -----
library(dplyr)
library(ggplot2)

# Read/load the joined dataset: -----
url <- "https://raw.githubusercontent.com/Stat184-Spring2025/Sec4_FP_Layan_Sara/main/Data/MoviesJoined.csv"
MoviesJoined <- read.csv(url, header = TRUE)
view(MoviesJoined)

# Define global elements ----
psuPalette <- c("#1E407C", "#BC204B", "#3EA39E", "#E98300",
                "#999999", "#AC8DCE", "#F2665E", "#99CC00")


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



# Production Companies Making Kid Movies Profit 
TopMovies <- MoviesJoined%>%
  filter(Company %in% c("Walt Disney Pictures",
                        "Warner Bros.",
                        "Universal Pictures",
                        "Columbia Pictures",
                        "DreamWorks Animation"))
#view(TopMovies)
ggplot(data = TopMovies, 
       mapping = aes(
         x = Budget, 
         y = Profit, 
         color = Company
         )
       ) +
  geom_point(size = 3) +
  labs(
    title = "Profit per Movie by Company (G & PG Rated)",
    x = "Budget",
    y = "Profit (USD)",
    color = "Company"
    ) +
  scale_color_manual(
    values = psuPalette
    )+
  theme_bw() +
  theme(
    legend.position = "right"
    )






# WORK IN PROGRESS:
# Rating of the top stars over times
TopStars <- c("Nicolas Cage",
              "Adam Sandler",
              "Denzel Washington",
              "Dwayne Johnson",
              "Tom Cruise",
              "Tom Hanks")

StarMovies <- MoviesJoined%>%
  filter(Star %in% TopStars)
view(StarMovies)

RatingYear <- StarMovies%>%
  group_by(Star,Year)%>%
  summarise(AverageRating = mean(Rating, na.rm = TRUE)) %>%
  ungroup()

all_years <- data.frame(Star = rep(TopStars, each = length(unique(RatingYear$Year))),
                        Year = rep(unique(RatingYear$Year), times = length(TopStars)))

StarRatingsByYearFull <- all_years %>%
  left_join(RatingYear, by = c("Star", "Year")) %>%
  replace_na(list(AverageRating = 0))  # Replace missing ratings with 0

# 4. Plot with a smoother line and handle missing years
ggplot(StarRatingsByYearFull, aes(x = Year, y = AverageRating, color = Star)) +
  geom_line(size = 1) +
  geom_smooth(method = "loess", se = FALSE, linetype = "dashed", size = 1) +  # Smoothed line
  labs(title = "Actor Ratings Over Time", 
       x = "Year", 
       y = "Average Rating",
       color = "Actor") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels

