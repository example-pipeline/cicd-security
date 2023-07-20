#!/bin/sh -l

echo "workspace = " $GITHUB_WORKSPACE
cd $GITHUB_WORKSPACE

echo "Running grype scan..."
grype -o sarif --file grype.sarif $GITHUB_WORKSPACE

echo "Running trivy file system scan"
trivy filesystem --format sarif /app --offline-scan --skip-db-update --skip-java-db-update --output /app/filesystem.sarif

echo "Creating cyclonedx file for trivy SBOM scan"
trivy filesystem --format cyclonedx /app --output /app/filesystem.cyclonedx  # Does not require the database
echo "Running trivy SBOM scan"
trivy sbom --offline-scan --skip-db-update --skip-java-db-update --output /app/filesystemsbom.sarif /app/filesystem.cyclonedx

echo "Running trivy repo scan for " $GITHUB_REPO_URL
trivy repo --offline-scan --skip-db-update --skip-java-db-update $GITHUB_REPO_URL


echo "exiting ..."
