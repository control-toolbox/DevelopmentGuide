#!/bin/bash
# Strategy 2: Parse Manifest.toml directly

echo "=== Strategy 2: Parse Manifest.toml ==="
echo ""

# Extract CT packages and their versions
grep -E "^\[\[deps\.(CT|OptimalControl)" Manifest.toml | while read line; do
    pkg=$(echo "$line" | sed 's/.*deps\.\(.*\)\]\]/\1/')
    
    # Get version for this package
    version=$(awk "/\[\[deps.$pkg\]\]/,/^$/" Manifest.toml | grep "^version" | head -1 | cut -d'"' -f2)
    
    echo "$pkg v$version"
    
    # Get CT dependencies
    awk "/\[\[deps.$pkg\]\]/,/^$/" Manifest.toml | grep "^deps = " | while read deps_line; do
        # Extract dependency names
        echo "$deps_line" | grep -oE "\"CT[^\"]+\"|\"OptimalControl\"" | tr -d '"' | while read dep; do
            dep_version=$(awk "/\[\[deps.$dep\]\]/,/^$/" Manifest.toml | grep "^version" | head -1 | cut -d'"' -f2)
            echo "  → $dep v$dep_version"
        done
    done
    echo ""
done
