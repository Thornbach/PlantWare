# GBIF GRABBI GRAB

library("rgbif")
library(data.table)
library(dplyr)
library(tidyverse)
library(sf) # sf stands for "Simple Features", spatial data in R
library(svMisc)

### Load in Species data

nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

gbif_handler <- function(PATH){

  SPECIES_CLEANED <- read_lines(file = PATH)
  
  DATA_LIST <- list()
  
  for(i in 1:length(SPECIES_CLEANED)){
    
    TEMP_FRAME <- occ_search(scientificName = SPECIES_CLEANED[i], country = "ET")
    
    species_x <- occ_data(scientificName = SPECIES_CLEANED[i], hasCoordinate = TRUE, country = "ET")
    TEMP_FRAME <- occ_data(taxonKey = species_x$data$taxonKey[1], hasCoordinate = TRUE, country = "ET")
    
    
    DATA_LIST[[SPECIES_CLEANED[i]]]$SPECIES <- as.list(TEMP_FRAME$data$species)
    DATA_LIST[[SPECIES_CLEANED[i]]]$LONGITUDE <- as.list(TEMP_FRAME$data$decimalLongitude)
    DATA_LIST[[SPECIES_CLEANED[i]]]$LATITUDE <- as.list(TEMP_FRAME$data$decimalLatitude)
    
    if("coordinateUncertaintyInMeters" %in% names(TEMP_FRAME$data)){
      DATA_LIST[[SPECIES_CLEANED[i]]]$COORDUNC <- as.list(TEMP_FRAME$data$coordinateUncertaintyInMeters)
    } else {
      myList <- vector("list", length(DATA_LIST[[i]]$SPECIES))
      DATA_LIST[[SPECIES_CLEANED[i]]]$COORDUNC <- myList
    }
    
    JOTARO_KUJO <- rbindlist(DATA_LIST)
    
    # TEXT BAR + PERECENTAGE

    progress(i * (100 / length(SPECIES_CLEANED)))
  }
  
  JOTARO_KUJO$COORDUNC <- nullToNA(JOTARO_KUJO$COORDUNC)
  
  DIO_BRANDO <- data.frame(matrix(nrow =length(unlist(JOTARO_KUJO$SPECIES)), ncol = 4))
  
  DIO_BRANDO[1] <- unlist(JOTARO_KUJO$SPECIES)
  DIO_BRANDO[3] <- as.numeric(unlist(JOTARO_KUJO$LATITUDE))
  DIO_BRANDO[2] <- as.numeric(unlist(JOTARO_KUJO$LONGITUDE))
  DIO_BRANDO[4] <- as.numeric(unlist(JOTARO_KUJO$COORDUNC))
  
  colnames(DIO_BRANDO) <- c("SPECIES", "LONGITUDE", "LATITUDE", "COORDUNC")
  
  DIO_BRANDO$COORDUNC[is.na(DIO_BRANDO$COORDUNC)] <- 0
  
  DIO_BRANDO <- DIO_BRANDO %>% filter(!is.na(LONGITUDE), !is.na(LATITUDE)) %>%
    filter(LONGITUDE > 3, LATITUDE < 14, COORDUNC <= 1000)
  
  
  return(DIO_BRANDO)
}