# Action Plan Update Summary

**Date**: 2026-01-19 09:21:15  
**Update**: Added Phase 3.5 for CTSolvers integration

---

## Changes Made

### 1. Summary Section Updated

- **Total phases**: 5 → **6**
- **Cascade**: Added CTSolvers to the dependency chain
- **Affected packages**: Added CTSolvers as a new package

### 2. New Phase 3.5: CTSolvers Beta Release

**Objective**: Create and release the first beta version of CTSolvers

**Key points**:
- New package in the ecosystem restructuring
- Depends on: CTBase v0.17.x, CTModels v0.7.x
- Will be used by: OptimalControl
- First release: v0.2.0-beta
- Uses CTModels v0.7.x directly (no progressive widening needed)

**Actions**:
1. Verify CTSolvers repository exists
2. Set up Project.toml with CTModels = "0.7"
3. Test with CTModels v0.7.x
4. Register in ct-registry
5. Create tag v0.2.0-beta

### 3. Phase 4 (OptimalControl) Updated

**New requirements**:
- Integrate CTSolvers as a new dependency
- Add `CTSolvers = "0.1"` to compat
- Update code to use CTSolvers

**Project.toml changes**:
```toml
# Added:
CTSolvers = "0.1"  # NEW dependency
```

### 4. Verification Checklist Updated

Added Phase 3.5 checklist items:
- [ ] CTSolvers v0.2.0-beta registered in ct-registry
- [ ] Tag v0.2.0-beta created
- [ ] Tests passing with CTModels v0.7.x
- [ ] Ready for integration in OptimalControl

---

## Migration Flow (Updated)

```
Phase 1: CTFlows widening (compatible)
  ↓
Phase 2: CTModels v0.7.0-beta release
  ↓
Phase 3: CTDirect adaptation (breaking)
  ↓
Phase 3.5: CTSolvers v0.2.0-beta release (NEW)
  ↓
Phase 4: OptimalControl adaptation + CTSolvers integration
  ↓
Phase 5: Stabilization (optional)
```

---

## New Dependency Graph (After Migration)

```
OptimalControl v2.0.0-beta
  ├── CTDirect v0.18.0-beta
  │   └── CTModels v0.7.0-beta
  │   └── CTBase v0.17.4
  ├── CTFlows v0.8.11-beta
  │   └── CTModels v0.7.0-beta
  │   └── CTBase v0.17.4
  ├── CTSolvers v0.2.0-beta (NEW)
  │   └── CTModels v0.7.0-beta
  │   └── CTBase v0.17.4
  ├── CTModels v0.7.0-beta
  │   └── CTBase v0.17.4
  ├── CTParser v0.8.2-beta
  │   └── CTBase v0.17.4
  ├── CTBase v0.17.4
```

---

## Important Notes

1. **CTSolvers is a new package**: No need for progressive widening `"0.6, 0.7"`, it starts directly with `CTModels = "0.7"`

2. **Phase 3.5 must come before Phase 4**: OptimalControl needs CTSolvers to be available before it can integrate it

3. **Ecosystem restructuring**: This migration includes the introduction of CTSolvers as part of the ecosystem reorganization

4. **Code moved from CTDirect**: CTSolvers will contain solver functionality previously in CTDirect

---

## Next Steps

1. Review the updated action plan: `action-plan.md`
2. Begin with Phase 1 (CTFlows widening)
3. Follow the phases in order, including the new Phase 3.5
4. Use the verification checklist to track progress

---

**Action plan file**: `reports-breaking/2026-01-18-ctmodels-0.7.0-beta/action-plan.md`
