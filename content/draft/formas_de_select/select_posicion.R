library(tidyverse)
library(janitor)

base <- datasets::iris %>% 
  clean_names()

names(base)

base %>% 
  select(1, 2) %>% 
  head(5)

base %>% 
  select(1:3) %>% 
  head(5)
