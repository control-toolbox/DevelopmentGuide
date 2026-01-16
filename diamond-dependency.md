# The Diamond Dependency Problem in Julia

## Overview

The diamond dependency problem occurs when a top-level package depends on multiple packages that share a common dependency, but require different versions of it.

```
    OptimalControl (A)
       /    |    \
      /     |     \
  CTDirect CTFlows CTParser (B, D, E)
      \     |     /
       \    |    /
        CTBase (C)
```

**Problem**: When CTBase releases a breaking change (v1 → v2), how do we test OptimalControl with updated packages without breaking the ecosystem?

## Julia Resolver Mechanics

### Resolution Algorithm

Julia's `Pkg.jl` resolver follows this order:

1. **Pre-release Filtering**: By default, pre-releases are **completely ignored**
2. **Constraint Intersection**: Find versions satisfying all dependencies
3. **Stability Preference**: Prefer stable over pre-release when both available
4. **Maximum Selection**: Choose highest version within stability class

### Pre-release Behavior

**Key insight**: Pre-releases are invisible unless explicitly allowed in compat.

```toml
# This IGNORES all v2 pre-releases
[compat]
CTBase = "1"

# This ALLOWS v2 pre-releases
[compat]
CTBase = "1, 2.0.0-"
```

### Intersection Rules

The resolver finds the **intersection** of all constraints:

```julia
# Example
OptimalControl requires: CTBase ∈ {v1}
CTDirect requires:       CTBase ∈ {v2}
# Intersection: {v1} ∩ {v2} = ∅ → UNSATISFIABLE ❌
```

### Stability Preference

When intersection contains both stable and pre-release:

```julia
Intersection = {v1, v2-beta.1} → Choose v1 (stable preferred)
Intersection = {v2-beta.1}     → Choose v2-beta.1 (only option)
```

## The Problem: Blocked Updates

### Scenario

1. **Initial state**: All packages use CTBase v1
2. **CTBase v2 released** (breaking change)
3. **CTDirect updated** to require CTBase v2
4. **Try to test OptimalControl** with new CTDirect

**Result**:

```julia
OptimalControl v1: CTBase ∈ {v1}
CTDirect v2:       CTBase ∈ {v2}
# Intersection: ∅ → UNSATISFIABLE ❌
```

**Cannot test integration!**

## The Solution: Beta Strategy

### Phase 1: Preventive Widening

**Before** releasing CTBase v2, widen compat in all dependent packages:

```toml
# OptimalControl, CTDirect, CTFlows, CTParser
[compat]
CTBase = "1, 2.0.0-"  # Accept v1 AND v2 pre-releases
```

**Effect**: Users still get v1 (stable preferred), but v2 betas are now allowed.

### Phase 2: Release Beta

```bash
# Release CTBase v2-beta.1
```

**User installation**:

```julia
Pkg.add("OptimalControl")
# Intersection: {v1, v2-}
# Available: {v1, v2-beta.1}
# Choose: v1 (stable preferred) ✅
```

**No disruption for users!**

### Phase 3: Update Dependent Packages

```toml
# CTDirect v2
[compat]
CTBase = "2.0.0-"  # Require v2 beta
```

**Integration test**:

```julia
# OptimalControl v1.1 + CTDirect v2
OptimalControl: CTBase ∈ {v1, v2-}  ← Widened
CTDirect:       CTBase ∈ {v2-}      ← Forces beta
# Intersection: {v2-}
# Available: {v2-beta.1}
# Choose: v2-beta.1 ✅
```

**Integration testing now works!**

### Phase 4: Stable Release

```bash
# Release CTBase v2 (stable)
```

**Resolution**:

```julia
# With updated packages
Intersection: {v2-}
Available: {v2-beta.1, v2}
Choose: v2 (stable preferred) ✅
```

## Why This Works

### Betas Create Resolution Paths

**Without beta**:

```
Intersection = ∅ → UNSATISFIABLE
```

**With beta**:

```
Intersection = {v2-beta} → SATISFIABLE
```

### Users Are Protected

The resolver **prefers stable** versions, so:

- Regular users get v1 (stable)
- Developers testing new versions get v2-beta (only option in intersection)
- After v2 stable release, everyone migrates smoothly

### Gradual Migration

```
Time 1: Everyone on v1 (stable)
Time 2: Beta available, users still on v1
Time 3: Some packages migrate to v2-beta
Time 4: v2 stable released
Time 5: Ecosystem migrates to v2
```

## Practical Workflow for control-toolbox

### 1. Before Breaking Change in CTBase

```bash
# Widen compat in all dependent packages
# CTDirect, CTFlows, CTParser, CTModels, OptimalControl
```

```toml
[compat]
CTBase = "1, 2.0.0-"
```

### 2. Release CTBase Beta

```bash
cd CTBase
# Make breaking changes
# Update version to 2.0.0-beta.1
# Register
```

### 3. Update Dependent Packages

```bash
cd CTDirect
# Adapt to CTBase v2
```

```toml
[compat]
CTBase = "2.0.0-"  # Require v2
```

### 4. Test Integration

```julia
using Pkg
Pkg.develop(path="path/to/OptimalControl")
Pkg.test("OptimalControl")
# Will use CTBase v2-beta.1 ✅
```

### 5. Release Stable

```bash
cd CTBase
# Update version to 2.0.0
# Register
```

## Key Takeaways

1. **Pre-releases are invisible** unless explicitly allowed in compat
2. **Widening creates paths** that didn't exist before
3. **Betas don't replace stables** - they're fallback options
4. **Preventive action** is essential - widen before releasing beta
5. **Users are protected** by stable preference in resolver

## Summary

The beta strategy solves the diamond dependency problem by:

- **Widening compat** preventively to allow future betas
- **Using betas** as resolution paths during migration
- **Protecting users** through resolver's stable preference
- **Enabling gradual migration** across the ecosystem

This allows independent package development while maintaining ecosystem stability.
