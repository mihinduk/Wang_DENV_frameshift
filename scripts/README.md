# Pipeline Scripts

Scripts for replicating the DENV frameshift analysis.

## run_full_pipeline_SRR35818898.sh

Complete end-to-end pipeline from FASTQ to frameshift detection.

**Purpose:** Validate pipeline replication by running complete workflow from raw sequencing data.

**Workflow:**
1. fastp quality trimming
2. bwa-mem2 alignment to NC_001477.1
3. SAM to BAM conversion and sorting
4. Add read groups (GATK requirement)
5. ivar consensus generation (Q=0, t=0 - collaborators' parameters)
6. GATK HaplotypeCaller variant calling
7. SnpEff annotation
8. Frameshift extraction

**Usage:**
```bash
sbatch run_full_pipeline_SRR35818898.sh
```

**Requirements:**
- SLURM cluster
- Conda environments: VVCP (GATK), java21 (SnpEff)
- Input FASTQ files in `/scratch/sahlab/kathie/DENV_frameshift/collab/`
- Reference: `/scratch/sahlab/kathie/DENV_frameshift/collab_pipeline/references/denv1.fasta`

**Parameters:**
- Threads: 8
- Memory: 16G
- Time: 2 hours
- GATK: --standard-min-confidence-threshold-for-calling 30, --min-base-quality-score 20
- ivar: -Q 0 -t 0 -q 20 (collaborators' original parameters)

**Output Directory:**
`/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline/SRR35818898_full_run/`

**Key Outputs:**
- `SRR35818898_rg.sorted.bam` - Aligned reads
- `SRR35818898_consensus.fa` - Consensus sequence
- `SRR35818898.vcf` - Raw variants
- `SRR35818898_annotated.vcf` - SnpEff annotations
- `SRR35818898_frameshifts.txt` - Frameshift variants
- `SRR35818898_snpEff_summary.html` - Annotation report

**Validation:**
- Job ID: 36306172
- Result: 1 frameshift at position 456 (prM)
- Status: IDENTICAL to previous BAM-based analysis ✓

## Future Scripts

Additional scripts can be added for:
- Batch processing all 6 samples
- IGV visualization preparation
- Allele frequency extraction
- Sequence context analysis
