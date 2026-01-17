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

✅ **Status**: Breakage tests completed on PR #404 with beta versions.

### Final Test Results (with CTModels v0.6.10-beta and CTParser v0.7.3-beta)

| Package | Latest | Stable | Status | Notes |
|---------|--------|--------|--------|-------|
| CTModels v0.6.10-beta | ✅ | ✅ | **Compatible** | Beta version with CTBase v0.17 support |
| CTParser v0.7.3-beta | ✅ | ✅ | **Compatible** | Beta version with CTBase v0.17 support |
| CTDirect v0.17.4 | ✅ | ✅ | **Compatible** | No breaking changes needed |
| CTFlows v0.8.9 | ✅ | ✅ | **Compatible** | No breaking changes needed |
| OptimalControl v1.1.6 | ✅ | ✅ | **Compatible** | No breaking changes needed |

**Conclusion**: ✅ **All packages are compatible with CTBase v0.17.0**

---

## 🎉 Simplified Migration - No Breaking Changes

**Excellent news**: Testing with beta versions (CTModels v0.6.10-beta and CTParser v0.7.3-beta) confirms that **no packages are broken** by CTBase v0.17.0.

### What This Means

1. **No code changes needed** in any downstream package
2. **Simple compat widening** is sufficient for all packages
3. **No cascade of breaking changes** to handle
4. **Much faster migration** than initially anticipated

### Migration Strategy

**Single Phase**: Compat widening only

All packages can simply widen their compat bounds to accept CTBase v0.17:

- **CTDirect** v0.17.4 → v0.17.5 (patch release)
- **CTFlows** v0.8.9 → v0.8.10 (patch release)
- **OptimalControl** v1.1.6 → v1.1.7 (patch release)

**Note**: CTModels and CTParser already have stable versions (v0.7.0 and v0.8.0) that support CTBase v0.17, so no action needed for them.

---

## Classification

### ✅ All Packages Compatible

All packages work with CTBase v0.17.0 without code changes. Only compat widening is needed:

- **CTDirect v0.17.4** - Tests pass, only needs compat widening
- **CTFlows v0.8.9** - Tests pass, only needs compat widening  
- **OptimalControl v1.1.6** - Tests pass, only needs compat widening

### � Beta Versions (Created for Testing)

Beta versions were created to isolate the CTBase migration from CTModels/CTParser breaking changes:

- **CTModels v0.6.10-beta** (from v0.6.9, adds CTBase v0.17 compat)
  - ✅ Registered in ct-registry
  - ✅ Tests pass with CTBase v0.17.0
  - Purpose: Testing only, not needed for production

- **CTParser v0.7.3-beta** (from v0.7.2, adds CTBase v0.17 compat)
  - ✅ Registered in ct-registry
  - ✅ Tests pass with CTBase v0.17.0
  - Purpose: Testing only, not needed for production

**Note**: These beta versions confirmed that CTBase v0.17.0 doesn't break any packages. They can remain in ct-registry for reference but are not required for the migration.

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
   - Breakage tests analyzed with beta versions
   - **Result: All packages compatible! ✅**

2. **Beta versions created** (for testing):
   - ✅ CTModels v0.6.10-beta
   - ✅ CTParser v0.7.3-beta
   - Both registered in ct-registry
   - Both tested successfully

### 🎯 Immediate Actions Required

1. **Update PR comment** with new test results

2. **Generate simplified action plan**:

   ```bash
   /breaking-action-plan reports-breaking/2026-01-16-ctbase-0.17.0
   ```

3. **Execute migration** (simple compat widening):
   - CTDirect v0.17.4 → v0.17.5
   - CTFlows v0.8.9 → v0.8.10
   - OptimalControl v1.1.6 → v1.1.7

**Estimated time**: 1-2 days (much faster than initially expected!)

---

## Summary

**Initial assessment**: Complex migration with cascade of breaking changes  
**Actual result**: ✅ Simple migration - all packages compatible!

**Beta versions proved their value**: They allowed us to test CTBase v0.17.0 independently and discover that no packages are actually broken.

**Migration complexity**: LOW (was: HIGH)

- No code changes needed
- Only compat widening required
- No cascade to handle

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
