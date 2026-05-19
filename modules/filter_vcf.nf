process VCF_FILTER {
    publishDir "results/vcf", mode: 'copy'
    tag "$sample_id"

    input:
    tuple val(sample_id), path(vcf)
    tuple path(ref), path(fai), path(dict)

    output:
    tuple val(sample_id), path("${sample_id}.filtered.vcf")

    script:
    """
    gatk VariantFiltration \
      -R ${ref} \
      -V ${vcf} \
      --filter-expression "QD < 2.0" \
      --filter-name "low_QD" \
      --filter-expression "FS > 60.0" \
      --filter-name "high_FS" \
      -O ${sample_id}.filtered.vcf
    """
}
