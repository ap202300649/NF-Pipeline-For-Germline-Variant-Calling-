process QC {
    publishDir "results/fastqc", mode: 'copy'
    tag "$sample_id"

    input:
    tuple val(sample_id), path(read)

    output:
    path "*_fastqc.html"
    path "*_fastqc.zip"

    script:
    """
    fastqc -t ${task.cpus} ${read}
    """
}
