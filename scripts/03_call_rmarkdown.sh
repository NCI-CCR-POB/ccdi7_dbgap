#!/bin/bash
#SBATCH --partition=norm
#SBATCH --job-name=ccdi_metdata
#SBATCH --ntasks=4
#SBATCH --mem=80g
#SBATCH --time=48:00:00
#SBATCH --gres=lscratch:200

module load R

Rscript -e "rmarkdown::render('Helper_GetMetaDataFastq.Rmd')"

