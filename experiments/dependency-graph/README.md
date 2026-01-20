# Dependency Graph Extractor

This script extracts the dependency graph for the control-toolbox ecosystem packages (CT* and OptimalControl).

## Features

- ✅ **Ephemeral environment**: Creates a temporary local Julia environment (doesn't pollute your global environment)
- ✅ **Auto-registry setup**: Automatically checks and installs `ct-registry` if needed
- ✅ Extract dependency graph with current environment
- ✅ Extract dependency graph with a specific OptimalControl version
- ✅ Export results to markdown format

## Usage

### Extract with current environment

```bash
julia extract-graph.jl
```

### Extract with specific OptimalControl version

```bash
# With 'v' prefix
julia extract-graph.jl v1.1.7-beta

# Without 'v' prefix (also works)
julia extract-graph.jl 1.1.7-beta
```

## How it works

1. **Ephemeral Environment Setup**: The script creates a temporary Julia environment in the script directory
   - Uses `Pkg.activate(@__DIR__)` to isolate from your global environment
   - All packages are installed in this temporary environment
   - Your global Julia environment remains untouched
   - Files can be deleted after running the script

2. **Registry Check**: The script checks if `ct-registry` is installed
   - If not installed, it automatically installs it from <https://github.com/control-toolbox/ct-registry.git>
   - If already installed, it skips this step

3. **Version Installation** (optional): If a version is specified as command-line argument
   - Installs the specified version of OptimalControl in the temporary environment
   - If installation fails, continues with current environment

4. **Graph Extraction**: Uses `Pkg.dependencies()` API to extract:
   - All CT* packages and OptimalControl
   - Their versions
   - Their dependencies within the control-toolbox ecosystem

5. **Output**:
   - Prints the dependency graph to console
   - Exports to `dependency-graph.md` with tree view and package details

## Output Format

The script generates a `dependency-graph.md` file containing:

- **Tree View**: Hierarchical view starting from OptimalControl
- **Package Details**: Detailed list of each package with its version and dependencies

## Example

```bash
$ julia extract-graph.jl v1.1.7-beta

Extracting dependency graph...

✓ ct-registry is already installed

Requested OptimalControl version: v1.1.7-beta

=== Strategy 1: Pkg.dependencies() ===

Installing OptimalControl@v1.1.7-beta...
✓ OptimalControl@v1.1.7-beta installed successfully

OptimalControl v1.1.7-beta
  ├── CTBase v0.16.0
  ├── CTDirect v0.9.0
  │   └── CTBase v0.16.0
  ├── CTFlows v0.3.0
  │   └── CTBase v0.16.0
  ...
```

## Cleanup

The script creates an ephemeral Julia environment in its directory. To clean up after running:

```bash
# Remove the temporary environment files
rm -f Project.toml Manifest.toml

# The dependency-graph.md output file can also be removed if needed
rm -f dependency-graph.md
```

All these files are in `.gitignore` and won't be committed.

## Notes

- The script uses an **ephemeral local environment** in the script directory, so your global Julia environment is never modified
- The environment files (`Project.toml` and `Manifest.toml`) are temporary and can be safely deleted after each run
- The `ct-registry` is required to access beta versions of control-toolbox packages
- If you're working in a team, the script will automatically install the registry for colleagues who don't have it yet
