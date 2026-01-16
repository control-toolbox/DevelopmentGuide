---
description: Methodological guide for creating breaking change action plans based on fundamental invariants
---

# Breaking Change Methodology Guide

This guide provides the **fundamental invariants and properties** that must hold true at each phase of a breaking change migration. Use this as your instruction manual when creating action plans.

> [!IMPORTANT]
> **Key Principle**: Case studies are examples. Your situation will be different. This guide provides the invariants that MUST be true for ANY migration to work.

---

## Required Reading (in order)

1. **First**: Read [`diamond-dependency.md`](../diamond-dependency.md) to understand Julia resolver mechanics and beta strategy
2. **Second**: Read the relevant case study based on breaking package position:
   - Leaf package (CTDirect, CTFlows, CTParser) → [`case-study-ctdirect-breaking.md`](../case-study-ctdirect-breaking.md)
   - Mid-layer package (CTModels) → [`case-study-ctmodels-breaking.md`](../case-study-ctmodels-breaking.md)
   - Foundation package (CTBase) → [`case-study-ctbase-cascading.md`](../case-study-ctbase-cascading.md)

> [!NOTE]
> For complete mathematical formulation, see the [invariants analysis document](../experiments/dependency-graph/invariants-analysis.md).

---

## Fundamental Invariants (MUST be true at ALL phases)

### Invariant 1: Non-Empty Intersection ⭐ CRITICAL

**Statement**: At every phase, for every package, the intersection of all compat constraints MUST be non-empty.

**Formal**: `∀ phase φ, ∀ package P: ⋂(compat constraints on P) ≠ ∅`

**Why**: This is the entire reason for the beta strategy. Without it, packages become uninstallable.

**Violation**: Breakage tests fail with "Unsatisfiable requirements" (not code errors).

**Check**: At each phase, verify resolver can find a solution for all packages.

---

### Invariant 2: Stable Closure

**Statement**: A stable version can only depend on stable versions.

**Formal**: `If package A (stable) requires package B (beta-only), then A must also be beta`

**Why**: Protects users from accidentally getting beta versions.

**Check**: Before releasing any stable version, verify all its dependencies are stable.

---

### Invariant 3: Stability Preference

**Statement**: When multiple versions satisfy constraints, the resolver prefers stable over pre-release.

**Result**: Users get stable versions unless forced to beta by constraints.

**Check**: After each phase, verify `Pkg.add("TopPackage")` gives expected stable versions.

---

### Invariant 4: Pre-release Visibility

**Statement**: Pre-releases are invisible to the resolver unless explicitly allowed in compat.

**Example**:
- `CTBase = "1"` → Only v1.x visible (v2 betas ignored)
- `CTBase = "1, 2.0.0-"` → Both v1.x and v2 betas visible

**Why**: Widening compat creates resolution paths that didn't exist before.

---

## Phase Properties

### Property 1: Widening Creates Paths (Monotonic)

**Statement**: Widening compat from `"1"` to `"1, 2.0.0-"` adds beta versions without removing stable versions.

**Formal**: `I_old ⊆ I_new` (intersection only grows)

**Application**: Widen compat BEFORE releasing beta to ensure resolution paths exist.

---

### Property 2: Forcing Constraint

**Statement**: If ANY package in the dependency chain has NOT widened, it forces the old stable version.

**Example**:
```
OptimalControl: CTBase ∈ {0.16, 0.17-}  ← Widened
CTDirect:       CTBase ∈ {0.16, 0.17-}  ← Widened
CTModels:       CTBase ∈ {0.16}         ← NOT widened

Intersection: {0.16, 0.17-} ∩ {0.16, 0.17-} ∩ {0.16} = {0.16}
Result: Users get CTBase 0.16.x ✅
```

**Why**: This protects users during migration - one un-widened package keeps everyone on old stable.

---

### Property 3: Beta Propagation

**Statement**: If package A requires beta version of B, then A must also be beta.

**Application**: When adapting to breaking change, release as beta until all dependencies are stable.

---

### Property 4: Stabilization Order (Bottom-Up)

**Statement**: Dependencies must be stabilized BEFORE dependents.

**Formal**: `For A → B: release_time(B stable) < release_time(A stable)`

**Why**: If A stable is released before B stable, A would depend on B beta, violating Invariant 2.

---

## Verification Checkpoints

### Checkpoint 1: Before Beta Release

**Verify**:
- ✓ All packages that work with both versions have widened compat
- ✓ Packages that break have NOT widened (still force old version)

**Why**: Ensures Invariant 1 (non-empty intersection) after beta release.

---

### Checkpoint 2: After Beta Release

**Verify**:
```julia
Pkg.add("TopPackage")
# Expected: Old stable versions ✅
```

**Also verify**:
- Breakage tests on widened packages have resolution paths (may fail on code)
- Breakage tests on non-widened packages fail with "Unsatisfiable" (expected)

---

### Checkpoint 3: Before Stabilization

**Verify**:
- ✓ All dependencies of package being stabilized are already stable

**Why**: Ensures Invariant 2 (stable closure).

---

### Checkpoint 4: After Stabilization

**Verify**:
```julia
Pkg.add("TopPackage")
# If all chain stabilized: New stable versions ✅
# Else: Old stable versions ✅ (protected by un-stabilized packages)
```

---

## Action Plan Template

For each phase in your action plan, use this template:

```markdown
### Phase X: [Description]

**Packages to modify**:
- PackageName: version X.Y.Z → X.Y.Z+1

**Project.toml changes**:
```toml
# PackageName/Project.toml
version = "X.Y.Z"
[compat]
Dependency = "A, B.0.0-"
```

**Actions**:
1. Modify Project.toml
2. Commit changes
3. Register version: `@JuliaRegistrator register`

**Verification**:
```julia
Pkg.add("TopPackage")
# Expected: [specific versions]
# Why: [which constraint forces this resolution]
```

**Invariant checks**:
- [ ] ⋂ constraints ≠ ∅ (Invariant 1)
- [ ] Stable → stable only (Invariant 2)
- [ ] Users get expected versions (Invariant 3)
```

---

## Common Anti-Patterns

### ❌ Anti-pattern 1: Premature Stabilization

**Violation**: Releasing A stable before dependency B stable

**Result**: Violates Invariant 2 (A stable depends on B beta)

**Detection**: Check release order matches dependency graph (bottom-up)

---

### ❌ Anti-pattern 2: Missing Widening

**Violation**: Package P works with both versions but compat not widened

**Result**: Violates Invariant 1 after beta release (empty intersection)

**Detection**: Breakage test fails with "Unsatisfiable" when it should pass

---

### ❌ Anti-pattern 3: Incorrect Widening

**Violation**: Package Q breaks with new version but compat widened anyway

**Result**: Users get broken code

**Detection**: Code breaks at runtime (not caught by resolver)

---

## Action Timing Guidelines

| Action | When | Why |
|--------|------|-----|
| Compat widening | BEFORE releasing beta | Creates resolution paths |
| Beta release | AFTER widening registered | Ensures paths exist |
| Adaptation | Can be parallel (all as beta) | No ordering between siblings |
| Stabilization | MUST be bottom-up | Maintains stable closure |
| Registry registration | After each Project.toml change | Makes versions available |

---

## Summary: The Golden Rule

> **At every phase, verify Invariant 1 (non-empty intersection).**
> 
> If ⋂ ≠ ∅ holds, the migration will work.

The beta strategy works because:
1. Widening creates paths (Property 1) without disrupting users
2. Un-widened packages force old stable (Property 2) protecting users
3. Betas are invisible (Invariant 4) unless explicitly allowed
4. Stable prefers stable (Invariant 3) keeping users safe
5. Bottom-up stabilization (Property 4) maintains stable closure

---

## References

- [Diamond Dependency Problem](../diamond-dependency.md)
- [Invariants Analysis](../experiments/dependency-graph/invariants-analysis.md)
- [Case Study: CTDirect](../case-study-ctdirect-breaking.md)
- [Case Study: CTModels](../case-study-ctmodels-breaking.md)
- [Case Study: CTBase](../case-study-ctbase-cascading.md)
