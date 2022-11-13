library(tidyverse)
library(janitor)

base <- datasets::iris %>% 
  clean_names()

names(base)

base %>% 
  select(sepal_length, sepal_width) %>% 
  head(5)

base %>% 
  select(sepal_length:petal_length) %>% 
  head(5)
