#!/usr/bin/env nextflow
workflow {
    log.info(
        """
        ┌───────────────────────────────┐
        │ O N T   B A S E C A L L I N G │
        │ by Fabian Ackle               │  
        └───────────────────────────────┘
        """.stripIndent()
    )

    data_ch = channel.fromPath(params.datadir)
    DORADO(data_ch)
    DEMUX(DORADO.out.bam)
}


process DORADO {
    label "dorado"
    tag "${params.name}"

    publishDir params.outdir, mode: 'copy'

    input:
    path datadir

    output:
    path ("${params.name}.bam"), emit: bam

    script:
    """
    nvidia-smi > nvidia-smi.log
    dorado -vv > version.log
    
    dorado basecaller \
        ${params.model} ${datadir} \
        --kit-name ${params.kit} \
        --barcode-both-ends \
        --emit-moves \
        > ${params.name}.bam
    """
}

process DEMUX {
    label "dorado"
    tag "${params.name}"

    publishDir params.outdir, mode: 'copy'

    input:
    path basecalled

    output:
    path ("demux"), emit: bam

    script:
    """
    mkdir demux
    dorado demux --no-classify --output-dir demux ${basecalled}
    """
}
