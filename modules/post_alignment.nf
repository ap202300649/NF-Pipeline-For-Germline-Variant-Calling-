process POST_ALIGNMENT {

    tag "$sample_id"

    input:
    tuple val(sample_id), path(sam)

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam")

    script:
    """
    samtools view -@ ${task.cpus} -bS ${sam} |
    samtools sort -@ ${task.cpus} -o ${sample_id}.sorted.bam
    """
}
