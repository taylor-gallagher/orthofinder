#!/bin/bash
#SBATCH --job-name=iqtree
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=3-00:00:00
#SBATCH --output=iqtree.out
#SBATCH --error=iqtree.err
#SBATCH --partition=aoraki

/home/galta815/.conda/envs/iqtree3/bin/iqtree3 \
	-s concatenated.out \
	-p partitions.txt \
	-m MFP \
	-B 1000 \
	-alrt 1000 \
	-T 16 
