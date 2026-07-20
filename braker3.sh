#!/bin/bash
#SBATCH --job-name=braker3
#SBATCH --array=1-13
#SBATCH --cpus-per-task=24
#SBATCH --mem=500GB
#SBATCH --nodes=1
#SBATCH --time=15-00:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --partition=aoraki_long

CONTAINER="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/braker-3/braker3.sif"
AUGUSTUS_CONFIG="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/braker-3/augustus_config"
MASKED_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/masked_genomes"
OUTDIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/braker3_output"
PROTEINS="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/braker-3/Arthropoda.fa"

mkdir -p "$OUTDIR"

GENOMES=($(ls ${MASKED_DIR}/*.masked.fasta))
GENOME=${GENOMES[$((SLURM_ARRAY_TASK_ID-1))]}
BASENAME=$(basename "$GENOME")

SPECIES=$(echo "$BASENAME" | cut -d'_' -f1,2)"_v2"

CLEAN_GENOME="$OUTDIR/${SPECIES}_headers_cleaned.fa"
sed 's/[[:space:]].*//' "$GENOME" | sed 's/:/_/g' | sed 's/|/_/g' > "$CLEAN_GENOME"

echo "[$(date)] Running BRAKER3 on $BASENAME as $SPECIES"

singularity exec -B /weka,/projects "$CONTAINER" \
    braker.pl \
        --genome="$CLEAN_GENOME" \
        --species="$SPECIES" \
        --AUGUSTUS_CONFIG_PATH="$AUGUSTUS_CONFIG" \
        --prot_seq="$PROTEINS" \
        --gff3 \
        --threads=24 \
        --workingdir="$OUTDIR/$SPECIES" \
	--useexisting \
        --overwrite

if [ $? -eq 0 ]; then
    echo "[$(date)] Finished $SPECIES successfully."
    rm "$CLEAN_GENOME"
else
    echo "[$(date)] BRAKER3 failed for $SPECIES. Check $OUTDIR/$SPECIES/braker.log"
    exit 1
fi
