library(tidyverse)
library(ggtext)
library(showtext)
library(scales)
library(sf)
sf_use_s2(FALSE)
library(sfheaders)
library(rnaturalearth)
library(cshapes)
library(grafify)
library(magrittr)
target_crs="+proj=eqearth +lon_0=-60 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
font_add_google(name = "Averia Serif Libre", family = "Averia Serif Libre")
font_add_google(name = "Old Standard TT", family = "Old Standard TT")
font_add_google(name = "Holtwood One SC", family = "Holtwood One SC")
font_add_google(name = "Fondamento", family = "Fondamento")
showtext_auto()
showtext_opts(dpi = 300)
theme_set(
  theme_void() +
    theme(
      text = element_text(family = "Averia Serif Libre", 
                          color = "midnightblue"),
      plot.title = element_markdown(family = "Holtwood One SC", 
                                    color = "khaki4",
                                    margin = margin(5,5,5,5),
                                    size = rel(1)),
      plot.title.position = "plot",
      plot.subtitle = element_text(family = "Holtwood One SC", 
                                   color = "burlywood4",
                                   size = rel(0.8),
                                   margin = margin(0,5,5,5)),
      plot.caption = element_markdown(size = rel(0.5),
                                      hjust = 0),
      plot.background = element_rect(fill = "floralwhite",
                                     color = "floralwhite"),
      plot.margin = margin(l=10,r=10),
      axis.text = element_text(margin = margin(2,2,2,4)),
      axis.title.y = element_markdown(angle = 90, margin =
                                        margin(2,2,4,2)),
      axis.line = element_line(color = "chocolate4"),
      axis.ticks = element_line(color = "chocolate3"),
      axis.ticks.length = unit(1, "mm"),
      panel.background = element_rect(fill = "antiquewhite1",
                                      color = "NA")
    )
)

