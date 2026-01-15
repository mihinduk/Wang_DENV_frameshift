# Data Locations

All analysis data is stored on the HTCF cluster. This document provides paths to key files and directories.

## HTCF Cluster Access

```bash
ssh htcf
# Full hostname: login.htcf.wustl.edu
# Username: mihindu
```

## Primary Working Directories

### Main Analysis Directory
```
/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/
```

Contains:
- All frameshift analysis files
- Annotated VCFs
- SnpEff reports
- Documentation summaries

### Original FASTQ Files
```
/scratch/sahlab/kathie/DENV_frameshift/collab/
```

Files:
- `SRR35818875_1.fastq.gz`, `SRR35818875_2.fastq.gz`
- `SRR35818879_1.fastq.gz`, `SRR35818879_2.fastq.gz`
- `SRR35818882_1.fastq.gz`, `SRR35818882_2.fastq.gz`
- `SRR35818886_1.fastq.gz`, `SRR35818886_2.fastq.gz`
- `SRR35818888_1.fastq.gz`, `SRR35818888_2.fastq.gz`
- `SRR35818898_1.fastq.gz`, `SRR35818898_2.fastq.gz`

### Collaborators' Pipeline
```
/tmp/Virus-Variant-Calling-Pipeline/
```

Cloned from: https://github.com/Rajindra04/Virus-Variant-Calling-Pipeline

### Reference Files
```
/scratch/sahlab/kathie/DENV_frameshift/collab_pipeline/references/denv1.fasta
```

Reference: NC_001477.1 (DENV1, 10,735 bp)

### SnpEff Database
```
/ref/sahlab/software/snpEff/
```

Files:
- `snpEff.jar`
- `SnpSift.jar`
- `snpEff.config`
- `data/NC_001477.1/` - DENV1 database

## Key Result Files

### Frameshift Calls

Located in: `/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/`

**Original Parameters (Q=0, t=0):**
```
SRR35818875_frameshifts.txt  (3 frameshifts)
SRR35818879_frameshifts.txt  (4 frameshifts)
SRR35818882_frameshifts.txt  (3 frameshifts)
SRR35818886_frameshifts.txt  (3 frameshifts)
SRR35818888_frameshifts.txt  (5 frameshifts)
SRR35818898_frameshifts.txt  (1 frameshift)
```

**Corrected Parameters (Q=20, t=0.5):**
```
SRR35818875_corrected_frameshifts.txt  (3 frameshifts - IDENTICAL)
SRR35818879_corrected_frameshifts.txt  (4 frameshifts - IDENTICAL)
SRR35818882_corrected_frameshifts.txt  (3 frameshifts - IDENTICAL)
SRR35818886_corrected_frameshifts.txt  (3 frameshifts - IDENTICAL)
SRR35818888_corrected_frameshifts.txt  (5 frameshifts - IDENTICAL)
SRR35818898_corrected_frameshifts.txt  (1 frameshift - IDENTICAL)
```

### Annotated VCF Files

Located in: `/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/`

```
SRR35818875_annotated.vcf
SRR35818879_annotated.vcf
SRR35818882_annotated.vcf
SRR35818886_annotated.vcf
SRR35818888_annotated.vcf
SRR35818898_annotated.vcf
```

Corrected parameter versions:
```
SRR35818875_corrected_annotated.vcf
SRR35818879_corrected_annotated.vcf
SRR35818882_corrected_annotated.vcf
SRR35818886_corrected_annotated.vcf
SRR35818888_corrected_annotated.vcf
SRR35818898_corrected_annotated.vcf
```

### BAM Files for IGV

**Full Pipeline Validation (SRR35818898):**
```
/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/SRR35818898_full_run/SRR35818898_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/SRR35818898_full_run/SRR35818898_rg.sorted.bam.bai
```

**Original Parameter BAMs:**
```
/scratch/sahlab/kathie/DENV_frameshift/collab/SRR35818875_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/collab/SRR35818879_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/collab/SRR35818882_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/collab/SRR35818886_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/collab/SRR35818888_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/collab/SRR35818898_rg.sorted.bam
```

**Corrected Parameter BAMs:**
```
/scratch/sahlab/kathie/DENV_frameshift/SRR35818875_corrected/SRR35818875_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/SRR35818879_corrected/SRR35818879_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/SRR35818882_corrected/SRR35818882_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/SRR35818886_corrected/SRR35818886_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/SRR35818888_corrected/SRR35818888_rg.sorted.bam
/scratch/sahlab/kathie/DENV_frameshift/collab_corrected_nc/SRR35818898_rg.sorted.bam
```

### SnpEff Reports

Located in: `/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/`

```
*_snpEff_summary.html       (HTML reports)
*_snpEff_summary.genes.txt  (Gene summary tables)
```

### Documentation Summaries

Located in: `/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/`

```
SESSION_SUMMARY.txt                    (7.0 KB) - Quick overview
CORRECTED_FRAMESHIFT_SUMMARY.txt       (9.3 KB) - Complete analysis
FILTERING_ANALYSIS.txt                 (6.7 KB) - Pipeline verification
QUICK_COMMANDS.txt                     (6.0 KB) - Ready-to-use commands
SRR35818898_FULL_PIPELINE_RESULTS.txt  (5.9 KB) - Full pipeline validation
ALL_SAMPLES_FRAMESHIFT_SUMMARY.txt     (7.1 KB) - Initial summary
```

## Samples Analyzed

### DENV1 Samples (6 total)

| Sample ID | Source | Frameshifts | Pattern |
|-----------|--------|-------------|---------|
| SRR35818875 | Wang et al. | 3 | prM + NS5 hotspots |
| SRR35818879 | Wang et al. | 4 | prM + NS5 + NS3 |
| SRR35818882 | Wang et al. | 3 | prM + NS5 hotspots |
| SRR35818886 | Wang et al. | 3 | prM + NS5 hotspots |
| SRR35818888 | Wang et al. | 5 | E (3x) + NS5 (no prM) |
| SRR35818898 | Wang et al. | 1 | prM only |

### Reference Genome

- **Accession:** NC_001477.1
- **Organism:** Dengue virus 1
- **Length:** 10,735 bp
- **Source:** NCBI GenBank

## Disk Usage

Main analysis directory:
```bash
du -sh /scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/
# ~200 MB (VCF files, BAMs, reports)
```

Full pipeline run (SRR35818898):
```bash
du -sh /scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/SRR35818898_full_run/
# ~88 MB (includes SAM file)
```

All FASTQ files:
```bash
du -sh /scratch/sahlab/kathie/DENV_frameshift/collab/
# ~100 MB (6 samples, paired-end, gzipped)
```

## Quick Access Commands

### Navigate to main directory
```bash
cd /scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/
```

### View all frameshifts
```bash
for sample in SRR35818875 SRR35818879 SRR35818882 SRR35818886 SRR35818888 SRR35818898; do
  echo "=== ${sample} ==="
  cut -f1-5 ${sample}_frameshifts.txt
  echo ""
done
```

### Check documentation
```bash
cat SESSION_SUMMARY.txt
cat CORRECTED_FRAMESHIFT_SUMMARY.txt
cat FILTERING_ANALYSIS.txt
```

### Download files to local machine
```bash
# From local machine
scp htcf:/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/SESSION_SUMMARY.txt .
scp htcf:/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/*_frameshifts.txt .
```

## Backup and Archival

### Important Files to Preserve

1. **Frameshift calls** (19 total)
   - `*_frameshifts.txt` (all samples)
   - `*_corrected_frameshifts.txt` (validation)

2. **Annotated VCFs**
   - `*_annotated.vcf` (SnpEff annotations)

3. **Documentation**
   - All `*.txt` summary files
   - SnpEff HTML reports

4. **Scripts**
   - `run_full_pipeline_SRR35818898.sh`

5. **Reference**
   - `denv1.fasta` (NC_001477.1)

### Long-term Storage Recommendation

Archive to Dropbox or institutional storage:
```bash
tar -czf Wang_DENV_frameshift_analysis.tar.gz \
  /scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/*.txt \
  /scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/*_frameshifts.txt \
  /scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/*_annotated.vcf \
  /scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/*.sh
```

## Last Updated

January 15, 2026
