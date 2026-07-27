#!/bin/bash
#SBATCH --job-name=cd-hit-est
#SBATCH --array=1-13
#SBATCH --cpus-per-task=24
#SBATCH --mem=100GB
#SBATCH --nodes=1
#SBATCH --time=7-00:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --partition=aoraki

INPUT_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/reprise/output"
OUTPUT_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/cd-hit/output"

mkdir -p "$OUTPUT_DIR"

# Store all .reprof files in a Bash array
REPROF=("$INPUT_DIR"/*.reprof)

# Pick the file corresponding to this Slurm array index (0-indexed)
INDEX=$((SLURM_ARRAY_TASK_ID - 1))
reprof="${REPROF[$INDEX]}"

# Extract the base filename (strips directory path and .reprof extension)
base=$(basename "$reprof" .reprof)

echo "Task $SLURM_ARRAY_TASK_ID running cd-hit-est on: $base"

# Run cd-hit-est
cd-hit-est \
    -i "$reprof" \
    -o "$OUTPUT_DIR/${base}_cdhit.fasta" \
    -c 0.8 \
    -p 1 \
    -T 4
