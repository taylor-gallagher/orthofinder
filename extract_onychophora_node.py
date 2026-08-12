import pandas as pd

# Path to CAFE5 change matrix
cafe_file = "cafe_results/Base_change.tab"

# Path to our annotated dataset
annot_file = "/weka/health_sciences/bms/biochemistry/dearden_lab/galta815/braker-3/orthofinder/N1_Panarthropoda_Classified.tsv"

# Load data
cafe_df = pd.read_csv(cafe_file, sep="\t")
annot_df = pd.read_csv(annot_file, sep="\t")

# Define Onychophoran columns from CAFE5
stem_col = '<16>'                          # Onychophora Ancestor
epiperipatus_col = 'Epiperipatus_broadwayi<1>' # Epiperipatus lineage
peripatoides_col = 'Peripatoides_otepoti<2>'   # Peripatoides lineage

# 1. Calculate Summary Statistics
stem_gains = (cafe_df[stem_col] > 0).sum()
stem_losses = (cafe_df[stem_col] < 0).sum()

ep_gains = (cafe_df[epiperipatus_col] > 0).sum()
ep_losses = (cafe_df[epiperipatus_col] < 0).sum()

per_gains = (cafe_df[peripatoides_col] > 0).sum()
per_losses = (cafe_df[peripatoides_col] < 0).sum()

print("==================================================")
print("       ONYCHOPHORA GENE FAMILY DYNAMICS           ")
print("==================================================")
print(f"Onychophora Ancestral Stem (Node <16>):")
print(f"  - Expansions / Gains: {stem_gains} HOGs")
print(f"  - Contractions / Losses: {stem_losses} HOGs\n")

print(f"Epiperipatus broadwayi (Tip <1>):")
print(f"  - Species-specific Expansions: {ep_gains} HOGs")
print(f"  - Species-specific Contractions: {ep_losses} HOGs\n")

print(f"Peripatoides otepoti (Tip <2>):")
print(f"  - Species-specific Expansions: {per_gains} HOGs")
print(f"  - Species-specific Contractions: {per_losses} HOGs\n")
print("==================================================")

# 2. Extract Top Functional Annotations for Onychophora Stem Gains
# Merge CAFE5 changes with functional annotations
merged = annot_df.merge(cafe_df[['FamilyID', stem_col, epiperipatus_col, peripatoides_col]], 
                        left_on='OG', right_on='FamilyID', how='inner')

merged = merged.rename(columns={
    stem_col: 'Onychophora_Ancestral_Change',
    epiperipatus_col: 'Epiperipatus_Change',
    peripatoides_col: 'Peripatoides_Change'
})

# Save full Onychophora dynamics table
merged.to_csv("Onychophora_Gene_Dynamics_Annotated.tsv", sep="\t", index=False)
print("\nSaved full results to: Onychophora_Gene_Dynamics_Annotated.tsv")

# Display top expanded families at the Onychophora Ancestor (Node <16>)
print("\nTop 10 Expanded Gene Families at the Onychophora Ancestor (Node <16>):")
top_stem_gains = merged[merged['Onychophora_Ancestral_Change'] > 0].sort_values(
    by='Onychophora_Ancestral_Change', ascending=False
)[['HOG', 'OG', 'Gene_Name', 'Description', 'Onychophora_Ancestral_Change']].head(10)

print(top_stem_gains.to_string(index=False))
