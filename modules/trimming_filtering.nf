process TRIMMING_FILTERING {
    publishDir "results/fastp", mode: 'copy'
    tag "$sample_id"

    input:
    tuple val(sample_id), path(read)

    output:
    tuple val(sample_id), path("trimmed_${sample_id}.fastq.gz")

    script:
    """
    fastp \
      -i ${read} \
      -o trimmed_${sample_id}.fastq.gz \
      -w ${task.cpus}
    """
}
