library(tabulizer)

tabel <- extract_tables('https://www.inegi.org.mx/contenidos/programas/enadid/2018/doc/clasificaciones_enadid18.pdf')
tabel[[1]]

clasificador_pag1 <- extract_areas(
  "https://www.inegi.org.mx/contenidos/programas/enadid/2018/doc/clasificaciones_enadid18.pdf", 
  pages = 8)
as.vector(clasificador_pag1)

clasificador_pag2 <- extract_areas(
  "https://www.inegi.org.mx/contenidos/programas/enadid/2018/doc/clasificaciones_enadid18.pdf", 
  pages = 9)
