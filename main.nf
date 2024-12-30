#!/usr/bin/env nextflow

process Basecalling {
    container 'ontresearch/dorado:latest'

    tag "Dorado on $params.name"

    publishDir params.outdir, mode: 'copy'

    input:
    path(datadir)

    output:
    path "${params.name}.bam"

    script:
    """
    dorado basecaller ${params.model} ${datadir} > ${params.name}.ba
    """
}

workflow {
    log.info """
    =============================
    O N T   B A S E C A L L I N G
    =============================
    """
    .stripIndent()
    data_ch = Channel.fromPath(params.datadir)
    Basecalling(data_ch)
}