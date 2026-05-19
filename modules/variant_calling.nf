process VARIANT_CALLING {

    tag "$sample_id"

    input:
    tuple val(sample_id), path(bam), path(bai)
    tuple path(ref), path(fai), path(dict)

    output:
    tuple val(sample_id), path("${sample_id}.vcf")

    script:
    """
    gatk HaplotypeCaller \
      -R ${ref} \
      -I ${bam} \
      -O ${sample_id}.vcf
    """
}
