# Case Study: CTDirect Breaking Change (0.17.4 → 0.18.0)

## Fundamental Principle

> [!CAUTION]
> **A stable version must only depend on stable versions.**
>
> If your package requires a beta dependency, your package must also be released as beta.

This ensures users who don't explicitly opt into betas never receive beta packages.

---

## Initial State

```
OptimalControl: 1.1.6
CTBase:         0.16.4
CTDirect:       0.17.4
CTFlows:        0.8.9
CTModels:       0.6.9
CTParser:       0.7.1
```

**Dependency graph:**

```
OptimalControl 1.1.6
    ├── CTDirect 0.17.4 ──┐
    ├── CTFlows 0.8.9 ────┼── CTBase 0.16.4
    ├── CTModels 0.6.9 ───┤
    └── CTParser 0.7.1 ───┘
```

**Scenario**: CTDirect needs breaking changes for version 0.18.0. This tutorial shows how to properly manage the transition while protecting users from beta versions.

---

## Scenario A: Backward-Compatible Change

**CTDirect 0.18 maintains old API** (deprecated but functional).

### Phase 1: Preparation

```toml
# OptimalControl/Project.toml
version = "1.1.7"
[compat]
CTDirect = "0.17, 0.18.0-"
```

**Action**: Register

### Phase 2: Beta Release

```toml
# CTDirect/Project.toml
version = "0.18.0-beta.1"
```

**Action**: Register

### Phase 3: Stabilization

```toml
# CTDirect/Project.toml
version = "0.18.0"
```

**Action**: Register

**User gets**: OptimalControl 1.1.7 + CTDirect 0.18.0 ✅ (all stable)

---

## Scenario B: Internal Breaking Change

**CTDirect 0.18 breaks API** that OptimalControl uses, but OptimalControl's public API unchanged.

### Phase 1: Preparation

```toml
# OptimalControl/Project.toml
version = "1.1.7"
[compat]
CTDirect = "0.17, 0.18.0-"
```

**Action**: Register

**User gets**: OptimalControl 1.1.7 + CTDirect 0.17.4 ✅

### Phase 2: CTDirect Beta Release

```toml
# CTDirect/Project.toml
version = "0.18.0-beta.1"
```

**Action**: Register

### Phase 3: OptimalControl Beta Adaptation

Adapt OptimalControl to CTDirect 0.18 API.

```toml
# OptimalControl/Project.toml
version = "1.2.0-beta.1"  # ⚠️ MUST be beta!
[compat]
CTDirect = "0.18.0-"
```

**Action**: Register

> [!IMPORTANT]
> OptimalControl must be beta because it requires a beta dependency.

**Developer testing**: Gets OptimalControl 1.2.0-beta.1 + CTDirect 0.18.0-beta.1 ✅

### Phase 4: CTDirect Stabilization

```toml
# CTDirect/Project.toml
version = "0.18.0"
```

**Action**: Register **first**

### Phase 5: OptimalControl Stabilization

```toml
# OptimalControl/Project.toml
version = "1.2.0"  # Now stable is OK
[compat]
CTDirect = "0.18"
```

**Action**: Register **after** CTDirect 0.18.0

**User gets**: OptimalControl 1.2.0 + CTDirect 0.18.0 ✅ (all stable)

---

## Scenario C: Public Breaking Change

**CTDirect 0.18 changes OptimalControl's public API**.

### Phase 1: Preparation

```toml
# OptimalControl/Project.toml
version = "1.1.7"
[compat]
CTDirect = "0.17, 0.18.0-"
```

**Action**: Register

### Phase 2: CTDirect Beta Release

```toml
# CTDirect/Project.toml
version = "0.18.0-beta.1"
```

**Action**: Register

### Phase 3: OptimalControl Beta Adaptation

```toml
# OptimalControl/Project.toml
version = "2.0.0-beta.1"  # Major + beta
[compat]
CTDirect = "0.18.0-"
```

**Action**: Register

### Phase 4: CTDirect Stabilization

```toml
# CTDirect/Project.toml
version = "0.18.0"
```

**Action**: Register **first**

### Phase 5: OptimalControl Stabilization

```toml
# OptimalControl/Project.toml
version = "2.0.0"
[compat]
CTDirect = "0.18"
```

**Action**: Register **after** CTDirect 0.18.0

---

## Release Order Rule

> [!WARNING]
> **Always release dependencies stable BEFORE dependents stable.**

```
Correct order:
1. CTDirect 0.18.0 (stable)     ← dependency first
2. OptimalControl 1.2.0 (stable) ← dependent after

Wrong order:
1. OptimalControl 1.2.0 (stable) ← ERROR: requires beta dep!
2. CTDirect 0.18.0 (stable)
```

---

## Summary

| Phase | CTDirect | OptimalControl | User Gets |
|-------|----------|----------------|-----------|
| Preparation | 0.17.4 | 1.1.7 | 1.1.7 + 0.17.4 ✅ |
| Beta | 0.18.0-beta.1 | 1.2.0-beta.1 | 1.1.7 + 0.17.4 ✅ |
| Stabilization | 0.18.0 | 1.2.0 | 1.2.0 + 0.18.0 ✅ |

Users always get stable versions unless they explicitly opt into betas.

---

## CI Breakage Testing

The [breakage.yml](https://github.com/control-toolbox/CTActions/blob/main/.github/workflows/breakage.yml) action tests dependent packages with your dev version. Here's what happens at each phase:

### Scenario B: Internal Breaking Change

**Phase 2** (CTDirect 0.18.0-beta.1 on dev branch):

```text
Breakage action on OptimalControl:
  OptimalControl 1.1.7: CTDirect ∈ {0.17, 0.18.0-}
  Dev CTDirect: 0.18.0-beta.1
  → Resolution path: CTDirect 0.18.0-beta.1 ✅
  → Tests run with beta version
```

**Phase 3** (OptimalControl 1.2.0-beta.1 on dev branch):

```text
Breakage action verifies OptimalControl works with CTDirect 0.18.0-beta.1
  → Resolution path exists ✅
  → Tests confirm adaptation is correct
```

> [!TIP]
> The widening in Phase 1 (`CTDirect = "0.17, 0.18.0-"`) ensures the breakage action has a valid resolution path. Without widening, the breakage action would fail with an empty intersection.

---

## Checklist

- [ ] Widen compat before beta release
- [ ] Release adapted package as **beta** if it requires beta dep
- [ ] Release dependency stable **before** dependent stable
- [ ] Update compat to stable-only after dependency is stable
- [ ] **Verify breakage action passes at each phase**
