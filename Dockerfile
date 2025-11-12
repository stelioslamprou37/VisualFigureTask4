# Dockerfile for GO Enrichment Plot Recreation
# Base image with R pre-installed
FROM rocker/r-ver:4.3.2

# Maintainer information
LABEL maintainer="bioinformatics@research.org"
LABEL description="Docker container for recreating GO enrichment plots from digitalized data"
LABEL version="1.0.0"

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('ggplot2', 'dplyr'), repos='https://cran.rstudio.com/')"

# Copy project files into container
COPY digitalized_go_enrichment_data.csv /app/
COPY recreate_go_enrichment_plot.R /app/

# Create output directory
RUN mkdir -p /app/output

# Set environment variables
ENV R_LIBS_USER=/usr/local/lib/R/site-library

# Command to run the R script
CMD ["Rscript", "recreate_go_enrichment_plot.R"]

# Alternative: Interactive R session
# CMD ["R"]
