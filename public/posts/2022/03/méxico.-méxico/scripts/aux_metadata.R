##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            ~~
##                                  METADATA                                ----
##                                                                            ~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
# ### Librerías
# library(pdftools)
# 
# ## Descargo el documento con los clasificadores
# txt <- pdf_text("https://www.inegi.org.mx/contenidos/programas/enadid/2018/doc/clasificaciones_enadid18.pdf", 
#                 "content/posts/2022-03-03-un-arg-en-mex/doc/clasificadores.pdf")
# 
# ## Me quedo unicamente con la página 8, donde se encuentran los clasificadores de países
# test <- txt[8]  #P.49






b_total <- b_total %>% 
  rename(lugar_nac = p3_7) %>% 
  mutate(lugar_nac = case_when(lugar_nac == 1 ~ "Aquí, en este estado",
                               lugar_nac == 2 ~ "En otro estado",
                               lugar_nac == 3 ~ "En Estados Unidos de América",
                               lugar_nac == 4 ~ "En otro país",
                               lugar_nac == 5 ~ "No especificado"),
         sexo = factor(sexo, 
                       levels = c(1, 2), 
                       labels = c("Hombre", "Mujer")),
         edad_agrup = case_when(edad %in% c(0:10) ~ "0 a 10",
                                edad %in% c(11:20) ~ "11 a 20",
                                edad %in% c(21:30) ~ "21 a 30",
                                edad %in% c(31:40) ~ "31 a 40",
                                edad %in% c(41:50) ~ "41 a 50",
                                edad %in% c(51:60) ~ "51 a 60",
                                edad %in% c(61:70) ~ "61 a 70",
                                edad %in% c(71:80) ~ "71 a 80",
                                edad %in% c(81:90) ~ "81 a 90",
                                edad %in% c(91:100) ~ "91 a 100",
                                edad > 100          ~ "Más de 100",
                                edad == 999         ~ "Edad no especificada"),
         edad_agrup = factor(edad_agrup))
