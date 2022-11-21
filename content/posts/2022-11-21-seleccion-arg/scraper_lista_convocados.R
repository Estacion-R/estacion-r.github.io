library(httr)
library(XML)
library(dplyr)
library(unheadr)

for (i in seq(from = 1974, to = 2022, by = 4)) {
  
  ## págia
  anio <- i
  url <- glue::glue("https://es.wikipedia.org/wiki/Argentina_en_la_Copa_Mundial_de_F%C3%BAtbol_de_{anio}#Lista_final")
  
  r <- GET(url)
  
  doc <- readHTMLTable(doc=content(r, "text"))
  
  if (anio == 2022){
    convocados <- doc[[16]]
  } else if (anio == 2018){
    convocados <- doc[[8]]
  } else if(anio == 2014){
    convocados <- doc[[15]]
  } else if (anio == 2010){
    convocados <- doc[[10]]
  } else if (anio == 2006){
    convocados <- doc[[5]]
  } else if (anio == 2002){
    convocados <- doc[[7]]
  } else if (anio == 1998){
    convocados <- doc[[7]]
  } else if (anio == 1994){
    convocados <- doc[[7]]
  } else if (anio == 1990){
    convocados <- doc[[3]]
  } else if (anio == 1986){
    convocados <- doc[[6]]
  } else if (anio == 1982){
    convocados <- doc[[3]]
  } else if (anio == 1978){
    convocados <- doc[[4]]
  } else if (anio == 1974){
    convocados <- doc[[8]]
  }
  

  
  if(!any(colnames(convocados) %in% "Nombre")){
    lista <- mash_colnames(convocados, 1, keep_names = FALSE, sliding_headers = TRUE) |>
      janitor::clean_names()
    
    if(colnames(lista)[1] == "n_o"){
      lista <- lista |> 
        rename(number = n_o)
    }
    
    lista <- lista |>
      select(number, nombre, posicion) |> 
      mutate(mundial = i)
    
  }
  
  if(!exists("lista_tot")){
    
    lista_tot <- data.frame()
    
  } else {
    
    lista_tot <- lista_tot |> 
      bind_rows(lista)
  }
}

if (file.exists("content/draft/2022-11-04-seleccion-2022/data/lista_convocados_wikipedia.rds")){
  
  file.remove("content/draft/2022-11-04-seleccion-2022/data/lista_convocados_wikipedia.rds")
  
  readr::write_rds(lista_tot, "content/draft/2022-11-04-seleccion-2022/data/lista_convocados_wikipedia.rds")
  
} else {
  readr::write_rds(lista_tot, "content/draft/2022-11-04-seleccion-2022/data/lista_convocados_wikipedia.rds")
}

