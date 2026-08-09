#!/bin/bash
#SBATCH --job-name=amas_concat
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=3-00:00:00
#SBATCH --output=amas.out
#SBATCH --error=amas.err
#SBATCH --partition=aoraki

/home/galta815/.conda/envs/amas/bin/AMAS.py \
	concat \
	-f fasta \
	-d aa \
	-i renamed_trimmed_genes/*_aln.fa  \
	-u nexus
