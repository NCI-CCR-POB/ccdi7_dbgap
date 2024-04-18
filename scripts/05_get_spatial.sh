#!/bin/bash


#### Script starts here
pythonscript="/data/CCRCCDI/rawdata/ccrccdi7/ccdi_clean/Helper_clean_spatial.py"
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
    	if [ -d "$folder/02_PrimaryAnalysisOutput/00_FullCellrangerOutputs" ]; then
    		SUBF="$folder/02_PrimaryAnalysisOutput/00_FullCellrangerOutputs/"
    		echo "Folder exists: $SUBF"
    		
    		countSubFolders=$(find $SUBF -type d -path "*/outs/spatial" | wc -l)
    		nameSubFolders=$(find "$SUBF" -maxdepth 3 -type d -path "*/outs/spatial")		
			
			echo "There are $countSubFolders spatial folders"
    		
    		# If there are at-least one spatial folder
    		if [[ $countSubFolders -ge 1 ]]; then
    			
    			# maybe call function
    			echo "here"
    			#make the clean output dir
    			SPATIALF="$folder/02_PrimaryAnalysisOutput/spatial"
    			mkdir $SPATIALF
    			
    			# Loop through each folder
				for f in $nameSubFolders; do
				
					echo "process subfolder:$f"
					echo "spatial :$SPATIALF"
					
					#call python script
					
					echo "call function here"
					module load python
					python $pythonscript $f $SPATIALF
				
    			done
    			
    			
    		else 
    			echo "There are no spatial folders"	
    		
    		fi
    		
    	fi
    	
    	
    else
    	echo "$folder/02_PrimaryAnalysisOutput does not exist"
	fi
	
done