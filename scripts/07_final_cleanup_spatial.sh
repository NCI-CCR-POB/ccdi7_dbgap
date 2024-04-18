#!/bin/bash

## Settings
basefolder="/data/CCRCCDI/rawdata/ccrccdi7/ccdi_clean/"
echo "basefolder: $basefolder"

# find number of CS folders. for each CS folder,
# remove 00 and 02 folders if they exist

# Count the number of sub-folders starting with "CS" in the current directory
cd $basefolder
#countcs=$(find . -maxdepth 1 -type d -name 'CS*' | wc -l)
foldercs=$(find . -maxdepth 1 -type d -name 'CS*')

# Print the count
echo "Number of sub-folders starting with 'CS': $foldercs"

# Loop through each folder
for folder in $foldercs; do
    echo "Processing folder: $folder"
	
	# count number of files in 03/Filteredmatrix file
	# if exists, count number of files in spatial files
	# the number of spatial files is twice the number of 03_filteredmatrix
	
	# check if its sub-folder exists
    if [ -d "$folder/02_PrimaryAnalysisOutput/03_FilteredMatricesH5" ]; then
    	echo "Count: $folder/02_PrimaryAnalysisOutput/03_FilteredMatricesH5"
    	countfilteredh5=$(find "$folder/02_PrimaryAnalysisOutput/03_FilteredMatricesH5" -maxdepth 1 -type f -name '*_filtered_*.h5' | wc -l)
    	echo "Count filteredh5 files: $countfilteredh5"
    		
    fi 
    
    # check if its sub-folder exists
    if [ -d "$folder/02_PrimaryAnalysisOutput/spatial" ]; then
    	echo "Count: $folder/02_PrimaryAnalysisOutput/spatial"
    	countspatial=$(find "$folder/02_PrimaryAnalysisOutput/spatial" -maxdepth 1 -type f -name '*.tiff' | wc -l)
    	
    	echo "Count countspatial tiff files: $countspatial"
		
		if [ $countfilteredh5 -eq $countspatial ]; then
			echo "All spatial files moved. Safe to remove 00_FullCellrangerOutputs"
			rm -rf "$folder/02_PrimaryAnalysisOutput/00_FullCellrangerOutputs"
			echo "00_FullCellrangerOutputs removed"
		
		else
			echo "All spatial files NOT MOVED. Do NOT remove 00_FullCellrangerOutputs"
		fi
		
	else
		echo "spatial folder does not exist"
	fi
    
done