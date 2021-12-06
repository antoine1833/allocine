

library(dplyr)
library(lubridate)
library(DT)
library(shinythemes)
library(plotly)

# Importer les données
data <- read.csv2("data/data_allocine.csv", stringsAsFactors =  FALSE, encoding = "latin1")

# Parser la date
data$date <- dmy(data$date)

# Extraire l'année
data$annee <- year(data$date)

# 6 Décembre 2021