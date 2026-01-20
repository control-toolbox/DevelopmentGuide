# Breaking Change Action Plan

**Generated**: 2026-01-19 07:38:27  
**Based on**: reports-breaking/2026-01-18-ctmodels-0.7.0-beta/setup.md  
**Package**: CTModels 0.6.10-beta → 0.7.0-beta  
**Complexity**: Medium (Mid-layer package with breaking dependents)

---

## Compat Strategy Guidance

When widening compat bounds, choose the appropriate strategy:

### Progressive Widening (Used in This Migration)

Use `DependencyName = "old, new"` (e.g., `CTModels = "0.6, 0.7"`) when:

✅ **Use when**:

- Tests confirm compatibility with both versions
- Releasing a patch/minor version
- Want to provide smooth transition period

✅ **Advantages**:

- Backward compatibility maintained
- Users can migrate at their own pace
- Safety net if new version has issues

❌ **Trade-offs**:

- Longer maintenance period
- Must test with both versions

### Recommendation for This Migration

For all packages in this migration:

- Use progressive widening: `CTModels = "0.6, 0.7"`
- This allows smooth transition and backward compatibility
- Stable versions can later use direct migration if needed

**Example**:

```toml
# CTFlows v0.8.11-beta (now - beta release)
CTModels = "0.6, 0.7"  # Progressive widening

# CTFlows v0.9.0 (later - stable release, optional)
CTModels = "0.7"  # Direct migration
```

---

## 📦 Local Registry Setup (Required for Beta Releases)

All beta versions in this migration will be registered in **ct-registry** (local registry) instead of the General registry.

### Why Use Local Registry for Betas?

- ✅ **Faster**: No waiting for General registry processing (~10-30 min delay)
- ✅ **Isolated**: Beta versions don't pollute the General registry
- ✅ **Flexible**: Easy to update/remove beta versions if needed

### One-Time Setup

Add ct-registry to your Julia environment (only needed once):

**SSH** (recommended):

```julia
pkg> registry add git@github.com:control-toolbox/ct-registry.git
```

**HTTPS**:

```julia
pkg> registry add https://github.com/control-toolbox/ct-registry.git
```

Install LocalRegistry.jl:

```julia
pkg> add LocalRegistry
```

### How to Register a Beta Version

When a phase instructs you to register a beta version:

1. **Update `Project.toml`** with the beta version number
2. **Commit and push** to GitHub
3. **Register in ct-registry**:

```julia
using LocalRegistry
using YourPackage  # e.g., using CTModels
register(YourPackage, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/YourPackage.jl.git")
```

**Note**:

- If the package is **already in ct-registry**, you can omit the `repo` parameter
- If it's the **first time** registering in ct-registry (even if it exists in General registry), you must specify `repo`
- Example: `repo = "git@github.com:control-toolbox/CTModels.jl.git"`

1. **Create GitHub tag** manually:

```bash
git tag v0.7.0-beta
git push origin v0.7.0-beta
```

**Note**: For stable (non-beta) releases, use `@JuliaRegistrator register()` as usual.

---

## Summary

**Migration overview**:

- Breaking package: CTModels (mid-layer)
- Cascade: CTModels → CTDirect, CTFlows, CTSolvers, OptimalControl
- Total phases: 6
- Estimated duration: 1-2 weeks

**Affected packages**:

- Breaking: CTDirect, OptimalControl (need code adaptation)
- Compatible: CTFlows (widening only)
- New package: CTSolvers (first beta release, depends on CTModels v0.7.x)

**Special note**: This migration includes the introduction of CTSolvers, a new package that will be part of the ecosystem restructuring.

---

## Phase 1: CTFlows Widening (Compatible Package)

**Objective**: Widen compat in CTFlows which is already compatible with CTModels v0.7.x.

**Why this phase first**: CTFlows tests pass with CTModels v0.7.x, so we can safely widen its compat before releasing CTModels beta. This reduces the number of packages that will show as breaking in later phases.

**Packages to modify**:

- CTFlows: 0.8.10-beta → 0.8.11-beta

### Project.toml changes

#### CTFlows/Project.toml

**Before**:

```toml
version = "0.8.10-beta"

[compat]
CTModels = "0.6"
CTBase = "0.17"
```

**After**:

```toml
version = "0.8.11-beta"

[compat]
CTModels = "0.6, 0.7"  # Widened to accept both 0.6 and 0.7
CTBase = "0.17"
```

### Actions

1. **Navigate to CTFlows repository**:

   ```bash
   cd /path/to/CTFlows.jl
   git checkout main
   git pull
   ```

2. **Create widening branch** (if not already on breaking/widening branch):

   ```bash
   git checkout -b widening/ctmodels-0.7
   ```

3. **Modify `Project.toml`** as shown above

4. **Commit changes**:

   ```bash
   git add Project.toml
   git commit -m "Widen CTModels compat to 0.6, 0.7"
   git push -u origin widening/ctmodels-0.7
   ```

5. **Register in ct-registry**:

   ```julia
   using LocalRegistry
   using CTFlows
   register(CTFlows, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/CTFlows.jl.git")
   ```

6. **Create GitHub tag**:

   ```bash
   git tag v0.8.11-beta
   git push origin v0.8.11-beta
   ```

7. **Create/update PR** (if not already exists):

   ```bash
   gh pr create --title "Widen CTModels compat to 0.6, 0.7" \
     --body "Widening compat for CTModels breaking change migration.
   
   Related to: control-toolbox/CTModels.jl#247
   
   This PR widens the compat constraint for CTModels to allow both 0.6 and 0.7 versions.
   
   **Changes**:
   - CTModels compat: \`0.6\` → \`0.6, 0.7\`
   - Version bump: \`0.8.10-beta\` → \`0.8.11-beta\`
   
   **Testing**:
   Tests already pass with CTModels v0.7.x (verified in breakage tests)."
   ```

### Verification

```julia
using Pkg
Pkg.add("CTFlows")
# Expected: CTFlows 0.8.11-beta, CTModels 0.6.10-beta
# Why: CTModels 0.7.0-beta not released yet, so resolver picks 0.6.10-beta
```

### Invariant checks

- [x] **⋂ constraints ≠ ∅** (Invariant 1): CTFlows accepts {0.6, 0.7}, CTModels only 0.7 available later → Intersection = {0.6} now, {0.6, 0.7} after Phase 2
- [x] **Stable → stable only** (Invariant 2): CTFlows is beta, can depend on beta CTModels
- [x] **Users get expected versions** (Invariant 3): Users still get CTModels 0.6.10-beta (0.7.0-beta not released yet)

### Expected breakage results

Not applicable (CTFlows already tested as compatible)

---

## Phase 2: CTModels Beta Release

**Objective**: Release CTModels v0.7.0-beta to ct-registry, making it available for breaking packages to adapt.

**Why this phase**: After CTFlows widening, we can release CTModels beta. Breaking packages (CTDirect, OptimalControl) will still use 0.6.10-beta until they adapt.

**Packages to modify**:

- CTModels: 0.6.10-beta → 0.7.0-beta

### Project.toml changes

#### CTModels/Project.toml

**Before** (currently on branch breaking/ctmodels-0.7):

```toml
version = "0.6.11"  # Temporary testing version
```

**After**:

```toml
version = "0.7.0-beta"
```

**Note**: The compat section should remain unchanged. Verify it looks like:

```toml
[compat]
CTBase = "0.17"
```

### Actions

1. **Navigate to CTModels repository**:

   ```bash
   cd /path/to/CTModels.jl
   git checkout breaking/ctmodels-0.7
   git pull
   ```

2. **Update version in `Project.toml`**:
   - Change `version = "0.6.11"` to `version = "0.7.0-beta"`

3. **Commit changes**:

   ```bash
   git add Project.toml
   git commit -m "Bump version to 0.7.0-beta for breaking migration"
   git push
   ```

4. **Register in ct-registry**:

   ```julia
   using LocalRegistry
   using CTModels
   register(CTModels, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/CTModels.jl.git")
   ```

5. **Create GitHub tag**:

   ```bash
   git tag v0.7.0-beta
   git push origin v0.7.0-beta
   ```

### Verification

```julia
using Pkg
Pkg.add("OptimalControl")
# Expected: CTModels 0.6.10-beta (not 0.7.0-beta)
# Why: CTDirect and OptimalControl still have CTModels = "0.6" (not widened yet)
#      Resolver picks 0.6.10-beta to satisfy all constraints
```

**Detailed constraint analysis**:

```
OptimalControl 1.1.8-beta requires:
  - CTDirect ∈ {0.17}
  - CTFlows ∈ {0.8}
  - CTModels ∈ {0.6}  ← Forces CTModels 0.6

CTDirect 0.17.5-beta requires:
  - CTModels ∈ {0.6}  ← Forces CTModels 0.6

CTFlows 0.8.11-beta requires:
  - CTModels ∈ {0.6, 0.7}  ← Accepts both

Intersection: {0.6} → Resolver picks CTModels 0.6.10-beta
```

### Invariant checks

- [x] **⋂ constraints ≠ ∅** (Invariant 1): Intersection = {0.6} (non-empty, forced by CTDirect and OptimalControl)
- [x] **Stable → stable only** (Invariant 2): All packages are beta, can depend on beta versions
- [x] **Users protected** (Invariant 3): Users still get CTModels 0.6.10-beta (safe, tested version)

### Expected breakage results

**On CTModels PR #248**: Breakage tests should now show:

- CTDirect: ❌ (expected, not adapted yet)
- CTFlows: ✅ (widened in Phase 1)
- OptimalControl: ❌ (expected, not adapted yet)

---

## Phase 3: CTDirect Adaptation (Breaking Package)

**Objective**: Adapt CTDirect code to work with CTModels v0.7.x and widen compat.

**Why this phase**: CTDirect is a direct dependent of CTModels and must be adapted before OptimalControl (which depends on CTDirect).

**Packages to modify**:

- CTDirect: 0.17.5-beta → 0.18.0-beta

### Code adaptation required

**Important**: Before modifying `Project.toml`, you must first adapt the CTDirect code to work with the new CTModels v0.7.x API.

**Steps to identify breaking changes**:

1. **Check CTModels CHANGELOG** or PR #248 for API changes
2. **Run CTDirect tests** with CTModels v0.7.0-beta to see failures:

   ```julia
   using Pkg
   Pkg.develop("CTDirect")
   Pkg.add(name="CTModels", version="0.7.0-beta")
   Pkg.test("CTDirect")
   ```

3. **Fix failing tests** by adapting code to new API
4. **Verify all tests pass** before proceeding

**Common breaking changes to look for**:

- Renamed functions or types
- Changed function signatures
- Removed deprecated functions
- Changed return types

### Project.toml changes

**Only after code adaptation is complete**:

#### CTDirect/Project.toml

**Before**:

```toml
version = "0.17.5-beta"

[compat]
CTModels = "0.6"
CTBase = "0.17"
```

**After**:

```toml
version = "0.18.0-beta"

[compat]
CTModels = "0.6, 0.7"  # Widened after code adaptation
CTBase = "0.17"
```

### Actions

1. **Navigate to CTDirect repository**:

   ```bash
   cd /path/to/CTDirect.jl
   git checkout main
   git pull
   ```

2. **Create adaptation branch**:

   ```bash
   git checkout -b breaking/ctmodels-0.7
   ```

3. **Adapt code** to work with CTModels v0.7.x (see "Code adaptation required" above)

4. **Run tests** to verify adaptation:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.test()'
   ```

5. **Update `Project.toml`** as shown above (only after tests pass)

6. **Commit changes**:

   ```bash
   git add .
   git commit -m "Adapt to CTModels v0.7.x and widen compat"
   git push -u origin breaking/ctmodels-0.7
   ```

7. **Register in ct-registry**:

   ```julia
   using LocalRegistry
   using CTDirect
   register(CTDirect, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/CTDirect.jl.git")
   ```

8. **Create GitHub tag**:

   ```bash
   git tag v0.18.0-beta
   git push origin v0.18.0-beta
   ```

9. **Create PR**:

   ```bash
   gh pr create --title "Adapt to CTModels v0.7.x" \
     --body "Adaptation for CTModels breaking change migration.
   
   Related to: control-toolbox/CTModels.jl#247
   
   This PR adapts CTDirect to work with CTModels v0.7.x.
   
   **Changes**:
   - Code adapted to new CTModels v0.7.x API
   - CTModels compat: \`0.6\` → \`0.6, 0.7\`
   - Version bump: \`0.17.5-beta\` → \`0.18.0-beta\`
   
   **Testing**:
   All tests pass with both CTModels 0.6.x and 0.7.x."
   ```

### Verification

```julia
using Pkg
Pkg.add("OptimalControl")
# Expected: CTModels 0.6.10-beta (still)
# Why: OptimalControl still has CTModels = "0.6" (not widened yet)
#      Even though CTDirect now accepts 0.7, OptimalControl forces 0.6
```

**Detailed constraint analysis**:

```
OptimalControl 1.1.8-beta requires:
  - CTDirect ∈ {0.17}  → Gets 0.18.0-beta
  - CTModels ∈ {0.6}   ← Still forces CTModels 0.6

CTDirect 0.18.0-beta requires:
  - CTModels ∈ {0.6, 0.7}  ← Accepts both

Intersection: {0.6} → Resolver still picks CTModels 0.6.10-beta
```

### Invariant checks

- [x] **⋂ constraints ≠ ∅** (Invariant 1): Intersection = {0.6} (forced by OptimalControl)
- [x] **Stable → stable only** (Invariant 2): All packages are beta
- [x] **Users protected** (Invariant 3): Users still get CTModels 0.6.10-beta (OptimalControl not widened yet)

### Expected breakage results

**On CTModels PR #248**: Breakage tests should now show:

- CTDirect: ✅ (adapted in this phase)
- CTFlows: ✅ (widened in Phase 1)
- OptimalControl: ❌ (not adapted yet)

---

## Phase 3.5: CTSolvers Beta Release (New Package)

**Objective**: Create and release the first beta version of CTSolvers, a new package in the ecosystem restructuring.

**Why this phase**: CTSolvers is a new package that will contain code moved from CTDirect. It depends on CTModels v0.7.x and CTBase, and will be used by OptimalControl. This phase must come after CTDirect adaptation (Phase 3) and before OptimalControl adaptation (Phase 4).

**Packages to create/modify**:

- CTSolvers: New package, first release v0.2.0-beta

### Package structure

CTSolvers is a **new package** with the following characteristics:

**Dependencies**:

- CTBase v0.17.x
- CTModels v0.7.x (uses the new API)

**Dependents**:

- OptimalControl (will use CTSolvers in Phase 4)

**Content**:

- Code moved from CTDirect
- New solver functionality for the control-toolbox ecosystem

### Project.toml setup

#### CTSolvers/Project.toml

**Initial version**:

```toml
name = "CTSolvers"
uuid = "[to-be-generated]"
version = "0.2.0-beta"
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

**Note**: Since this is a new package, it starts directly with CTModels v0.7.x (no need for progressive widening `"0.6, 0.7"`).

### Actions

1. **Verify CTSolvers repository exists**:

   ```bash
   # Check if repository exists
   ls /path/to/CTSolvers.jl
   ```

2. **Navigate to CTSolvers repository**:

   ```bash
   cd /path/to/CTSolvers.jl
   git checkout main
   git pull
   ```

3. **Ensure Project.toml is set up correctly**:
   - Version: `0.2.0-beta`
   - Dependencies: CTBase, CTModels (and others as needed)
   - Compat: `CTModels = "0.7"` (not `"0.6, 0.7"` since it's a new package)

4. **Verify code works with CTModels v0.7.x**:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.test()'
   ```

5. **Commit any final changes**:

   ```bash
   git add .
   git commit -m "Prepare CTSolvers v0.2.0-beta for first release"
   git push
   ```

6. **Register in ct-registry** (first time registration):

   ```julia
   using LocalRegistry
   using CTSolvers
   register(CTSolvers, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/CTSolvers.jl.git")
   ```

   **Important**: Since this is the **first registration** of CTSolvers (even in ct-registry), you **must** specify the `repo` parameter.

7. **Create GitHub tag**:

   ```bash
   git tag v0.2.0-beta
   git push origin v0.2.0-beta
   ```

8. **Create PR** (if needed):

   ```bash
   gh pr create --title "First beta release: CTSolvers v0.2.0-beta" \
     --body "First beta release of CTSolvers package.
   
   Related to: control-toolbox/CTModels.jl#247
   
   This is a new package in the control-toolbox ecosystem restructuring.
   
   **Dependencies**:
   - CTBase v0.17.x
   - CTModels v0.7.x (uses new API)
   
   **Features**:
   - Solver functionality moved from CTDirect
   - [List key features]
   
   **Testing**:
   All tests pass with CTModels v0.7.x."
   ```

### Verification

```julia
using Pkg
Pkg.add(name="CTSolvers", version="0.2.0-beta")
# Expected: CTSolvers 0.2.0-beta, CTModels 0.7.0-beta, CTBase 0.17.4
# Why: CTSolvers requires CTModels = "0.7", so resolver picks 0.7.0-beta
```

**Note**: Installing CTSolvers alone will pull CTModels v0.7.0-beta, but installing OptimalControl (not yet updated) will still pull CTModels v0.6.10-beta.

### Invariant checks

- [x] **⋂ constraints ≠ ∅** (Invariant 1): CTSolvers requires CTModels 0.7, which exists
- [x] **Stable → stable only** (Invariant 2): CTSolvers is beta, can depend on beta CTModels
- [x] **New package introduction** (Property): New package correctly integrated into ecosystem

### Expected breakage results

**On CTModels PR #248**: Breakage tests should still show:

- CTDirect: ✅ (adapted in Phase 3)
- CTFlows: ✅ (widened in Phase 1)
- OptimalControl: ❌ (not adapted yet, doesn't use CTSolvers yet)

**Note**: CTSolvers won't appear in breakage tests yet since it's a new package not yet used by existing packages.

---

## Phase 4: OptimalControl Adaptation (Breaking Package)

**Objective**: Adapt OptimalControl code to work with CTModels v0.7.x, integrate CTSolvers, and widen compat using a **phased beta approach**.

**Why this phase**: OptimalControl is the top-level package. This phase integrates the new CTSolvers package and adapts to CTModels v0.7.x through multiple beta releases.

**Packages to modify**:

- OptimalControl: 1.1.8-beta → 2.0.0-beta.1 → 2.0.0-beta.2 → 2.0.0 (final)

> [!IMPORTANT]
> **Phased Beta Strategy**
>
> - **v2.0.0-beta.1**: Minimal integration with CTSolvers (limited tests)
> - **v2.0.0-beta.2**: Complete integration with all tests
> - **v2.0.0**: Final release after Phase 5 validation

**Detailed roadmap**: See `phase4-detailed-roadmap.md` for complete plan

---

### Phase 4.1: Initial Integration (v2.0.0-beta.1)

**Objective**: Minimal viable integration with CTSolvers

#### Code changes required

1. **Integrate solve_api.jl from CTSolvers**
   - Source: <https://github.com/control-toolbox/CTSolvers.jl/raw/main/src/optimalcontrol/solve_api.jl>
   - Copy to `src/solve_api.jl` in OptimalControl
   - Adapt imports/exports as needed

2. **Integrate associated tests**
   - Source: <https://raw.githubusercontent.com/control-toolbox/CTSolvers.jl/main/test/optimalcontrol/test_optimalcontrol_solve_api.jl>
   - Copy to `test/test_solve_api.jl`
   - Adapt test structure for OptimalControl

3. **Temporarily comment out other tests**
   - Modify `test/runtests.jl`
   - Keep only `test_solve_api.jl` active
   - Document which tests are disabled

#### Project.toml changes

**Before**:

```toml
version = "1.1.8-beta"

[compat]
CTDirect = "0.17"
CTFlows = "0.8"
CTModels = "0.6"
CTParser = "0.8"
CTBase = "0.17"
```

**After**:

```toml
version = "2.0.0-beta.1"

[deps]
# ... existing deps
CTSolvers = "..."  # NEW: Add CTSolvers

[compat]
CTDirect = "0.17, 0.18"
CTFlows = "0.8"
CTModels = "0.6, 0.7"  # Widened
CTParser = "0.8"
CTSolvers = "0.2"  # NEW
CTBase = "0.17"
```

#### Actions

1. **Navigate to OptimalControl repository**:

   ```bash
   cd /path/to/OptimalControl.jl
   git fetch --tags
   git checkout v1.1.8-beta
   git checkout -b breaking/ctmodels-0.7
   ```

2. **Integrate solve_api.jl and tests** (see code changes above)

3. **Update `Project.toml`** as shown above

4. **Run tests** to verify integration:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.test()'
   # Should pass with only solve_api tests
   ```

5. **Commit changes**:

   ```bash
   git add .
   git commit -m "Initial CTSolvers integration (v2.0.0-beta.1)"
   git push
   ```

6. **Register in ct-registry**:

   ```julia
   using LocalRegistry
   using OptimalControl
   register(OptimalControl, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/OptimalControl.jl.git")
   ```

7. **Create GitHub tag**:

   ```bash
   git tag v2.0.0-beta.1
   git push origin v2.0.0-beta.1
   ```

---

### Phase 4.2: Export Macro Improvement

**Objective**: Simplify and improve import/export management

#### Current Problem

```julia
# Repetitive pattern in OptimalControl.jl
import CTBase: foo, bar, baz
export foo, bar  # baz imported but not exported

import CTModels: qux, quux
export qux, quux
```

#### Proposed Solution

```julia
# New macro-based approach
@reexport_from CTBase [foo, bar, baz] exclude=[baz]
@reexport_from CTModels [qux, quux]
```

#### Implementation

1. **Create `src/export_macros.jl`**:

```julia
"""
    @reexport_from Module [symbols...] exclude=[excluded_symbols...]

Import symbols from Module and re-export them, optionally excluding some from export.

# Example
```julia
@reexport_from CTBase [foo, bar, baz] exclude=[baz]
# Equivalent to:
# import CTBase: foo, bar, baz
# export foo, bar
```

"""
macro reexport_from(mod, imports, exclude=Symbol[])
    # Implementation
end

```

2. **Refactor `src/OptimalControl.jl`** to use new macro

3. **Test all exports work correctly**

4. **Commit changes**:

   ```bash
   git add .
   git commit -m "Improve export management with @reexport_from macro"
   git push
   ```

---

### Phase 4.3: Complete Integration (v2.0.0-beta.2)

**Objective**: Full test suite passing

#### Actions

1. **Re-enable all tests** in `test/runtests.jl`

2. **Fix any failing tests**:
   - Adapt to CTModels v0.7.x API changes
   - Ensure CTSolvers integration works
   - Verify compatibility

3. **Update `Project.toml`**:

   ```toml
   version = "2.0.0-beta.2"
   ```

4. **Run full test suite**:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.test()'
   # All tests should pass
   ```

5. **Commit changes**:

   ```bash
   git add .
   git commit -m "Complete integration with all tests (v2.0.0-beta.2)"
   git push
   ```

6. **Register in ct-registry**:

   ```julia
   using LocalRegistry
   using OptimalControl
   register(OptimalControl, 
            registry = "ct-registry")
   ```

7. **Create GitHub tag**:

   ```bash
   git tag v2.0.0-beta.2
   git push origin v2.0.0-beta.2
   ```

8. **Update PR** with progress

### Verification

```julia
using Pkg
Pkg.add(name="OptimalControl", version="2.0.0-beta.2")
# Expected: CTModels 0.7.0-beta, CTSolvers 0.2.0-beta
# All dependencies at correct versions
```

**Detailed constraint analysis**:

```
OptimalControl 2.0.0-beta.2 requires:
  - CTDirect ∈ {0.17, 0.18}  → Gets 0.18.0-beta
  - CTFlows ∈ {0.8}          → Gets 0.8.11-beta
  - CTModels ∈ {0.6, 0.7}    → Gets 0.7.0-beta
  - CTSolvers ∈ {0.2}        → Gets 0.2.0-beta
  - CTParser ∈ {0.8}         → Gets 0.8.2-beta
  - CTBase ∈ {0.17}          → Gets 0.17.4

All packages now use CTModels v0.7.0-beta! ✅
```

### Invariant checks

- [x] **⋂ constraints ≠ ∅** (Invariant 1): All packages accept CTModels 0.7.x
- [x] **Stable → stable only** (Invariant 2): All packages are beta
- [x] **Users get expected versions** (Invariant 3): Resolver picks CTModels 0.7.0-beta

### Expected breakage results

**On CTModels PR #248**: All breakage tests should now pass:

- CTDirect: ✅ (adapted in Phase 3)
- CTFlows: ✅ (widened in Phase 1)
- OptimalControl: ✅ (adapted in this phase)

---

## Phase 5: Systematic Sub-Package Validation

**Objective**: Validate all sub-packages for final v2.0.0 release

**Strategy**: Bottom-up validation through dependency tree

**See**: `phase4-detailed-roadmap.md` for complete Phase 5 plan

### Validation Order

1. CTBase (foundation)
2. CTModels, CTParser (depend on CTBase)
3. CTFlows, CTSolvers (depend on CTModels)
4. CTDirect (depends on CTModels, CTSolvers)
5. OptimalControl v2.0.0 final (depends on all)

### Standard Process for Each Package

1. **Coverage Improvement** (using `CTBase.CoveragePostprocessing`)
2. **Documentation Enhancement** (using `CTBase.DocumenterReference`)
3. **Test Execution Modernization** (using `CTBase.TestRunner`)
4. **Package-Specific Tasks** (see roadmap)
5. **Final Beta Release**

### Package-Specific Tasks

- **CTModels**: Clarify interfaces, add options, add Makie extension
- **CTFlows**: Finalize restructuring, introduce new features
- **CTParser**: Review and determine improvements
- **CTSolvers**: Add solver options
- **CTDirect**: Update tests for CTSolvers, rewrite Collocation, choose name

### Timeline

- Phase 4 (beta.1, beta.2): ~1 week
- Phase 5 (sub-package validation): ~2-3 weeks
- **Total**: ~4 weeks for v2.0.0 final release

---

## Migration Complete

Once Phase 5 is complete:

- All sub-packages validated and at final beta versions
- OptimalControl v2.0.0 stable released
- All packages in ecosystem support CTModels v0.7.x
- Migration from CTModels 0.6.10-beta to 0.7.0 complete

**Total migration phases**: 6 (Phases 1-3.5 complete, Phase 4 in progress, Phase 5 planned)

OptimalControl 2.0.0-beta requires:

- CTDirect ∈ {0.17}  → Gets 0.18.0-beta
- CTFlows ∈ {0.8}    → Gets 0.8.11-beta
- CTModels ∈ {0.6, 0.7}  ← Accepts both

CTDirect 0.18.0-beta requires:

- CTModels ∈ {0.6, 0.7}  ← Accepts both

CTFlows 0.8.11-beta requires:

- CTModels ∈ {0.6, 0.7}  ← Accepts both

Intersection: {0.6, 0.7} → Resolver picks latest: 0.7.0-beta ✅

```

### Invariant checks

- [x] **⋂ constraints ≠ ∅** (Invariant 1): Intersection = {0.6, 0.7} (non-empty)
- [x] **Stable → stable only** (Invariant 2): All packages are beta
- [x] **Users get latest** (Invariant 3): Users now get CTModels 0.7.0-beta (all packages support it)

### Expected breakage results

**On CTModels PR #248**: Breakage tests should now show:

- CTDirect: ✅ (adapted in Phase 3)
- CTFlows: ✅ (widened in Phase 1)
- OptimalControl: ✅ (adapted in this phase)

**🎉 All packages now support CTModels v0.7.x!**

---

## Phase 5: Stabilization and Cleanup

**Objective**: Merge the existing v0.7.0 into the breaking branch and prepare for stable releases.

**Why this phase**: The beta migration is complete. Now we can merge the final v0.7.0 changes and optionally release stable versions.

**Note**: This phase is optional and depends on your release strategy. You may choose to:

- **Option A**: Keep beta versions for now, stabilize later
- **Option B**: Release stable versions immediately
- **Option C**: Merge v0.7.0 into breaking branch but delay stable releases

### Actions (Option C - Recommended)

1. **Merge v0.7.0 into breaking branch**:

   ```bash
   cd /path/to/CTModels.jl
   git checkout breaking/ctmodels-0.7
   git merge v0.7.0
   # Resolve any conflicts (likely just version number in Project.toml)
   git commit -m "Merge v0.7.0 into breaking branch"
   git push
   ```

1. **Update PR #248**:
   - Add comment explaining that v0.7.0 has been merged
   - Update PR description if needed
   - Keep PR open for now (or merge to main if ready)

2. **Monitor ecosystem**:
   - Wait for users to test beta versions
   - Collect feedback
   - Fix any issues discovered

3. **Plan stable releases** (when ready):
   - CTModels: v0.7.0 (already exists, just merge PR)
   - CTFlows: v0.9.0 (major bump, or keep beta)
   - CTDirect: v0.18.0 (major bump, or keep beta)
   - OptimalControl: v1.2.0 (minor bump, or keep beta)

### Verification

```julia
using Pkg
Pkg.add("OptimalControl")
# Expected: All beta versions
# CTModels 0.7.0-beta
# CTDirect 0.18.0-beta
# CTFlows 0.8.11-beta
# OptimalControl 2.0.0-beta
```

### Invariant checks

- [x] **Migration complete**: All packages support CTModels v0.7.x
- [x] **Ecosystem stable**: All tests passing
- [x] **Ready for stable releases**: When appropriate

---

## Verification Checklist

Track your progress through the migration:

- [ ] **Phase 1**: CTFlows widening complete
  - [ ] CTFlows v0.8.11-beta registered in ct-registry
  - [ ] PR created and tests passing
  
- [ ] **Phase 2**: CTModels beta release complete
  - [ ] CTModels v0.7.0-beta registered in ct-registry
  - [ ] Tag v0.7.0-beta created
  - [ ] Breakage tests show CTFlows ✅, others ❌
  
- [ ] **Phase 3**: CTDirect adaptation complete
  - [ ] Code adapted to CTModels v0.7.x
  - [ ] CTDirect v0.18.0-beta registered in ct-registry
  - [ ] PR created and tests passing
  - [ ] Breakage tests show CTDirect ✅, CTFlows ✅, OptimalControl ❌
  
- [ ] **Phase 3.5**: CTSolvers beta release complete
  - [ ] CTSolvers v0.2.0-beta registered in ct-registry
  - [ ] Tag v0.2.0-beta created
  - [ ] Tests passing with CTModels v0.7.x
  - [ ] Ready for integration in OptimalControl
  
- [ ] **Phase 4**: OptimalControl adaptation complete
  - [ ] Code adapted to CTModels v0.7.x
  - [ ] CTSolvers integrated as dependency
  - [ ] OptimalControl v2.0.0-beta registered in ct-registry
  - [ ] PR created and tests passing
  - [ ] Breakage tests show all ✅
  
- [ ] **Phase 5**: Stabilization (optional)
  - [ ] v0.7.0 merged into breaking branch
  - [ ] Ecosystem monitoring complete
  - [ ] Stable releases planned/executed

---

## Troubleshooting

### Issue: LocalRegistry.register() fails

**Error**: `Package not found in registry`

**Solution**: Add the `repo` parameter:

```julia
register(YourPackage, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/YourPackage.jl.git")
```

### Issue: Tests fail with CTModels v0.7.x

**Solution**:

1. Check CTModels CHANGELOG for breaking changes
2. Look at CTModels PR #248 for API changes
3. Adapt code to new API before widening compat
4. Run tests locally before registering

### Issue: Resolver picks wrong version

**Solution**:

1. Check all compat constraints in the ecosystem
2. Verify that all necessary packages have been widened
3. Use `Pkg.resolve()` to see constraint resolution
4. Check ct-registry is properly configured

---

## References

- **Setup report**: [setup.md](./setup.md)
- **Methodology**: [breaking-change-rules.md](../../breaking-change-rules.md)
- **Invariants**: [invariants-analysis.md](../../experiments/dependency-graph/invariants-analysis.md)
- **CTModels Issue**: <https://github.com/control-toolbox/CTModels.jl/issues/247>
- **CTModels PR**: <https://github.com/control-toolbox/CTModels.jl/pull/248>

---

## Notes

- **Beta strategy**: All versions use beta releases in ct-registry
- **Progressive widening**: All packages use `"0.6, 0.7"` format
- **Code adaptation**: CTDirect and OptimalControl require code changes
- **Testing**: Verify each phase with breakage tests before proceeding
- **Flexibility**: Phases can be adjusted based on actual results

---

**Ready to start? Begin with Phase 1: CTFlows Widening**
