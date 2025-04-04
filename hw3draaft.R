---
  title: "Homework 3: More Data Viz"
execute: 
  warning: true
fig-height: 3
fig-width: 5
fig-align: center
code-fold: false
---
  
  Make sure every package used in this assignment is installed on your machine. If not, install it by either:
  
  RStudio --> Console --> run install.packages(package name)

RStudio --> Packages pane --> Install --> type package name --> click Install.

{r}
# Load required libraries
library(tidyverse)
library(openintro)

Spatial Viz

Exercise 1

In this exercise, we will use the same Starbucks location data we worked with in class but on the contiguous US state-level only while taking into account the population of each state.

{r}
# Import starbucks location data
starbucks <- read.csv("https://mac-stat.github.io/data/starbucks.csv")

# Keep only stores in contiguous US
starbucks_us <- starbucks |>
  filter(Country == "US", !State.Province %in% c("AK", "HI"))


The code below creates the dataset starbucks_us_by_state that gives the number of Starbucks in each state.

{r}
starbucks_us_by_state <- starbucks_us |>
  count(State.Province) |>
  mutate(state_name = str_to_lower(abbr2state(State.Province)))

The code below adds the variable starbucks_per_10000 that gives the number of Starbucks per 10,000 people to the dataest starbucks_with_2018_pop_est which will be used for the spatial visualization.

{r}
census_pop_est_2018 <- read_csv("https://mac-stat.github.io/data/us_census_2018_state_pop_est.csv") |>
  separate(state, into = c("dot", "state"), extra = "merge") |>
  select(-dot) |>
  mutate(state = str_to_lower(state))

starbucks_with_2018_pop_est <-
  starbucks_us_by_state |>
  left_join(census_pop_est_2018,
            by = c("state_name" = "state")
  ) |>
  mutate(starbucks_per_10000 = (n / est_pop_2018) * 10000)

Part a

Create a choropleth state map that shows the number of Starbucks per 10,000 people on a map of the US while taking into consideration the following instructions:
  
  Use a new fill color palette for the states,

Add points for all Starbucks in the contiguous US,

Add an informative title for the plot, and

Include a caption that says who created the plot (you!).

{r}

library(ggplot2)
library(dplyr)
library(maps)
library(ggthemes)

starbucks_contiguous_us <- starbucks |>
  filter(Country == "US", State.Province != "AK", State.Province != "HI")
head(starbucks_contiguous_us)

state_map <- map_data("state")

ggplot(starbucks_with_2018_pop_est, aes(map_id = state_name, fill = starbucks_per_10000)) +
  geom_map(map = state_map) +
  expand_limits(x = state_map$long, y = state_map$lat) +
  theme_map() + 
  labs(
    title = "Starbucks in the Contiguous U.S.",
    caption = "Plot created by [Feride]") +
  theme_minimal()+
  scale_fill_gradientn(name = "Starbucks_per_10000", colors = c("blue", "purple", "red"), values = scales::rescale(seq(0, 100, by = 5)))

Part b

Make a conclusion about what you observe from that spatial visual.

There is more starbucks per 1000 people in the west coast rather than the east coast. 

Exercise 2

In this exercise, you are going to create a single Leaflet map of some of your favorite places! The end result will be one map.

Part a

Create a data set using the tribble() function that has 10-15 rows of your favorite places. The columns will be the name of the location, the latitude, the longitude, and a column that indicates if it is in your top 3 favorite locations or not. For an example of how to use tribble(), look at the favorite_stp that was created manually below.

{r}
# Brianna's favorite St. Paul places - Used Google Maps to get coordinates
# https://support.google.com/maps/answer/18539?hl=en&co=GENIE.Platform%3DDesktop
favorite_stp <- tribble(
  ~place, ~long, ~lat, ~favorite,
  "Macalester College", -93.1712321, 44.9378965, "yes", 
  "Groveland Recreation Center", -93.1851310, 44.9351034, "yes",
  "Due Focacceria", -93.1775469,  44.9274973, "yes",
  "Shadow Falls Park", -93.1944518, 44.9433359, "no",
  "Mattocks Park", -93.171057, 44.9284142, "no",
  "Carondelet Fields", -93.1582673, 44.9251236, "no",
  "Pizza Luce", -93.1524256, 44.9468848, "no",
  "Cold Front Ice Cream", -93.156652, 44.9266768, "no"
)

{r}


Part b

Create a map that uses circles to indicate your favorite places while taking into consideration the following instructions:
  
  Label the circles with the name of the place.

Choose the base map you like best.

Color your 3 favorite places differently than the ones that are not in your top 3.

Add a legend that explains what the colors mean

{r}
library(tibble)

favorite_places <- tribble(
  ~place, ~long, ~lat, ~favorite,
  "Macalester College", -93.1712321, 44.9378965, "yes",
  "Minnehaha Falls", -93.209003, 44.915466, "yes",
  "Como Park", -93.151911, 44.981388, "yes",
  "Ordway Field Station", -92.998528, 44.670816, "no",
  "Mississippi River Blvd", -93.200374, 44.928734, "no",
  "Grand Avenue", -93.157639, 44.939740, "no",
  "Regions Hospital", -93.099854, 44.953368, "no",
  "Science Museum of Minnesota", -93.097343, 44.940480, "no",
  "Spyhouse Coffee", -93.287853, 44.948950, "no",
  "Lake Phalen", -93.061340, 44.987712, "no",
  "Aster Cafe", -93.260517, 44.983703, "no"
)

print(favorite_places)



TidyTuesday

Tidy Tuesday is a weekly data project put on by some folks from the R Data Science community. Each week, a different data set is posted and people around the world wrangle and visualize that data. According to the organizers, "The intent of Tidy Tuesday is to provide a safe and supportive forum for individuals to practice their wrangling and data visualization skills independent of drawing conclusions."

The goals of this TidyTuesday are:
  
  Practice generating questions. You have to decide what to ask and how to answer it with a graphic.

Practice identifying what viz and (eventually) wrangling tools are useful for addressing your questions.

Get a sense of the broader data science community. Check out what people share out on X/Twitter #TidyTuesday. Maybe even share your own #TidyTuesday work on social media. Recent Mac alum Erin Franke (X/Twitter) has an inspiring account! Scrolling through, you'll notice the trajectory of her work, starting from COMP/STAT 112 to today. Very cool.

What percentage of agencies in each state participate in NIBRS reporting? Are there any trends in NIBRS adoption?- Ill answer this by using an indicator variable and making a scatter plot.

{r}
# Option 1: tidytuesdayR package 
## install.packages("tidytuesdayR")

tuesdata <- tidytuesdayR::tt_load('2025-02-18')
## OR
tuesdata <- tidytuesdayR::tt_load(2025, week = 7)

agencies <- tuesdata$agencies

# Option 2: Read directly from GitHub

agencies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-02-18/agencies.csv')

Exercise 3

Go to TidyTuesday. Pick a dataset that was posted in the last 4 weeks. Here, include:
  
  A short (~2 sentence) written description of your data. This should include:
  
  the original data source, ie, where did TidyTuesday get the data from?
  
  units of observation, ie, what are you analyzing?, and

the data size, ie, how many data points do you have? how many variables are measured on each data point?.

PLACE YOUR ANSWER IN THIS CALLOUT BOX

Code to import and examine the basic properties of your chosen dataset. This code must support the facts you cited in your short written description.

{r}


Exercise 4

In the 3 sections below (Viz 1, 2, 3), construct 3 separate graphs that tell a connected story about the data you chose.

Before each viz:
  
  write a simple but specific research question you're trying to address with the viz.

write a 2-4 sentence summary of what you learn from the viz. This should connect back to your research question!

After each viz:

Comment on at least 2 effective aspects of the viz (consider the effective visualization principles).

Comment on at least 2 aspects of the visualization that could be improved. Perhaps these are aspects that you don't know how to implement yet but wish you could update it.

Make sure each viz:
  
  has meaningful axis labels and legend titles

has a figure caption (fig.cap)

uses alt text (fig.alt)

uses a more color-blind friendly color palette

Tips:
  
  Start with some questions in mind of what you want to learn.

Start with a simple viz (viz 1), and build this up into something multivariate (viz 3).

Reflect on each viz -- what new questions do you have after checking out the viz? Let these questions guide your next viz. (eg: recall how we worked through the MacNaturalGas data at the start of the Spatial Viz activity).

Viz 1

PLACE YOUR RESEARCH QUESTION IN THIS CALLOUT BOX

{r}


PLACE YOUR SUMMARY IN THIS CALLOUT BOX

Viz 2

PLACE YOUR RESEARCH QUESTION IN THIS CALLOUT BOX

{r}


PLACE YOUR SUMMARY IN THIS CALLOUT BOX

Viz 3

PLACE YOUR RESEARCH QUESTION IN THIS CALLOUT BOX

{r}


PLACE YOUR SUMMARY IN THIS CALLOUT BOX

Finalize Work

Congratulation 🎉. You're done with the homework. See the instruction at top of the Homework Assignments page for how to submit.
