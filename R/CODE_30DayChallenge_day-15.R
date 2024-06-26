library(datapasta)
library(readr)
library(ggplot2)
library(dplyr)
library(ggforce)
library(tidyr)


### Cargo datos
source(file = "df_capacidad_instalada.R")


meses_texto <- df_capacidad_inst_orig |> 
  select(anio, mes) |> 
  filter(anio == 2023) |> pull(mes)

meses_numero <- df_capacidad_inst_orig |> 
  select(anio, mes) |> 
  filter(anio == 2023) |> 
  mutate(orden = row_number()) |> pull(orden)

df_capacidad_inst <- df_capacidad_inst_orig |> 
  mutate(periodo = paste0(anio, "-", meses_numero),
         anio = ifelse(mes == "Enero", anio, NA_character_))

valor_min <- df_capacidad_inst |> filter(nivel_general == min(nivel_general)) |> select(periodo, nivel_general)
valor_max <- df_capacidad_inst |> filter(nivel_general == max(nivel_general)) |> select(periodo, nivel_general)
valor_ult <- df_capacidad_inst |> filter(periodo == max(periodo)) |> select(periodo, nivel_general)


viz <- 
  df_capacidad_inst |> 
  ggplot(aes(x = periodo, y = nivel_general, group = "")) + 
  #scale_x_discrete(labels = ) +
  scale_x_discrete(breaks = c("2016-1", "2017-1", "2018-1", "2019-1", "2020-1", "2021-1", "2022-1", "2023-1", "2024-1", "2025-1"), 
                   labels = c("2016-1", "2017-1", "2018-1", "2019-1", "2020-1", "2021-1", "2022-1", "2023-1", "2024-1", "2025-1")) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1, scale = 1)) +
  geom_line() + 
  ### Valor mínimo
  geom_point(aes(x = valor_min$periodo, y = valor_min$nivel_general),
             color = "red") +
  geom_text(x = valor_min$periodo, y = valor_min$nivel_general,
            label = paste0(valor_min$nivel_general, "%"),
            color = "red", hjust = -0.5) +
  annotate('text', 
           x = "2019-1" , y = valor_min$nivel_general + 10,
           label = paste("Valor mínimo:", valor_min$periodo), 
           size = 4, color = "red") +
  annotate(
    'curve',
    x = "2019-1", xend = "2020-4",
    y = 51, 
    yend = valor_min$nivel_general,
    color = "red",
    linewidth = 0.5,
    curvature = 0.5,
    arrow = arrow(length = unit(0.3, 'cm'))
  ) +
  ### Valor máximo
  geom_point(aes(x = valor_max$periodo, y = valor_max$nivel_general),
             color = "green") +
  geom_text(x = valor_max$periodo, y = valor_max$nivel_general,
            label = paste0(valor_max$nivel_general, "%"),
            color = "green", hjust = -0.2) +
  annotate('text', 
           x = "2019-8" , 
           y = 75,
           label = paste("Valor Máximo:", valor_max$periodo), 
           size = 4, color = "green") +
  annotate('curve',
           x = "2021-1", xend = "2022-8",
           y = 75, yend = valor_max$nivel_general,
           color = "green",
           linewidth = 0.5,
           curvature = -0.2,
           arrow = arrow(length = unit(0.3, 'cm'))
  ) +
  ### Valor último
  geom_point(aes(x = valor_ult$periodo, y = valor_ult$nivel_general),
             color = "darkgrey") +
  geom_text(x = valor_ult$periodo, y = valor_ult$nivel_general,
            label = paste0(valor_ult$nivel_general, "%"),
            color = "darkgrey", hjust = 1.2) +
  annotate('text', 
           x = "2022-1" , 
           y = 45,
           label = paste("Valor Último:", valor_ult$periodo), 
           size = 4, color = "darkgrey") +
  annotate('curve',
           x = "2023-1", xend = "2024-1",
           y = 45, yend = valor_ult$nivel_general-1,
           color = "darkgrey",
           linewidth = 0.5,
           curvature = 0.5,
           arrow = arrow(length = unit(0.3, 'cm'))
  ) +
  labs(x = "", y = "",
       #color = "Período",
       title = "Utilización de la Capacidad Instalada en la Industria.",
       subtitle = "Serie 2016-2024. Argentina",
       caption = "Fuente: Elaboración propia en base al INDEC") + 
  theme(axis.line = element_line(color = "gray30", linewidth = rel(1)),
        text = element_text(family = "Ubuntu"),
        plot.title = element_text(size = rel(1.7)),
        plot.subtitle = element_text(size = rel(1)),
        axis.title.x = element_text(size = rel(1)),
        axis.title.y = element_text(size = rel(1)),
        legend.text = element_text(size = rel(1.25)),
        legend.title = element_text(size = rel(1)),
        strip.text = element_text(face = "bold", size = rel(.1))
        #axis.text.x = element_blank(), 
        #axis.ticks.x = element_blank()
  )

viz