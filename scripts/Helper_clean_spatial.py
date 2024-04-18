### Python script - to append SCAF or CCDI name to the image files, and then move those file to the "spatial" folder. So all images will be in one folder. After that the entire 00_FullCellRanger output  can be removed.

import sys
import os
import glob
import shutil

print("Script name:",sys.argv[0]) # prints python_script.py
print("Spatial folder:",sys.argv[1]) # prints spatial folder
print("Output folder:",sys.argv[2]) # prints Output

# save into variables
spatialf=sys.argv[1]
outputf=sys.argv[2]

#extract the SCAF or CCDI name
temp1=spatialf.split("/")
scaf_ccdi_name=temp1[4]
print("SCAF or CCDI name:",scaf_ccdi_name) # must be the SCAF of the CCDI name
	
# Find files matching the pattern within the directory
filesCyt=glob.glob(os.path.join(spatialf,"*cytassist_image.tiff"))

filesHighres=glob.glob(os.path.join(spatialf,"*tissue_hires_image.png"))

print("Number of Cytassist files:",len(filesCyt))
print("Number of High rest image files:",len(filesHighres))

# Check if num_files is zero and print an error message if true
if len(filesCyt) == 0 or len(filesHighres) == 0:
    print("Error: No files with '*cytassist_image.tiff' or '*tissue_hires_image.png' found in:", spatialf)

else:
	
	filenamesCyt=filesCyt[0]
	print("filenamesCyt:",filenamesCyt)

	filenamesHighres=filesHighres[0]
	print("filenamesHighres:",filenamesHighres)

	# Concatenate the components to form the new file path
	newcytfile = outputf + "/" + scaf_ccdi_name + "_cytassist_image.tiff"
	newhighresfile=outputf + "/" + scaf_ccdi_name + "_tissue_hires_image.png"
	
	print("newcytfile:",newcytfile)
	print("newhighresfile:",newhighresfile)
	
	
	# Move the file from the source to the destination
	os.rename(filenamesCyt, newcytfile)
	# Move the file from the source to the destination
	os.rename(filenamesHighres, newhighresfile)
	
	print("All done:", spatialf)
	