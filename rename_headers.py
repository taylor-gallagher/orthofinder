import os
import glob
import csv

# UPDATE THIS PATH to point to your Orthogroups.tsv file:
orthogroups_tsv = "/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/braker-3/orthofinder/orthofinder_results/Results_Aug06/Orthogroups/Orthogroups.tsv"

# 1. Build the Gene ID -> Species Name dictionary
gene_to_species = {}
with open(orthogroups_tsv, 'r') as f:
    reader = csv.reader(f, delimiter='\t')
    header = next(reader)
    species_names = [s.strip() for s in header[1:]] # Species column names
    
    for row in reader:
        for i, gene_str in enumerate(row[1:]):
            species = species_names[i]
            genes = [g.strip() for g in gene_str.split(',') if g.strip()]
            for gene in genes:
                gene_to_species[gene] = species

# 2. Replace headers in all trimmed alignment files
os.makedirs("renamed_trimmed_genes", exist_ok=True)

for filepath in glob.glob("trimmed_genes/*_aln.fa"):
    filename = os.path.basename(filepath)
    outpath = os.path.join("renamed_trimmed_genes", filename)
    
    with open(filepath, 'r') as infile, open(outpath, 'w') as outfile:
        for line in infile:
            if line.startswith(">"):
                gene_id = line.strip()[1:] # Remove '>'
                if gene_id in gene_to_species:
                    species_name = gene_to_species[gene_id]
                    outfile.write(f">{species_name}\n")
                else:
                    print(f"Warning: {gene_id} not found in Orthogroups.tsv")
                    outfile.write(line)
            else:
                outfile.write(line)

print("Done! Renamed files are saved in 'renamed_trimmed_genes/'")
