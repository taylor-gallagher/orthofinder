#!/usr/bin/env python3

from pathlib import Path

SRC_DIR = Path("/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/raw_genomes/epiperipatus")
DEST_DIR = Path("/projects/health_sciences/bms/biochemistry/dearden_lab/Taylor/OrthoFinder/unmasked_genomes")


def unmask_genome(input_path: Path, output_path: Path):
    with open(input_path, "r") as infile, open(output_path, "w") as outfile:
        for line in infile:
            if line.startswith(">"):
                outfile.write(line)
            else:
                outfile.write(line.upper())


def main():
    DEST_DIR.mkdir(parents=True, exist_ok=True)

    fna_files = list(SRC_DIR.glob("*.fna"))

    if not fna_files:
        print(f"No .fna files found in {SRC_DIR}")
        return

    print(f"Found {len(fna_files)} genome file(s) to unmask.\n")

    for idx, fna_file in enumerate(fna_files, 1):
        output_file = DEST_DIR / fna_file.name
        print(f"[{idx}/{len(fna_files)}] Processing: {fna_file.name}...")
        unmask_genome(fna_file, output_file)

    print("\nUnmasking complete! All files saved to:")
    print(DEST_DIR)


if __name__ == "__main__":
    main()
