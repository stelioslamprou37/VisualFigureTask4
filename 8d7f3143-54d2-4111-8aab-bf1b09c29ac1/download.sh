#!/bin/bash

# ============================================================================
# Download Script: GO Enrichment Analysis Data
# ============================================================================

echo "============================================================================"
echo "GO Enrichment Analysis - Data Setup"
echo "============================================================================"
echo ""

# Create input_data directory
if [ ! -d "input_data" ]; then
    echo "Creating input_data directory..."
    mkdir -p input_data
else
    echo "input_data directory already exists"
fi

# Copy paper.pdf if it exists in parent directory
if [ -f "paper.pdf" ]; then
    echo "Moving paper.pdf to input_data/..."
    cp paper.pdf input_data/
    echo "✓ paper.pdf copied to input_data/"
else
    echo "⚠ paper.pdf not found - please manually place it in input_data/"
fi

echo ""
echo "============================================================================"
echo "Setup complete!"
echo "============================================================================"
echo ""
echo "Note: This analysis uses digitalized GO enrichment data."
echo "The data is already included in extracted_solution.csv"
echo ""
