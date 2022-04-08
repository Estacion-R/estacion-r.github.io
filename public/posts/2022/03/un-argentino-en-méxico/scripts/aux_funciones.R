

#                          Armo theme                         ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
theme_mex <- function(){ 
  #font <- "Georgia"   #assign font family up front
  
  theme_minimal() %+replace% 
    
    theme(
      
      # Grilla
      line = element_blank(),
      # panel.background = element_rect(fill = "transparent"),
      # plot.background = element_rect(fill = "transparent", color = "transparent"),
      # panel.border = element_rect(color = "transparent"),
      strip.background = element_rect(color = "gray20"),
      axis.text = element_blank(),
      plot.margin = margin(25, 25, 10, 25),
      panel.grid.major = element_blank(),    #strip major gridlines
      panel.grid.minor = element_blank(),    #strip minor gridlines
      axis.ticks = element_blank(),          #strip axis ticks
      
      # Texto
      plot.title.position = 'plot',
      plot.title = element_text( 
        #family = font,            
        size = 20,                
        face = 'bold',            
        hjust = 0,                # Alineamiento a la izquierda
        vjust = 2),               # Elevo un toque
      
      plot.subtitle = element_text(
        #family = font,            
        size = 14),                
      
      plot.caption.position = 'plot',
      plot.caption = element_text(
        #family = font,            
        size = 9,                 
        hjust = 1),               
      
      axis.title = element_text(  
        #family = font,            
        size = 10),    
      
      # Leyenda
      
      legend.position = 'plot'
      
      # axis.text = element_text(   
      #   #family = font,            
      #   size = 9),                
      # 
      # axis.text.x = element_text( 
      #   margin=margin(5, b = 10))
      
    )
}



#                  Algunos seteos opcionales                  ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Leyenda
# guides(color = guide_colorbar(title.position = 'top', title.hjust = .5,
#                               barwidth = unit(20, 'lines'), barheight = unit(.5, 'lines')))


### Ejes
# coord_cartesian(expand = FALSE, clip = 'off')


### Bandera Mexicana
png <- magick::image_read("img/bandera_mex3.jpg")
img <- grid::rasterGrob(png, interpolate = TRUE)
# annotation_custom(img, ymin = 22, ymax = 31, xmin = 55, xmax = 65.5)

#                        Colores México                       ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mex_colores <- function(...) {
  
  ### Lista de colores de la dnmye
  colores <- c(
    `verde`  = "#006341",
    `blacno` = "#FFFFFF",
    `rojo`   = "#C8102E",
    `marron` = "#B9975B")
  
  cols <- c(...)
  
  return(unname(colores[cols]))
  
}



#                      Paletas de colores                     ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mex_paletas <- function(palette = "tricolor", reverse = FALSE, ...) {
  
  ### Paleta de colores
  paletas <- list(
    
    `tricolor`  = c(mex_colores("verde"), mex_colores("blanco"), mex_colores("rojo")),
    `cuatricolor` = c(mex_colores("verde"), mex_colores("blanco"), mex_colores("rojo"), mex_colores("marron")))
  
  pal <- paletas[[palette]]
  
  if (reverse) pal <- rev(pal)
  
  grDevices::colorRampPalette(pal, ...)
}





#                    Tabulados univariados                    ~~~ ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

tabulado_x1 <- function(base, x) {
  
  base %>% 
    eph::calculate_tabulates(x = x, 
                             weights = "fac_viv",
                             add.totals = "row") %>% 
    dplyr::bind_cols(b_total %>% 
                       eph::calculate_tabulates(x, 
                                                weights = "fac_viv", add.percentage = "col", add.totals = "row") %>% 
                       dplyr::select(Porcentaje = Freq)) %>% 
    dplyr::mutate(
      Porcentaje = paste0(format(as.numeric(Porcentaje), decimal.mark = ","), "%"),
      Freq = format(Freq, big.mark = ".", decimal.mark = ","))
  
}