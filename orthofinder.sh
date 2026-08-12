#!/bin/bash
#SBATCH --job-name=OrthoFinder
#SBATCH --cpus-per-task=16
#SBATCH --mem=500GB
#SBATCH --nodes=1
#SBATCH --time=7-00:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --partition=aoraki_fastcore

set -euo pipefail

BASE_DIR="/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/braker-3/orthofinder"
INPUT_DIR="${BASE_DIR}/braker3_output/filtered_longest_isoforms"
RESULTS_DIR="${BASE_DIR}/orthofinder_results"
SIF_FILE="${BASE_DIR}/orthofinder_2.5.5.sif"
THREADS=16

if [[ -d "${RESULTS_DIR}" ]]; then
    echo "Removing pre-existing results directory..."
    rm -rf "${RESULTS_DIR}"
fi

echo "Launching OrthoFinder on files in: ${INPUT_DIR}"
echo "Using container: ${SIF_FILE}"

singularity exec \
    -B /weka \
    "${SIF_FILE}" \
    orthofinder \
    -f "${INPUT_DIR}" \
    -o "${RESULTS_DIR}" \
    -t "${THREADS}"

echo "OrthoFinder finished successfully!"
echo "Final results located in: ${RESULTS_DIR}"









