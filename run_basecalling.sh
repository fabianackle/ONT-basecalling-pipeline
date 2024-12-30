#!/usr/bin/env bash

eval "$(conda shell.bash hook)"

nextflow run main.nf \
    -profile standard \
    -params-file params.json \
    -resume \
    -with-report \
    -with-timeline \
    -ansi-log false
