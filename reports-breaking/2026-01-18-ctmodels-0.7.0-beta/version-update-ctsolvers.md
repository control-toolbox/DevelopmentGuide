# Version Update: CTSolvers v0.2.0-beta

**Date**: 2026-01-19 16:07:35  
**Change**: CTSolvers version updated from 0.1.0-beta to 0.2.0-beta

---

## Reason for Change

CTSolvers is being released as **v0.2.0-beta** instead of v0.1.0-beta, likely because:
- The package already has some development history
- Starting at v0.2.0 reflects the current state of the codebase
- Aligns with the project's versioning strategy

---

## Files Updated

The following files have been updated to reflect the new version:

1. ✅ **`action-plan.md`**
   - Phase 3.5: CTSolvers Beta Release
   - All references to 0.1.0-beta → 0.2.0-beta
   - Compat in Phase 4 (OptimalControl): `CTSolvers = "0.2"`
   - Verification checklist updated

2. ✅ **`action-plan-update-summary.md`**
   - CTSolvers version references updated

---

## Updated Version Information

### CTSolvers

**Initial release**: v0.2.0-beta (instead of v0.1.0-beta)

**Rationale**: 
- Package has existing development
- v0.2.0 reflects current maturity level
- First beta release in the migration context

---

## Project.toml Configuration

```toml
# CTSolvers/Project.toml

name = "CTSolvers"
uuid = "[to-be-generated]"
version = "0.2.0-beta"  # Updated from 0.1.0-beta
authors = ["Olivier Cots <olivier.cots@toulouse-inp.fr>"]

[deps]
CTBase = "..."
CTModels = "..."
# ... other dependencies

[compat]
julia = "1.9"
CTBase = "0.17"
CTModels = "0.7"  # Uses new CTModels v0.7.x directly
# ... other compat entries
```

---

## Impact on Phase 4 (OptimalControl)

OptimalControl will use CTSolvers v0.2.x:

```toml
# OptimalControl/Project.toml (Phase 4)

version = "1.1.9-beta"

[compat]
CTDirect = "0.17, 0.18"
CTFlows = "0.8"
CTModels = "0.6, 0.7"
CTParser = "0.8"
CTSolvers = "0.2"  # Updated from "0.1"
CTBase = "0.17"
```

---

## Registration Commands

Updated commands for Phase 3.5:

```bash
# Tag creation
git tag v0.2.0-beta  # Instead of v0.1.0-beta
git push origin v0.2.0-beta

# Registration in ct-registry
julia -e '
using LocalRegistry, CTSolvers
register(CTSolvers, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/CTSolvers.jl.git")
'
```

---

## Verification

After registration:

```julia
using Pkg
Pkg.add(name="CTSolvers", version="0.2.0-beta")
# Expected: CTSolvers 0.2.0-beta, CTModels 0.7.0-beta, CTBase 0.17.4
# Why: CTSolvers requires CTModels = "0.7", so resolver picks 0.7.0-beta
```

---

## Updated Migration Flow

```
Phase 1: CTFlows v0.8.11-beta ✅
  ↓
Phase 2: CTModels v0.7.0-beta ✅
  ↓
Phase 3: CTDirect v0.18.0-beta ✅
  ↓
Phase 3.5: CTSolvers v0.2.0-beta 🔄 (current)
  ↓
Phase 4: OptimalControl v1.1.9-beta ⏳
  - Will use: CTSolvers = "0.2"
  ↓
Phase 5: Stabilization ⏳
```

---

## Dependency Graph (After Phase 3.5)

```
CTSolvers v0.2.0-beta (NEW)
  ├── CTModels v0.7.0-beta
  └── CTBase v0.17.4
```

Once integrated in OptimalControl (Phase 4):

```
OptimalControl v1.1.9-beta
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
  └── CTBase v0.17.4
```

---

## Next Steps

1. ✅ Version updated in all documentation
2. 🔄 Set up CTSolvers Project.toml with version 0.2.0-beta
3. ⏳ Test CTSolvers with CTModels v0.7.0-beta
4. ⏳ Register CTSolvers v0.2.0-beta in ct-registry
5. ⏳ Proceed to Phase 4 (OptimalControl integration)

---

## Notes

- **Version Choice**: v0.2.0-beta instead of v0.1.0-beta reflects existing development
- **New Package**: This is still the first release in the migration context
- **Direct CTModels 0.7**: No progressive widening needed (new package)
- **Compat Strategy**: Uses `CTModels = "0.7"` directly

---

**All documentation updated successfully** ✅
