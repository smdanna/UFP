# Ubicación familiar promedio
# Sofia Danna
# 2022-07-07

# Usando <https://cran.r-project.org/web/packages/tidygeocoder/readme/README.html>
# Incorporar esto para mejor calcular <http://www.geomidpoint.com/calculation.html>

# install.packages("dplyr")
# install.packages("tidygeocoder")

library(dplyr)
library(ggplot2)
library(readxl)
library(tidygeocoder)

#### Importar datos ----

# ubicaciones <- tibble::tribble(
# ~name,                  ~addr,
# "White House",          "1600 Pennsylvania Ave NW, Washington, DC",
# "Transamerica Pyramid", "600 Montgomery St, San Francisco, CA 94111",     
# "Willis Tower",         "233 S Wacker Dr, Chicago, IL 60606"                                  
# )

# ubicaciones <- read.csv("~/Dropbox/gioia/ufp/ubicaciones.csv")

ubicaciones <- read_excel("~/Dropbox/gioia/ufp/ubicaciones.xlsx")
View(ubicaciones) 

#### Geocode ----

lat_longs <- ubicaciones %>%
  geocode(ubic, method = 'osm', lat = latitude , long = longitude)

head(lat_longs)

####  Plot ubicaciones individuales ----

ggplot(lat_longs, aes(longitude, latitude), color = "grey99") +
  borders("state") + geom_point() +
  ggrepel::geom_label_repel(aes(label = noche)) +
  theme_void()

#### Calcular coordenadas promedio ----

lat_longs <- lat_longs %>% add_row(fecha = as.Date("2022-07-07"), noche = "promedio", latitude = mean(lat_longs$latitude), longitude = mean(lat_longs$longitude))

#### Geocode coordenadas promedio ----

reverse <- lat_longs %>%
  reverse_geocode(lat = latitude, long = longitude, method = 'osm',
                  address = address_found, full_results = TRUE) %>%
  select(-ubic, -licence)

head(reverse)
tail(reverse)

#### Plot ubicación promedio ----

ggplot(lat_longs, aes(longitude, latitude), color = "grey99") +
  borders("state") + geom_point() +
  ggrepel::geom_label_repel(aes(label = noche)) +
  theme_void()

#theme_classic() gives labelled axes
#theme_minimal() gives labelled axes and grid
