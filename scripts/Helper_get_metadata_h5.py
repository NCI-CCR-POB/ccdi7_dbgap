### Python script - get meta data for the filtered h5 files

import sys
import os
import glob
import shutil
import pandas as pd
import re
import hashlib
import pathlib
import numpy as np


## settings 
basefolder="/data/CCRCCDI/rawdata/ccrccdi2/ccdi2_clean"
outFolder="/data/CCRCCDI/rawdata/ccrccdi2/ccdi2_clean"
outFileName="metadata_filtered_h5.tsv"
subfoldername="03_FilteredMatricesH5"

##### Function definition to save the metadata - item name, file id, size, md5check sum
# append values to a datafram and export it into a TSV file
def funcGetMetadata(items1, itemfolderpath, outFolder, outFileName, cs_id):
	
	# Declare an empty DataFrame
	tempdf = pd.DataFrame()
	finaldf = pd.DataFrame()
	
	# loop for every  file
	for item in items1:
		print("One h5 file:", item)
		
		#get the ccdi/scaf id
		sampleid = item.replace("_filtered_feature_bc_matrix.h5", "")
		print("sampleid:", sampleid)
		
		fullpath=os.path.join(itemfolderpath, item)
		### create a file id
		temp1 = os.path.join(cs_id, item)
		#print("Fileid: ", fileid)
		delimiter = "."
		#Replace "/" with "."
		fileid = re.sub("/", ".", temp1)
		print("fileid:", fileid)
		
		### get file size
		fileize=os.path.getsize(fullpath)
		print("filesize:", fileize)
		md5checksum=hashlib.md5(pathlib.Path(fullpath).read_bytes()).hexdigest()
		print("md5checksum:", md5checksum)
		
		# cbind to df
		# Assuming name, full_path, id3, file_size, and md5_checksum are lists or arrays
		data = {'sampleid': [sampleid], 
				'Filename': [item], 
				'Fileid': [fileid], 
				'File_Size': [fileize], 
				'MD5_Checksum': [md5checksum],
				'libraryid': [sampleid]}
		tempdf = pd.DataFrame(data)

		# Append tempDF to finalDF - same as rbind
		finaldf = pd.concat([finaldf, tempdf], ignore_index=True)
		
	#outside loop - export data
	newOutFilename=cs_id + "_"+ outFileName
	outfilepattern = os.path.join(outFolder, newOutFilename)
	finaldf.to_csv(outfilepattern, sep='\t', index=False, quoting=None)


#### START OF THE SCRIPT

# Get the list of all items (files and directories) in the current directory
items = os.listdir(basefolder)
print(items)

# Get a list of all folder names in the path
folders = [folder for folder in os.listdir(basefolder) if os.path.isdir(os.path.join(basefolder, folder))]
# Filter the folder names to keep only those starting with "CS"
cs_subfolders = [folder for folder in folders if folder.startswith("CS")]

print(cs_subfolders)
# Count the number of sub-folders starting with "CS"
num_cs_subfolders = len(cs_subfolders)

print("Number of sub-folders starting with 'CS':", num_cs_subfolders)

# Change current working directory to basefolder
os.chdir(basefolder)  

for folder in cs_subfolders:
	print("folder path: ", folder)
	
	cs_id=folder
	
	#save the path of the h5 folder
	h5folderpath=os.path.join(basefolder, 
			folder,
			"02_PrimaryAnalysisOutput",
			subfoldername)
	print("h5 folder path:", h5folderpath )
	h5items = os.listdir(h5folderpath)
	
	print("How many h5 files: ", len(h5items) )
	print("These are the h5 files: ", h5items)
	
	#call function
	funcGetMetadata(h5items, h5folderpath, outFolder, outFileName, cs_id)
	

	

