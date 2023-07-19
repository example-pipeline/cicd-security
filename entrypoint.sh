#!/bin/sh -l

echo "workspace = " $GITHUB_WORKSPACE
cd $GITHUB_WORKSPACE

echo "Running grype scan..."
grype -o sarif --file grype.sarif $GITHUB_WORKSPACE

echo "Creating trivy SBOM file"
trivy filesystem --format cyclonedx --output /app/result.json .
echo "Running trivy SBOM scan"
trivy sbom --offline-scan --skip-db-update --skip-java-db-update /app/result.json

echo "Running trivy file system scan"
trivy sbom --offline-scan --skip-db-update --skip-java-db-update /app/result.json

echo "exiting ..."
