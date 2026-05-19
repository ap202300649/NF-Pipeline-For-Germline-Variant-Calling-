process FASTA_INDEX {

    input:
    path fasta

    output:
    tuple path("ref.fasta"), path("ref.fasta.*")

    script:
    """
    cp ${fasta} ref.fasta
    bwa index ref.fasta
    """
}
