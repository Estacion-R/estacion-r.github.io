library(tidyverse)
library(worldfootballR)
library(rvest)
library(stringr)
library(janitor)


anio <- 1998

### Armo base final
jugadores_wiki <- readr::read_rds("content/draft/2022-11-04-seleccion-2022/data/lista_convocados_wikipedia.rds") |> 
  filter(mundial == anio) |> 
  mutate(nombre_join = stringi::stri_trans_general(nombre,"Latin-ASCII"),
         nombre_join = tolower(nombre_join),
         nombre_join = case_when(nombre == "Alejandro Gómez" ~ "papu gomez",
                                 nombre == "Maximiliano Rodríguez" ~ "maxi rodriguez",
                                 nombre == "José Basanta" ~ "jose maria basanta",
                                 nombre == "Ricardo Álvarez" ~ "ricky alvarez",
                                 nombre == "Roberto Abbondanzieri" ~ "pato abbondanzieri",
                                 nombre == "Cristian González" ~ "kily gonzalez",
                                 nombre == "Mauricio Héctor Pineda" ~ "mauricio pineda",
                                 nombre == "Claudio Javier López" ~ "claudio lopez",
                                 nombre == "Diego Pablo Simeone" ~ "diego simeone",
                                 nombre == "Marcelo Alejandro Delgado" ~ "marcelo delgado",
                                 nombre == "Ramón Ismael Medina Bello" ~ "ramon medina bello",
                                 nombre == "Diego Armando Maradona †" ~ "diego maradona",
                                 nombre == "Ángel David Comizzo" ~ "angel comizzo",
                                 nombre == "Sergio Almirón" ~ "sergio omar almiron",
                                 nombre == "Ricardo Enrique Bochini" ~ "ricardo bochini",
                                 nombre == "José Luis Brown †" ~ "jose luis brown",
                                 nombre == "José Luis Cuciuffo †" ~ "jose luis cuciuffo",
                                 nombre == "Diego Maradona  †" ~ "diego maradona",
                                 nombre == "Héctor Miguel Zelada" ~ "hector zelada",
                                 nombre == "Nery Pumpido" ~ "mario kempes",
                                 nombre == "Santiago Santamaría †" ~ "santiago santamaria",
                                 nombre == "Mario Alberto Kempes" ~ "mario kempes",
                                 nombre == "Jorge Mario Olguín" ~ "jorge olguin",
                                 nombre == "Leopoldo Jacinto Luque †" ~ "leopoldo luque",
                                 nombre == "Oscar Ortiz" ~ "oscar alberto ortiz",
                                 nombre == "René Houseman †" ~ "rene houseman",
                                 nombre == "Rubén Galván †" ~ "ruben galvan",
                                 
                                 
                                 TRUE ~ nombre_join))


### Seleccion de fbref
seleccion_arg <- as.data.frame(fb_player_urls(glue::glue("https://fbref.com/en/squads/f9fddd6e/{anio}/Argentina-Men-Stats"), 
                                              time_pause = 3))

colnames(seleccion_arg)[1] <- "url"

seleccion_arg <- seleccion_arg %>% 
  mutate(
    jugador = str_replace(string = url, pattern = "^.+/", replacement = ""),
    jugador = str_replace_all(jugador, pattern = "-", replacement = " "),
    jugador = case_when(jugador == "Ruben Ayala" ~ "Roberto Ayala",
                        TRUE ~ jugador),
    info_jugador = NA_character_,
    nombre_join = stringr::str_to_lower(jugador),
    nombre_join = stringi::stri_trans_general(nombre_join,"Latin-ASCII")
         )


seleccion_def <- jugadores_wiki |> 
  left_join(seleccion_arg)



seleccion_def <- seleccion_def |> 
  mutate(url = case_when(nombre_join == "enzo fernandez" ~ "https://fbref.com/en/players/5ff4ab71/Enzo-Fernandez",
                         nombre_join == "lionel scaloni" ~ "https://fbref.com/en/players/6cc4990c/Lionel-Scaloni",
                         nombre_join == "thiago almada" ~ "https://fbref.com/en/players/27f33438/Thiago-Almada",
                         nombre_join == "wilfredo caballero" ~ "https://fbref.com/en/players/a179d516/Willy-Caballero",
                         nombre_join == "roberto ayala" ~ "https://fbref.com/es/jugadores/561d182e/Roberto-Ayala",
                         TRUE ~ url),
         jugador = case_when(nombre_join == "enzo fernandez" ~ "Enzo Fernandez",
                             nombre_join == "lionel scaloni" ~ "Lionel Scaloni",
                             nombre_join == "thiago almada" ~ "Thiago Almada",
                             nombre_join == "wilfredo caballero" ~ "Wilfredo Caballero",
                             TRUE ~ jugador))


### Saco al DT
seleccion_def <- seleccion_def %>% 
  filter(!is.na(url))

### Agrego info de localidad
for (i in 1:nrow(seleccion_def)) {
  
    seleccion_def[i, "info_jugador"] <- read_html(seleccion_def[i,"url"]) %>% 
    html_element(css = "#meta p:nth-child(5)") %>% 
    html_text2()
  
  Sys.sleep(time = 1)
  
}

### Chequeo aquellos casos sin info de localidad
no_match <- seleccion_def %>% 
  filter(!str_starts(info_jugador, "Born"))

for (i in 1:nrow(no_match)) {
  
  no_match[i, "info_jugador"] <- read_html(no_match[i, "url"]) %>% 
    html_element(css = "#meta p:nth-child(4)") %>% 
    html_text2()
  
  Sys.sleep(time = 3)
}

seleccion_def <- seleccion_def %>% 
  filter(str_starts(info_jugador, "Born")) %>% 
  bind_rows(no_match)

#rm(no_match, jugadores)


### Armo variables de localidad
seleccion_def <- seleccion_def %>% 
  mutate(origen = str_replace(string = info_jugador, pattern = "^.+ in", replacement = "")) %>% 
  separate(col = origen, into = c("localidad", "pais"), sep = ",")

### Separo y reparo aquellos jugadores sin localidad (a manopla)
sin_loc <- seleccion_def %>% 
  filter(is.na(pais)) %>% 
  mutate(localidad = case_when(
    str_detect(jugador, "Otamendi|Papu Gomez|Giovanni Simeone|Agustin Rossi|Pablo Zabaleta|Ricky Alvarez") ~ "Ciudad de Buenos Aires",
    str_detect(jugador, "Clemente Rodriguez|Javier Saviola|Lucho Gonzalez|Juan Pablo Sorin|Luis Islas") ~ "Ciudad de Buenos Aires",
    str_detect(jugador, "Diego Simeone|Diego Placente|Mauricio Pineda|Leonardo Astrada|Sergio Vazquez") ~ "Ciudad de Buenos Aires",
    str_detect(jugador, "Jorge Borelli|Sergio Batista|Nestor Fabbri|Ricardo La Volpe") ~ "Ciudad de Buenos Aires",
    str_detect(jugador, "Nicolas Tagliafico") ~ "Almirante Brown",
    str_detect(jugador, "Carlos Tevez") ~ "Ciudadela",
    str_detect(jugador, "Sergio Aguero") ~ "Quilmes",
    str_detect(jugador, "Lucas Martinez Quarta") ~ "Mar del Plata",
    str_detect(jugador, "Medina") ~ "Villa Fiorito",
    str_detect(jugador, "Federico Fazio|Agustin Orion") ~ "Ramos Mejía",
    str_detect(jugador, "Mariano Andujar") ~ "Villa Lugano",
    str_detect(jugador, "Jonas Gutierrez") ~ "Saenz Peña",
    str_detect(jugador, "Esteban Cambiasso") ~ "San Fernando de la Buena Vista",
    str_detect(jugador, "Javier Zanetti") ~ "Dock Sud",
    str_detect(jugador, "Matias Almeyda") ~ "Azul",
    str_detect(jugador, "Mauricio Pochettino") ~ "Murphy",
    str_detect(jugador, "Sergio Goycochea") ~ "Lima",
    str_detect(jugador, "Jose Basualdo") ~ "Campana",
    str_detect(jugador, "Nestor Lorenzo") ~ "Villa Celina",
    str_detect(jugador, "Pedro Troglio") ~ "Luján",
    str_detect(jugador, "Enzo Trossero") ~ "Esmeralda",
    str_detect(jugador, "Ricardo Villa") ~ "Roque Pérez",
    str_detect(jugador, "Roberto Ayala") ~ "Paraná",
    str_detect(jugador, "Juan Roman Riquelme") ~ "San Fernando"))


### Rearmo base con corrección de localidad
seleccion_def <- seleccion_def %>% 
  filter(!is.na(pais)) %>% 
  bind_rows(sin_loc) %>% 
  mutate(pais = "Argentina",
         localidad = str_to_lower(str_trim(localidad, side = "both")))

#rm(sin_loc)


if(!exists("bahra")){
  ### Traigo base BAHRA para machear Provincia
  url_loc <- "https://wms.ign.gob.ar/geoserver/bahra/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=bahra%3Alocalidad_bahra&outputFormat=csv"
  #url_ent <- "https://wms.ign.gob.ar/geoserver/bahra/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=bahra%3Aentidad_bahra&outputFormat=csv"
  
  bahra <- read_delim(url_loc) %>% 
    select(nombre_geografico, nombre_provincia, codigo_indec_provincia, 10:13, geom) %>% 
    mutate(nombre_geografico = str_to_lower(nombre_geografico))
  }


### Uno con seleccion
seleccion_def <- seleccion_def %>% 
  left_join(bahra, by = c("localidad" = "nombre_geografico"))

duplicados <- seleccion_def %>% 
  janitor::get_dupes(jugador) 

duplicados <- duplicados%>% 
  mutate(duplicado = case_when(
    jugador == "Joaquin Correa" & nombre_provincia == "Tucumán" ~ "verdadero",
    jugador == "Eduardo Salvio" & nombre_provincia == "Buenos Aires" ~ "verdadero",
    jugador == "Alexis Mac Allister" & nombre_provincia == "La Pampa"  & codigo_indec_provincia == 42 ~ "verdadero",
    jugador == "Enzo Perez" & nombre_provincia == "Mendoza" ~ "verdadero",
    jugador == "Javier Mascherano" & nombre_provincia == "Santa Fe" ~ "verdadero",
    jugador == "Lucas Biglia" & nombre_provincia == "Buenos Aires" ~ "verdadero",
    jugador == "Sergio Romero" & nombre_provincia == "Misiones" ~ "verdadero",
    jugador == "Wilfredo Caballero" & nombre_provincia == "Entre Ríos" & codigo_indec_provincia == 30 ~ "verdadero"
  )) %>% 
  filter(duplicado == "verdadero") %>% 
  select(-duplicado, -dupe_count) %>% 
  distinct()

jugadores <- duplicados$jugador

seleccion_def <- seleccion_def %>% 
  filter(!jugador %in% jugadores) %>% 
  bind_rows(duplicados)

### Reviso casos sin match
no_match <- seleccion_def %>% 
  filter(is.na(nombre_provincia))

### Reparo
prueba <- seleccion_def %>% 
  mutate(nombre_provincia = case_when(
    str_detect(jugador, "Eduardo Salvio|Rodrigo De Paul|Nicolas Gonzalez|Nicolas Dominguez|Manuel Lanzini|Agustin Orion") ~ "Buenos Aires",
    str_detect(jugador, "Guido Rodriguez|Gonzalo Montiel|Facundo Medina|Agustin Marchesin|Fernando Gago|Mariano Andujar") ~ "Buenos Aires",
    str_detect(jugador, "Alexis Mac Allister") ~ "La Pampa",
    str_detect(jugador, "Maximiliano Meza") ~ "Corrientes",
    str_detect(jugador, "Ezequiel Lavezzi|Carlos Roa|Nery Pumpido|Fabian Cancelarich|Nestor Clausen|Pedro Pasculli|Leopoldo Luque") ~ "Santa Fe",
    str_detect(jugador, "Jose Serrizuela") ~ "Tucumán",
    str_detect(jugador, "Federico Fazio|Diego Milito|Carlos Tevez|Jonas Gutierrez|Hernan Crespo|Gabriel Milito|Julio Olarticoechea") ~ "Buenos Aires",
    str_detect(jugador, "Oscar Ustari|Esteban Cambiasso|Javier Zanetti|Leonardo Astrada|Alejandro Mancuso|Fernando Redondo") ~ "Buenos Aires",
    str_detect(jugador, "Nestor Lorenzo|Juan Barbas") ~ "Buenos Aires",
    TRUE ~ nombre_provincia),
    localidad = case_when(jugador == "Facundo Medina" ~ "Villa fiorito", 
                          TRUE ~ localidad),
    codigo_indec_provincia = case_when(nombre_provincia == "Buenos Aires" ~ "06",
                                       nombre_provincia == "Corrientes" ~ "18",
                                       TRUE ~ codigo_indec_provincia),
    pais = case_when(jugador == "Gonzalo Higuain" ~ "Francia", TRUE ~ pais))

table(is.na(prueba$nombre_provincia))

seleccion_def <- prueba

### Escribo seleccion
if(file.exists(glue::glue("content/draft/2022-11-04-seleccion-2022/data/seleccion_{anio}.rds"))){
  
  file.remove(glue::glue("content/draft/2022-11-04-seleccion-2022/data/seleccion_{anio}.rds"))
  
  write_rds(seleccion_def,
            glue::glue("content/draft/2022-11-04-seleccion-2022/data/seleccion_{anio}.rds"))
} else {
  
  write_rds(seleccion_def,
            glue::glue("content/draft/2022-11-04-seleccion-2022/data/seleccion_{anio}.rds"))
}

