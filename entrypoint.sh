#!/bin/sh -l

echo "workspace = " $GITHUB_WORKSPACE
cd $GITHUB_WORKSPACE

echo "Running grype scan..."
grype -o sarif --file grype.sarif $GITHUB_WORKSPACE

echo "Running trivy file system scan"
trivy filesystem --format sarif /app --offline-scan --skip-db-update --skip-java-db-update --output trivyfilesystem.sarif

echo "Creating cyclonedx file for trivy SBOM scan"
trivy filesystem --format cyclonedx /app --output trivyfilesystem.cyclonedx  # Does not require the database
echo "Running trivy SBOM scan"
trivy sbom --offline-scan --skip-db-update --skip-java-db-update --output trivyfilesystemsbom.sarif trivyfilesystem.cyclonedx

echo "Running trivy repo scan for " $GITHUB_REPO_URL
trivy repo --offline-scan --skip-db-update --skip-java-db-update --format sarif --output trivyreposcan.sarif $GITHUB_REPO_URL

echo "exiting ..."
