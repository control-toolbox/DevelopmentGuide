---
description: Initial setup and information gathering for breaking change migrations
---

# Breaking Change Setup Workflow

This workflow collects and validates all information needed for creating a breaking change action plan.

## When to Use

- You have made breaking changes in a package
- Breakage tests are failing
- You need to prepare for migration to new version

## Prerequisites

- Breaking changes committed to package
- Access to package repository
- `gh` CLI installed (optional, for automation)
- Julia installed

---

## Workflow Steps

### Step 1: Confirm Initial Information

Ask the user for:

1. **Package name** (e.g., `CTBase`)
2. **Current version** (e.g., `0.16.4`)
3. **Target version** (e.g., `0.17.0`)
4. **Has branch/issue/PR been created?** (yes/no)

**Example**:
```
User: I'm working on CTBase and it's breaking, what should I do?

Agent: Let me help you set up the breaking change migration.

Please confirm:
- Package: CTBase
- Current version: 0.16.4
- Target version: 0.17.0
- Have you created a branch/issue/PR yet? (yes/no)
```

---

### Step 1b: Create Report Directory

**Generate directory name** in format: `YYYY-MM-DD-{package}-{version}`

Example: `2026-01-16-ctbase-0.17.0`

**Confirm with user**:

```
I will create a report directory:
reports-breaking/2026-01-16-ctbase-0.17.0/

All files for this migration will be stored there.
Proceed? (yes/no)
```

**Create directory**:

```bash
// turbo
mkdir -p reports-breaking/2026-01-16-ctbase-0.17.0
```

**Store directory path** for use in subsequent steps:

```
REPORT_DIR="reports-breaking/2026-01-16-ctbase-0.17.0"
```

**Note**: All subsequent file paths in this workflow will use `${REPORT_DIR}/` as the base path.

---

### Step 1c: Setup Local Registry (for Beta Releases)

**Important**: Beta versions will be registered in the **local registry** (ct-registry), not the General registry.

**Inform user**:

```
⚠️ Beta Release Strategy

For this migration, beta versions will be registered in ct-registry:
- Faster: No waiting for General registry processing (~10-30 min)
- Isolated: Beta versions don't pollute General registry
- Testing: Breakage tests automatically use ct-registry

You need to add ct-registry to your Julia environment (one-time setup):

pkg> registry add git@github.com:control-toolbox/ct-registry.git

Or via HTTPS:
pkg> registry add https://github.com/control-toolbox/ct-registry.git

Verify it's added:
pkg> registry status

You also need LocalRegistry.jl to register packages:
pkg> add LocalRegistry
```

**Note**: This step is only needed for migrations using beta versions (Option B strategy).

---

### Step 2: Branch/Issue/PR Setup

#### If NOT created:

Propose names and ask if user wants agent to create via `gh` CLI:

**Proposed names**:
- Branch: `breaking/{package}-{version}` (e.g., `breaking/ctbase-0.17`)
- Issue title: `Breaking change migration: {package} {old} → {new}`
- PR title: Same as issue

**Ask user**:
```
I can create these for you using `gh` CLI:
- Branch: breaking/ctbase-0.17
- Issue: "Breaking change migration: CTBase 0.16.4 → 0.17.0"
- PR: Same title

Create automatically? (yes/no)
```

**If yes**: Execute commands:
```bash
// turbo
cd /path/to/CTBase.jl
git checkout -b breaking/ctbase-0.17
gh issue create --title "Breaking change migration: CTBase 0.16.4 → 0.17.0" \
  --body "Migration tracking issue for CTBase breaking change."
gh pr create --title "Breaking change migration: CTBase 0.16.4 → 0.17.0" \
  --body "See issue #XXX for details."
```

#### If already created:

Ask user for:
- Branch name
- Issue number
- PR number

---

### Step 3: Retrieve Dependency Graph

Use validated strategy: `Pkg.dependencies()` API

**Extract graph using working script**:

```bash
// turbo
# Use the validated extract-graph.jl script
cd /path/to/dev-workflows/experiments/dependency-graph
julia --project=@. extract-graph.jl
```

**Alternative: Inline extraction** (if script not available):

```bash
// turbo
julia --project=@. -e '
using Pkg

println("Extracting dependency graph...\n")

# Get all dependencies
deps = Pkg.dependencies()

# Filter CT packages and OptimalControl
ct_pkgs = filter(p -> startswith(p.second.name, "CT") || 
                      p.second.name == "OptimalControl", deps)

# Build graph
graph = Dict()
for (uuid, pkg) in ct_pkgs
    pkg_deps = []
    if !isnothing(pkg.dependencies)
        for (dep_name, dep_uuid) in pkg.dependencies
            if haskey(deps, dep_uuid) && 
               (startswith(deps[dep_uuid].name, "CT") || 
                deps[dep_uuid].name == "OptimalControl")
                push!(pkg_deps, (deps[dep_uuid].name, deps[dep_uuid].version))
            end
        end
    end
    graph[pkg.name] = (pkg.version, pkg_deps)
end

# Print full graph
println("=== Dependency Graph ===\n")
for (pkg_name, (version, pkg_deps)) in sort(collect(graph))
    println("$pkg_name v$version")
    for (dep_name, dep_version) in pkg_deps
        println("  → $dep_name v$dep_version")
    end
    println()
end
'
```

**Present graph to user and ask for confirmation**:
```
Dependency graph extracted:

CTBase v0.16.4
CTDirect v0.17.4
  → CTModels v0.6.9
  → CTBase v0.16.4
CTFlows v0.8.9
  → CTModels v0.6.9
  → CTBase v0.16.4
CTModels v0.6.9
  → CTBase v0.16.4
CTParser v0.7.2
  → CTBase v0.16.4
OptimalControl v1.1.6
  → CTDirect v0.17.4
  → CTParser v0.7.2
  → CTFlows v0.8.9
  → CTModels v0.6.9
  → CTBase v0.16.4

Are these versions current? (yes/no)
```

---

### Step 4: Breakage Test Results

**Ask user**: "Have breakage tests run on the PR?" (yes/no)

#### If NO:
```
Please trigger breakage tests on your PR, then return to this workflow.

To trigger tests, push your changes and wait for CI to run.
```

#### If YES:

**Option A**: Agent reads PR comments via GitHub API

```bash
gh api repos/control-toolbox/{package}.jl/issues/{pr_number}/comments \
  | jq -r '.[] | select(.user.id == 41898282) | .body'
```

Parse markdown table format:
```
| Name | Latest | Stable |
|------|--------|--------|
| PackageName | ✅/❌ badge | ✅/❌ badge |
```

**Option B**: User copies/pastes breakage comment

```
Please copy and paste the breakage test comment from your PR:
```

**Parse results and present to user**:
```
Breakage test results:

| Package | Latest | Stable | Status |
|---------|--------|--------|--------|
| CTModels | ❌ | ❌ | Breaking |
| CTDirect | ❌ | ❌ | Breaking |
| CTFlows | ✅ | ✅ | Compatible |
| CTParser | ✅ | ✅ | Compatible |
| OptimalControl | ✅ | ✅ | Compatible |

Please confirm this interpretation is correct. (yes/no)
```

---

### Step 5: Classify Packages

Based on breakage results + user confirmation:

**Breaking packages** (need adaptation):
- Tests fail (❌)
- Code doesn't work with new version

**Compatible packages** (can widen compat):
- Tests pass (✅) OR user confirms compatibility
- Code works with both versions

**Present classification**:
```
Package classification:

Breaking packages (need adaptation):
- CTModels (direct dependency, uses changed API)
- CTDirect (indirect via CTModels)

Compatible packages (can widen compat):
- CTFlows
- CTParser
- OptimalControl

Is this classification correct? (yes/no)
```

---

### Step 6: Generate Setup Report

**Filename**: `${REPORT_DIR}/setup.md`

Example: `reports-breaking/2026-01-16-ctbase-0.17.0/setup.md`

**Content**:
```markdown
# Breaking Change Setup Report

**Date**: 2026-01-16 19:40:00
**Package**: CTBase
**Current Version**: 0.16.4
**Target Version**: 0.17.0
**Branch**: breaking/ctbase-0.17
**Issue**: #123
**PR**: #124
**Report Directory**: reports-breaking/2026-01-16-ctbase-0.17.0

## Dependency Graph

```
[Insert graph from Step 3]
```

## Breakage Test Results

| Package | Latest | Stable | Status |
|---------|--------|--------|--------|
| CTModels | ❌ | ❌ | Breaking |
| CTDirect | ❌ | ❌ | Breaking |
| CTFlows | ✅ | ✅ | Compatible |
| CTParser | ✅ | ✅ | Compatible |
| OptimalControl | ✅ | ✅ | Compatible |

## Classification

**Breaking packages** (need adaptation):
- CTModels (direct dependency, uses changed API)
- CTDirect (indirect via CTModels)

**Compatible packages** (can widen compat):
- CTFlows
- CTParser
- OptimalControl

## Next Steps

Ready for action plan generation. Run `/breaking-action-plan` with this report directory.
```

---

### Step 7: Archive Report and Prepare PR Comment

1. **Report already saved** in `${REPORT_DIR}/setup.md` (from Step 6)

2. **Create PR comment file** for user to copy-paste:

Create file `${REPORT_DIR}/PR-comment.md` with summary:

```markdown
## 🔧 Breaking Change Setup Complete

Setup report directory: `reports-breaking/{date}-{package}-{version}/`

**Summary**:
- **Breaking packages**: [list packages that need adaptation]
- **Compatible packages**: [list packages that can widen compat]

**Beta Strategy**: Beta versions will be registered in ct-registry (local registry) for faster testing.

**Next step**: Run `/breaking-action-plan reports-breaking/{date}-{package}-{version}` to generate migration plan.

---

*Setup completed on {date}*
```

1. **Create additional guide files** in `${REPORT_DIR}/`:

   - `README.md` - Overview of the report directory
   - `GUIDE.md` - Next steps guide (optional)

2. **Inform user**:

```
✅ Setup complete! All files saved in: reports-breaking/{date}-{package}-{version}/

Files created:
- setup.md - Main setup report
- PR-comment.md - Comment for PR #{pr_number}

To post the comment on the PR:
1. Open reports-breaking/{date}-{package}-{version}/PR-comment.md
2. Copy the entire content
3. Paste it as a comment on PR #{pr_number}
```

**Note**: All files for this migration are now organized in a single directory for easy tracking.

---

### Step 8: Transition to Workflow 2

**Ask user**: "Setup complete. Generate action plan now?" (yes/no)

**If yes**: Automatically invoke `/breaking-action-plan` with report directory:
```
/breaking-action-plan reports-breaking/2026-01-16-ctbase-0.17.0
```

**If no**: 
```
Setup complete! You can generate the action plan later by running:
/breaking-action-plan reports-breaking/2026-01-16-ctbase-0.17.0
```

---

## Output Files

All files are organized in: `reports-breaking/{date}-{package}-{version}/`

Example: `reports-breaking/2026-01-16-ctbase-0.17.0/`

**Files created**:

- `setup.md` - Detailed setup report
- `PR-comment.md` - PR comment for user to copy-paste
- `README.md` - Overview of the report directory (optional)
- `GUIDE.md` - Next steps guide (optional)

---

## Notes

- Use `// turbo` annotation for safe auto-run commands
- Always ask user confirmation for critical decisions
- Validate all information before proceeding
- Keep reports for traceability

---

## Example Complete Flow

```
User: I'm working on CTBase and it's breaking

Agent: [Step 1] Confirms: CTBase 0.16.4 → 0.17.0
Agent: [Step 2] Creates branch/issue/PR or gets existing info
Agent: [Step 3] Extracts graph, user confirms versions
Agent: [Step 4] Gets breakage results from PR
Agent: [Step 5] Classifies packages, user confirms
Agent: [Step 6] Generates setup report
Agent: [Step 7] Saves report + posts PR comment
Agent: [Step 8] Offers to run /breaking-action-plan

Result: Complete setup report ready for action plan generation
```
