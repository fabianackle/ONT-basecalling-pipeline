#!/usr/bin/env nextflow

process Basecalling {
    container 'ontresearch/dorado:latest'

    cpus 8
    memory '16 GB'
    time { 60.min * params.gigabases }
    clusterOptions '--gpus=V100:2'

    tag "Dorado on $params.name"

    publishDir params.outdir, mode: 'copy'

    input:
    path(datadir)

    output:
    path "calls.bam"

    script:
    """
    dorado basecaller ${params.model} ${datadir} > calls.bam
    """
}

workflow {
    log.info """
    =============================
    O N T   B A S E C A L L I N G
    =============================
    """
    .stripIndent()
    Basecalling(params.datadir)
}