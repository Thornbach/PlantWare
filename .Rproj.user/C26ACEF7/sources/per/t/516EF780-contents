# MAIN FUNCTION FOR PLANTWARE
#----------------------------------------------------#
# REQUIRED PACKAGES
#----------------------------------------------------#

#----------------------------------------------------#
# PlantWare interaction
#----------------------------------------------------#

# Load in args from PLANTWARE

args = commandArgs(trailingOnly=TRUE)

# Check if PlantWare is working correctly

if (length(args) == 0){
  stop("Something went horribly wrong!")
}else{
  "PlantWare Input is getting processed!"
}

# safe args into variables

ASC_PATH <- args[1] # asc files path
SPECIES <- args[2] # species path
MODE <- args[3] # declare the Workmode

# We need some kind of logic to determine if DAF or MAF are empty

#-----------------------------------------------------------------------------#
# Source R Logics depending on Workmode
#-----------------------------------------------------------------------------#
print("----------------")
print("SOURCING LOGIC")
print("----------------")


if(MODE == "all"){
  
  # WCVP IS DOWN ATM? WTF?!?
  #source("./R_Logic/powo_grabber.R")
  #write.csv(synonym_finder(PATH=SPECIES), paste0("./output/all_plants/SYNONYMS.csv"))

  source("./R_Logic/occ_grabber.R")
  
  write.csv(gbif_handler(SPECIES), 
            file = "./output/occurences.csv",
            row.names = FALSE)
  
  # ADD MAXENT
  
  source("./R_Logic/maxent_calc.R")
  maxent_resolve(ASC_PATH = ASC_PATH)
  
} else if (MODE == "syn"){
  
  # WCVP IS DOWN ATM? WTF?!?
  #source("./R_Logic/powo_grabber.R")
  #write.csv(synonym_finder(PATH=SPECIES), paste0("./output/all_plants/SYNONYMS.csv"))
  
} else if (MODE == "occ"){
  
  source("./R_Logic/occ_grabber.R")
  
  write.csv(gbif_handler(SPECIES), 
            file = "./output/occurences.csv",
            row.names = FALSE)
  
  
} else if (MODE == "max"){
  
  source("./R_Logic/maxent_calc.R")
  maxent_resolve(ASC_PATH = ASC_PATH)
  
} else {
  print("ERROR: ABORT PROCEDURE") # This point shouldn't be reachable
}
