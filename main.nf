nextflow.enable.dsl=2

params.sample_sheet = params.sample_sheet ?: null
params.ref         = params.ref ?: "/home/micro/NF_TESTING/HUMAN_REF_GENOME/BWAIndex/Homo_sapiens_assembly38.fasta"

// Input Validation 

if( !file(params.sample_sheet).exists() ) {
    error "sample_sheet not found: ${params.sample_sheet}"
}

if( !file(params.ref).exists() ) {
    error "Reference genome not found: ${params.ref}"
}

// sequence dictionary

def dict = params.ref.replaceAll(/\.fa(sta)?$/, '.dict')

// Modules

include { FASTQC }       from './modules/qc'
include { FASTP }        from './modules/trimming_filtering'
include { BWA_MEM }      from './modules/alignment'
include { SAMTOOLS }     from './modules/post_alignment'
include { ADD_RG }       from './modules/add_readgroups'
include { MARK_DUP }     from './modules/markdup'
include { BAM_INDEX }    from './modules/bam_index'
include { GATK_HC }      from './modules/variant_calling'
include { GATK_FILTER }  from './modules/filter_vcf'

// Workflow

workflow {

    
    // Read sample_sheet

    reads_ch = Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true)
        .map { row ->

            def r1 = file(row.fastq_1)

            // paired-end
            if( row.fastq_2 ) {
                def r2 = file(row.fastq_2)
                tuple(
                    row.sample,
                    [r1, r2],
                    "PE"
                )
            }

            // single-end
            else {
                tuple(
                    row.sample,
                    [r1],
                    "SE"
                )
            }
        }

    
    // BWA reference bundle

    ref_bundle = Channel.value([

        file(params.ref),
        file("${params.ref}.amb"),
        file("${params.ref}.ann"),
        file("${params.ref}.bwt"),
        file("${params.ref}.pac"),
        file("${params.ref}.sa")
    ])


    // GATK reference bundle
    
    ref_tuple = Channel.value(
        tuple(
            file(params.ref),
            file("${params.ref}.fai"),
            file(dict)
        )
    )

    
    // Pipeline
    
    FASTQC(reads_ch)

    trimmed = FASTP(reads_ch)
    aligned = BWA_MEM(trimmed, ref_bundle)
    bam = SAMTOOLS(aligned)
    rg = ADD_RG(bam)
    dedup = MARK_DUP(rg)
    indexed_bam = BAM_INDEX(dedup)
    vcf = GATK_HC(indexed_bam, ref_tuple)
    filtered = GATK_FILTER(vcf, ref_tuple)
}