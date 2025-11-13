#!/usr/bin/env python3

import hashlib
import json
from pathlib import Path

def compute_md5(filepath):
    """Compute MD5 checksum of a file."""
    md5 = hashlib.md5()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(8192), b''):
            md5.update(chunk)
    return md5.hexdigest()

# Process input_data directory
input_dir = Path('input_data')

if not input_dir.exists():
    print("Error: input_data/ directory not found!")
    print("Note: This GO enrichment analysis may not require download.sh")
    print("Creating metadata.jsonl with available files...")

    # For GO enrichment, we might just have the paper.pdf
    # Create a minimal metadata.jsonl
    with open('metadata.jsonl', 'w') as out:
        if Path('paper.pdf').exists():
            shutil.copy('paper.pdf', 'input_data/paper.pdf')
            md5sum = compute_md5(Path('input_data/paper.pdf'))
            entry = {"name": "paper.pdf", "md5sum": md5sum}
            out.write(json.dumps(entry) + '\n')
            print("✓ Added paper.pdf to metadata.jsonl")
    exit(0)

print("Generating metadata.jsonl...")
print(f"Scanning {input_dir}/ for files...")

with open('metadata.jsonl', 'w') as out:
    files_found = 0
    for file in sorted(input_dir.iterdir()):
        if file.is_file() and not file.name.startswith('.'):
            print(f"  Processing: {file.name}")
            md5sum = compute_md5(file)
            entry = {"name": file.name, "md5sum": md5sum}
            out.write(json.dumps(entry) + '\n')
            files_found += 1

print(f"\n✓ Created metadata.jsonl with {files_found} files")
