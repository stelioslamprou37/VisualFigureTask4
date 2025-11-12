#!/bin/bash

# download.sh - Script to download and setup GO enrichment plot recreation project
# Usage: bash download.sh

set -e  # Exit on error

echo "=========================================="
echo "GO Enrichment Plot Recreation Setup"
echo "=========================================="
echo ""

# Define variables
PROJECT_DIR="go_enrichment_analysis"
DATA_FILE="digitalized_go_enrichment_data.csv"
SCRIPT_FILE="recreate_go_enrichment_plot.R"
DOCKERFILE="Dockerfile"

# Create project directory
echo "Creating project directory: ${PROJECT_DIR}"
mkdir -p ${PROJECT_DIR}
cd ${PROJECT_DIR}

# Download data file (placeholder URL - replace with actual source)
echo ""
echo "Downloading data file..."
if [ -f "../${DATA_FILE}" ]; then
    cp ../${DATA_FILE} .
    echo "✓ Data file copied: ${DATA_FILE}"
else
    echo "⚠ Warning: ${DATA_FILE} not found in parent directory"
    echo "  Please manually place the CSV file in this directory"
fi

