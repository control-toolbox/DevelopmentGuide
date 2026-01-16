# Dependency Graph Extraction - Strategy Comparison

## Tested Strategies

### ✅ Strategy 1: Pkg.dependencies() API (RECOMMENDED)

**Implementation**: `extract-graph.jl`

**Approach**:
```julia
using Pkg, Dates

deps = Pkg.dependencies()
ct_pkgs = filter(p -> startswith(p.second.name, "CT") || p.second.name == "OptimalControl", deps)

for (uuid, pkg) in ct_pkgs
    println("$(pkg.name) v$(pkg.version)")
    if !isnothing(pkg.dependencies)
        for (dep_name, dep_uuid) in pkg.dependencies
            if haskey(deps, dep_uuid)
                println("  → $(deps[dep_uuid].name) v$(deps[dep_uuid].version)")
            end
        end
    end
end
```

**Advantages**:
- ✅ Clean, reliable Julia API
- ✅ Automatically resolves all dependencies
- ✅ Gets exact installed versions
- ✅ Easy to parse and manipulate
- ✅ Works with any Julia environment

**Disadvantages**:
- ⚠️ Requires Julia environment with OptimalControl installed
- ⚠️ Needs `Pkg.add("OptimalControl")` first (~20-30 seconds)

**Output Example**:
```
OptimalControl v1.1.6
  ├── CTDirect v0.17.4 → CTModels v0.6.9, CTBase v0.16.4
  ├── CTParser v0.7.2 → CTBase v0.16.4
  ├── CTFlows v0.8.9 → CTModels v0.6.9, CTBase v0.16.4
  ├── CTModels v0.6.9 → CTBase v0.16.4
  └── CTBase v0.16.4
```

**Performance**: ~2-3 seconds after environment setup

---

### ❌ Strategy 2: Manifest.toml Parsing (NOT RECOMMENDED)

**Approach**: Parse Manifest.toml with bash/grep/awk

**Disadvantages**:
- ❌ Complex regex parsing
- ❌ Fragile (depends on TOML format)
- ❌ Hard to maintain
- ❌ Requires Manifest.toml to exist

**Conclusion**: Not worth the complexity

---

### 🔄 Strategy 3: GitHub API (ALTERNATIVE)

**Approach**: Query Project.toml files from GitHub

```bash
gh api repos/control-toolbox/OptimalControl.jl/contents/Project.toml \
  | jq -r '.content' | base64 -d
```

**Advantages**:
- ✅ No local Julia environment needed
- ✅ Can query any version/branch

**Disadvantages**:
- ⚠️ Requires `gh` CLI and authentication
- ⚠️ Needs to query each package separately
- ⚠️ Doesn't resolve versions automatically (only compat ranges)
- ⚠️ Slower (network requests)

**Use case**: When you need to check a specific branch/version without installing

---

## Recommendation for Workflows

### For `/breaking-setup` workflow:

Use **Strategy 1** (Pkg.dependencies()):

```julia
# In workflow, create temp environment
mkdir -p /tmp/ct-graph-$$
cd /tmp/ct-graph-$$

julia --project=. -e '
using Pkg, Dates

# Install OptimalControl
Pkg.add("OptimalControl")

# Extract graph
deps = Pkg.dependencies()
ct_pkgs = filter(p -> startswith(p.second.name, "CT") || p.second.name == "OptimalControl", deps)

# Print graph
for (uuid, pkg) in sort(collect(ct_pkgs), by=p->p.second.name)
    println("$(pkg.second.name) v$(pkg.second.version)")
    if !isnothing(pkg.second.dependencies)
        for (dep_name, dep_uuid) in pkg.second.dependencies
            if haskey(deps, dep_uuid) && (startswith(deps[dep_uuid].name, "CT") || deps[dep_uuid].name == "OptimalControl")
                println("  → $(deps[dep_uuid].name) v$(deps[dep_uuid].version)")
            end
        end
    end
end
'
```

**Workflow integration**:
1. Agent creates temp environment
2. Runs Julia script to extract graph
3. Parses output to build graph structure
4. Asks user to confirm versions are current
5. Uses graph for classification and planning

---

## Files Created

- `extract-graph.jl` - Full-featured extraction script
- `dependency-graph.md` - Example output (generated 2026-01-16)
- `test-strategies.sh` - Test harness (partial)
- `parse-manifest.sh` - Bash parsing attempt (not recommended)

---

## Next Steps

1. Integrate `extract-graph.jl` logic into `/breaking-setup` workflow
2. Add user confirmation step for graph validation
3. Use graph to classify breaking vs. compatible packages
4. Store graph in setup report for action plan generation
