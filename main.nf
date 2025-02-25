#!/usr/bin/env nextflow

process DORADO {
    container 'ontresearch/dorado:latest'

    tag "$params.name"

    publishDir params.outdir, mode: 'copy'

    input:
    path(datadir)

    output:
    path("${params.name}.bam"), emit:bam

    script:
    """
    nvidia-smi > nvidia-smi.log
    dorado basecaller ${params.model} ${datadir} > ${params.name}.bam
    """
}

process DEMUX {
    container 'ontresearch/dorado:latest'

    tag "$params.name"

    publishDir params.outdir, mode: 'copy'

    input:
    path(basecalled)

    output:
    path("demux/*.bam"), emit:bam

    script:
    """
    mkdir demux
    dorado demux --kit-name $params.kit --output-dir demux $basecalled
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
    DORADO(data_ch)
    DEMUX(DORADO.out.bam)
}