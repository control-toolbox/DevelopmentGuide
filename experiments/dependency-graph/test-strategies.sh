#!/bin/bash
# Test different strategies to retrieve dependency graph with versions

echo "=== Strategy 1: Julia Pkg.status() approach ==="
echo "Creating empty environment and installing OptimalControl..."

# This will show us what we get from Pkg.status
