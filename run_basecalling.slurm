#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem=2048
#SBATCH --time=1-00:00:00
#SBATCH --output=log/main_%j
##SBATCH --mail-user=user@example.com
##SBATCH --mail-type=BEGIN,END 

module load mamba
module load singularityce

eval "$(conda shell.bash hook)"
conda activate nextflow

set -u

PARAMS_FILE="$1"

nextflow run main.nf \
    -params-file PARAMS_FILE.json \
    -with-report \
    -with-timeline \
    -ansi-log false
