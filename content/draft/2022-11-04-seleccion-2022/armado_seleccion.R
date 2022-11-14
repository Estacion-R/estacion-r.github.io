library(tidyverse)
library(worldfootballR)
library(rvest)
library(stringr)
library(janitor)


#anio <- 2022

### Armo base final
jugadores_wiki <- readr::read_rds("content/draft/2022-11-04-seleccion-2022/data/lista_convocados_wikipedia.rds") |> 
  filter(mundial == 2022) |> 
  mutate(nombre_join = stringi::stri_trans_general(nombre,"Latin-ASCII"),
         nombre_join = tolower(nombre_join),
         nombre_join = case_when(nombre == "Alejandro Gómez" ~ "papu gomez",
                                 TRUE ~ nombre_join))

### seleccion
anio <- 2022

seleccion_arg <- as.data.frame(fb_player_urls(glue::glue("https://fbref.com/en/squads/f9fddd6e/{anio}/Argentina-Men-Stats"), time_pause = 3))

colnames(seleccion_arg)[1] <- "url"

seleccion_arg <- seleccion_arg %>% 
  mutate(jugador = str_replace(string = url, pattern = "^.+/", replacement = ""),
         jugador = str_replace_all(jugador, pattern = "-", replacement = " "),
         info_jugador = NA_character_,
         nombre_join = stringr::str_to_lower(jugador),
         nombre_join = stringi::stri_trans_general(nombre_join,"Latin-ASCII"))


seleccion_def <- jugadores_wiki |> 
  left_join(seleccion_arg, by = "nombre_join")

seleccion_def <- seleccion_def |> 
  mutate(url = case_when(nombre_join == "enzo fernandez" ~ "https://fbref.com/en/players/5ff4ab71/Enzo-Fernandez",
                         nombre_join == "lionel scaloni" ~ "https://fbref.com/en/players/6cc4990c/Lionel-Scaloni",
                         TRUE ~ url),
         jugador = case_when(nombre_join == "enzo fernandez" ~ "Enzo Fernandez",
                             nombre_join == "lionel scaloni" ~ "Lionel Scaloni",
                             TRUE ~ jugador))


### Agrego info de localidad
for (i in 1:nrow(seleccion_def)) {
  
  seleccion_arg[i, "info_jugador"] <- read_html(seleccion_arg[i,1]) %>% 
    html_element(css = "#meta p:nth-child(5)") %>% 
    html_text2()
  
  Sys.sleep(time = 1)
  
}

### Chequeo aquellos casos sin info de localidad
no_match <- seleccion_arg %>% 
  filter(!str_starts(info_jugador, "Born"))

for (i in 1:nrow(no_match)) {
  
  no_match[i, "info_jugador"] <- read_html(no_match[i,1]) %>% 
    html_element(css = "#meta p:nth-child(4)") %>% 
    html_text2()
  
  Sys.sleep(time = 3)
}

seleccion_arg <- seleccion_arg %>% 
  filter(str_starts(info_jugador, "Born")) %>% 
  bind_rows(no_match)

rm(no_match, jugadores)


### Armo variables de localidad
seleccion_arg <- seleccion_arg %>% 
  mutate(origen = str_replace(string = info_jugador, pattern = "^.+ in", replacement = "")) %>% 
  separate(col = origen, into = c("localidad", "pais"), sep = ",")

### Separo y reparo aquellos jugadores sin localidad (a manopla)
sin_loc <- seleccion_arg %>% 
  filter(is.na(pais)) %>% 
  mutate(localidad = case_when(
    str_detect(jugador, "Otamendi|Papu Gomez|Giovanni Simeone|Agustin Rossi|Pablo Zabaleta|Ricky Alvarez") ~ "Ciudad de Buenos Aires",
    str_detect(jugador, "Nicolas Tagliafico") ~ "Almirante Brown",
    str_detect(jugador, "Sergio Aguero") ~ "Quilmes",
    str_detect(jugador, "Lucas Martinez Quarta") ~ "Mar del Plata",
    str_detect(jugador, "Medina") ~ "Villa Fiorito",
    str_detect(jugador, "Federico Fazio|Agustin Orion") ~ "Ramos Mejía",
    str_detect(jugador, "Mariano Andujar") ~ "Villa Lugano"))


### Rearmo base con corrección de localidad
seleccion_arg <- seleccion_arg %>% 
  filter(!is.na(pais)) %>% 
  bind_rows(sin_loc) %>% 
  mutate(pais = "Argentina",
         localidad = str_to_lower(str_trim(localidad, side = "both")))

rm(sin_loc)


### Traigo base BAHRA para machear Provincia
url_loc <- "https://wms.ign.gob.ar/geoserver/bahra/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=bahra%3Alocalidad_bahra&outputFormat=csv"
#url_ent <- "https://wms.ign.gob.ar/geoserver/bahra/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=bahra%3Aentidad_bahra&outputFormat=csv"

bahra <- read_delim(url_loc) %>% 
  select(nombre_geografico, nombre_provincia, codigo_indec_provincia, 10:13, geom) %>% 
  mutate(nombre_geografico = str_to_lower(nombre_geografico))

### Uno con seleccion
seleccion_arg <- seleccion_arg %>% 
  left_join(bahra, by = c("localidad" = "nombre_geografico"))

### Reviso casos sin match
no_match <- seleccion_arg %>% 
  filter(is.na(nombre_provincia))

### Reparo
prueba <- seleccion_arg %>% 
  mutate(nombre_provincia = case_when(
    str_detect(jugador, "Eduardo Salvio|Rodrigo De Paul|Nicolas Gonzalez|Nicolas Dominguez|Manuel Lanzini|Agustin Orion") ~ "Buenos Aires",
    str_detect(jugador, "Guido Rodriguez|Gonzalo Montiel|Facundo Medina|Agustin Marchesin|Fernando Gago|Mariano Andujar") ~ "Buenos Aires",
    str_detect(jugador, "Alexis Mac Allister") ~ "La Pampa",
    str_detect(jugador, "Maximiliano Meza") ~ "Corrientes",
    str_detect(jugador, "Ezequiel Lavezzi") ~ "Santa Fe",
    str_detect(jugador, "Federico Fazio") ~ "Buenos Aires",
    TRUE ~ nombre_provincia),
    localidad = case_when(jugador == "Facundo Medina" ~ "Villa fiorito", 
                          TRUE ~ localidad),
    codigo_indec_provincia = case_when(nombre_provincia == "Buenos Aires" ~ "06",
                                       nombre_provincia == "Corrientes" ~ "18",
                                       TRUE ~ codigo_indec_provincia),
    pais = case_when(jugador == "Gonzalo Higuain" ~ "Francia", TRUE ~ pais))

### Separo casos con más de una provincia asignada
duplicados <- seleccion_arg %>% 
  janitor::get_dupes(jugador) 

duplicados <- duplicados%>% 
  mutate(duplicado = case_when(
    jugador == "Joaquin Correa" & nombre_provincia == "Tucumán" ~ "verdadero",
    jugador == "Eduardo Salvio" & nombre_provincia == "Buenos Aires" ~ "verdadero",
    jugador == "Alexis Mac Allister" & nombre_provincia == "La Pampa" ~ "verdadero",
    jugador == "Enzo Perez" & nombre_provincia == "Mendoza" ~ "verdadero",
    jugador == "Javier Mascherano" & nombre_provincia == "Santa Fe" ~ "verdadero",
    jugador == "Lucas Biglia" & nombre_provincia == "Buenos Aires" ~ "verdadero",
    jugador == "Sergio Romero" & nombre_provincia == "Misiones" ~ "verdadero")) %>% 
  filter(duplicado == "verdadero") %>% 
  select(-duplicado, -dupe_count)

jugadores <- duplicados$jugador

seleccion_arg <- seleccion_arg %>% 
  filter(!jugador %in% jugadores) %>% 
  bind_rows(duplicados)

### Armo base final
lista_wiki <- readr::read_rds("content/draft/2022-11-04-seleccion-2022/data/lista_convocados_wikipedia.rds") |> 
  filter(mundial == 2022) |> 
  mutate(nombre_join = stringi::stri_trans_general(nombre,"Latin-ASCII"),
         nombre_join = tolower(nombre_join))


prueba <- seleccion_arg |> 
  select(jugador, localidad, nombre_provincia) |> 
  mutate(nombre_join = tolower(jugador)) |> 
  right_join(lista_wiki, by = "nombre_join")

### Escribo seleccion
write_rds(seleccion_arg,
          glue::glue("content/draft/2022-11-04-seleccion-2022/data/seleccion_{anio}.rds"))
