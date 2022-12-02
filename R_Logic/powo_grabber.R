### POWO GRABBER

library(kewr)
library(readr)

synonym_finder <- function(PATH){
  SPECIES <- read_lines(PATH) # read species txt
  
  PB_TAXA <- data.frame(TAXON_ID=rep(NA,length(SPECIES)),
                        FULL_NAME=rep(NA,length(SPECIES)),
                        FAMILY=rep(NA,length(SPECIES)),
                        SYNONYMS=rep(NA,length(SPECIES)))
  
  SYN_NAMES = c()
  
  for(i in 1:length(SPECIES)){
    id_var <- search_wcvp(SPECIES[i])
    syn_check <- lookup_wcvp(tidy(id_var)$id[1]) # Grab the ID for WCVP
    FULL_NAME <- paste(tidy(id_var)$name[1], tidy(id_var)$author[1])
    FAMILY <- tidy(id_var)$family
    X <- syn_check$name
    TAXON_ID <- paste0(substr(X, 1, 4), substr(sub("^\\S+\\s+", "", X), 1, 4))
    
    for(j in 1:length(syn_check$synonyms)){
      if(length(syn_check$synonyms) == 0){
        next
      }
      # need to fix this
      SYN_NAMES[j] <- paste(syn_check$synonyms[[j]]$name, syn_check$synonyms[[j]]$author)
    }
    
    PB_TAXA$TAXON_ID[i] <- tolower(TAXON_ID)
    PB_TAXA$FULL_NAME[i] <- FULL_NAME
    PB_TAXA$FAMILY[i] <- FAMILY
    PB_TAXA$SYNONYMS[i] <- paste(SYN_NAMES, collapse = "; ")
    
    rm(SYN_NAMES)
    SYN_NAMES = c()
    
    print(paste0("Done with ", SPECIES[i]))
    
  }
  
  return(PB_TAXA)
}
