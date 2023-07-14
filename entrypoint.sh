#!/bin/sh -l

echo "Running grype scan..."
grype -o sarif --file grype.sarif .
echo "grype_sarif=`cat ./grype.sarif`" >> $GITHUB_OUTPUT
