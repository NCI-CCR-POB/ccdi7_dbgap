#!/bin/bash
#SBATCH --partition=norm
#SBATCH --job-name=ccdi_h5
#SBATCH --ntasks=4
#SBATCH --mem=80g
#SBATCH --time=48:00:00
#SBATCH --gres=lscratch:200

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
	
	#### Check if the folder "02_PrimaryAnalysisOutput" exists
	if [ -d "$folder/02_PrimaryAnalysisOutput" ]; then
    	echo "Folder exists: $folder/02_PrimaryAnalysisOutput"
    	
    	# check if its sub-folder exists
    	if [ -d "$folder/02_PrimaryAnalysisOutput/01_SummaryHTMLs" ]; then
    		echo "Remove: $folder/02_PrimaryAnalysisOutput/01_SummaryHTMLs"
    		rm -rf "$folder/02_PrimaryAnalysisOutput/01_SummaryHTMLs"
    	fi
    	
    	# check if its sub-folder exists
    	if [ -d "$folder/02_PrimaryAnalysisOutput/02_LoupeCellBrowserFiles" ]; then
    		echo "Remove: $folder/02_PrimaryAnalysisOutput/02_LoupeCellBrowserFiles"
    		rm -rf "$folder/02_PrimaryAnalysisOutput/02_LoupeCellBrowserFiles"
    	fi
    	
    	# check if its sub-folder exists
    	if [ -d "$folder/02_PrimaryAnalysisOutput/03_FilteredMatricesH5" ]; then
    		echo "Keep: $folder/02_PrimaryAnalysisOutput/03_FilteredMatricesH5"
    		
    	fi
		
		# check if its sub-folder exists
    	if [ -d "$folder/02_PrimaryAnalysisOutput/04_RawMatricesH5" ]; then
    		echo "Remove: $folder/02_PrimaryAnalysisOutput/04_RawMatricesH5"
    		rm -rf "$folder/02_PrimaryAnalysisOutput/04_RawMatricesH5"
    	fi
    	
    	# check if its sub-folder exists
    	if [ -d "$folder/02_PrimaryAnalysisOutput/00_FullCellrangerOutputs" ]; then
    		echo "Look for spatial in next script. Do nothing here: $folder/02_PrimaryAnalysisOutput/00_FullCellrangerOutputs"
    	fi
    	
    	
    else
    	echo "$folder/02_PrimaryAnalysisOutput does not exist"
	fi
	
done