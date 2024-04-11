---
title: ¿La mejor selección Argentina de la historia?
description: "Este artículo propone indagar en un método de puntuación que permite analizar selecciones de fútbol a lo largo de la historia: el puntaje Elo. Para ello nos valdremos de R para hacer scraping web, procesamiento de datos y visualizaciones"
author: Juan Urricariet
date: '2024-04-10'
slug: la-mejor-selecci-n-argentina-de-la-historia
categories:
  - analisis
  - scrapping
  - articulo
  - futbol
  - seleccion
  - argentina
tags:
  - seleccion
  - argentina
  - futbol
  - elo
  - rstats
  - rstatsES
  - analisis
  - ggplot2
  - lubridate
  - rvest
  - tidyverse
  - dt
  - ggtext
toc: no
images: ~
---

<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>
<link href="{{< blogdown/postref >}}index_files/datatables-css/datatables-crosstalk.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/datatables-binding/datatables.js"></script>
<script src="{{< blogdown/postref >}}index_files/jquery/jquery-3.6.0.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/dt-core/css/jquery.dataTables.min.css" rel="stylesheet" />
<link href="{{< blogdown/postref >}}index_files/dt-core/css/jquery.dataTables.extra.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/dt-core/js/jquery.dataTables.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>

La pregunta que da título a este artículo, obviamente, no tiene una respuesta correcta. Las ponderaciones históricas, y más aún en el ámbito del fútbol, tienen un componente subjetivo importante. Muchas veces, la impronta generacional resulta decisiva: tenemos mayor cariño por equipos que nos deslumbraron en nuestra infancia o juventud y otros que simplemente no pudimos ver en tiempo real o los documentos fílmicos son escasos. Existieron equipos que llegaron más lejos de lo que su juego sugirió y otros que tuvieron grandes planteles pero que no culminaron con un trofeo.

<center>

<figure>
<img src="argentina_2006.jpg" style="width:60.0%" alt="Selección del Mundial 2006" />
<figcaption aria-hidden="true">Selección del Mundial 2006</figcaption>
</figure>

</center>

<br>

También hubo selecciones que basaron su juego en el funcionamiento colectivo y otros que destacaron por tener una estrella deslumbrante.

<center>

<figure>
<img src="argentina_1986.jpg" style="width:120.0%" alt="Selección campeona Mundial 1986" />
<figcaption aria-hidden="true">Selección campeona Mundial 1986</figcaption>
</figure>

</center>

<br>

Estas y muchas otras variables influyen en nuestra elección personal. En esta oportunidad, queremos hacer uso de un sistema que no es el dueño de la verdad, pero puede ser de utilidad para acompañar nuestras percepciones con algún sustento en los datos. Y para practicar R.

## ¿Qué es el sistema Elo?

El nombre proviene de su inventor, Árpád Élő, quien ideó un sistema de puntuación para la clasificación de jugadores de ajedrez, adoptada luego por la Federación Internacional de Ajedrez (FIDE). El método puede ser aplicado para cualquier competencia que enfrente equipos o jugadores entre sí. Consiste en otorgar un puntaje a cada participante relacionado con el rival que enfrenta, y se actualiza en cada partido o competencia. La [fórmula matemática que lo calcula](https://www.eloratings.net/about) tiene en cuenta la diferencia de puntaje entre ambos competidores. En términos futbolísticos, obtener un triunfo frente a Brasil otorgará un mayor puntaje -o disminuirá menos, en caso de perder- que uno ante Islas Feroe. Además, en el caso del fútbol se agrega una ponderación de acuerdo a la localía -vale más ganar de visitante- y a la competición en que se enmarca el encuentro -vencer en la final de la Copa del Mundo otorga más puntaje que hacerlo en un amistoso-. Actualmente la FIFA utiliza este sistema para sus clasificaciones oficiales [masculina](https://inside.fifa.com/es/fifa-world-ranking/men) y [femenina](https://inside.fifa.com/es/fifa-world-ranking/women).

## Obtención de los datos

Para jugar un poco con los datos vamos a presentar un breve código que extrae los puntajes de todos los países de la página web https://www.international-football.net/elo-ratings-table. Los datos comienzan en 1873, tiempos en los que solo se registran enfrentamientos en el clásico británico Inglaterra-Escocia.[^1]

La idea detrás del código para obtener los datos es hacer una serie de consultas a la página donde se publican los puntajes, de manera que vaya devolviendo los resultados para cada fecha que se elija.
Proponemos que se consulte por el primer día de cada mes entre 1873 y la fecha actual. Si bien podría hacerse para todos los días, el tiempo que demoraría sería excesivo, por lo que para ahorrar tiempo -este proceso demora unos 50 minutos- vamos a extraer solo una tabla por mes.

``` r
# Librerías utilizadas
library(rvest) # Paquete para implementar scraping web
library(lubridate) # Paquete para datos con formato fecha
library(tictoc) # Paquete para ver cuánto demoran los procesos
library(tidyverse)
library(ggtext) # Paquete para darle formato al texto
library(gt) # Paquete para armar tablas
```

``` r
# Fechas que se van a consultar: desde 1873 a 2024, el 1 de cada mes
fechas <- seq.Date(from = as.Date("1873-01-01"),
                   to = Sys.Date(),
                   by = "month")

# Lista para guardar las tablas según fecha
tabla_ratings <- list() 

tic() # Con esta función comenzamos a tomar el tiempo que tomará el procesamiento, hasta que se ejecute la función toc()

# Consulta: Con un for loop, se recorre la tabla de puntajes para cada fecha
for (i in 1:length(fechas)){
  link <- glue::glue("https://www.international-football.net/elo-ratings-table?year={year(fechas[i])}&month={month(fechas[i])}&day={day(fechas[i])}")
  elo_page <- read_html(link) # Lectura de la parte HTML estática de la web
  
  # Extracción de los elementos de texto de la web
  summaries_css <- elo_page %>%
    html_elements("td")
  
  elo_summaries <- html_text(summaries_css)
  
  # Manipulación de cada tabla para tener un resultado limpio
  rating <- as.data.frame(elo_summaries) %>% # Convierto a data frame
    rename(v1 = elo_summaries) %>% # Cambio de nombre a la variable
    filter(v1 != "") %>% # Saco filas vacías
    slice(-c(1:2)) # Excluyo las primeras 2 filas
  
  # La tabla que devuelve contiene el nombre de país y su puntaje en filas consecutivas
  row_odd <- seq_len(nrow(rating)) %% 2  # Selecciono las filas que son impares
  
  # Armo la tabla: las filas impares son el país y las pares el puntaje. Añado la columna fecha
  tabla_ratings[[i]] <- data.frame(pais = rating[row_odd == 1, ],
                                   elo =  rating[row_odd == 0, ],
                                   fecha = fechas[i])
  print(fechas[i])
}

toc() # Termina el conteo de tiempo que tomó el proceso

# Unifico todas las tablas en 1
tabla <- do.call(bind_rows, 
                 tabla_ratings)

# Guardo en formato .rds:
write_rds(tabla, 
          glue::glue("data/elo_ranks_{fechas[1]}_{fechas[length(fechas)]}.rds"))
```

De esta manera tenemos, en una única tabla, los puntajes Elo de las selecciones nacionales entre 1873 y 2024.
Veamos cómo está el ranking actualmente

``` r
# Lectura de la tabla en formato rds
elo <- read_rds("elo_ranks_1873-01-01_2024-04-01.rds") %>% 
  mutate(elo = as.numeric(elo), 
         pais = ifelse(pais == "Falkland Islands", 
                       yes = "Islas Malvinas",
                       no = pais))

# Mostramos la tabla de forma interactiva, con la función datatable del paquete {DT}
elo %>% filter(fecha == max(fecha)) %>% # Seleccionamos los registros de la última fecha
  arrange(-elo) %>% # Ordenamos valores de forma decreciente
  select(-fecha) %>% # Sacamos la variable fecha
  DT::datatable(caption = glue::glue("Ranking Elo al {format(max(elo$fecha),'%d de %B de %Y')}")) # Tabla y título
```

<div class="datatables html-widget html-fill-item" id="htmlwidget-1" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"filter":"none","vertical":false,"caption":"<caption>Ranking Elo al 01 de abril de 2024<\/caption>","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134","135","136","137","138","139","140","141","142","143","144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159","160","161","162","163","164","165","166","167","168","169","170","171","172","173","174","175","176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191","192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207","208","209","210","211","212","213","214","215","216","217","218","219","220","221","222","223","224","225","226","227","228","229","230","231","232","233","234","235","236","237","238","239"],["Argentina","France","Brazil","Spain","Portugal","England","Colombia","Uruguay","Belgium","Netherlands","Italy","Croatia","Germany","Ecuador","Ukraine","Austria","Japan","Hungary","Denmark","Iran","Switzerland","United States","Mexico","Serbia","Scotland","Senegal","Czech Republic","Russia","Australia","Morocco","Turkey","Peru","Venezuela","Greece","Slovenia","Norway","South Korea","Poland","Canada","Chile","Wales","Panama","Paraguay","Sweden","Tunisia","Uzbekistan","Algeria","Romania","Slovakia","Georgia","Mali","Qatar","Iraq","Jamaica","Egypt","Ivory Coast","Nigeria","Finland","Albania","Saudi Arabia","Ireland","Costa Rica","Bolivia","Jordan","Cape Verde","South Africa","Montenegro","Equatorial Guinea","Israel","Cameroon","North Macedonia","Iceland","Oman","Dem. Rep. of Congo","New Zealand","Northern Ireland","Luxembourg","Kosovo","Angola","United Arab Emirates","Burkina Faso","Ghana","Azerbaijan","Haiti","Honduras","Guatemala","Zambia","Guinea","Bosnia and Herzegovina","Bulgaria","Kazakhstan","Bahrain","Armenia","Northern Cyprus","Belarus","Syria","Martinique","Gabon","Kurdistan","Palestine","Trinidad and Tobago","Thailand","Libya","Kenya","China","El Salvador","Mauritania","Togo","Tajikistan","Namibia","Mozambique","North Korea","Uganda","Guinea-Bissau","Gambia","Estonia","Tanzania","Benin","Moldova","Reunion","Botswana","Latvia","Indonesia","Rwanda","Curaçao","Lithuania","Kuwait","Guadeloupe","Zanzibar","Zimbabwe","Central African Republic","Cyprus","Nicaragua","Sudan","Sierra Leone","Suriname","Comoros","Cuba","Malawi","Madagascar","Ethiopia","Solomon Islands","French Guiana","Burundi","Lebanon","Congo","Guyana","Kyrgyzstan","Vietnam","Faroe Islands","Malaysia","Malta","Liberia","Eswatini","Lesotho","Niger","New Caledonia","Fiji","Mayotte","Turkmenistan","Dominican Republic","India","Chad","Tahiti","Eritrea","Bermuda","South Sudan","Puerto Rico","Singapore","Afghanistan","Andorra","Grenada","Saint Lucia","Yemen","Papua New Guinea","Saint Kitts and Nevis","Saint Vincent and the Grenadines","Belize","São Tomé e Príncipe","Hong Kong","Gibraltar","Vanuatu","Philippines","Montserrat","Mauritius","Antigua and Barbuda","Somaliland","Dominica","Aruba","Western Sahara","Liechtenstein","Greenland","Saint Martin","Barbados","Djibouti","Bangladesh","Myanmar","Somalia","Chinese Taipei","Monaco","Nepal","Maldives","Sint Maarten","Seychelles","Bonaire","Cambodia","Pakistan","Bahamas","Cayman Islands","Mongolia","Chagos Islands","San Marino","Tuvalu","Samoa","Saint Barthelemy","Sri Lanka","Wallis and Futuna","Guam","Vatican","Turks and Caicos","Cook Islands","Saint Pierre and Miquelon","Laos","Macau","British Virgin Islands","Tibet","Brunei","US Virgin Islands","Timor-Leste","Bhutan","Islas Malvinas","Anguilla","Micronesia","Kiribati","Niue","Tonga","Northern Mariana Islands","Palau","American Samoa"],[2139,2085,2028,2019,2013,1999,1998,1989,1986,1968,1956,1953,1921,1873,1863,1857,1851,1842,1822,1818,1804,1800,1800,1788,1776,1776,1772,1772,1768,1767,1750,1746,1744,1740,1739,1737,1731,1721,1716,1713,1710,1707,1705,1697,1679,1666,1666,1664,1655,1650,1649,1647,1643,1638,1637,1631,1629,1623,1613,1612,1607,1605,1605,1599,1582,1575,1572,1558,1558,1558,1552,1545,1542,1534,1526,1516,1513,1509,1508,1508,1503,1503,1494,1494,1488,1487,1485,1479,1478,1473,1470,1460,1456,1456,1454,1446,1437,1433,1424,1419,1417,1416,1409,1406,1404,1398,1396,1391,1388,1373,1366,1366,1363,1362,1357,1356,1355,1353,1347,1346,1343,1341,1341,1341,1339,1331,1330,1327,1326,1323,1320,1318,1316,1314,1311,1307,1305,1305,1301,1296,1295,1290,1288,1281,1281,1275,1273,1269,1269,1268,1264,1261,1252,1250,1250,1241,1234,1222,1217,1212,1208,1194,1191,1186,1144,1143,1137,1130,1118,1114,1113,1096,1094,1094,1083,1080,1078,1075,1067,1056,1047,1046,1045,1022,1012,1011,1002,1001,998,996,959,953,942,938,933,932,919,906,906,903,889,879,872,855,842,842,827,817,799,790,785,777,756,745,727,707,701,698,692,690,685,677,665,665,654,630,621,618,610,607,571,571,565,545,496,481,434,403,377]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>pais<\/th>\n      <th>elo<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":2},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"pais","targets":1},{"name":"elo","targets":2}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

``` r
  # gt() %>%
  # tab_header(md(glue::glue("**Ranking Elo al {format(max(elo$fecha),'%d de %B de %Y')}**"))) %>%  # Tabla y título
  # cols_label(
  #   pais = "**País**",
  #   elo = "**Elo**", 
  #   .fn = md
  # ) %>%
  # fmt_number(columns = elo, sep_mark = ".", decimals = 0) |> 
  # opt_interactive()
```

La selección campeona en Qatar 2022 ocupa la primera posición, como era de esperar. También era de esperar la segunda posición. En el resto de la tabla pueden surgir algunas sorpresas, países que no creíamos que estuvieran tan bien rankeados -tal vez por tener presente su performance únicamente en el último mundial y no los enfrentamientos en otras competencias-. Adentrándonos en las profundidades de la tabla podemos detectar algunos territorios pintorescos, como el territorio dependiente de Estados Unidos Samoa Americana, la República de Palaos o las Islas Marianas del Pacífico. Selecciones con las que se podría fantasear arrancarles una victoria con nuestro equipo de amigos.

## Argentina en el tiempo

Si nos enfocamos en la selección Argentina, podemos seguir su derrotero desde el año 1902. Los picos cuando se obtuvieron las 3 Copas Mundiales son elocuentes. Llama la atención la clasificación durante las décadas de 1940 y 1950, tiempos en los cuales la selección albiceleste tenía grandes participaciones en los Campeonatos Sudamericanos (actual Copa América). En 1957, por ejemplo, [la Argentina obtiene el torneo continental con grandes goleadas (4-0 a Uruguay, 3-0 a Brasil) de la mano de la delantera de *Los Carasucias*](https://es.wikipedia.org/wiki/Campeonato_Sudamericano_1957).

<center>

<figure>
<img src="carasucias.webp" style="width:70.0%" alt="Selección 1957" />
<figcaption aria-hidden="true">Selección 1957</figcaption>
</figure>

</center>

<br>

El puntaje más bajo de la serie corresponde a abril de 1990: el entonces campéon del mundo no hacía pie en la preparación para el mundial de ese año, que culminaría en un subcampeonato.

``` r
# Graficamos la serie de Argentina
elo %>% 
  filter(pais == "Argentina") %>% 
  ggplot(aes(x=fecha,
             y=elo))+
  geom_point(data = elo %>% 
               filter(pais == "Argentina" & fecha %in% as.Date(c("1978-08-01","1986-08-01","2023-01-01"))),
             color="gold",
             size=10)+
  geom_line(color = "#75aadb")+
  theme_minimal()+
  labs(x = "",
       y = "",
       title = "Puntaje Elo de Argentina",
       subtitle = "")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" style="display: block; margin: auto;" />

Los datos del puntaje Elo permiten dar una respuesta a nuestra pregunta incial: el mayor nivel alcanzado por la selección Argentina coincide con la obtención de la última Copa del Mundo. Muchas personas, estimamos, compartirán esta apreciación.

<center>

<figure>
<img src="argentina_campeon_22.webp" style="width:70.0%" alt="Selección campeona Mundial 2022" />
<figcaption aria-hidden="true">Selección campeona Mundial 2022</figcaption>
</figure>

</center>

## Mano a mano

El puntaje Elo nos permite hacer un seguimiento en el tiempo de algunos duelos históricos de selecciones. La memoria reciente de los mundiales no es grata a la hora de recordar los enfrentamientos argentinos con Alemania. En el siglo XXI el país europeo eliminó tres veces seguidas a Argentina (en 2006, 2010 y la final de 2014). A falta de enfrentamientos más recientes podemos hacer uso de las estadísticas que nos provee nuestro amigo Elo. En la actualidad, la diferencia de puntuación a favor de Argentina (esto es el puntaje Elo de Argentina menos el de Alemania) es la mayor desde hace más de 80 años.

``` r
# Armamos una tabla con los resultados de Argentina y Alemania
elo_arg_germany <- elo %>% 
  filter(pais %in% c("Argentina", "Germany", "West Germany")) %>% 
  pivot_wider(names_from = "pais",
              values_from = "elo") %>% 
  mutate(Germany = ifelse(is.na(Germany), 
                          yes = `West Germany`, 
                          no = Germany)) %>% 
  mutate(dif = Argentina - Germany) %>% # Diferencia de puntajes
  pivot_longer(cols = c("Argentina", "Germany", "dif"),
               names_to = "var",
               values_to = "val") %>% 
  mutate(var_tipo = ifelse(var == "dif",
                           yes= "dif",
                           no = "elo"), 
         var_tipo = factor(var_tipo,levels = c("elo", "dif"),
                           labels = c("elo","dif"))) # Convertimos a formato factor
```

``` r
# Graficamos la evolución de las series de Argentina y Alemania, junto con la diferencia
ggplot(data = elo_arg_germany,
       aes(x = fecha,
           y = val)) + 
  geom_line(aes(color = var),
            data = elo_arg_germany %>% 
              filter(var_tipo == "elo"))+ # Líneas de ambas series
  geom_col(data = elo_arg_germany %>% 
             filter(var_tipo == "dif"),
           fill = "gold")+ # Columnas con la diferencia entre ambas
  facet_grid(facets = "var_tipo",
             scales = "free_y")+
  scale_color_manual(values = c("#75aadb", "#DD0000"),
                     name="")+
  theme(
    text = element_text(family = "Encode Sans"), 
    plot.title =  element_markdown(size = 14, face = "bold"),
    plot.subtitle = element_markdown(size = 12, face = "bold"),
    plot.caption  = element_markdown(size = 10),
    strip.text.y  = element_text(size = 8, face = "bold"),
    axis.text.x   = element_text(size = 6, angle = 90),
    axis.text.y   = element_text(size = 6),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.position = "none",
    strip.placement = "outside",
    legend.title = element_blank())+
  theme_minimal()+
  labs(x = "",
       y = "",
       title = "Puntaje Elo de Argentina y Alemania y diferencia entre ambos",
       subtitle = "Aplica Alemania Occidental durante la división")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" style="display: block; margin: auto;" />

## Conociendo al autor **\[Juan Urricariet\]**

*Soy un economista apasionado por la ciencia de datos. Tengo experiencia en el ámbito de las estadísticas oficiales y en el análisis económico, donde implementé herramientas de programación (R principalemente) para la gran parte de las tareas de trabajo.*

<figure>
<img src="foto_juan.jpeg" style="width:30.0%" alt="Juan Urricariet" />
<figcaption aria-hidden="true">Juan Urricariet</figcaption>
</figure>

Pueden conocer su trabajo y contactarse por:

**Github**: https://github.com/jurricariet

📬: juanurricariet@gmail.com

[^1]: Es posible extraer, con un código muy similar, los datos de la web de la FIFA, pero estos inician recién en 1993.
