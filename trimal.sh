#!/bin/bash
#SBATCH --job-name=trimal_of
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=3-00:00:00
#SBATCH --output=trimal.out
#SBATCH --error=trimal.err
#SBATCH --partition=aoraki

mkdir trimmed_genes
for f in aligned_of_genes/*_aln.fa; do
    basename=$(basename "$f")
    /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/trimAL/trimal/source/trimal -in "$f" -out "trimmed_genes/$basename" -automated1
done
