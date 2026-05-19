process ADD_RG {

    tag "$sample_id"

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("${sample_id}.rg.bam")

    script:
    """
    java -jar /opt/conda/bin/picard.jar AddOrReplaceReadGroups \
      I=${bam} \
      O=${sample_id}.rg.bam \
      RGID=${sample_id} \
      RGLB=lib1 \
      RGPL=ILLUMINA \
      RGPU=unit1 \
      RGSM=${sample_id}
    """
}
