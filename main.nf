#!/usr/bin/env nextflow

/* Print pipeline info */
log.info """
    =============================
    O N T   B A S E C A L L I N G
    =============================
    """
    .stripIndent()

process Basecalling {
    container 'ontresearch/dorado:latest'
    
    cpus 8
    memory '8 GB'
    time { 15.min * params.gigabases }
    clusterOptions '--gpus=T4:1'

    tag "Dorado on $params.name"

    publishDir params.outdir, mode: 'copy'

    input:
    path(params.data)

    output:
    path "calls.bam"

    script:
    """
    dorado basecaller $params.model $params.data > calls.bam
    """
}

workflow {
    Basecalling(params.data)
}