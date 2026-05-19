process MARK_DUP {
    publishDir "results/bam_final", mode: 'copy'
    tag "$sample_id"

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("${sample_id}.dedup.bam")

    script:
    """
    java -jar /opt/conda/bin/picard.jar MarkDuplicates \
      I=${bam} \
      O=${sample_id}.dedup.bam \
      M=${sample_id}.metrics.txt \
      REMOVE_DUPLICATES=true
    """
}
