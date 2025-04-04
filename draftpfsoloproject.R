---
  title: "soloproject"
format: html
---
  

library(sf)
library(tidyverse)
library(ggplot2)
testscore <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/AER/CASchools.csv")
cal_boundries <- read_sf("data/California_County_Boundaries_8408091426384550881/cnty19_1.shp")

ggplot(cal_boundries)+
  geom_sf()
s

```{r}

# Prepare test score data by averaging income per county
testscore_summary <- testscore %>%
  group_by(county) |>
  summarize(income = mean(income, na.rm = TRUE))

# Join with shapefile data
cal_boundries <- cal_boundries %>%
  left_join(testscore_summary, by = c("COUNTY_NAM" = "county"))

# Plot Choropleth
ggplot(cal_boundries) +
  geom_sf(aes(fill = income)) +
  scale_fill_viridis_c(option = "plasma") +  # Better visualization
  theme_minimal() +
  labs(title = "Choropleth of Income by County",
       fill = "Average Income")



```

