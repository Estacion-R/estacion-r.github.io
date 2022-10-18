---
title: Todos los caminos conducen a Microcentro
author: ''
date: '2022-10-01'
slug: caminos-a-microcentro
categories:
  - rstatsES
  - analisis
tags:
  - rstats
  - rstatsES
  - datascience
  - ggplot2
  - mapas
  - maps
toc: no
images: ~
---

## Idea

Analizar la concentración de la infraestructura de la administración pública. La hipótesis por detrás de este informe exploratorio asume la presencia de una alta concentración de innmuebles en ciertas zonas, principalmente en aquella denominada “Microcentro”, hecho que genera una gran movilización de personas hacia mismos lugares con una consecuente saturación del sistema de transporte, por un lado y de servicios, por otro.

Por otro lado, este hecho, dado el contexto actual en donde la aglomeración de personas no es aconsejable a la hora de combatir enfermedades producidas por virus como el COVID, potencia las consecuencias negativas de dicha distribución geográfica de los inmuebles estatales y refuerza la necesidad de impulsar una política pública que apunte a la desconcentración.

Finalmente, se deja como posibilidad el avanzar en una estimación sobre la cantidad de personas que se movilizan hacia esos edificios, posiblemente, en función de la superficie de los inmuebles.

## Ubicación.

El análisis se centra en la ubicación de los inmuebles del Estado Nacional en la Ciudad de Autónoma de Buenos Aires, dada la relevancia administrativa que presenta la jurisdicción para el país. Esto no impide que el análisis se pueda extender a otras localidades, siempre que la información lo permita.

## Fuentes de datos.

-   [Inmuebles Propios del Estado Nacional y Alquilados.](https://datos.gob.ar/dataset/otros-inmuebles-propios-estado-nacional-alquilados)

-   [Edificios Públicos del Gobierno de la Ciudad de Buenos Aires](https://data.buenosaires.gob.ar/dataset/edificios-publicos)

    -   A Futuro:

        -   [Nómina del personal civil de la Administración Pública Nacional (APN)](https://datos.gob.ar/dataset/jgm-nomina-personal-civil-administracion-publica-nacional-apn)

        -   Buscar: Nómina de la administración Pública del Gobierno de la Ciudad de Buenos Aires

## Urgando en la información disponible

La informaciuón con la que se cuenta es aquella referida a los Inmuebles Propios del Estado Nacional y Alquilados, provista por la Dirección Nacional del Registro de Bienes Inmuebles - Agencia de Administración de Bienes del Estado - Jefatura de Gabinete de Ministros.

Una de las primeras observaciones alude a la presencia de varios campos que indican que la información que contiene la base es para absolutamente todos los edificios en manos del Estado Nacional Argentino (propios o en alquiler), sea que estén ubicados dentro o fuera del país y, en el primer caso, en qué jurisdicción.

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />

Para este análisis, vamos a quedarnos unicamente con aquellos localizados en Argentina y, a su vez, en la Ciudad Autónoma de Buenos Aires (CABA). Notamos cómo en la Ciudad Autónoma de Buenos Aires, centro adminitrativo del país, se concetra practicamente la totalidad de los inmuebles **(97,5%)**

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" />

Tal como se mencionó anteriormente, el análisis se centra en la distribución de inmuebles ubicados en la CABA. Una vez seleccionado nuestro universo de análisis, se procede a localizar geográficamente sobre un mapa la ubicación de cada uno de los edificios:

    ## Reading layer `CABA_comunas' from data source 
    ##   `https://bitsandbricks.github.io/data/CABA_comunas.geojson' 
    ##   using driver `GeoJSON'
    ## Simple feature collection with 15 features and 4 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -58.53152 ymin: -34.70529 xmax: -58.33514 ymax: -34.52754
    ## Geodetic CRS:  WGS 84

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Podemos notar que ciertos puntos presentan un color intenso. Esto nos permite sospechar que una misma dirección aparece varias veces en la base de datos. Tratemos de quedarnos con una sóla fila por dirección, intentando no perder información en el camino, como la superficie en mts2 del edificio (posible estimador de cantidad de personas por edificio a utilizar en un futuro):

Para ello, se crea una variable que contenga la información de la calle y el número en un mismo campo, y así poder identificar si se encuentra duplicada la fila.

Encontramos, efectivamente, que hay 247 direcciones duplicadas y 207 coordenadas duplicadas. Esto se debe, principalmente, a que en aquellos edificios donde el Estado dispone de más de un piso, se registra cada uno como un caso diferente.

Al mismo tiempo, evidenciamos que el campo de superficie se encuentra de forma agregada por edificio y no por piso:

    ## # A tibble: 259 × 8
    ##    codigo_del_inmueble calle_n…¹ depar…² super…³ longi…⁴ latitud dupli…⁵ dupli…⁶
    ##                  <dbl> <chr>     <chr>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
    ##  1           200000196 Esmerald… Comuna…   1082.   -58.4   -34.6       2       1
    ##  2           200000390 Avenida … Comuna…   1092.   -58.4   -34.6       2       1
    ##  3           200000463 25 de Ma… Comuna…    382.   -58.4   -34.6       1       1
    ##  4           200000471 25 de Ma… Comuna…    382.   -58.4   -34.6       1       1
    ##  5           200000481 25 de Ma… Comuna…    382.   -58.4   -34.6       1       1
    ##  6           200000498 25 de Ma… Comuna…    382.   -58.4   -34.6       1       1
    ##  7           200000617 25 de Ma… Comuna…    299.   -58.4   -34.6       1       1
    ##  8           200000625 25 de Ma… Comuna…    299.   -58.4   -34.6       1       1
    ##  9           200000749 Av. 9 de… Comuna…   1750.   -58.4   -34.6       2       1
    ## 10           200001192 Av. Corr… Comuna…    337.   -58.4   -34.6       1       1
    ## # … with 249 more rows, and abbreviated variable names ¹​calle_numero,
    ## #   ²​departamento, ³​superficie_aproximada_m2, ⁴​longitud, ⁵​duplicados_dir,
    ## #   ⁶​duplicados_coord

Procedemos entonces a eliminar los edificios duplicados para evitar el doble conteo. Su peso por superficie, en caso de considerarlo, seguirá siendo posible de analizar.

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />

A continuación se puede ver cómo se distribuyen los edificios según la comuna en donde estén ubicados y notar que tenemos casos donde no se dispone de información sobre a cuál de ellas pertenecen:

<div id="mdishhyfav" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#mdishhyfav .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#mdishhyfav .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#mdishhyfav .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#mdishhyfav .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#mdishhyfav .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mdishhyfav .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#mdishhyfav .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#mdishhyfav .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#mdishhyfav .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#mdishhyfav .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#mdishhyfav .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#mdishhyfav .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#mdishhyfav .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#mdishhyfav .gt_from_md > :first-child {
  margin-top: 0;
}

#mdishhyfav .gt_from_md > :last-child {
  margin-bottom: 0;
}

#mdishhyfav .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#mdishhyfav .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#mdishhyfav .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#mdishhyfav .gt_row_group_first td {
  border-top-width: 2px;
}

#mdishhyfav .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mdishhyfav .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#mdishhyfav .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#mdishhyfav .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mdishhyfav .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#mdishhyfav .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#mdishhyfav .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#mdishhyfav .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#mdishhyfav .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#mdishhyfav .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#mdishhyfav .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#mdishhyfav .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#mdishhyfav .gt_left {
  text-align: left;
}

#mdishhyfav .gt_center {
  text-align: center;
}

#mdishhyfav .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#mdishhyfav .gt_font_normal {
  font-weight: normal;
}

#mdishhyfav .gt_font_bold {
  font-weight: bold;
}

#mdishhyfav .gt_font_italic {
  font-style: italic;
}

#mdishhyfav .gt_super {
  font-size: 65%;
}

#mdishhyfav .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#mdishhyfav .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#mdishhyfav .gt_indent_1 {
  text-indent: 5px;
}

#mdishhyfav .gt_indent_2 {
  text-indent: 10px;
}

#mdishhyfav .gt_indent_3 {
  text-indent: 15px;
}

#mdishhyfav .gt_indent_4 {
  text-indent: 20px;
}

#mdishhyfav .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col">Comuna</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col">Cantidad</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_center">Comuna 1</td>
<td class="gt_row gt_right">178</td></tr>
    <tr><td class="gt_row gt_center">Comuna 14</td>
<td class="gt_row gt_right">32</td></tr>
    <tr><td class="gt_row gt_center">Comuna 2</td>
<td class="gt_row gt_right">29</td></tr>
    <tr><td class="gt_row gt_center">Comuna 3</td>
<td class="gt_row gt_right">17</td></tr>
    <tr><td class="gt_row gt_center">Comuna 4</td>
<td class="gt_row gt_right">15</td></tr>
    <tr><td class="gt_row gt_center">Comuna 13</td>
<td class="gt_row gt_right">12</td></tr>
    <tr><td class="gt_row gt_center">Comuna 7</td>
<td class="gt_row gt_right">9</td></tr>
    <tr><td class="gt_row gt_center">Comuna 15</td>
<td class="gt_row gt_right">8</td></tr>
    <tr><td class="gt_row gt_center">Comuna 6</td>
<td class="gt_row gt_right">8</td></tr>
    <tr><td class="gt_row gt_center">Comuna 5</td>
<td class="gt_row gt_right">7</td></tr>
    <tr><td class="gt_row gt_center">Comuna 12</td>
<td class="gt_row gt_right">6</td></tr>
    <tr><td class="gt_row gt_center">Comuna 9</td>
<td class="gt_row gt_right">5</td></tr>
    <tr><td class="gt_row gt_center">Comuna 11</td>
<td class="gt_row gt_right">4</td></tr>
    <tr><td class="gt_row gt_center">Comuna 10</td>
<td class="gt_row gt_right">3</td></tr>
    <tr><td class="gt_row gt_center">Comuna 8</td>
<td class="gt_row gt_right">2</td></tr>
  </tbody>
  
  
</table>
</div>

Una vez descartados los casos sin información, se nota claramente la concentración de inmuebles del Estado Nacional en la **Comuna 1**, con más de la mitad de los inmuebles **(52.7)** y muy lejos de la **Comuna 14**, en segundo lugar, quien concentra un **9.6** de los mismos.

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

Intenemos armar un mapa de coropletas:

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" />

En el mapa se puede identificar claramente la concentración extrema de oficinas del Estado Nacional en la comuna 1.

Podríamos precisar en una escala menor esta distribución, por ejemplo, por radios censales:

    ## Reading layer `CABA_rc' from data source 
    ##   `https://bitsandbricks.github.io/data/CABA_rc.geojson' using driver `GeoJSON'
    ## Simple feature collection with 3554 features and 8 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -58.53092 ymin: -34.70574 xmax: -58.33455 ymax: -34.528
    ## Geodetic CRS:  WGS 84

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="672" />

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-14-1.png" width="672" />

Otra forma de visualizar la información es a través de los gráficos de densidad. En este caso, se puede identificar una clara zona predominante (como vimos, principalmente en la Comuna 1) y pequeñas zonas poco densas en cuanto a la cantidad de edificios del Estado.

    ##      left    bottom     right       top 
    ## -58.53800 -34.68466 -58.33475 -34.52943

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-15-1.png" width="672" />

(Breve) Conclusión.

Desde el punto de vista de la movilidad de personas al trabajo, comprobamos que (casi) todes vamos para el mismo lado, o dicho de otra forma, que más de la mitad de los inmuebles del Estado se ubican en una sóla Comuna lo que, inevitablemente, genera un flujo de personas hacia la misma dirección. Esto, por un lado, conlleva consecuencias negativas importantes tanto para la calidad como para la capacidad de servicio del transporte público (y que, a su vez, afecta a la calidad de vida de las personas).

Por otro lado, una mejor redistribución de los inmuebles podría generar una mejor distribución de los recursos económicos que se movilizan para ofrecer servicios a las personas que deben movilizarse hacia esos destinos para trabajar. Y no sólo nos referimos a servicios desde una perspectiva comercial. La redistribución podría facilitar el acceso a la seguridad y a la salud de la población del resto de las comunas, por ejemplo.

Se podría decir, en su momento, que una distribución espacial como la actual estaba fundamentada en la ventaja que proporcionaba el hecho de estar cerca, fisicamente, del centro administrativo del país. Hoy ese motivo puede ser relativizado, cuando muchas de las razones para acercarse ya no siguen vigente (tramites online, operatorias administrativas, bancarias, entre otras, en su gran proporción hoy digitales).
¿Cómo sigue?

Queda a futuro poder avanzar sobre una estimación de la cantidad de personas que se movilizan hacia estos inmuebles concentrados geograficamente que posee el Estado Nacional, sumando información sobre la pertinencia de permanecer en dicha zona y la posibilidad de implementar una política pública de relocalización.

También queda para seguir sumando la distribución de los inmuebles propios o alguilados que le corresponden a la Ciudad Autónoma de Buenos Aires.

<br>

------------------------------------------------------------------------

## El Código.

``` r
# Librerías
library(tidyverse)
#devtools::install_github("holatam/eph")
library(eph)
library(sf)
library(ggmap)
library(hrbrthemes)
#remotes::install_github("ewenme/ghibli")
library(ghibli)
library(kableExtra)
library(DataExplorer)
library(skimr)

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                               Carga de datos                             ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
b_inmuebles_apn <- read_csv("https://infra.datos.gob.ar/catalog/otros/dataset/6/distribution/6.1/download/inmuebles-estado-nacional.csv")


skim(b_inmuebles_apn)

calculate_tabulates(b_inmuebles_apn, "pais") %>% 
  arrange(-Freq) %>% 
  ggplot(aes(x = reorder(pais, Freq), y = Freq)) +
  geom_col(fill = "forestgreen", alpha = 0.5, colour = "black") +
  geom_hline(yintercept = 0) + 
  geom_text(aes(label = Freq), hjust = -0.2, size = 3) +
  labs(title = "Cantidad de inmuebles del Estado Nacional Argentino por país",
       caption= "Fuente: https://datos.gob.ar/",
       fill = "", x = "País", y = "Cantidad") +
  coord_flip() +
  theme_minimal() +
  theme(plot.margin = margin(0.25, 1, 0.25, 0.1, "cm"),
                     plot.caption=element_text(face = "italic", colour = "gray35",size=6),
                     title=element_text(size=10, face = "bold"))

b_inmuebles_apn %>% 
  filter(pais == "Argentina") %>% 
  calculate_tabulates( "provincia", add.percentage = "col") %>% 
  mutate(Freq = as.numeric(Freq)) %>% 
  arrange(-Freq) %>% 
  ggplot(aes(x = reorder(provincia, Freq), y = Freq)) +
  geom_col(fill = "forestgreen", alpha = 0.5, colour = "black") +
  geom_hline(yintercept = 0) + 
  geom_text(aes(label = paste0(Freq, "%"), y = Freq + 0.5), hjust = -0.1, size = 3) +
  labs(title = "Distribución porcentual de los inmuebles del Estado \n Nacional Argentino por provincia",
       caption= "Fuente: https://datos.gob.ar/",
       fill = "", x = "Provincia", y = "Porcentaje") +
  coord_flip() +
  theme_minimal() +
  theme(plot.margin = margin(0.25, 1, 0.25, 0.1, "cm"),
        plot.caption=element_text(face = "italic", colour = "gray35",size=6),
        title=element_text(size=10, face = "bold")) +
  #scale_y_continuous(limits = c(0, 110), breaks = c(0, 20, 40, 60, 80 ,100))
  scale_y_continuous(limits = c(0, 105), breaks = c(0, 20, 40, 60, 80, 100))

b_inmuebles_apn_caba <- b_inmuebles_apn %>% 
  filter(provincia == "Ciudad Autonoma de Buenos Aires")

capa_comunas <- st_read('https://bitsandbricks.github.io/data/CABA_comunas.geojson')

# Hacemos al objeto uno de tipo espacial
capa_inmuebles_caba <- b_inmuebles_apn_caba %>% 
  filter(!is.na(longitud), !is.na(latitud), !is.na(departamento)) %>% 
  st_as_sf(coords = c("longitud", "latitud"), crs = 4326) %>% 
  mutate(lat = st_coordinates(.)[,1],
         lon = st_coordinates(.)[,2])

ggplot() +
  geom_sf(data = capa_comunas) +
  geom_sf(data = capa_inmuebles_caba, color = "forestgreen", alpha = 0.4) +
  labs(title = "Distribución geográfica de los inmuebles del Estado \n Nacional Argentino.",
       subtitle = "Ciudad Autónoma de Buenos Aires",
       caption= "Fuente: https://datos.gob.ar/",
       fill = "", x = "Provincia", y = "Cantidad") +
  theme_void() +
  theme(plot.margin = margin(0.25, 1, 0.25, 0.1, "cm"),
                     plot.caption=element_text(face = "italic", colour = "gray35",size=6),
                     title=element_text(size=10, face = "bold"))

b_inmuebles_apn_caba <- b_inmuebles_apn_caba %>% 
  mutate(calle_numero = paste0(calle, "_", numero)) %>% 
  mutate(duplicados_dir   = ifelse(duplicated(calle_numero) == TRUE, 1, 2),
         duplicados_coord = ifelse(duplicated(longitud, latitud) == TRUE, 1 ,2))

b_inmuebles_apn_caba %>% 
  filter(duplicados_dir == 1 | duplicados_coord == 1) %>%  
  select(codigo_del_inmueble, calle_numero,  departamento, 
         superficie_aproximada_m2, longitud, latitud, duplicados_dir, duplicados_coord) %>% 
  arrange(codigo_del_inmueble)

# Remuevo casos duplicados, quedandome con los unicos
b_inmuebles_apn_caba <- b_inmuebles_apn_caba %>% 
  distinct(calle_numero,  .keep_all = TRUE)

# Hacemos al objeto uno de tipo espacial y remuevo los duplicados por coordenadas
capa_inmuebles_caba <- b_inmuebles_apn_caba %>% 
  filter(!is.na(longitud), !is.na(latitud), !is.na(departamento)) %>% 
  st_as_sf(coords = c("longitud", "latitud"), crs = 4326) %>% 
  mutate(lat = st_coordinates(.)[,1],
         lon = st_coordinates(.)[,2]) %>% 
  rename(superficie = superficie_aproximada_m2) %>% 
  distinct(geometry,  .keep_all = TRUE)

ggplot() +
  geom_sf(data = capa_comunas) +
  geom_sf(data = capa_inmuebles_caba, color = "forestgreen", alpha = 0.4, 
          aes(size = as.numeric(superficie))) +
  labs(title = "Distribución geográfica de los inmuebles del Estado \n Nacional Argentino por superficie del inmueble.",
       subtitle = "Ciudad Autónoma de Buenos Aires",
       caption= "Fuente: https://datos.gob.ar/",
       fill = "", x = "Provincia", y = "Cantidad") +
  theme_void() +
  theme(plot.margin = margin(0.25, 1, 0.25, 0.1, "cm"),
                     plot.caption=element_text(face = "italic", colour = "gray35",size=6),
                     title=element_text(size=10, face = "bold"), 
        legend.position = "none")

# Frecuencia
calculate_tabulates(capa_inmuebles_caba, "departamento") %>% 
  arrange(-as.numeric(Freq)) %>% 
  rename(Cantidad = Freq, Comuna = departamento)

#Vemos que hay edificios sin dato en departamento
#unique(capa_inmuebles_caba$departamento)

# Los quitamos de la base
capa_inmuebles_caba <- capa_inmuebles_caba %>% 
  filter(departamento != "")

# Tabla
porc_comuna <- capa_inmuebles_caba %>% 
  calculate_tabulates(x = "departamento", add.percentage = "col")



# Gráfico
  ggplot(data = porc_comuna) + 
  geom_col(aes(x = reorder(departamento, as.numeric(Freq)), y = as.numeric(Freq),
               fill = ifelse(departamento == "Comuna 1", "A","B"))) +
  geom_hline(yintercept = 0) +
  scale_fill_manual(values=c(A="#AF9699FF", B="#F3E8CCFF")) +
  geom_text(aes(x = reorder(departamento, as.numeric(Freq)), y = as.numeric(Freq), 
                label = paste0(Freq, "%")),
            hjust = "inward") +
  labs(title = "Distribución porcentual de los inmuebles del Estado Nacional \n por Comuna",
       x = "Comuna", y = "Porcentaje",
       caption = "Fuente: Jefatura de Gabinete de Ministros. Agencia de Administración de Bienes del Estado. Dirección Nacional del Registro de Bienes Inmuebles.",
       fill = "") +
  coord_flip() +
  theme_minimal()+
  theme(plot.margin = margin(0.25, 1, 0.25, 0.1, "cm"),
        plot.caption=element_text(face = "italic", colour = "gray35",size=6),
        title=element_text(size=10, face = "bold"), 
        legend.position = "none")


  
inmuebles_x_comuna <- capa_inmuebles_caba %>%
  mutate(comunas = case_when(departamento == "Comuna 1" ~ 1, departamento == "Comuna 2" ~ 2, 
                             departamento == "Comuna 3" ~ 3, departamento == "Comuna 4" ~ 4, 
                             departamento == "Comuna 5" ~ 5, departamento == "Comuna 6" ~ 6,
                             departamento == "Comuna 7" ~ 7, departamento == "Comuna 8" ~ 8, 
                             departamento == "Comuna 9" ~ 9, departamento == "Comuna 10" ~ 10,
                             departamento == "Comuna 11" ~ 11, departamento == "Comuna 12" ~ 12,
                             departamento == "Comuna 13" ~ 13, departamento == "Comuna 14" ~ 14,
                             departamento == "Comuna 15" ~ 15)) %>% 
  filter(!is.na(comunas)) %>%
  group_by(comunas) %>%
  summarise(cantidad=n()) %>% 
  st_set_geometry(NULL)

capa_comunas <- capa_comunas %>%
  #mutate(comunas = as.numeric(levels(comunas))[comunas]) %>%
  mutate(comunas = as.numeric(comunas)) %>% 
  left_join(inmuebles_x_comuna, by = "comunas")

ggplot() +
  geom_sf(data = capa_comunas, aes(fill=cantidad), color = NA) +
  geom_sf_text(data = capa_comunas, aes(label = comunas), size=2.5, colour = "black") +
    labs(title = "Inmuebles Propios del Estado Nacional y Alquilados",
         subtitle = "Densidad de propiedades",
         fill = "Cantidad",
         caption= "Fuente: https://datos.gob.ar/") +
  theme_void() +
  scale_fill_distiller(palette = "Spectral")


capa_radios <- st_read("https://bitsandbricks.github.io/data/CABA_rc.geojson")

# Join de capa inmuebles y capa de radios + creo variable de cantidad
inmuebles_x_radio <- st_join(capa_inmuebles_caba, capa_radios) %>% 
  group_by(RADIO_ID) %>%
  summarise(cantidad=n()) %>% 
  st_set_geometry(NULL)

# Llevo variable de cantidad a la capa de radios
capa_radios <- capa_radios %>%
  left_join(inmuebles_x_radio, by = "RADIO_ID")

# Visualizo distribución de inmuebles por radio censal
ggplot() +
  geom_sf(data = capa_radios, aes(fill=cantidad), color = NA) +
  labs(title = "Inmuebles Propios del Estado Nacional y Alquilados",
       subtitle = "Propiedades publicadas",
       fill = "Cantidad",
       caption= "Fuente: xxx") +
  theme_void() +
  scale_fill_distiller(palette = "Spectral")


ggplot() +
  geom_sf(data = capa_radios, aes(fill=cantidad)) +
  labs(title = "Inmuebles Propios del Estado Nacional y Alquilados",
       subtitle = "Propiedades publicadas",
       fill = "Cantidad",
       caption= "Fuente: xxx") +
  theme_void() +
  coord_sf(xlim = c(-58.39, -58.35), ylim = c(-34.63, -34.56), expand = FALSE)+
  scale_fill_distiller(palette = "Spectral")


bbox <- make_bbox(lon = b_inmuebles_apn_caba$longitud, lat = b_inmuebles_apn_caba$latitud)

bbox

CABA <- get_stamenmap(bbox, zoom = 11, maptype = "terrain")

# ggmap(CABA)

### Para replicar
theme_caba_map <- theme (plot.margin = margin(0.25, 1, 0.25, 0.1, "cm"), #ajustar los margenes del gráfico
                       title=element_text(size=10, face = "bold"), #tamaño de titulo del mapa
                       legend.key.size = unit(0.3, "cm"), #alto de cuadrados de referencia
                       legend.key.width = unit(0.4,"cm"), #ancho de cuadrados de referencia 
                       legend.position="right", #ubicacion de leyenda
                       legend.direction = "vertical", #dirección de la leyenda
                       legend.title=element_text(size=8, face = "bold"), #tamaño de titulo de leyenda
                       legend.text=element_text(size=7), #tamaño de texto de leyenda
                       plot.caption=element_text(face = "italic", colour = "gray35",size=6), #tamaño de nota al pie
                       axis.text = element_blank(), #texto eje X e Y
                       axis.ticks = element_blank())

ggmap(CABA) +
  geom_point(data = b_inmuebles_apn_caba, aes(x = longitud, y = latitud),
  color = "forestgreen", alpha = .5) +
  stat_density_2d(data = b_inmuebles_apn_caba, aes(x = longitud, y = latitud, 
                      fill = stat(level)),alpha = .4,
              bins = 25,
              geom = "polygon") +
  labs(title="Distribución de los inmuebles del Estado Nacional",
       subtitle="Ciudad Autónoma de Buenos Aires",
       x="",
       y="",
       caption= "Fuente: https://datos.gob.ar/",
       fill="Nivel")+
  scale_fill_distiller(palette = "Spectral") +
  #scale_fill_gradientn(colors = RColorBrewer::brewer.pal(7, "YlOrRd"))
  #theme_caba_c
  theme_minimal() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x.bottom = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y.left = element_blank(),
        plot.margin = margin(0.25, 1, 0.25, 0.1, "cm"),
        plot.caption=element_text(face = "italic", colour = "gray35",size=6),
        legend.position = "none",
        title=element_text(size=10, face = "bold"))
```
