#!/bin/bash
#SBATCH --job-name=emapper
#SBATCH --cpus-per-task=32
#SBATCH --mem=500GB
#SBATCH --nodes=1
#SBATCH --array=1-14
#SBATCH --time=7-00:00:00
#SBATCH --output=eggnog_%A_%a.log
#SBATCH --error=eggnog_%A_%a.err
#SBATCH --partition=aoraki

set -euo pipefail

BASE_DIR="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/braker-3/orthofinder"
INPUT_DIR="${BASE_DIR}/braker3_output/filtered_longest_isoforms"
OUTPUT_DIR="${BASE_DIR}/eggnog_output"

EGGNOG_DATA_DIR="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trinotate/data_directory/EGGNOG_DATA_DIR" 

# Adjusted per-task resources (8 CPUs is optimal for DIAMOND in parallel arrays)
THREADS=8

mkdir -p "${OUTPUT_DIR}"

source ~/miniforge3/bin/activate
conda activate eggnog

EMAPPER_PATH="$HOME/.conda/envs/trinotate/bin/emapper.py"

shopt -s nullglob
files=("${INPUT_DIR}"/*.fasta)

if [ ${#files[@]} -eq 0 ]; then
    echo "Error: No fasta files found in ${INPUT_DIR}" >&2
    exit 1
fi

fasta="${files[$SLURM_ARRAY_TASK_ID]}"
filename=$(basename "${fasta}")
species_name="${filename%.fasta}"

echo "--------------------------------------------------"
echo "SLURM Array Task ID: ${SLURM_ARRAY_TASK_ID}"
echo "Processing species: ${species_name}"
echo "File path: ${fasta}"
echo "--------------------------------------------------"

python3 "${EMAPPER_PATH}" \
    -i "${fasta}" \
    -o "${species_name}" \
    --output_dir "${OUTPUT_DIR}" \
    --data_dir "${EGGNOG_DATA_DIR}" \
    --itype proteins \
    -m diamond \
    --cpu "${THREADS}" \
    --override

echo "Successfully completed: ${species_name}"
