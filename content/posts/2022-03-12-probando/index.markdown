---
title: Probando
author: ''
date: '2022-03-12'
slug: probando
categories: []
tags:
  - untagged
toc: no
images: ~
---



```r
knitr::opts_chunk$set(collapse = TRUE, message = F, warning = F)
```


```r
library(tidyverse)

# Esto es una prueba
base <- eph::toybase_individual_2016_03
```

pepep

pepepe


```r
edad <- c(1,2,3,4)
ingreso <- c("Pepe", "Mujica", "queseio")

base %>% 
  summarise(media = mean(P21))
##      media
## 1 3375.926
```

pepepe


```r
base %>% 
  select(CODUSU, CH04, ESTADO) %>% 
  head()
##                          CODUSU CH04 ESTADO
## 1 TQSMNORTUHJOOPCDEIJAH00482615    1      4
## 2 TQRMNOQXSHMKMPCDEIIAD00494796    1      3
## 3 TQRMNOPWSHLLKRCDEOJAH00487512    2      4
## 4 TQRMNOSVUHMMPPCDEIJAH00496251    2      2
## 5 TQRMNORXUHJMLUCDEFIAH00469135    1      2
## 6 TQRMNOQUTHJOKRCDEGOIH00476207    2      4
```
