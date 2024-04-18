#!/bin/bash
#SBATCH --partition=norm
#SBATCH --job-name=ccdi2_metdata
#SBATCH --ntasks=4
#SBATCH --mem=80g
#SBATCH --time=48:00:00
#SBATCH --gres=lscratch:200

module load python
SCRIPTS="/data/CCRCCDI/rawdata/ccrccdi7/ccdi_clean/scripts"

python $SCRIPTS"/Helper_get_metadata_images.py"

echo "Python script done"