# MAXENT SCRIPT FUNCTIONS
# AUTHOR: Tobias Müller
# DATE: 2022/11/17
# GOETHE UNIVERSITY FRANKFURT

require(dismo)
require(rJava)

maxent_resolve <- function(ASC_PATH){
  
  maxent() # Is maxent working?
  
  fnames <- list.files(path=ASC_PATH, 
                       pattern = ".asc$", full.names = TRUE)
  
  
  # create a Rasterstack of our Predictors
  predictors <- stack(fnames)
  
  # load in our occurences
  # we can replace the paste in the row below with a function variable
  occurence <- paste("./output/occurences.csv")
  occ <- read.csv(occurence)
  
  # OCC Data can only have 
  
  # remove first column
  if(ncol(occ) == 2){
    print("Occurence data has the right ncol")
  } else if (ncol(occ) >= 3){
    print("removing col 1 and 4")
    occ <- occ[,2:3]
  } else {
    print("ERROR: WRONG INPUT DATA (OCCURENCE)")
  }
  
  # We are gonna use 20% of the dataset as a testing sample
  fold <- kfold(occ, k=5)
  occtest <- occ[fold == 1, ]
  occtrain <- occ[fold != 1, ]
  
  # Model fitting
  
  me <- maxent(predictors, occtrain, 
               path = "./output/maxent_output/",
               args=c("responsecurves"))
  
  # This will open the Browser window for Maxent
  me
  
  print("Writing asc file...")
  r <- predict(me, predictors, progres='text',
               filename='./output/maxent_output/maxent_prediction.grd')
  
  r
  
  
}