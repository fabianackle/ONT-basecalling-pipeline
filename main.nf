#!/usr/bin/env nextflow

process Basecalling {
    cpus 8
    memory '8 GB'
    time { 15.min * params.gigabases }
    clusterOptions '--gpus=V100:1'

    tag "Dorado on $params.name"

    publishDir params.outdir, mode: 'copy'

    input:
    path(params.data)

    output:
    path "calls.bam"

    script:
    """
    singularity exec /data/$USER/dorado --nv dorado basecaller $params.model $params.data > calls.bam
    """
}

workflow {
    log.info """
    =============================
    O N T   B A S E C A L L I N G
    =============================
    """
    .stripIndent()
    Basecalling(params.data)
}