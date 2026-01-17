---
description: Generate detailed phase-by-phase migration plan based on setup report
---

# Breaking Change Action Plan Workflow

This workflow generates a detailed, phase-by-phase migration plan based on the setup report from `/breaking-setup`.

## When to Use

- After completing `/breaking-setup` workflow
- You have a setup report in `reports-breaking/`
- Ready to create detailed migration plan

## Prerequisites

- Setup report from `/breaking-setup`
- Access to methodology guide (`breaking-change-rules.md`)
- Understanding of invariants (see `experiments/dependency-graph/invariants-analysis.md`)

---

## Workflow Steps

### Step 1: Read Setup Report

**Input**: Path to setup report **directory** (e.g., `reports-breaking/2026-01-16-ctbase-0.17.0`)

**Note**: The workflow now accepts a directory path instead of a file path. This allows all migration files to be organized together.

**Read setup report**:

- File: `{report_dir}/setup.md`
- Example: `reports-breaking/2026-01-16-ctbase-0.17.0/setup.md`

**Parse and extract**:

- Package name and versions
- Dependency graph
- Breakage test results
- Package classification (breaking vs compatible)
- Branch/issue/PR information
- Report directory path

**Store for later use**:

```
REPORT_DIR="{report_dir}"  # e.g., "reports-breaking/2026-01-16-ctbase-0.17.0"
```

**Validate completeness**:
```
Setup report loaded from: {REPORT_DIR}/setup.md

- Package: CTBase 0.16.4 → 0.17.0
- Breaking packages: CTModels, CTDirect
- Compatible packages: CTFlows, CTParser, OptimalControl
- Dependency graph: [validated]

Report complete ✅
```

---

### Step 2: Load Methodology Guide

**Read required documents**:
1. `breaking-change-rules.md` - Methodology guide
2. `experiments/dependency-graph/invariants-analysis.md` - Invariants
3. Relevant case study based on package position

**Determine package position**:
- **Leaf**: CTDirect, CTFlows, CTParser (no CT packages depend on them)
- **Mid-layer**: CTModels (some CT packages depend on it)
- **Foundation**: CTBase (all CT packages depend on it)

**Select case study**:
```
Package position: Foundation (CTBase)
Relevant case study: case-study-ctbase-cascading.md
Complexity: Complex (full cascade)
```

---

### Step 3: Determine Migration Complexity

Based on dependency graph and breaking packages:

**Simple** (Leaf package):
- Example: CTDirect breaking
- Pattern: Single package update
- Phases: ~3-5

**Medium** (Mid-layer):
- Example: CTModels breaking
- Pattern: Multiple dependents need adaptation
- Phases: ~5-7

**Complex** (Foundation with cascade):
- Example: CTBase breaking
- Pattern: Full cascade through multiple layers
- Phases: ~7-10

**Present to user**:
```
Migration complexity: Complex
Estimated phases: 8
Cascade depth: 3 (CTBase → CTModels → CTDirect)

This will require:
1. Preparation (widen compatible packages)
2. CTBase beta release
3. CTModels beta adaptation
4. CTDirect beta adaptation
5. CTBase stabilization
6. CTModels stabilization
7. CTDirect stabilization
8. OptimalControl cleanup
```

---

### Step 4: Generate Phase-by-Phase Plan

For each phase, generate detailed instructions following the template from `breaking-change-rules.md`.

**Use invariants for validation**:
- Invariant 1: ⋂ constraints ≠ ∅ (verify at each phase)
- Invariant 2: Stable → stable only
- Property 4: Bottom-up stabilization

**Phase template**:
```markdown
### Phase X: [Description]

**Objective**: [What this phase accomplishes]

**Packages to modify**:
- PackageName: version X.Y.Z → X.Y.Z+1

**Project.toml changes**:

#### PackageName/Project.toml
```toml
version = "X.Y.Z"
[compat]
Dependency = "A, B.0.0-"
```

**Actions**:
1. Modify Project.toml as shown above
2. Commit changes: `git commit -am "Prepare for PackageName X.Y.Z"`
3. Push: `git push`
4. Register: Comment `@JuliaRegistrator register` on commit

**Verification**:
```julia
using Pkg
Pkg.add("OptimalControl")
# Expected: [specific versions]
# Why: [constraint explanation]
```

**Invariant checks**:
- [ ] ⋂ constraints ≠ ∅ (Invariant 1) - [explain why]
- [ ] Stable → stable only (Invariant 2) - [verify]
- [ ] Users get expected versions (Invariant 3) - [verify]

**Expected breakage results**:
- Package X: ✅ (widened, should pass)
- Package Y: ❌ (not widened, expected to fail)
```

---

### Step 5: Validate Plan Against Invariants

For each phase, verify:

**Invariant 1**: Non-empty intersection
```
Phase 1: Widening
- OptimalControl: CTBase ∈ {0.16, 0.17-}
- CTFlows: CTBase ∈ {0.16, 0.17-}
- CTModels: CTBase ∈ {0.16}  ← Forces 0.16
Intersection: {0.16} ✅ Non-empty
```

**Invariant 2**: Stable closure
```
Phase 3: CTModels beta
- CTModels 0.7.0-beta.1 requires CTBase 0.17.0-
- CTModels is beta ✅
- Stable closure maintained
```

**Property 4**: Stabilization order
```
Phase 5-7: Stabilization
- CTBase 0.17.0 (stable) - First ✅
- CTModels 0.7.0 (stable) - Second ✅ (after CTBase)
- CTDirect 0.18.0 (stable) - Third ✅ (after CTModels)
Order correct: bottom-up ✅
```

**Present validation summary**:
```
Plan validation:
✅ All phases have non-empty intersections
✅ Stable closure maintained throughout
✅ Stabilization order correct (bottom-up)
✅ User protection verified at each phase

Plan is valid ✅
```

---

### Step 6: Generate Action Plan File

**Filename**: `${REPORT_DIR}/action-plan.md`

Example: `reports-breaking/2026-01-16-ctbase-0.17.0/action-plan.md`

**Note**: The plan is saved in the same directory as the setup report for easy organization.

**For beta-based migrations**, include local registry instructions at the beginning of the plan:

**Content structure**:
```markdown
# Breaking Change Action Plan

**Generated**: 2026-01-16 19:45:00
**Based on**: {REPORT_DIR}/setup.md
**Package**: CTBase 0.16.4 → 0.17.0
**Complexity**: Complex (Foundation package with cascade)

---

## Compat Strategy Guidance

When widening compat bounds for foundation packages, choose the appropriate strategy:

### Progressive Widening (Recommended for Foundation Packages)

Use `DependencyName = "old, new"` (e.g., `CTBase = "0.16, 0.17"`) when:

✅ **Use when**:
- Package is a foundation package (many dependents)
- Tests confirm compatibility with both versions
- Releasing a patch version (respecting SemVer)
- Want to provide smooth transition period

✅ **Advantages**:
- Backward compatibility maintained
- Users can migrate at their own pace
- Safety net if new version has issues
- Respects SemVer (patch = no breaking)

❌ **Trade-offs**:
- Longer maintenance period
- Must test with both versions

### Direct Migration

Use `DependencyName = "new"` (e.g., `CTBase = "0.17"`) when:

⚠️ **Use when**:
- Releasing a major/minor version (breaking change)
- Old version has critical bugs/security issues
- New version has essential features
- After a transition period (e.g., 6 months)

✅ **Advantages**:
- Forces adoption of new version
- Simpler maintenance (one version)
- Clear migration path

❌ **Trade-offs**:
- Breaks backward compatibility
- Forces immediate migration
- No fallback if issues arise

### Recommendation for This Migration

For foundation packages like CTBase:
1. **Initial release** (patch): Use progressive widening `"0.16, 0.17"`
2. **After transition** (6+ months, major): Use direct migration `"0.17"`

**Example**:
```toml
# CTDirect v0.17.5 (now - patch release)
CTBase = "0.16, 0.17"  # Progressive widening

# CTDirect v0.18.0 (later - major release)
CTBase = "0.17"  # Direct migration
```

---

## 📦 Local Registry Setup (Required for Beta Releases)

All beta versions in this migration will be registered in **ct-registry** (local registry) instead of the General registry.

### Why Use Local Registry for Betas?

- ✅ **Faster**: No waiting for General registry processing (~10-30 min delay)
- ✅ **Isolated**: Beta versions don't pollute the General registry
- ✅ **Flexible**: Easy to update/remove beta versions if needed

### One-Time Setup

Add ct-registry to your Julia environment (only needed once):

**SSH** (recommended):
```julia
pkg> registry add git@github.com:control-toolbox/ct-registry.git
```

**HTTPS**:

```julia
pkg> registry add https://github.com/control-toolbox/ct-registry.git
```

Install LocalRegistry.jl:

```julia
pkg> add LocalRegistry
```

### How to Register a Beta Version

When a phase instructs you to register a beta version:

1. **Update `Project.toml`** with the beta version number
2. **Commit and push** to GitHub
3. **Register in ct-registry**:

```julia
using LocalRegistry
using YourPackage  # e.g., using CTModels
register(YourPackage, 
         registry = "ct-registry",
         repo = "git@github.com:org/YourPackage.jl.git")
```

**Note**:

- If the package is **already in ct-registry**, you can omit the `repo` parameter
- If it's the **first time** registering in ct-registry (even if it exists in General registry), you must specify `repo`
- Example: `repo = "git@github.com:control-toolbox/CTModels.jl.git"`

1. **Create GitHub tag** manually:

```bash
git tag v0.6.10-beta
git push origin v0.6.10-beta
```

**Note**: For stable (non-beta) releases, use `@JuliaRegistrator register()` as usual.

---

## Summary

**Migration overview**:

- Breaking package: CTBase (foundation)
- Cascade: CTBase → CTModels → CTDirect
- Total phases: 8
- Estimated duration: 2-3 weeks

**Affected packages**:

- Breaking: CTModels, CTDirect
- Compatible: CTFlows, CTParser, OptimalControl

---

## Phase 1: Preparation

[Detailed phase instructions as per template]

---

## Phase 2: CTBase Beta Release

[Detailed phase instructions]

---

[... all phases ...]

---

## Verification Checklist

- [ ] Phase 1: Preparation complete
- [ ] Phase 2: CTBase beta released
- [ ] Phase 3: CTModels beta released
- [ ] Phase 4: CTDirect beta released
- [ ] Phase 5: CTBase stabilized
- [ ] Phase 6: CTModels stabilized
- [ ] Phase 7: CTDirect stabilized
- [ ] Phase 8: OptimalControl updated

---

## References

- Setup report: [{REPORT_DIR}/setup.md]({REPORT_DIR}/setup.md)
- Methodology: [breaking-change-rules.md](../../breaking-change-rules.md)
- Invariants: [invariants-analysis.md](../../experiments/dependency-graph/invariants-analysis.md)
- Case study: [case-study-ctbase-cascading.md](../../case-study-ctbase-cascading.md)

```

---

### Step 7: Present Plan to User

**Show summary**:
```
Action plan generated!

Summary:
- 8 phases total
- Complexity: Complex (foundation package)
- Cascade: CTBase → CTModels → CTDirect
- All invariants validated ✅

Plan saved to: {REPORT_DIR}/action-plan.md

Would you like me to show you the plan? (yes/no)
```

**If yes**: Display plan or key phases

**If no**: 
```
Plan ready! You can review it at:
{REPORT_DIR}/action-plan.md

All migration files are in: {REPORT_DIR}/
```

---

## Example Phase Generation

### Phase 1: Preparation (Widening)

```markdown
### Phase 1: Preparation

**Objective**: Widen compat in packages that work with both CTBase 0.16 and 0.17.

**Packages to modify**:
- CTFlows: 0.8.9 → 0.8.10
- CTParser: 0.7.1 → 0.7.2
- OptimalControl: 1.1.6 → 1.1.7

**Project.toml changes**:

#### CTFlows/Project.toml
```toml
version = "0.8.10"
[compat]
CTBase = "0.16, 0.17.0-"  # Widened
CTModels = "0.6, 0.7.0-"  # Widened
```

#### CTParser/Project.toml
```toml
version = "0.7.2"
[compat]
CTBase = "0.16, 0.17.0-"  # Widened
CTModels = "0.6, 0.7.0-"  # Widened
```

#### OptimalControl/Project.toml
```toml
version = "1.1.7"
[compat]
CTBase = "0.16, 0.17.0-"
CTDirect = "0.17, 0.18.0-"
CTFlows = "0.8, 0.9.0-"
CTModels = "0.6, 0.7.0-"
CTParser = "0.7, 0.8.0-"
```

**Actions**:
1. For each package, modify Project.toml as shown
2. Commit: `git commit -am "Widen compat for CTBase 0.17 migration"`
3. Push: `git push`
4. Register each package: `@JuliaRegistrator register`

**Verification**:
```julia
using Pkg
Pkg.add("OptimalControl")
# Expected: CTBase 0.16.4, CTModels 0.6.9, CTDirect 0.17.4
# Why: CTModels 0.6.9 forces CTBase ∈ {0.16} (not widened yet)
```

**Invariant checks**:
- [x] ⋂ constraints ≠ ∅ - Intersection = {0.16} (non-empty)
- [x] Stable → stable only - All packages stable, all deps stable
- [x] Users get old stable - CTBase 0.16.4 (forced by CTModels)

**Expected breakage results**:
- Not applicable (no beta released yet)
```

---

## Notes

- **Do NOT post plan to PR** (too long, keep in file)
- Plan file is the source of truth
- User can reference plan during migration
- Update checklist as phases complete

---

## Validation Rules

Before generating plan, ensure:
1. Setup report is complete
2. All packages classified correctly
3. Dependency graph validated
4. Methodology guide loaded

During plan generation:
1. Verify invariants at each phase
2. Check stabilization order
3. Validate expected breakage results
4. Ensure resolution paths exist

---

## Example Complete Flow

```
User: /breaking-action-plan reports-breaking/2026-01-16-ctbase-0.17.0

Agent: [Step 1] Reads setup report from reports-breaking/2026-01-16-ctbase-0.17.0/setup.md
Agent: [Step 2] Loads methodology + invariants
Agent: [Step 3] Determines complexity: Complex
Agent: [Step 4] Generates 8 phases with details
Agent: [Step 5] Validates all invariants
Agent: [Step 6] Saves plan to reports-breaking/2026-01-16-ctbase-0.17.0/action-plan.md
Agent: [Step 7] Presents summary to user

Result: Complete action plan ready for execution
```
