import pandas as pd

# Load CAFE5 change table
df = pd.read_csv("cafe_results/Base_change.tab", sep="\t")

# Target node N1
node = '<15>'

gains = (df[node] > 0).sum()
losses = (df[node] < 0).sum()
net_expansion = df[node][df[node] > 0].sum()
net_contraction = abs(df[node][df[node] < 0].sum())

print(f"=== CAFE5 SUMMARY FOR PANARTHROPODA (NODE N1 / <15>) ===")
print(f"Gene Families Expanded:    {gains} (+{net_expansion} total genes)")
print(f"Gene Families Contracted:  {losses} (-{net_contraction} total genes)")
