---
title: Adiós 2024. Hola 2025.
author: Pablo Tiscornia
date: '2024-12-30'
slug: adios-2024-hola-2025
categories: []
tags:
  - untagged
toc: no
css: estilo.css
images: ~
---

# Resumen 2024: Un año de crecimiento y aprendizajes en Estación R

Este 2024 ha sido un año emocionante para Estación R. Hemos alcanzado hitos importantes, sumado aprendizajes y contribuido a la comunidad de datos + R con nuevas iniciativas. A medida que cerramos este capítulo, miramos hacia el 2025 con más energía que nunca.

## Lo que logramos en 2024


### Multi-column environments

Multi-column environments are supported via's Pandoc's [fenced_divs](https://pandoc.org/MANUAL.html#extension-fenced_divs) syntax and some preamble sugar (bundled together with the template). For example, a two-column section would look like this.

:::::: {.columns}
::: {.column width="48%" data-latex="{0.48\textwidth}"}
Here is some example **dplyr** code.


``` r
library(dplyr)

mtcars %>% 
  group_by(am) %>% 
  summarise(mean(mpg))    
```

```
## # A tibble: 2 × 2
##      am `mean(mpg)`
##   <dbl>       <dbl>
## 1     0        17.1
## 2     1        24.4
```
:::

::: {.column width="4%" data-latex="{0.04\textwidth}"}
\ <!-- an empty Div (with a white space), serving as a column separator -->
:::

::: {.column width="48%" data-latex="{0.48\textwidth}"}
And the **data.table** equivalent.


``` r
library(data.table)

mtcars_dt = as.data.table(mtcars)
mtcars_dt[, mean(mpg), by = am]   
```

```
##       am       V1
##    <num>    <num>
## 1:     1 24.39231
## 2:     0 17.14737
```
:::
::::::
\ <!-- an empty Div again to give some extra space before the next block -->

### **Cursos y formación**
- **Dos cohortes del curso "Introducción al Procesamiento de Datos con R"**: Este curso se consolidó como una de nuestras propuestas más populares, ayudando a decenas de personas a dar sus primeros pasos en el análisis de datos con R.
- **Nuevo curso: "Introducción al desarrollo de Dashboards y Aplicaciones web con R y Shiny"**: De la mano de Elian Soutullo, este curso fue un éxito en su primera edición. Ya estamos trabajando en una nueva edición para el 2025, además de planear talleres específicos para profundizar en estas herramientas.

### **Contribuciones a la comunidad**
- **Nuestro blog**: Finalmente logramos publicar algunos artículos, compartiendo experiencias, tips y reflexiones para seguir aportando al ecosistema de R.
- **Tips de R**: Publicamos más de **200 tips de R** en nuestras redes (X, LinkedIn, Mastodon y Bluesky). Este proyecto sigue creciendo gracias al entusiasmo y apoyo de la comunidad.

### **Colaboración con organizaciones**
- **Automatización y flujo de datos con la AAIP**: Trabajamos junto a la Agencia de Acceso a la Información Pública (AAIP) para desarrollar un flujo de trabajo que automatiza la importación, limpieza y publicación de datos. Este sistema no solo optimiza el portal de datos abiertos, sino que también genera **más de 200 reportes automáticos** con solo unos clics.
- **Capacitación para la sostenibilidad**: Diseñamos y llevamos adelante una capacitación al equipo de datos de la AAIP, empoderándolos para que puedan mantener y mejorar el flujo de trabajo con sus propias manos.

## ¡Lo que se viene en 2025!

### **Proyectos con organizaciones**
Seguiremos apoyando a las organizaciones en el diseño de tableros que faciliten el consumo de información y la toma de decisiones. Este trabajo estará acompañado de un plan de capacitación integral para que las entidades se conviertan en dueñas de sus propios procesos.

### **Expansión de nuestra oferta de cursos**
- Una nueva edición del curso **"Introducción al desarrollo de Dashboards y Aplicaciones web con R y Shiny"**.
- Nuevos cursos como:
  - **R Intermedio**
  - **Git y GitHub**
  - **Armado de reportes con R**
  - Y muchos más que estamos diseñando.

### **Una nueva plataforma para Estación R**
Estamos trabajando en el desarrollo de una nueva página web. Desde allí, podrás:
- Gestionar tus cursos sincrónicos y asincrónicos.
- Acceder a las novedades.
- Leer artículos exclusivos que continuaremos publicando.

## ¡Gracias por acompañarnos!
Nada de esto sería posible sin el apoyo de la comunidad que cree en nuestro trabajo y en la importancia de fomentar una cultura de datos accesible. Estamos entusiasmados por todo lo que viene en el 2025 y esperamos seguir creciendo juntos.

¡Sigamos explorando y aprendiendo con R!

