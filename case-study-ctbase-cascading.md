# Case Study: CTBase Cascading Breaking Change (0.16.4 → 0.17.0)

## Fundamental Principles

> [!CAUTION]
> **1. A stable version must only depend on stable versions.**
>
> **2. Only widen compat if your code ACTUALLY works with both versions.**
>
> **3. Release dependencies stable BEFORE dependents stable.**

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
    │                     └── CTBase 0.16.4
    ├── CTFlows 0.8.9 ────┬── CTModels 0.6.9
    │                     └── CTBase 0.16.4
    ├── CTModels 0.6.9 ───── CTBase 0.16.4
    └── CTParser 0.7.1 ───┬── CTModels 0.6.9
                          └── CTBase 0.16.4
```

**Scenario**: CTBase needs breaking changes for version 0.17.0.

**Cascading impact**:

```text
CTBase 0.17.0
    └── breaks CTModels → CTModels 0.7.0
            └── breaks CTDirect → CTDirect 0.18.0
                    └── doesn't break OptimalControl ✅
```

**Impact analysis**:

| Package | Broken by CTBase? | Broken by CTModels? | Action |
|---------|-------------------|---------------------|--------|
| CTModels | ❌ Yes | - | Must adapt to CTBase 0.17 |
| CTDirect | ✅ No (direct) | ❌ Yes | Must adapt to CTModels 0.7 |
| CTFlows | ✅ No | ✅ No | Widen both CTBase and CTModels |
| CTParser | ✅ No | ✅ No | Widen both CTBase and CTModels |
| OptimalControl | ✅ No | ✅ No | Widen all compats |

---

## Phase 1: Preparation

**Objective**: Widen compat for packages that work with both versions.

### Step 1.1: CTFlows (works with both CTBase and CTModels)

```toml
# CTFlows/Project.toml
version = "0.8.10"
[compat]
CTBase = "0.16, 0.17.0-"    # ✅ Works with both
CTModels = "0.6, 0.7.0-"    # ✅ Works with both
```

**Action**: Register CTFlows 0.8.10

### Step 1.2: CTParser (works with both CTBase and CTModels)

```toml
# CTParser/Project.toml
version = "0.7.2"
[compat]
CTBase = "0.16, 0.17.0-"    # ✅ Works with both
CTModels = "0.6, 0.7.0-"    # ✅ Works with both
```

**Action**: Register CTParser 0.7.2

### Step 1.3: CTDirect (works with both CTBase, but NOT CTModels)

```toml
# CTDirect/Project.toml
version = "0.17.5"
[compat]
CTBase = "0.16, 0.17.0-"    # ✅ Works with both
CTModels = "0.6"            # ❌ Keep unchanged - breaks with 0.7
```

**Action**: Register CTDirect 0.17.5

### Step 1.4: CTModels (breaks with new CTBase)

```toml
# CTModels/Project.toml
version = "0.6.9"  # No change
[compat]
CTBase = "0.16"    # ❌ Keep unchanged - breaks with 0.17
```

**Action**: No registration needed

### Step 1.5: OptimalControl

```toml
# OptimalControl/Project.toml
version = "1.1.7"
[compat]
CTBase = "0.16, 0.17.0-"
CTDirect = "0.17, 0.18.0-"
CTFlows = "0.8, 0.9.0-"
CTModels = "0.6, 0.7.0-"
CTParser = "0.7, 0.8.0-"
```

**Action**: Register OptimalControl 1.1.7

### Verification

```julia
Pkg.add("OptimalControl")

# Resolver reasoning:
# 1. OptimalControl 1.1.7: CTDirect ∈ {0.17, 0.18-}
#    → Prefers stable: selects CTDirect 0.17.5
#
# 2. CTDirect 0.17.5: CTModels ∈ {0.6}  ← KEY: not widened!
#    → Forces CTModels 0.6.x
#
# 3. CTModels 0.6.x: CTBase ∈ {0.16}  ← KEY: not widened!
#    → Forces CTBase 0.16.x
#
# Result: CTBase 0.16.4, CTModels 0.6.9, CTDirect 0.17.5 ✅
```

---

## Phase 2: CTBase Beta Release

```toml
# CTBase/Project.toml
version = "0.17.0-beta.1"
```

**Action**: Register CTBase 0.17.0-beta.1

### Verification

```julia
Pkg.add("OptimalControl")
# CTModels 0.6.x still forces CTBase ∈ {0.16}
# Result: CTBase 0.16.4 ✅ (user unaffected)
```

---

## Phase 3: CTModels Beta Adaptation

```toml
# CTModels/Project.toml
version = "0.7.0-beta.1"  # Beta - requires beta CTBase
[compat]
CTBase = "0.17.0-"
```

**Action**: Register CTModels 0.7.0-beta.1

### Verification

```julia
Pkg.add("OptimalControl")
# CTDirect 0.17.5 forces CTModels ∈ {0.6}
# CTModels 0.6.x forces CTBase ∈ {0.16}
# Result: CTBase 0.16.4, CTModels 0.6.9 ✅ (user unaffected)
```

---

## Phase 4: CTDirect Beta Adaptation

```toml
# CTDirect/Project.toml
version = "0.18.0-beta.1"  # Beta - requires beta CTModels
[compat]
CTBase = "0.17.0-"
CTModels = "0.7.0-"
```

**Action**: Register CTDirect 0.18.0-beta.1

### Verification

```julia
Pkg.add("OptimalControl")
# Resolver prefers stable: CTDirect 0.17.5
# This forces CTModels 0.6.x → CTBase 0.16.x
# Result: CTBase 0.16.4, CTModels 0.6.9, CTDirect 0.17.5 ✅
```

---

## Phase 4b: OptimalControl Beta (Optional)

**Objective**: Allow developers to test the full beta stack.

```toml
# OptimalControl/Project.toml
version = "1.2.0-beta.1"
[compat]
CTBase = "0.17.0-"
CTDirect = "0.18.0-"
CTFlows = "0.8"
CTModels = "0.7.0-"
CTParser = "0.7"
```

**Action**: Register OptimalControl 1.2.0-beta.1

### Verification

```julia
# Regular user
Pkg.add("OptimalControl")
# Result: CTBase 0.16.4, CTModels 0.6.9, CTDirect 0.17.5 ✅

# Developer testing betas
Pkg.add(name="OptimalControl", version="1.2.0-beta.1")
# Result: CTBase 0.17.0-beta.1, CTModels 0.7.0-beta.1, 
#         CTDirect 0.18.0-beta.1 ✅ (full beta stack)
```

---

## Phase 5: CTBase Stabilization

> [!WARNING]
> **Order**: Dependencies must be stabilized BEFORE dependents.
> CTBase → CTModels → CTDirect

```toml
# CTBase/Project.toml
version = "0.17.0"
```

**Action**: Register CTBase 0.17.0 **FIRST**

### Verification

```julia
Pkg.add("OptimalControl")
# CTDirect 0.17.5 still forces CTModels 0.6 → CTBase 0.16
# Result: CTBase 0.16.4 ✅ (user still gets old stable)
```

---

## Phase 6: CTModels Stabilization

```toml
# CTModels/Project.toml
version = "0.7.0"
[compat]
CTBase = "0.17"
```

**Action**: Register CTModels 0.7.0 **SECOND**

### Verification

```julia
Pkg.add("OptimalControl")
# CTDirect 0.17.5 still forces CTModels 0.6 → CTBase 0.16
# Result: CTBase 0.16.4, CTModels 0.6.9 ✅ (user still gets old stable)
```

---

## Phase 7: CTDirect Stabilization

```toml
# CTDirect/Project.toml
version = "0.18.0"
[compat]
CTBase = "0.17"
CTModels = "0.7"
```

**Action**: Register CTDirect 0.18.0 **THIRD**

### Verification

```julia
Pkg.add("OptimalControl")

# Resolver reasoning:
# 1. OptimalControl 1.1.7: CTDirect ∈ {0.17, 0.18-}
#    → Both 0.17.5 and 0.18.0 are stable now
#    → Prefers maximum: selects CTDirect 0.18.0
#
# 2. CTDirect 0.18.0: CTModels ∈ {0.7}, CTBase ∈ {0.17}
#    → Forces CTModels 0.7.x and CTBase 0.17.x
#
# 3. CTModels 0.7.0: CTBase ∈ {0.17}
#    → Consistent with CTDirect constraint
#
# Result: CTBase 0.17.0, CTModels 0.7.0, CTDirect 0.18.0 ✅
# → ECOSYSTEM UPGRADED!
```

---

## Phase 8: OptimalControl Update (Optional)

```toml
# OptimalControl/Project.toml
version = "1.1.8"
[compat]
CTBase = "0.17"
CTDirect = "0.18"
CTFlows = "0.8"
CTModels = "0.7"
CTParser = "0.7"
```

**Action**: Register OptimalControl 1.1.8

---

## Summary

| Phase | What happens | User gets CTBase |
|-------|--------------|------------------|
| 1. Preparation | Widen non-breaking packages | 0.16.4 |
| 2. CTBase Beta | CTBase 0.17.0-beta.1 | 0.16.4 |
| 3. CTModels Beta | CTModels 0.7.0-beta.1 | 0.16.4 |
| 4. CTDirect Beta | CTDirect 0.18.0-beta.1 | 0.16.4 |
| 5. CTBase Stable | CTBase 0.17.0 | 0.16.4 |
| 6. CTModels Stable | CTModels 0.7.0 | 0.16.4 |
| 7. CTDirect Stable | CTDirect 0.18.0 | **0.17.0** ✅ |
| 8. Cleanup | OptimalControl 1.1.8 | 0.17.0 |

**Key insight**: Users only get CTBase 0.17.0 after the ENTIRE cascade is stable.

---

## Stabilization Order

```text
CTBase 0.17.0       ← First (no dependencies)
    ↓
CTModels 0.7.0      ← Second (depends on CTBase)
    ↓
CTDirect 0.18.0     ← Third (depends on CTModels)
    ↓
OptimalControl 1.1.8 ← Last (depends on all)
```

---

## Final State

```text
OptimalControl: 1.1.8
CTBase:         0.17.0
CTDirect:       0.18.0
CTFlows:        0.8.10
CTModels:       0.7.0
CTParser:       0.7.2
```

---

## CI Breakage Testing

The [breakage.yml](https://github.com/control-toolbox/CTActions/blob/main/.github/workflows/breakage.yml) action tests dependent packages with your dev version.

### Phase 2: CTBase 0.17.0-beta.1 on dev branch

```text
Breakage on CTModels:
  CTModels 0.6.9: CTBase ∈ {0.16}  ← Not widened!
  Dev CTBase: 0.17.0-beta.1
  → Intersection: ∅
  → Breakage FAILS (expected - CTModels needs adaptation)

Breakage on CTFlows:
  CTFlows 0.8.10: CTBase ∈ {0.16, 0.17.0-}  ← Widened
  Dev CTBase: 0.17.0-beta.1
  → Resolution path: CTBase 0.17.0-beta.1 ✅
  → Tests confirm CTFlows works with new CTBase
```

### Phase 3: CTModels 0.7.0-beta.1 on dev branch

```text
Breakage on CTDirect:
  CTDirect 0.17.5: CTModels ∈ {0.6}  ← Not widened for CTModels!
  Dev CTModels: 0.7.0-beta.1
  → Intersection: ∅
  → Breakage FAILS (expected - CTDirect needs adaptation)

Breakage on CTFlows:
  CTFlows 0.8.10: CTModels ∈ {0.6, 0.7.0-}  ← Widened
  Dev CTModels: 0.7.0-beta.1 (requires CTBase 0.17.0-)
  → Resolution path: CTModels 0.7.0-beta.1 + CTBase 0.17.0-beta.1 ✅
```

### Phase 4: CTDirect 0.18.0-beta.1 on dev branch

```text
Breakage on OptimalControl:
  OptimalControl 1.1.7: CTDirect ∈ {0.17, 0.18.0-}
  Dev CTDirect: 0.18.0-beta.1 (requires CTModels 0.7.0-, CTBase 0.17.0-)
  → Resolution path: CTDirect 0.18.0-beta.1 + CTModels 0.7.0-beta.1 + CTBase 0.17.0-beta.1 ✅
  → Full cascade tested!
```

> [!TIP]
> Breakage failures cascade: Phase 2 fails on CTModels, Phase 3 fails on CTDirect. This is expected! It identifies which packages need adaptation at each level.

---

## Checklist

- [ ] Identify cascade: which packages break which others?
- [ ] Widen compat ONLY in packages that work with both versions
- [ ] Release betas bottom-up: CTBase → CTModels → CTDirect
- [ ] (Optional) Release OptimalControl beta for full stack testing
- [ ] Release stables bottom-up: CTBase → CTModels → CTDirect
- [ ] Update top package compat (OptimalControl)
- [ ] **Verify breakage action at each level: expected failures cascade through breaking packages**
