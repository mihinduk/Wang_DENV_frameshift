#!/bin/bash
#SBATCH --job-name=full_SRR35818898
#SBATCH --output=full_SRR35818898_%j.out
#SBATCH --error=full_SRR35818898_%j.err
#SBATCH --mem=16G
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=8

set -e
set -x

# Activate conda
source /ref/sahlab/software/anaconda3/bin/activate

SAMPLE="SRR35818898"
WORKDIR="/scratch/sahlab/kathie/DENV_frameshift/collab_full_pipeline"
FASTQ_DIR="/scratch/sahlab/kathie/DENV_frameshift/collab"
REFERENCE="/scratch/sahlab/kathie/DENV_frameshift/collab_pipeline/references/denv1.fasta"
SNPEFF_JAR="/ref/sahlab/software/snpEff/snpEff.jar"
SNPEFF_CONFIG="/ref/sahlab/software/snpEff/snpEff.config"
THREADS=8

cd ${WORKDIR}

# Create sample-specific directory
mkdir -p ${SAMPLE}_full_run
cd ${SAMPLE}_full_run

echo "=========================================="
echo "FULL PIPELINE: ${SAMPLE}"
echo "Starting from FASTQ files"
echo "=========================================="

# Step 1: Quality trimming with fastp
echo "Step 1: Quality trimming with fastp..."
conda activate VVCP

fastp \
  -i ${FASTQ_DIR}/${SAMPLE}_1.fastq.gz \
  -I ${FASTQ_DIR}/${SAMPLE}_2.fastq.gz \
  -o ${SAMPLE}_trimmed_R1.fastq.gz \
  -O ${SAMPLE}_trimmed_R2.fastq.gz \
  -h ${SAMPLE}_fastp.html \
  -j ${SAMPLE}_fastp.json \
  --thread ${THREADS}

echo "✓ Fastp complete"

# Step 2: Alignment with bwa-mem2
echo "Step 2: Alignment with bwa-mem2..."

bwa-mem2 mem \
  -t ${THREADS} \
  ${REFERENCE} \
  ${SAMPLE}_trimmed_R1.fastq.gz \
  ${SAMPLE}_trimmed_R2.fastq.gz \
  > ${SAMPLE}.sam

echo "✓ Alignment complete"

# Step 3: Convert SAM to BAM and sort
echo "Step 3: Converting to BAM and sorting..."

samtools view -@ ${THREADS} -bS ${SAMPLE}.sam | \
samtools sort -@ ${THREADS} -o ${SAMPLE}.sorted.bam

samtools index ${SAMPLE}.sorted.bam

echo "✓ BAM conversion complete"

# Step 4: Add read groups (required for GATK)
echo "Step 4: Adding read groups..."

gatk AddOrReplaceReadGroups \
  -I ${SAMPLE}.sorted.bam \
  -O ${SAMPLE}_rg.sorted.bam \
  -RGID ${SAMPLE} \
  -RGLB lib1 \
  -RGPL ILLUMINA \
  -RGPU unit1 \
  -RGSM ${SAMPLE}

samtools index ${SAMPLE}_rg.sorted.bam

echo "✓ Read groups added"

# Step 5: Generate consensus with ivar (using collaborators' parameters)
echo "Step 5: Generating consensus with ivar (Q=0, t=0)..."

samtools mpileup -d 1000 -A -Q 0 ${SAMPLE}_rg.sorted.bam | \
ivar consensus -p ${SAMPLE}_consensus -q 20 -t 0 -m 10

echo "✓ Consensus generated"

# Step 6: GATK HaplotypeCaller variant calling
echo "Step 6: GATK variant calling..."

gatk HaplotypeCaller \
  -R ${REFERENCE} \
  -I ${SAMPLE}_rg.sorted.bam \
  -O ${SAMPLE}.vcf \
  --standard-min-confidence-threshold-for-calling 30 \
  --min-base-quality-score 20

echo "✓ Variant calling complete"

# Step 7: SnpEff annotation
echo "Step 7: SnpEff annotation..."
conda activate java21

java -Xmx8g -jar ${SNPEFF_JAR} ann \
  -c ${SNPEFF_CONFIG} \
  -v NC_001477.1 \
  -stats ${SAMPLE}_snpEff_summary.html \
  ${SAMPLE}.vcf \
  > ${SAMPLE}_annotated.vcf

echo "✓ Annotation complete"

# Step 8: Extract frameshifts
echo "Step 8: Extracting frameshift variants..."

grep 'frameshift' ${SAMPLE}_annotated.vcf | grep -v '^#' > ${SAMPLE}_frameshifts.txt || true

FRAMESHIFT_COUNT=$(wc -l < ${SAMPLE}_frameshifts.txt)

echo "=========================================="
echo "PIPELINE COMPLETE: ${SAMPLE}"
echo "=========================================="
echo "Output directory: ${WORKDIR}/${SAMPLE}_full_run/"
echo ""
echo "Key output files:"
echo "  - ${SAMPLE}_rg.sorted.bam - Aligned reads"
echo "  - ${SAMPLE}_consensus.fa - Consensus sequence"
echo "  - ${SAMPLE}.vcf - Raw variants"
echo "  - ${SAMPLE}_annotated.vcf - Annotated variants"
echo "  - ${SAMPLE}_frameshifts.txt - Frameshift variants"
echo ""
echo "Frameshift variants found: ${FRAMESHIFT_COUNT}"
echo "=========================================="

if [ ${FRAMESHIFT_COUNT} -gt 0 ]; then
  echo ""
  echo "Frameshift details:"
  cat ${SAMPLE}_frameshifts.txt
fi
