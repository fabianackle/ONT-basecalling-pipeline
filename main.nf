#!/usr/bin/env nextflow

process DORADO {
    container 'ontresearch/dorado:latest'

    tag "$params.name"

    publishDir params.outdir, mode: 'copy'

    input:
    path(datadir)

    output:
    path("${params.name}.bam"), emit:bam
    path("${params.name}_summary.tsv"), emit:stats

    script:
    """
    nvidia-smi > nvidia-smi.log
    dorado basecaller \
        ${params.model} ${datadir} \
        --kit-name $params.kit > ${params.name}.bam
    dorado summary ${params.name}.bam > ${params.name}_summary.tsv
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
    path("demux/*_summary.tsv"), emit:stats

    script:
    """
    mkdir demux
    dorado demux --no-classify --output-dir demux $basecalled

    for bam in ./demux/*.bam; do
        base=\$(basename "\$bam" .bam)
        dorado summary "\$bam" > "./demux/\${base}_summary.tsv"
    done
    """
}

workflow {
    log.info """
    ┌───────────────────────────────┐
    │ O N T   B A S E C A L L I N G │
    │ by Fabian Ackle               │  
    └───────────────────────────────┘
    """
    .stripIndent()
    
    data_ch = Channel.fromPath(params.datadir)
    DORADO(data_ch)
    DEMUX(DORADO.out.bam)
}