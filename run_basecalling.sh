#!/usr/bin/env bash

eval "$(conda shell.bash hook)"
conda activate nextflow

nextflow run main.nf \
    -params-file params.json \
    -resume \
    -with-report \
    -with-timeline \
    -ansi-log false
