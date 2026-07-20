#!/bin/bash
#SBATCH --job-name=hmmer
#SBATCH --cpus-per-task=24
#SBATCH --mem=500GB
#SBATCH --nodes=1
#SBATCH --time=3-00:00:00
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --partition=aoraki

singularity exec -B /projects /projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/Containers/hmmer_3.4.sif \
	hmmscan --cpu 16 --domtblout SPECIES_NAME_pfam.domtbl \
	-E 1e-5 --domE 1e-5 \
	Pfam-A.hmm \
	/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/braker3_output/SPECIES_NAME/braker.aa
