#!/bin/bash
#SBATCH --job-name=mafft
#SBATCH --cpus-per-task=6
#SBATCH --mem=500G
#SBATCH --time=7-0:00:00
#SBATCH --output=mafft.out
#SBATCH --error=mafft.err
#SBATCH --partition=aoraki

mkdir aligned_of_genes

for f in *.fa; do

	singularity exec -B /weka /weka/health_sciences/bms/biochemistry/dearden_lab/galta815/msa/mafft/mafft_7.526.sif \
	mafft --auto \
	--localpair --maxiterate 1000 \
	"$f" > "aligned_of_genes/${f%.fa}_aln.fa"
done
