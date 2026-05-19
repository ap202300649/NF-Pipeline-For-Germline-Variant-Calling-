# NF-Pipeline-For-Germline-Variant-Calling

A modular DSL2-based Nextflow pipeline for Germline Variant Calling using:

FastQC
FastP
BWA-MEM
SAMtools
Picard
GATK HaplotypeCaller

Designed for learning production-style bioinformatics workflow development using modular Nextflow architecture.

```mermaid
flowchart TD

A[GERMLINE] --> B[main.nf]
A --> C[nextflow.config]
A --> D[sample_sheet.csv]

A --> E[modules]
E --> E1[qc.nf]
E --> E2[trimming_filtering.nf]
E --> E3[alignment.nf]
E --> E4[post_alignment.nf]
E --> E5[add_readgroups.nf]
E --> E6[markdup.nf]
E --> E7[bam_index.nf]
E --> E8[variant_calling.nf]
E --> E9[filter_vcf.nf]

A --> F[data]
F --> F1[fastq]
F --> F2[reference]

A --> G[results]
```
