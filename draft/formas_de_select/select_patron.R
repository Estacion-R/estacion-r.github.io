library(tidyverse)
library(janitor)

base <- datasets::iris %>% 
  clean_names()

names(base)

base %>% 
  select(starts_with("sepal")) %>% 
  head(5)

base %>% 
  select(ends_with("length")) %>% 
  head(5)

base %>% 
  select(contains("_w")) %>% 
  head(5)
