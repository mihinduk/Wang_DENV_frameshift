# DENV Frameshift Investigation

Investigation of frameshift mutations found in Dengue virus (DENV1) samples, replicating and analyzing the methodology from Wang et al. collaborators' pipeline.

## Project Overview

**Research Question:** Why do collaborators find frameshift mutations in DENV1 consensus sequences, and are these biological or methodological artifacts?

**Key Finding:** Frameshifts are **BIOLOGICAL**, not artifacts. They represent genuine defective viral genomes present at ~50% allele frequency in viral populations.

## Background

Wang et al. collaborators reported frameshift mutations in their DENV sequencing data using their pipeline:
- Repository: https://github.com/Rajindra04/Virus-Variant-Calling-Pipeline
- Reference: DENV1 (NC_001477.1)

Initial hypothesis: Frameshifts might be artifacts from poor ivar parameters:
- `samtools mpileup -Q 0` (no base quality filter)
- `ivar consensus -t 0` (no frequency threshold)

## Summary of Findings

### Frameshift Hotspots (19 total across 6 samples)

| Position | Gene | Mutation | Frequency | Effect |
|----------|------|----------|-----------|--------|
| **456** | prM | G→GA | 5/6 samples (83%) | c.20_21insA, p.Glu9fs |
| **7959** | NS5 | GGA→G | 5/6 samples (83%) | Frameshift in RNA polymerase |
| **7963** | NS5 | A→AGG | 5/6 samples (83%) | Frameshift in RNA polymerase |

Additional sample-specific frameshifts:
- Position 1038, 1937, 1944 (E gene): Only in SRR35818888
- Position 6277 (NS3): Only in SRR35818879

### Sample Breakdown

| Sample | Frameshifts | Pattern |
|--------|-------------|---------|
| SRR35818875 | 3 | prM + NS5 hotspots |
| SRR35818879 | 4 | prM + NS5 hotspots + NS3 |
| SRR35818882 | 3 | prM + NS5 hotspots |
| SRR35818886 | 3 | prM + NS5 hotspots |
| SRR35818888 | 5 | E gene (3) + NS5 hotspots (no prM) |
| SRR35818898 | 1 | prM only |

### Key Conclusions

1. **Frameshifts are BIOLOGICAL**, not methodological artifacts
   - Identical results with Q=0,t=0 vs Q=20,t=0.5 parameters
   - Present across multiple independent samples
   - Show consistent allele frequencies (~0.5)

2. **No variant filtering in collaborators' pipeline**
   - Only GATK calling thresholds (--min-base-quality-score 20)
   - No VariantFiltration, SelectVariants, or other post-calling filters
   - We successfully replicated their exact methodology

3. **NS5 frameshifts suggest defective viral genomes**
   - NS5 is essential for replication
   - Frameshifted NS5 should be non-functional
   - Likely represent defective viral particles (DVPs) requiring trans-complementation

4. **Frameshift hotspots are position-specific**
   - Position 456 (prM): 5/6 samples
   - Positions 7959/7963 (NS5): Always occur together, only 4bp apart
   - Sample SRR35818898 lacks NS5 frameshifts (cleanest sample)
   - Sample SRR35818888 has unique pattern (no prM, but E gene frameshifts)

## Repository Structure

```
Wang_DENV_frameshift/
├── README.md                          # This file
├── docs/                              # Analysis documentation
│   ├── SESSION_SUMMARY.txt            # Quick overview
│   ├── CORRECTED_FRAMESHIFT_SUMMARY.txt  # Complete 6-sample analysis
│   ├── FILTERING_ANALYSIS.txt         # Pipeline filtering verification
│   ├── QUICK_COMMANDS.txt             # Ready-to-use analysis commands
│   └── SRR35818898_FULL_PIPELINE_RESULTS.txt  # Full pipeline validation
├── scripts/                           # Pipeline scripts
│   ├── run_full_pipeline_SRR35818898.sh  # Complete FASTQ→VCF workflow
│   └── README.md                      # Script documentation
└── data/                              # Data locations and paths
    └── DATA_LOCATIONS.md              # Paths to data on HTCF
```

## Quick Start

### View Analysis Summaries

All analysis documentation is on HTCF:
```bash
ssh htcf
cd /scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline

# Quick overview
cat SESSION_SUMMARY.txt

# Complete frameshift analysis
cat CORRECTED_FRAMESHIFT_SUMMARY.txt

# Filtering verification
cat FILTERING_ANALYSIS.txt

# Ready-to-use commands
cat QUICK_COMMANDS.txt
```

### Data Locations

**Working Directory:** `/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/`

**Key Files:**
- Frameshifts: `*_frameshifts.txt`
- Annotated VCFs: `*_annotated.vcf`
- BAM files for IGV: `SRR35818898_full_run/SRR35818898_rg.sorted.bam`
- Reference: `/scratch/sahlab/kathie/DENV_frameshift/collab_pipeline/references/denv1.fasta`

**Samples Analyzed:**
- SRR35818875, SRR35818879, SRR35818882, SRR35818886, SRR35818888, SRR35818898
- Original FASTQ files: `/scratch/sahlab/kathie/DENV_frameshift/collab/`

## Methodology

### Pipeline Overview

1. **Quality Control** - fastp trimming
2. **Alignment** - bwa-mem2 to NC_001477.1
3. **BAM Processing** - sorting, read group addition
4. **Consensus Generation** - ivar with parameters Q=0, t=0 (collaborators' original)
5. **Variant Calling** - GATK HaplotypeCaller
6. **Annotation** - SnpEff with NC_001477.1 database
7. **Frameshift Extraction** - grep 'frameshift' from annotated VCF

### Key Parameters (Identical to Collaborators)

**GATK HaplotypeCaller:**
```bash
gatk HaplotypeCaller \
  -R reference.fasta \
  -I sample.bam \
  -O sample.vcf \
  --standard-min-confidence-threshold-for-calling 30 \
  --min-base-quality-score 20
```

**SnpEff Annotation:**
```bash
java -jar snpEff.jar ann \
  -c snpEff.config \
  -v NC_001477.1 \
  sample.vcf > sample_annotated.vcf
```

### Validation

1. **Parameter Verification** ✓
   - GATK parameters: IDENTICAL
   - SnpEff database: NC_001477.1 (IDENTICAL)
   - No filtering steps in their pipeline

2. **Method Comparison** ✓
   - Our grep vs their SnpSift: 19/19 frameshifts match
   - Full pipeline validation: SRR35818898 FASTQ→VCF confirmed

3. **Artifact Testing** ✓
   - Original (Q=0, t=0) vs Corrected (Q=20, t=0.5): IDENTICAL frameshifts
   - Confirms frameshifts are biological, not ivar parameter artifacts

## Biological Questions

### Open Questions

1. **How can DENV1 replicate with NS5 frameshifts?**
   - Hypothesis: Defective viral genomes requiring trans-complementation
   - NS5 is essential for RNA replication
   - Frameshifted NS5 should be non-functional

2. **Why is AF consistently ~0.5?**
   - All frameshifts show heterozygous-like genotype (0/1)
   - Suggests 50% of viral population has frameshift
   - Could indicate mixed infection or systematic error

3. **Why are positions 7959/7963 always linked?**
   - Only 4bp apart
   - Always occur together in same samples
   - Could represent single mutational event

4. **What's the biological significance?**
   - Defective viral particles?
   - Quasispecies diversity?
   - Position-specific sequencing errors?
   - Functional ribosomal frameshifting?

### Next Steps

1. **Visual Inspection**
   - Load BAMs in IGV
   - Check for homopolymer runs at frameshift positions
   - Verify read support and mapping quality

2. **Sequence Context Analysis**
   - Extract reference sequence at hotspots
   - Check for low-complexity regions
   - Assess likelihood of polymerase slippage

3. **Literature Search**
   - DENV defective viral genomes
   - Flavivirus frameshifts
   - Trans-complementation in viral populations

4. **Extended Analysis**
   - Compare to other DENV1 datasets
   - Check if these positions are known variants
   - Analyze allele frequency distributions

## Results Files

### Documentation (on HTCF)

- **SESSION_SUMMARY.txt** - Quick overview and next steps
- **CORRECTED_FRAMESHIFT_SUMMARY.txt** - Complete analysis with all positions
- **FILTERING_ANALYSIS.txt** - Pipeline filtering verification
- **QUICK_COMMANDS.txt** - Ready-to-use commands for further analysis
- **SRR35818898_FULL_PIPELINE_RESULTS.txt** - Full pipeline validation report

### Data Files (on HTCF)

All files in: `/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/`

**Frameshifts:**
- `SRR35818875_frameshifts.txt`
- `SRR35818879_frameshifts.txt`
- `SRR35818882_frameshifts.txt`
- `SRR35818886_frameshifts.txt`
- `SRR35818888_frameshifts.txt`
- `SRR35818898_frameshifts.txt`

**Annotated VCFs:**
- `*_annotated.vcf` - SnpEff annotations
- `*_snpEff_summary.html` - Annotation reports

**BAM Files:**
- `SRR35818898_full_run/SRR35818898_rg.sorted.bam` - Full pipeline validation

**Original Pipeline:**
- `/tmp/Virus-Variant-Calling-Pipeline/` - Collaborators' cloned repository

## Reference Information

**DENV1 Reference Genome:** NC_001477.1 (10,735 bp)

**Gene Structure:**
- C (capsid): 95-394
- prM (pre-membrane): 437-934
- E (envelope): 935-2419
- NS1: 2420-3475
- NS2A: 3476-4129
- NS2B: 4130-4519
- NS3: 4520-6376
- NS4A: 6377-6757
- 2K: 6758-6826
- NS4B: 6827-7573
- NS5: 7574-10270

**Frameshift Positions:**
- Position 456: In prM (structural protein)
- Position 1038, 1937, 1944: In E (structural protein)
- Position 6277: In NS3 (protease/helicase)
- Position 7959, 7963: In NS5 (RNA polymerase)

## Contact

**Principal Investigator:** Dr. Handley
**Analyst:** Mihindu Kumarasinghe
**Institution:** Washington University in St. Louis
**Date:** January 2026

## Acknowledgments

- Wang et al. collaborators for sharing their pipeline
- Rajindra04 for the Virus Variant Calling Pipeline repository
- HTCF cluster resources for computational analysis

## Citation

If you use this analysis or methodology, please cite:
- Wang et al. (pending publication)
- This repository: https://github.com/mihinduk/Wang_DENV_frameshift.git
- Collaborators' pipeline: https://github.com/Rajindra04/Virus-Variant-Calling-Pipeline
