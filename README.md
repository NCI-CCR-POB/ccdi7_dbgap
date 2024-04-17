# Instructions on how to get rawdata ready for dbgap submission

#### Note : These scripts are meant work for data generated by the POB-CCDI sequencing lab.  

## Step 0: Start here
* SSH into biowulf cluster and Start an interactive node

  ```
  ssh user@biowulf.nih.gov
  sinteractive --mem=80g --cpus-per-task=2
  ```
  
* Establish a "base folder" . The example used here is `ccdi2_clean`
* Copy the entire rawdata into this base folder.
* IMPORTANT - Ensure that you are working on a copy of the data, and are NOT working on the master copy. As we start the following steps, the folders that are not rquired for dbgap submission will be DELETED. 

## Here is a look at the original folder structure
Under the `ccdi2_clean` base folder, there are one or more sub-folders with the name `CS*` .Each CS sub-folder contains data from many captures, and every capture has a sub-folder with the name `Seq*`. Within the capture folder, there is a folder for every sample denoted by a `CCDIid` or `SCAFid`.  
    
 <img width="407" alt="Screenshot 2024-04-17 at 11 36 43 AM" src="https://github.com/NCI-CCR-POB/ccdi7_dbgap/assets/1800604/37109155-1eb8-4e35-83b3-6b0136eb29ac">



## Step: Untar fastq files
* Script name: 01_script_untar.sh. 
* Note: Open this script, and change the path for the “base folder” . This script will untar and retain the fastq files. Folders not required for dbgap submission are deleted. 
* How to Run:
  `bash 01_script_untar.sh > log01.txt`
   or `sbatch <scriptname> `

## Step: Extract meta data file
* Script: 03_call_rmarkdown.sh 
* Note: Run script only after you change base folder path as needed
* How to run: `bash 03_call_rmarkdown.sh > log03.txt` or `sbatch <scriptname>`
* This script internally calls Helper_GetMetaDataFastq.Rmd and generates metadata_1.tsv file that contains the following information
  - Full File path -  This information can be used to extract additional information if needed
      - You can write additional code to split the filepath using delimiters to extract the relevant information. Can also use excel to perform this delimiter based split. 
      - Examples: extracting the CCDI or SCAF name, extract the capture name (Seq*) to use as `library id`.
  - A unique identifier `file id` is generated
  - md5 check sum
  - file size

## Step: Get filtered H5 files
* Script: 04_get_h5_files.sh 
* Note: Run script only after you change base folder path as needed
* This script extracts the filtered h5 files from the `00_CellRangerOutput` and moves it directly under `02_PrimaryAnalysisOutput`. Folders/files not required for dbgap submission are deleted. 
* How to run: `bash 04_get_h5_files.sh > log04.txt` or `sbatch <scriptname>`

## Step: For spatial data only - get the cytassit tiff images
* Script: 05_get_spatial.sh
* Summary: this script extracts the spatial images from the `00_CellRangerOutput` by appending the SCAF/CCDI number and moving them to a folder called “spatial” . This script internally calls Helper_clean_spatial.py to get the right file names for the images. Folders/files not required for dbgap submission are deleted. 
* Note: Run script only after you change base folder path as needed in the code
* How to run: `bash 05_get_spatial.sh > log05.txt` or `sbatch <scriptname>`

## Step: Get metadata for the filtered h5 files
* Script: 08_call_helper_h5.sh
* Summary: Call helper script t Helper_get_metadata_h5.py to get the meta data for filtered h5 files
* Note: Run script only after you change base folder path as needed
* How to run: `bash 08_call_helper_h5.sh > log08.txt` or `sbatch <scriptname>`

## Step: For spatial data only - Get metadata for the spatial image files
* Script: 09_call_helper_images.sh 
* Summary: Call helper script Helper_get_metadata_images.py to get the meta data for the images
* Note: Run script only after you change base folder path as needed
* How to run: `bash 09_call_helper_images.sh > log09.txt` or `sbatch <scriptname>`

## Final step: sanity check
* By this point any folders not needed for dbgap submission would have been removed.
* Perform sanity check and remove any extra files missed not needed for submission. Example: file_list.txt, md5sum.txt. CS*_combined_summary_metrics.xlsx

## Here is a look at the cleaned folder structure

<img width="484" alt="Screenshot 2024-04-17 at 11 44 21 AM" src="https://github.com/NCI-CCR-POB/ccdi7_dbgap/assets/1800604/cd9e33ca-51ea-4e7a-87da-d256609af524">










