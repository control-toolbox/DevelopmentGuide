# Breaking Change Setup Report

**Date**: 2026-01-16 21:03:00  
**Package**: CTBase  
**Current Version**: 0.16.2  
**Target Version**: 0.17.0  
**Branch**: `breaking/ctbase-0.17`  
**Issue**: [#403](https://github.com/control-toolbox/CTBase.jl/issues/403)  
**PR**: [#404](https://github.com/control-toolbox/CTBase.jl/pull/404)

---

## Dependency Graph

Current dependency graph extracted from OptimalControl ecosystem:

```
CTBase v0.16.2
CTDirect v0.17.4
  → CTModels v0.6.9
  → CTBase v0.16.2
CTFlows v0.8.9
  → CTModels v0.6.9
  → CTBase v0.16.2
CTModels v0.6.9
  → CTBase v0.16.2
CTParser v0.7.2
  → CTBase v0.16.2
OptimalControl v1.1.6
  → CTDirect v0.17.4
  → CTParser v0.7.2
  → CTFlows v0.8.9
  → CTModels v0.6.9
  → CTBase v0.16.2
```

**All packages depend on CTBase**, making this a critical breaking change that will affect the entire ecosystem.

---

## Breakage Test Results

✅ **Status**: Breakage tests completed on PR #404.

### Current Test Results (CTBase temporarily reverted to v0.16.4 for testing)

| Package | Latest | Stable | Status | Notes |
|---------|--------|--------|--------|-------|
| CTModels v0.6.9 | ❌ | ❌ | **Compat conflict** | Already migrated to v0.7.0 (breaking) with CTBase v0.17 support |
| CTParser v0.7.2 | ❌ | ❌ | **Compat conflict** | Already migrated to v0.8.0 (breaking) with CTBase v0.17 support |
| CTDirect v0.17.4 | ✅ | ✅ | **Compatible** | No breaking changes needed |
| CTFlows v0.8.9 | ✅ | ✅ | **Compatible** | No breaking changes needed |
| OptimalControl v1.1.6 | ✅ | ✅ | **Compatible** | No breaking changes needed |

---

## ⚠️ Complex Situation - Historical Context

**Important**: This migration has a complex history that affects the strategy:

### What Happened

1. **CTBase v0.17.0** was already released with breaking changes
2. **CTModels** and **CTParser** were already migrated:
   - CTModels v0.6.9 → **v0.7.0** (breaking, supports CTBase v0.17)
   - CTParser v0.7.2 → **v0.8.0** (breaking, supports CTBase v0.17)
3. **Both CTModels v0.7.0 and CTParser v0.8.0 introduced their own breaking changes** 😱
4. CTBase was temporarily reverted to v0.16.4 in Project.toml to re-run breakage tests
5. Current breakage failures for CTModels/CTParser are **compat conflicts**, not real breakages

### Cascade of Breaking Changes

```
CTBase v0.16.2 → v0.17.0 (BREAKING)
  ↓
  ├─ CTModels v0.6.9 → v0.7.0 (BREAKING) ← Already done, but also breaking!
  │    ↓
  │    ├─ CTDirect v0.17.4 (needs update for CTModels v0.7.0)
  │    └─ CTFlows v0.8.9 (needs update for CTModels v0.7.0)
  │
  ├─ CTParser v0.7.2 → v0.8.0 (BREAKING) ← Already done, but also breaking!
  │    ↓
  │    └─ OptimalControl v1.1.6 (needs update for CTParser v0.8.0)
  │
  └─ Direct dependents: CTDirect, CTFlows, OptimalControl (all compatible with CTBase v0.17)
```

---

## Classification

### ✅ Compatible Packages (can widen compat to accept CTBase v0.17)

These packages work with CTBase v0.17.0 without code changes:

- **CTDirect v0.17.4** - Tests pass, only needs compat widening
- **CTFlows v0.8.9** - Tests pass, only needs compat widening  
- **OptimalControl v1.1.6** - Tests pass, only needs compat widening

### 🔄 Already Migrated (but with their own breaking changes)

These packages were already migrated to support CTBase v0.17, but introduced breaking changes:

- **CTModels v0.7.0** (breaking from v0.6.9)
  - ✅ Supports CTBase v0.17
  - ❌ Introduces breaking changes affecting CTDirect and CTFlows
  
- **CTParser v0.8.0** (breaking from v0.7.2)
  - ✅ Supports CTBase v0.17
  - ❌ Introduces breaking changes affecting OptimalControl

### 🧪 Beta Strategy Option

For testing purposes, we could create beta versions from the old versions:

- **CTModels v0.6.10-beta** (from v0.6.9, add CTBase v0.17 compat)
- **CTParser v0.7.3-beta** (from v0.7.2, add CTBase v0.17 compat)

This would allow testing the CTBase migration independently of the CTModels/CTParser breaking changes.

---

## Breaking Changes Description

### CTBase v0.16.2 → v0.17.0

**TODO**: Document the specific breaking changes that were introduced:

- What APIs changed?
- What functions were renamed/removed?
- What behavior changed?

### Downstream Breaking Changes

**CTModels v0.6.9 → v0.7.0**:

- **TODO**: Document CTModels breaking changes

**CTParser v0.7.2 → v0.8.0**:

- **TODO**: Document CTParser breaking changes

---

## Next Steps

### ✅ Completed

1. **Setup complete**:
   - Branch created: `breaking/ctbase-0.17`
   - Issue created: #403
   - PR created: #404
   - Dependency graph extracted
   - Breakage tests analyzed
   - **Strategy chosen: Option B (Beta versions)**

### 🎯 Immediate Actions Required

1. **Document Breaking Changes**:
   - [ ] Document CTBase v0.17.0 breaking changes
   - [ ] Document CTModels v0.7.0 breaking changes
   - [ ] Document CTParser v0.8.0 breaking changes

2. **✅ Chosen Strategy: Option B - Beta Versions**

   We will create beta versions to isolate the CTBase migration from the CTModels/CTParser breaking changes:

   **Phase 1: CTBase Migration (with beta versions)**
   - Create **CTModels v0.6.10-beta** (from v0.6.9 + CTBase v0.17 compat)
   - Create **CTParser v0.7.3-beta** (from v0.7.2 + CTBase v0.17 compat)
   - Test CTBase v0.17.0 migration independently
   - Widen compat for CTDirect, CTFlows, OptimalControl

   **Phase 2: CTModels/CTParser Breaking Changes**
   - Handle CTModels v0.7.0 breaking changes
   - Handle CTParser v0.8.0 breaking changes
   - Migrate affected packages (CTDirect, CTFlows, OptimalControl)

   **Benefits**:
   - ✅ Isolates breaking changes for easier debugging
   - ✅ Allows independent testing of CTBase migration
   - ✅ More control over the migration process
   - ✅ Clearer understanding of which changes cause which issues

3. **Create Beta Versions**:

   **For CTModels v0.6.10-beta**:

   ```bash
   cd CTModels.jl
   git checkout -b beta/ctbase-0.17-compat v0.6.9
   # Edit Project.toml: CTBase = "0.16, 0.17"
   # Update version to 0.6.10-beta
   git commit -m "chore: add CTBase v0.17 compat (beta)"
   git tag v0.6.10-beta
   git push origin v0.6.10-beta
   ```

   **For CTParser v0.7.3-beta**:

   ```bash
   cd CTParser.jl
   git checkout -b beta/ctbase-0.17-compat v0.7.2
   # Edit Project.toml: CTBase = "0.16, 0.17"
   # Update version to 0.7.3-beta
   git commit -m "chore: add CTBase v0.17 compat (beta)"
   git tag v0.7.3-beta
   git push origin v0.7.3-beta
   ```

4. **Generate Action Plan**:
   - Once beta versions are created and breaking changes documented, run:

     ```bash
     /breaking-action-plan reports-breaking/ctbase-0.17.0-2026-01-16-setup.md
     ```

---

## Notes

- This is a **preliminary setup report**
- Update the "Breakage Test Results" section when tests complete
- Document the specific breaking changes in the "Breaking Changes Description" section
- This breaking change affects the entire CT ecosystem since all packages depend on CTBase

---

## How to Update This Report

When breakage tests complete:

1. Check PR #404 for the breakage test comment
2. Update the "Breakage Test Results" table with ✅/❌ badges
3. Update the "Classification" section based on results
4. Document the specific breaking changes
5. Run `/breaking-action-plan reports-breaking/ctbase-0.17.0-2026-01-16-setup.md`
