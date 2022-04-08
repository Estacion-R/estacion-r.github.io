##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            ~~
##                                  METADATA                                ----
##                                                                            ~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Librerías
library(pdftools)

## Descargo el documento con los clasificadores
txt <- pdf_text("https://www.inegi.org.mx/contenidos/programas/enadid/2018/doc/clasificaciones_enadid18.pdf", 
                "content/posts/2022-03-03-un-arg-en-mex/doc/clasificadores.pdf")

## Me quedo unicamente con la página 8, donde se encuentran los clasificadores de países
test <- txt[8]  #P.49






prueba <- b_total %>% 
  rename(lugar_nac = p3_7) %>% 
  mutate(lugar_nac = case_when(lugar_nac == 1 ~ "Aquí, en este estado",
                               lugar_nac == 2 ~ "En otro estado",
                               lugar_nac == 3 ~ "En Estados Unidos de América",
                               lugar_nac == 4 ~ "En otro país",
                               lugar_nac == 5 ~ "No especificado"))



