# Case Study: CTModels Breaking Change (0.6.9 → 0.7.0)

## Fundamental Principles

> [!CAUTION]
> **1. A stable version must only depend on stable versions.**
>
> **2. Only widen compat if your code ACTUALLY works with both versions.**

---

## Initial State

```text
OptimalControl: 1.1.6
CTBase:         0.16.4
CTDirect:       0.17.4
CTFlows:        0.8.9
CTModels:       0.6.9
CTParser:       0.7.1
```

**Dependency graph:**

```text
OptimalControl 1.1.6
    ├── CTDirect 0.17.4 ──┬── CTModels 0.6.9 ── CTBase 0.16.4
    ├── CTFlows 0.8.9 ────┤
    ├── CTModels 0.6.9 ───┘
    └── CTParser 0.7.1 ───── CTModels 0.6.9
```

**Scenario**: CTModels needs breaking changes for version 0.7.0.

**Impact analysis**:

| Package | Uses changed API? | Action |
|---------|-------------------|--------|
| CTDirect | ❌ Yes | Must adapt, don't widen old version |
| CTParser | ❌ Yes | Must adapt, don't widen old version |
| CTFlows | ✅ No | Code works with both, widen compat |
| OptimalControl | ✅ No | Works with new CTDirect/CTParser, widen compat |

---

## Phase 1: Preparation

**Objective**: Prepare ecosystem for upcoming beta.

> [!IMPORTANT]
> **Only packages whose code works with both versions should widen their compat.**

### Step 1.1: CTFlows (works with both)

CTFlows uses CTModels API that is unchanged.

```toml
# CTFlows/Project.toml
version = "0.8.10"
[compat]
CTModels = "0.6, 0.7.0-"  # ✅ Code works with both
CTBase = "0.16"
```

**Action**: Register CTFlows 0.8.10

### Step 1.2: CTDirect (breaks)

CTDirect uses CTModels API that is changed. **DO NOT widen.**

```toml
# CTDirect/Project.toml
version = "0.17.4"  # No change
[compat]
CTModels = "0.6"  # ❌ Keep unchanged - code doesn't work with 0.7
CTBase = "0.16"
```

**Action**: No registration needed

### Step 1.3: CTParser (breaks)

CTParser uses CTModels API that is changed. **DO NOT widen.**

```toml
# CTParser/Project.toml
version = "0.7.1"  # No change
[compat]
CTModels = "0.6"  # ❌ Keep unchanged - code doesn't work with 0.7
CTBase = "0.16"
```

**Action**: No registration needed

### Step 1.4: OptimalControl

OptimalControl works with both old and new CTDirect/CTParser.

```toml
# OptimalControl/Project.toml
version = "1.1.7"
[compat]
CTDirect = "0.17, 0.18.0-"  # Accept future versions
CTParser = "0.7, 0.8.0-"
CTFlows = "0.8"
CTModels = "0.6, 0.7.0-"
```

**Action**: Register OptimalControl 1.1.7

### Verification

```julia
Pkg.add("OptimalControl")
# Constraints:
#   OptimalControl: CTModels ∈ {0.6, 0.7-}
#   CTFlows:        CTModels ∈ {0.6, 0.7-}
#   CTDirect:       CTModels ∈ {0.6}       ← Forces 0.6
#   CTParser:       CTModels ∈ {0.6}       ← Forces 0.6
# Intersection: {0.6}
# Result: CTModels 0.6.9 ✅
```

---

## Phase 2: CTModels Beta Release

```toml
# CTModels/Project.toml
version = "0.7.0-beta.1"
[compat]
CTBase = "0.16"
```

**Action**: Register CTModels 0.7.0-beta.1

### Verification

```julia
Pkg.add("OptimalControl")
# CTDirect 0.17.4 and CTParser 0.7.1 still force CTModels ∈ {0.6}
# Result: CTModels 0.6.9 ✅ (user unaffected)
```

---

## Phase 3: Adaptation (Parallel)

**Objective**: Adapt breaking packages as betas.

### Step 3.1: CTDirect Beta

```toml
# CTDirect/Project.toml
version = "0.18.0-beta.1"  # Beta - requires beta CTModels
[compat]
CTModels = "0.7.0-"
CTBase = "0.16"
```

**Action**: Register CTDirect 0.18.0-beta.1

### Step 3.2: CTParser Beta

```toml
# CTParser/Project.toml
version = "0.8.0-beta.1"  # Beta - requires beta CTModels
[compat]
CTModels = "0.7.0-"
CTBase = "0.16"
```

**Action**: Register CTParser 0.8.0-beta.1

### Verification

```julia
Pkg.add("OptimalControl")
# Resolver prefers stable: CTDirect 0.17.4, CTParser 0.7.1
# These force CTModels ∈ {0.6}
# Result: CTModels 0.6.9 ✅ (user still unaffected)
```

---

## Phase 3b: OptimalControl Beta (Optional)

**Objective**: Allow developers to test the full beta stack via OptimalControl.

> [!TIP]
> This step is useful to let external developers test the entire beta ecosystem easily.

```toml
# OptimalControl/Project.toml
version = "1.2.0-beta.1"  # Beta - requires beta dependencies
[compat]
CTDirect = "0.18.0-"
CTParser = "0.8.0-"
CTFlows = "0.8"
CTModels = "0.7.0-"
```

**Action**: Register OptimalControl 1.2.0-beta.1

### Verification

```julia
# Regular user
Pkg.add("OptimalControl")
# Gets: OptimalControl 1.1.7 + CTModels 0.6.9 ✅ (stable)

# Developer testing betas
Pkg.add(name="OptimalControl", version="1.2.0-beta.1")
# Gets: OptimalControl 1.2.0-beta.1 + CTDirect 0.18.0-beta.1 + 
#       CTParser 0.8.0-beta.1 + CTModels 0.7.0-beta.1 ✅ (full beta stack)
```

---

## Phase 4: CTModels Stabilization

```toml
# CTModels/Project.toml
version = "0.7.0"
[compat]
CTBase = "0.16"
```

**Action**: Register CTModels 0.7.0

### Verification

```julia
Pkg.add("OptimalControl")
# CTDirect 0.17.4 requires CTModels ∈ {0.6}
# CTParser 0.7.1 requires CTModels ∈ {0.6}
# These constraints still limit to 0.6!
# Result: CTModels 0.6.9 ✅ (user still gets old stable)
```

---

## Phase 5: CTDirect and CTParser Stabilization

> [!WARNING]
> **Order**: CTModels 0.7.0 must be registered BEFORE these.

### Step 5.1: CTDirect Stable

```toml
# CTDirect/Project.toml
version = "0.18.0"
[compat]
CTModels = "0.7"
CTBase = "0.16"
```

**Action**: Register CTDirect 0.18.0

### Step 5.2: CTParser Stable

```toml
# CTParser/Project.toml
version = "0.8.0"
[compat]
CTModels = "0.7"
CTBase = "0.16"
```

**Action**: Register CTParser 0.8.0

### Verification

```julia
Pkg.add("OptimalControl")
# Resolver now has: CTDirect 0.17.4 OR 0.18.0, CTParser 0.7.1 OR 0.8.0
# Prefers maximum stable: CTDirect 0.18.0, CTParser 0.8.0
# These require CTModels ∈ {0.7}
# Result: CTModels 0.7.0 ✅ (ecosystem upgraded)
```

---

## Phase 6: OptimalControl Update (Optional)

**Objective**: Clean up compat to require new stable versions only.

```toml
# OptimalControl/Project.toml
version = "1.1.8"
[compat]
CTDirect = "0.18"
CTParser = "0.8"
CTFlows = "0.8"
CTModels = "0.7"
```

**Action**: Register OptimalControl 1.1.8

---

## Summary

| Phase | What happens | User gets |
|-------|--------------|-----------|
| 1. Preparation | CTFlows + OptimalControl widen | CTModels 0.6.9 |
| 2. Beta | CTModels 0.7.0-beta.1 | CTModels 0.6.9 |
| 3. Adaptation | CTDirect + CTParser betas | CTModels 0.6.9 |
| 4. CTModels Stable | CTModels 0.7.0 | CTModels 0.6.9 |
| 5. Full Stable | CTDirect 0.18.0 + CTParser 0.8.0 | CTModels 0.7.0 |
| 6. Cleanup | OptimalControl 1.1.8 | CTModels 0.7.0 |

**Key insight**: Users only get CTModels 0.7.0 after ALL dependent packages are stable.

---

## Final State

```text
OptimalControl: 1.1.8
CTBase:         0.16.4
CTDirect:       0.18.0
CTFlows:        0.8.10
CTModels:       0.7.0
CTParser:       0.8.0
```

---

## CI Breakage Testing

The [breakage.yml](https://github.com/control-toolbox/CTActions/blob/main/.github/workflows/breakage.yml) action tests dependent packages with your dev version.

### Phase 2: CTModels 0.7.0-beta.1 on dev branch

```text
Breakage on CTDirect:
  CTDirect 0.17.4: CTModels ∈ {0.6}  ← Not widened!
  Dev CTModels: 0.7.0-beta.1
  → Intersection: ∅  ← Empty!
  → Breakage FAILS (expected - CTDirect needs adaptation)

Breakage on CTFlows:
  CTFlows 0.8.10: CTModels ∈ {0.6, 0.7.0-}  ← Widened
  Dev CTModels: 0.7.0-beta.1
  → Resolution path: CTModels 0.7.0-beta.1 ✅
  → Tests confirm CTFlows works with new CTModels
```

### Phase 3: CTDirect 0.18.0-beta.1 on dev branch

```text
Breakage on OptimalControl:
  OptimalControl 1.1.7: CTDirect ∈ {0.17, 0.18.0-}, CTModels ∈ {0.6, 0.7.0-}
  Dev CTDirect: 0.18.0-beta.1 (requires CTModels 0.7.0-)
  → Resolution path: CTDirect 0.18.0-beta.1 + CTModels 0.7.0-beta.1 ✅
  → Tests confirm OptimalControl works with new stack
```

> [!TIP]
> Breakage failures during Phase 2 are **expected** for packages that need adaptation (CTDirect, CTParser). The widening in Phase 1 ensures packages that work with both versions (CTFlows) pass breakage tests.

---

## Checklist

- [ ] Identify which packages break (need adaptation) vs. which work with both
- [ ] Widen compat ONLY in packages that work with both versions
- [ ] Release base package beta (CTModels)
- [ ] Adapt breaking packages as betas (CTDirect, CTParser)
- [ ] Release base package stable FIRST (CTModels)
- [ ] Release adapted packages stable AFTER (CTDirect, CTParser)
- [ ] Update top package compat (OptimalControl)
- [ ] **Verify breakage action: expected failures for breaking packages, passes for widened packages**
