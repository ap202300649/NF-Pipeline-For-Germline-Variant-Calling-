process ALIGNMENT {
    publishDir "results/bam", mode: 'copy'
    tag "$sample_id"

    input:
    tuple val(sample_id), path(read)
    path ref_bundle

    output:
    tuple val(sample_id), path("${sample_id}.sam")

    script:
    """
    REF=\$(ls *.fasta)

    bwa mem -t ${task.cpus} \$REF ${read} > ${sample_id}.sam
    """
}
