import pandas as pd

# Load N1.tsv
n1_file = "/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/braker-3/orthofinder/orthofinder_results/Results_Aug10/Phylogenetic_Hierarchical_Orthogroups/N1.tsv"
df = pd.read_csv(n1_file, sep='\t')

# The HOGs inside OG
target_hogs = [
    "N1.HOG0000787",
    "N1.HOG0000788",
    "N1.HOG0000789",
    "N1.HOG0000790",
    "N1.HOG0000791",
    "N1.HOG0000792",
    "N1.HOG0000793",
    "N1.HOG0000794",
    "N1.HOG0000795",
    "N1.HOG0000796",
    "N1.HOG0000797",
    "N1.HOG0000798"
]

subset = df[df['HOG'].isin(target_hogs)]

print(f"{'HOG':<15} | {'Epip_Copies':<12} | {'Peri_Copies':<12}")
print("-" * 45)

for idx, row in subset.iterrows():
    # Count genes by splitting the comma-separated string
    epip_genes = str(row['Epiperipatus_broadwayi']).split(',') if pd.notna(row['Epiperipatus_broadwayi']) else []
    peri_genes = str(row['Peripatoides_otepoti']).split(',') if pd.notna(row['Peripatoides_otepoti']) else []
    
    # Remove empty strings if any
    epip_count = len([g for g in epip_genes if g.strip() != 'nan' and g.strip() != ''])
    peri_count = len([g for g in peri_genes if g.strip() != 'nan' and g.strip() != ''])
    
    print(f"{row['HOG']:<15} | {epip_count:<12} | {peri_count:<12}")
