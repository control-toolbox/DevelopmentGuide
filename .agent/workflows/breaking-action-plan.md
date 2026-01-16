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

**Input**: Path to setup report (e.g., `reports-breaking/ctbase-0.17.0-2026-01-16-setup.md`)

**Parse and extract**:
- Package name and versions
- Dependency graph
- Breakage test results
- Package classification (breaking vs compatible)
- Branch/issue/PR information

**Validate completeness**:
```
Setup report loaded:
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

**Filename**: `reports-breaking/{package}-{version}-{date}-plan.md`

Reuses base name from setup report, adds `-plan` suffix.

Example: `reports-breaking/ctbase-0.17.0-2026-01-16-plan.md`

**Content structure**:
```markdown
# Breaking Change Action Plan

**Generated**: 2026-01-16 19:45:00
**Based on**: reports-breaking/ctbase-0.17.0-2026-01-16-setup.md
**Package**: CTBase 0.16.4 → 0.17.0
**Complexity**: Complex (Foundation package with cascade)

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

- Setup report: [reports-breaking/ctbase-0.17.0-2026-01-16-setup.md](reports-breaking/ctbase-0.17.0-2026-01-16-setup.md)
- Methodology: [breaking-change-rules.md](../breaking-change-rules.md)
- Invariants: [invariants-analysis.md](../experiments/dependency-graph/invariants-analysis.md)
- Case study: [case-study-ctbase-cascading.md](../case-study-ctbase-cascading.md)
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

Plan saved to: reports-breaking/ctbase-0.17.0-2026-01-16-plan.md

Would you like me to show you the plan? (yes/no)
```

**If yes**: Display plan or key phases

**If no**: 
```
Plan ready! You can review it at:
reports-breaking/ctbase-0.17.0-2026-01-16-plan.md
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
User: /breaking-action-plan reports-breaking/ctbase-0.17.0-2026-01-16-setup.md

Agent: [Step 1] Reads and validates setup report
Agent: [Step 2] Loads methodology + invariants
Agent: [Step 3] Determines complexity: Complex
Agent: [Step 4] Generates 8 phases with details
Agent: [Step 5] Validates all invariants
Agent: [Step 6] Saves plan to reports-breaking/
Agent: [Step 7] Presents summary to user

Result: Complete action plan ready for execution
```
