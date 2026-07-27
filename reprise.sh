#!/bin/bash
#SBATCH --job-name=reprise
#SBATCH --array=1-13
#SBATCH --cpus-per-task=24
#SBATCH --mem=500GB
#SBATCH --nodes=1
#SBATCH --time=7-00:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --partition=aoraki

INPUT_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/unmasked_genomes"
OUTPUT_DIR="/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/reprise/output"

mkdir -p "$OUTPUT_DIR"

# Store all .fna files in a Bash array
GENOMES=("$INPUT_DIR"/*.fna)

# Pick the file corresponding to this Slurm array index (0-indexed)
INDEX=$((SLURM_ARRAY_TASK_ID - 1))
genome="${GENOMES[$INDEX]}"

base=$(basename "$genome" .fna)

echo "Task $SLURM_ARRAY_TASK_ID running REPrise on: $base"

/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/reprise/REPrise/./REPrise \
    -input "$genome" \
    -output "$OUTPUT_DIR/${base}_reprise" \
    -pa 24
