#!/bin/bash

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
	
	#countfastq=$(find . -maxdepth 3 -type d -name "$folder/*.fastq.gz" | wc -l)
	 
	countfastq=$(find . -type f -name "*.fastq.gz" | wc -l)
	counttar=$(find . -type f -name "*.tar" | wc -l)
	echo "There are $countfastq fastq.gz files"
	echo "There are $counttar tar files"
	
	if [[ $counttar -ge 1 ]]; then
    		
    	#### Check if the folder "00_RawSequencingData" exists
		if [ -d "$folder/00_RawSequencingData" ]; then
    		echo "Deleting folder: $folder/00_RawSequencingData"
    		rm -rf "$folder/00_RawSequencingData"
    	else
    		echo "$folder/00_RawSequencingData does not exist"
		fi
	
		#### Check if the folder "02_PrimaryAnalysisOutput" exists
		if [ -d "$folder/02_PrimaryAnalysisOutput" ]; then
    		echo "Do nothing to this folder: $folder/02_PrimaryAnalysisOutput"
    		#rm -rf "$folder/02_PrimaryAnalysisOutput"
    	else
    		echo "$folder/02_PrimaryAnalysisOutput does not exist"
		fi
	
		#### Check if the folder "01_PrimaryAnalysisOutput" exists
		if [ -d "$folder/01_DemultiplexedFastqs" ]; then
			echo "$folder/01_DemultiplexedFastqs exists"
			echo "Script executed from: ${PWD}"
		
			tarfiles=$(find "$folder" -mindepth 1 -maxdepth 3 -type f -name '*.tar')
			echo $tarfiles
		
			#Untar all .tar files in the directory
			for file in $tarfiles; do
    			echo "Untarring: $file"
    			tar -xvf "$file" -C "$(dirname "$file")" && rm "$file" 
    			
			done
			echo "All files untar complete: $folder"
		fi
		
	else
		echo "There are no .tar files. Exit"
		break
	fi 
	
done
    	
	
    
    