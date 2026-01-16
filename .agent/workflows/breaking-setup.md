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

**Create temporary environment and extract graph**:

```bash
// turbo
mkdir -p /tmp/ct-graph-$$
cd /tmp/ct-graph-$$

julia --project=. -e '
using Pkg, Dates

println("Installing OptimalControl to get dependency graph...")
Pkg.add("OptimalControl")

println("\nExtracting dependency graph...")
deps = Pkg.dependencies()
ct_pkgs = filter(p -> startswith(p.second.name, "CT") || 
                      p.second.name == "OptimalControl", deps)

println("\n=== Dependency Graph ===\n")
for (uuid, pkg) in sort(collect(ct_pkgs), by=p->p.second.name)
    println("$(pkg.second.name) v$(pkg.second.version)")
    if !isnothing(pkg.second.dependencies)
        for (dep_name, dep_uuid) in pkg.second.dependencies
            if haskey(deps, dep_uuid) && 
               (startswith(deps[dep_uuid].name, "CT") || 
                deps[dep_uuid].name == "OptimalControl")
                println("  → $(deps[dep_uuid].name) v$(deps[dep_uuid].version)")
            end
        end
    end
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

**Filename**: `reports-breaking/{package}-{version}-{date}-setup.md`

Example: `reports-breaking/ctbase-0.17.0-2026-01-16-setup.md`

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

Ready for action plan generation. Run `/breaking-action-plan` with this report.
```

---

### Step 7: Archive Report

1. **Save report** to `reports-breaking/` directory

```bash
// turbo
mkdir -p reports-breaking
# Save report content to file
```

2. **Post PR comment summary**:

```markdown
## 🔧 Breaking Change Setup Complete

Setup report generated: `reports-breaking/ctbase-0.17.0-2026-01-16-setup.md`

**Summary**:
- **Breaking packages**: CTModels, CTDirect
- **Compatible packages**: CTFlows, CTParser, OptimalControl

**Next step**: Run `/breaking-action-plan` to generate migration plan.
```

Use `gh` CLI to post comment:
```bash
gh pr comment {pr_number} --body "[comment text]"
```

---

### Step 8: Transition to Workflow 2

**Ask user**: "Setup complete. Generate action plan now?" (yes/no)

**If yes**: Automatically invoke `/breaking-action-plan` with report path:
```
/breaking-action-plan reports-breaking/ctbase-0.17.0-2026-01-16-setup.md
```

**If no**: 
```
Setup complete! You can generate the action plan later by running:
/breaking-action-plan reports-breaking/ctbase-0.17.0-2026-01-16-setup.md
```

---

## Output Files

- `reports-breaking/{package}-{version}-{date}-setup.md` - Detailed setup report
- PR comment - Summary with link to report

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
