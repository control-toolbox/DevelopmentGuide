# Version Update: CTDirect v0.18.0-beta

**Date**: 2026-01-19 15:56:31  
**Change**: CTDirect version updated from 0.17.6-beta to 0.18.0-beta

---

## Reason for Change

CTDirect is moving to a **major version bump** (0.17.x → 0.18.x) instead of a patch version bump, reflecting the significance of the changes required to adapt to CTModels v0.7.x.

---

## Files Updated

The following files have been updated to reflect the new version:

1. ✅ **`action-plan.md`**
   - Phase 3: CTDirect Adaptation
   - All references to 0.17.6-beta → 0.18.0-beta
   - Verification checklist updated

2. ✅ **`setup.md`**
   - Strategy overview updated
   - CTDirect version references updated

3. ✅ **`action-plan-update-summary.md`**
   - Dependency graph updated

---

## Updated Version Information

### CTDirect

**Before**: 0.17.5-beta  
**After**: 0.18.0-beta

**Rationale**: Major version bump (0.17 → 0.18) to reflect:
- Breaking changes adaptation to CTModels v0.7.x
- Significant API changes
- Following semantic versioning best practices

---

## Project.toml Changes

```toml
# CTDirect/Project.toml

# Before
version = "0.17.5-beta"

[compat]
CTModels = "0.6"
CTBase = "0.17"

# After
version = "0.18.0-beta"

[compat]
CTModels = "0.6, 0.7"  # Widened after code adaptation
CTBase = "0.17"
```

---

## Registration Commands

Updated commands for Phase 3:

```bash
# Tag creation
git tag v0.18.0-beta
git push origin v0.18.0-beta

# Registration in ct-registry
julia -e '
using LocalRegistry, CTDirect
register(CTDirect, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/CTDirect.jl.git")
'
```

---

## Impact on Dependency Resolution

After CTDirect v0.18.0-beta is registered:

```
OptimalControl 1.1.8-beta requires:
  - CTDirect ∈ {0.17}  → Gets 0.18.0-beta ✅
  - CTModels ∈ {0.6}   ← Still forces CTModels 0.6

CTDirect 0.18.0-beta requires:
  - CTModels ∈ {0.6, 0.7}  ← Accepts both

Intersection: {0.6} → Resolver still picks CTModels 0.6.10-beta
```

**Note**: OptimalControl will need to update its compat to accept CTDirect 0.18 in Phase 4.

---

## Updated Migration Flow

```
Phase 1: CTFlows v0.8.11-beta ✅
  ↓
Phase 2: CTModels v0.7.0-beta ✅
  ↓
Phase 3: CTDirect v0.18.0-beta 🔄 (in progress)
  ↓
Phase 3.5: CTSolvers v0.1.0-beta ⏳
  ↓
Phase 4: OptimalControl v1.1.9-beta ⏳
  - Will need: CTDirect = "0.17, 0.18"
  ↓
Phase 5: Stabilization ⏳
```

---

## Next Steps

1. ✅ Version updated in all documentation
2. 🔄 Complete CTDirect code adaptation
3. ⏳ Test with CTModels v0.7.0-beta
4. ⏳ Register CTDirect v0.18.0-beta in ct-registry
5. ⏳ Proceed to Phase 3.5 (CTSolvers)

---

## Notes

- **Semantic Versioning**: 0.17 → 0.18 is a major version bump in the 0.x series
- **Breaking Changes**: This reflects that CTDirect has breaking changes due to CTModels v0.7.x adaptation
- **Compat Strategy**: Still uses progressive widening `"0.6, 0.7"` for smooth transition
- **OptimalControl Impact**: Will need to widen CTDirect compat in Phase 4

---

**All documentation updated successfully** ✅
