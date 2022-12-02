#!/bin/bash

VERSION="0.6"
source ./bin/cols.sh # source the colorcode

############################################################
# Startscreen                                              #
############################################################

# ! TBA
## TODO: GitHub Data, maybe an intelligent system for checking
## TODO: Species text files

cat "./bin/logo"
echo
echo -e "${L_PURPLE}Author:${NC} Tobias Müller"
echo -e "${L_PURPLE}MailTo:${NC} ToMu94@outlook.de"
echo -e "${L_PURPLE}Affiliation:${NC} Goethe University Frankfurt"
echo "Paleobiology and Environment"


############################################################
# Help                                                     #
############################################################

# Help function to show which flags are usable and what they are doing
helper()
{
   # Display Help
   echo "PlantWare - a tool for reproducability regarding ethnobotany"
   echo
   echo "default: ASC_PATH= ./data/raster"
   echo "default DAFSPECIES_PATH= ./data/SPECIES.txt"
   echo
   echo "Syntax: [-d|-a|-h|-v]"
   echo -e "${GREEN}options${NC}:"
   echo "d     change directory of SPECIES"
   echo "a     change directory of .asc files"
   echo "h     display this help screen"
   echo "v     display version number"
   echo
}

############################################################
# Directory checker                                        #
############################################################

#  This function is checking for files and gives user the choice
# to overwrite the default settings with the findings
directory_finder()
{
    # Check for output directories

    echo "----------------------------------------"
    echo "Checking for output directories..."
    echo "----------------------------------------"
    echo

    if [ -d "./output" ]
        then
            echo
            echo "Directory ./output/ exists"
        else
            echo
            echo "Creating output directory"
            mkdir output
            cd output
            mkdir all_plants
            mkdir all_plants/maxent

            mkdir all_plants/maxent/PER_SPECIES
            mkdir all_plants/maxent/SUM

            cd ..
    fi

    # Check if data folder exists

    if [ -d "./data" ]
        then
            echo
            echo "Data folder exists"
        else
            mkdir data
            echo
            echo "Please put your input data into the ${GREEN}data${NC} folder"
            exit
    fi

    # Find variables    
    FOUND_ASC=$(find . -name *.asc -printf '%h\n' | uniq)
    FOUND_SPECIES=$(find . -name *.txt | uniq)


    # Print out found paths
    echo
    echo "Found the following directories for the necessary data: "
    echo "Raster asc: $FOUND_ASC"
    echo "SPECIES: $FOUND_SPECIES"
    echo
    echo "Are those paths correct?"
    echo "type [y/n] and press Enter"
    echo

    read -p "[y/n]: " userprompt

    if [[ $userprompt == *"y"* ]]; then
        # Overwrite Variables

        SPECIES_PATH=$FOUND_SPECIES
        ASC_PATH=$FOUND_ASC

    elif [[ $userprompt == *"n"* ]]; then
        # End the program and show the help
        echo "Please input your paths with the -d -m -a flags"
        exit
    else
        echo -e "${RED}ERROR${NC}: Please input 'y' or 'n' and then press Enter!"
        exit
    fi

}

ASC_PATH="./data/raster"
SPECIES_PATH="./data/SPECIES.txt"

# If no arguments were used search for directoriesn

if [ $# -eq 0 ]
    then
        directory_finder # call directory finder function
fi


############################################################
# Main                                                     #
############################################################

# allow the user to change directory of the different datafiles
# : before flag - no input required
# : after flag - input required

while getopts ':vd:m:a::h' OPTION; do
    case "$OPTION" in
        d) # change directory of shp files
            SPECIES_PATH=$OPTARG
            echo "changed directory of .shp files to $SPECIES_PATH"
            ;;
        a) # change directory of species txt file
            ASC_PATH=$OPTARG
            echo "changed directory of species file to $ASC_PATH"
            ;;
        h) # display Help Function
            helper
            exit
            ;;
        v) # display version number
            echo "Version: $VERSION"
            exit
            ;;
        \?) # Invalid Option
            echo -e "${RED} Error${NC}: Invalid option"
            exit
            ;;
    esac
done
shift "$((OPTIND -1))"

############################################################
# User Input                                               #
############################################################

echo "Do you wish to proceed with the following input?"
echo
echo "ASC Files:    $ASC_PATH"
echo "Species:      $SPECIES_PATH"
echo
echo "${L_PURPLE}type [all/syn/occ/max/no] and press Enter${NC}"
echo "all = do all modes of the program (synonyms, occurences, maxent)"
echo "syn = just do synonym grabber"
echo "occ = just the occurences"
echo "max = just MAXENT"
echo

read -p "[all/syn/occ/max/no]: " userprompt

############################################################
# Transfer Arguments to R Logic                            #
############################################################

# TODO: DRY principles are not used here! I dont want to repeat
# TODO: myself. Looks not professional.

if [[ $userprompt == *"all"* ]]; then
    # R Integration
    echo  "------------------"
    echo "initialize main.R"
    echo  "------------------"
    echo "Loading R_Logic"
    sleep 3s # wait 3 seconds
    MODE="all"
    # Run Script with variables
    Rscript ./R_Logic/main.R "$ASC_PATH" "$SPECIES_PATH" "$MODE"
elif [[ $userprompt == *"syn"* ]]; then
 # R Integration
    echo  "------------------"
    echo "initialize main.R"
    echo  "------------------"
    echo "Loading R_Logic"
    sleep 3s # wait 3 seconds
    MODE="syn"
    # Run Script with variables
    Rscript ./R_Logic/main.R "$ASC_PATH" "$SPECIES_PATH" "$MODE"
elif [[ $userprompt == *"occ"* ]]; then
 # R Integration
    echo  "------------------"
    echo "initialize main.R"
    echo  "------------------"
    echo "Loading R_Logic"
    sleep 3s # wait 3 seconds
    MODE="occ"
    # Run Script with variables
    Rscript ./R_Logic/main.R "$ASC_PATH" "$SPECIES_PATH" "$MODE"
elif [[ $userprompt == *"max"* ]]; then
 # R Integration
    echo  "------------------"
    echo "initialize main.R"
    echo  "------------------"
    echo "Loading R_Logic"
    sleep 3s # wait 3 seconds
    MODE="max"
    # Run Script with variables
    Rscript ./R_Logic/main.R "$ASC_PATH" "$SPECIES_PATH" "$MODE"
elif [[ $userprompt == *"no"* ]]; then
    # End the program and show the help
    echo "Showing the help menu for command inputs:"
    echo "#----------------------------------------#"
    helper
else
    echo -e "${RED}ERROR:${NC} Please input [all/syn/occ/max/no] and then press Enter!"
fi

