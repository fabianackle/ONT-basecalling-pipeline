#!/usr/bin/env bash
#SBATCH --cpus-per-task=2
#SBATCH --mem=4096
#SBATCH --time=2-00:00:00
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
    -params-file $PARAMS_FILE \
    -with-report \
    -with-timeline \
    -ansi-log false
