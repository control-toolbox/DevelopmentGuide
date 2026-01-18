# Breaking Change Action Plan - CTParser

**Generated**: 2026-01-17 23:03:00  
**Based on**: `reports-breaking/2026-01-17-ctparser-0.8.2-beta/setup.md`  
**Package**: CTParser v0.8.1 → v0.8.2-beta (provisional)  
**Complexity**: Simple (Leaf package with single dependent)  
**Issue**: [#207](https://github.com/control-toolbox/CTParser.jl/issues/207)  
**PR**: [#208](https://github.com/control-toolbox/CTParser.jl/pull/208)

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
using YourPackage  # e.g., using OptimalControl
register(YourPackage, 
         registry = "ct-registry",
         repo = "git@github.com:org/YourPackage.jl.git")
```

**Note**:

- If the package is **already in ct-registry**, you can omit the `repo` parameter
- If it's the **first time** registering in ct-registry (even if it exists in General registry), you must specify `repo`
- Example: `repo = "git@github.com:control-toolbox/OptimalControl.jl.git"`

1. **Create GitHub tag** manually:

```bash
git tag v1.1.8-beta
git push origin v1.1.8-beta
```

**Note**: For stable (non-beta) releases, use `@JuliaRegistrator register()` as usual.

---

## Summary

**Migration overview**:

- Breaking package: CTParser (leaf package)
- Direct dependent: OptimalControl
- **Status**: ✅ **Breakage tests passed - Fully compatible**
- Total phases: 2 (simplified from 3)
- Estimated duration: 1 day

**Breakage Test Results** (2026-01-18):

- OptimalControl: ✅ All tests passing
- Conclusion: CTParser v0.8.1 is fully compatible

**Strategy** (confirmed compatible path):

1. **Phase 1**: Widen compat in OptimalControl to accept CTParser v0.8.x ✅
2. **Phase 2**: Create CTParser v0.8.2-beta (minor version, not v0.9.0)

**~~Phase 3B not needed~~**: No breaking changes detected, no adaptation required.

---

## Phase 1: Preparation (Widening)

**Objective**: Widen compat in OptimalControl to accept CTParser v0.8.x, creating a resolution path for testing.

**Packages to modify**:

- OptimalControl: v1.1.7-beta → v1.1.8-beta

### Project.toml Changes

#### OptimalControl/Project.toml

**Current**:

```toml
version = "1.1.7-beta"

[compat]
CTParser = "0.7"  # ← Blocks CTParser v0.8.x
```

**New**:

```toml
version = "1.1.8-beta"

[compat]
CTParser = "0.7, 0.8"  # ← Widened to accept v0.8.x
```

### Actions

1. **Navigate to OptimalControl repository**:

   ```bash
   cd ~/Research/logiciels/dev/control-toolbox/OptimalControl
   ```

2. **Ensure you're on the correct branch** (main or create a new branch):

   ```bash
   git checkout main
   # OR create a new branch if preferred:
   # git checkout -b widening/ctparser-0.8
   ```

3. **Edit `Project.toml`**:
   - Change `version = "1.1.7-beta"` to `version = "1.1.8-beta"`
   - Change `CTParser = "0.7"` to `CTParser = "0.7, 0.8"`

4. **Commit changes**:

   ```bash
   git add Project.toml
   git commit -m "Widen compat for CTParser v0.8.x migration

   - Accept CTParser v0.7 and v0.8
   - Prepare for CTParser v0.8.2-beta testing
   - Part of migration tracked in control-toolbox/CTParser.jl#207"
   ```

5. **Push to GitHub**:

   ```bash
   git push
   ```

6. **Register OptimalControl v1.1.8-beta in ct-registry**:

   ```julia
   using LocalRegistry
   using OptimalControl
   
   # First time registering OptimalControl in ct-registry
   register(OptimalControl, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/OptimalControl.jl.git")
   ```

7. **Create and push git tag**:

   ```bash
   git tag v1.1.8-beta
   git push origin v1.1.8-beta
   ```

### Verification

**Test that OptimalControl v1.1.8-beta is available**:

```julia
using Pkg
Pkg.Registry.update()  # Update registries

# Try to add OptimalControl@1.1.8-beta
Pkg.add(name="OptimalControl", version="1.1.8-beta")

# Check installed version
Pkg.status("OptimalControl")
# Expected: OptimalControl v1.1.8-beta
```

**Verify current stable resolution** (should still use old versions):

```julia
# In a fresh environment
using Pkg
Pkg.add("OptimalControl")

# Expected versions:
# - OptimalControl: v1.1.7-beta (latest stable in ct-registry)
# - CTParser: v0.7.3-beta (forced by OptimalControl v1.1.7-beta)

# Why: OptimalControl v1.1.8-beta is a pre-release and won't be 
# selected unless explicitly requested
```

### Invariant Checks

- ✅ **Invariant 1** (⋂ constraints ≠ ∅):
  - OptimalControl v1.1.8-beta can now resolve with CTParser v0.8.x
  - Resolution path created for testing
  
- ✅ **Invariant 2** (Stable closure):
  - OptimalControl v1.1.8-beta is beta (not stable)
  - Can depend on CTParser v0.8.x-beta without violating stable closure
  
- ✅ **Invariant 3** (Stability preference):
  - Users installing OptimalControl still get v1.1.7-beta (latest stable)
  - v1.1.8-beta only used when explicitly requested

### Expected Breakage Results

Not applicable yet - breakage tests will run in Phase 2.

---

## Phase 2: Breakage Testing

> **✅ UPDATE (2026-01-18)**: This phase has been completed. Breakage tests were run and **all tests passed**. OptimalControl is fully compatible with CTParser v0.8.1. Proceed directly to **Phase 3A** (create v0.8.2-beta). Phase 3B is not needed.

**Objective**: Run breakage tests on CTParser PR to assess compatibility with OptimalControl.

### Actions

1. **Ensure CTParser PR #208 is ready**:
   - Branch: `breaking/ctparser-0.8.2-beta`
   - Current version in Project.toml: `0.8.1`
   - All changes committed and pushed

2. **Trigger breakage tests**:
   - The breakage tests should run automatically on PR #208
   - If not, push a commit to trigger CI:

     ```bash
     cd ~/Research/logiciels/dev/control-toolbox/CTParser.jl
     git commit --allow-empty -m "Trigger breakage tests"
     git push
     ```

3. **Wait for breakage test results**:
   - Check PR #208 for the breakage test comment
   - Look for the table showing test results for OptimalControl

### Interpreting Results

The breakage test will show one of these outcomes:

#### Scenario A: OptimalControl tests PASS ✅

**Interpretation**: CTParser v0.8.1 is **compatible** with OptimalControl

**Next action**: Proceed to **Phase 3A** (Create v0.8.2-beta)

**Example result**:

```
| Package | Latest | Stable | Status |
|---------|--------|--------|--------|
| OptimalControl | ✅ | ✅ | Compatible |
```

#### Scenario B: OptimalControl tests FAIL ❌

**Interpretation**: CTParser v0.8.1 introduces **breaking changes**

**Next action**: Proceed to **Phase 3B** (Create v0.9.0-beta and adapt OptimalControl)

**Example result**:

```
| Package | Latest | Stable | Status |
|---------|--------|--------|--------|
| OptimalControl | ❌ | ❌ | Breaking |
```

### Verification

**Check that tests ran with correct versions**:

- Breakage test should install OptimalControl v1.1.8-beta (from ct-registry)
- This version accepts CTParser v0.8.x
- Test runs with CTParser from PR branch

**If tests fail with "Unsatisfiable requirements"**:

- ❌ This means the widening didn't work correctly
- Check that OptimalControl v1.1.8-beta is registered in ct-registry
- Check that breakage workflow includes ct-registry
- Verify compat constraint is `CTParser = "0.7, 0.8"`

---

## Phase 3A: Create CTParser v0.8.2-beta (If Compatible)

**Condition**: Execute this phase ONLY if Phase 2 shows OptimalControl tests PASS ✅

**Objective**: Create CTParser v0.8.2-beta as a compatible minor version.

### Project.toml Changes

#### CTParser/Project.toml

**Current**:

```toml
version = "0.8.1"
```

**New**:

```toml
version = "0.8.2-beta"
```

### Actions

1. **Navigate to CTParser repository**:

   ```bash
   cd ~/Research/logiciels/dev/control-toolbox/CTParser.jl
   git checkout breaking/ctparser-0.8.2-beta
   ```

2. **Update version in Project.toml**:
   - Change `version = "0.8.1"` to `version = "0.8.2-beta"`

3. **Commit changes**:

   ```bash
   git add Project.toml
   git commit -m "Bump version to v0.8.2-beta

   - Compatible with OptimalControl (tests passed)
   - Beta version for ecosystem testing
   - Tracked in #207"
   ```

4. **Push to GitHub**:

   ```bash
   git push
   ```

5. **Register CTParser v0.8.2-beta in ct-registry**:

   ```julia
   using LocalRegistry
   using CTParser
   
   # Register in ct-registry
   register(CTParser, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/CTParser.jl.git")
   ```

6. **Create and push git tag**:

   ```bash
   git tag v0.8.2-beta
   git push origin v0.8.2-beta
   ```

### Verification

**Test that CTParser v0.8.2-beta works with OptimalControl**:

```julia
using Pkg

# Add OptimalControl with CTParser beta
Pkg.add(name="OptimalControl", version="1.1.8-beta")

# Check versions
Pkg.status()
# Expected:
# - OptimalControl v1.1.8-beta
# - CTParser v0.8.2-beta (or v0.8.1 if v0.8.2-beta not yet in registry)
```

### Next Steps After Phase 3A

**Migration complete for beta testing!** 🎉

The ecosystem now has:

- ✅ CTParser v0.8.2-beta available for testing
- ✅ OptimalControl v1.1.8-beta compatible with it
- ✅ Users protected (still get old stable versions)

**Future actions** (not part of this migration):

1. Monitor beta usage and gather feedback
2. When ready to stabilize:
   - Release CTParser v0.8.2 (stable)
   - Release OptimalControl v1.1.8 (stable)
   - Follow bottom-up stabilization order

---

## Phase 3B: Create CTParser v0.9.0-beta (If Breaking)

**Condition**: Execute this phase ONLY if Phase 2 shows OptimalControl tests FAIL ❌

**Objective**: Create CTParser v0.9.0-beta and adapt OptimalControl to work with it.

### Part 1: Create CTParser v0.9.0-beta

#### CTParser/Project.toml

**Current**:

```toml
version = "0.8.1"
```

**New**:

```toml
version = "0.9.0-beta"
```

#### Actions

1. **Navigate to CTParser repository**:

   ```bash
   cd ~/Research/logiciels/dev/control-toolbox/CTParser.jl
   git checkout breaking/ctparser-0.8.2-beta
   ```

2. **Update version in Project.toml**:
   - Change `version = "0.8.1"` to `version = "0.9.0-beta"`

3. **Commit changes**:

   ```bash
   git add Project.toml
   git commit -m "Bump version to v0.9.0-beta (breaking changes)

   - Breaking changes detected in OptimalControl tests
   - Requires adaptation in dependents
   - Tracked in #207"
   ```

4. **Push to GitHub**:

   ```bash
   git push
   ```

5. **Register CTParser v0.9.0-beta in ct-registry**:

   ```julia
   using LocalRegistry
   using CTParser
   
   register(CTParser, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/CTParser.jl.git")
   ```

6. **Create and push git tag**:

   ```bash
   git tag v0.9.0-beta
   git push origin v0.9.0-beta
   ```

### Part 2: Adapt OptimalControl

**Objective**: Fix OptimalControl to work with CTParser v0.9.0-beta.

#### Actions

1. **Analyze breakage test failures**:
   - Review the error messages from Phase 2
   - Identify what changed in CTParser API
   - Determine required fixes in OptimalControl

2. **Create adaptation branch**:

   ```bash
   cd ~/Research/logiciels/dev/control-toolbox/OptimalControl
   git checkout -b adapt/ctparser-0.9
   ```

3. **Make necessary code changes**:
   - Fix API usage to match CTParser v0.9.0-beta
   - Update tests if needed
   - Document changes

4. **Update Project.toml**:

   ```toml
   version = "1.1.9-beta"  # New beta version
   
   [compat]
   CTParser = "0.7, 0.9"  # Accept v0.9.x instead of v0.8.x
   ```

5. **Test locally**:

   ```julia
   using Pkg
   Pkg.develop(path="~/Research/logiciels/dev/control-toolbox/OptimalControl")
   Pkg.add(name="CTParser", version="0.9.0-beta")
   Pkg.test("OptimalControl")
   ```

6. **Commit and push**:

   ```bash
   git add .
   git commit -m "Adapt to CTParser v0.9.0-beta breaking changes

   - Fix API usage for CTParser v0.9
   - Update compat to accept v0.9.x
   - Tracked in control-toolbox/CTParser.jl#207"
   git push -u origin adapt/ctparser-0.9
   ```

7. **Create PR for OptimalControl adaptation**:

   ```bash
   gh pr create --title "Adapt to CTParser v0.9.0-beta" \
                --body "Adapts OptimalControl to work with CTParser v0.9.0-beta breaking changes.

   Related to control-toolbox/CTParser.jl#207"
   ```

8. **Register OptimalControl v1.1.9-beta in ct-registry**:

   ```julia
   using LocalRegistry
   using OptimalControl
   
   register(OptimalControl, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/OptimalControl.jl.git")
   ```

9. **Create and push git tag**:

   ```bash
   git tag v1.1.9-beta
   git push origin v1.1.9-beta
   ```

### Verification

**Test that adapted OptimalControl works with CTParser v0.9.0-beta**:

```julia
using Pkg

# Add both beta versions
Pkg.add(name="OptimalControl", version="1.1.9-beta")
Pkg.add(name="CTParser", version="0.9.0-beta")

# Run tests
Pkg.test("OptimalControl")
# Expected: All tests pass ✅
```

### Next Steps After Phase 3B

**Migration complete for beta testing!** 🎉

The ecosystem now has:

- ✅ CTParser v0.9.0-beta available
- ✅ OptimalControl v1.1.9-beta adapted to work with it
- ✅ Users protected (still get old stable versions)

**Future actions** (not part of this migration):

1. Monitor beta usage and gather feedback
2. When ready to stabilize:
   - Release CTParser v0.9.0 (stable) - FIRST
   - Release OptimalControl v1.1.9 (stable) - AFTER CTParser
   - Follow bottom-up stabilization order (Invariant 2)

---

## Verification Checklist

Track your progress through the migration:

- [ ] **Phase 1**: OptimalControl v1.1.8-beta registered with widened compat
- [ ] **Phase 2**: Breakage tests run on CTParser PR #208
- [ ] **Decision**: Determined if compatible (→ 3A) or breaking (→ 3B)

**If compatible (Phase 3A)**:

- [ ] CTParser v0.8.2-beta created and registered
- [ ] Verified OptimalControl v1.1.8-beta works with CTParser v0.8.2-beta

**If breaking (Phase 3B)**:

- [ ] CTParser v0.9.0-beta created and registered
- [ ] OptimalControl adapted to work with CTParser v0.9.0-beta
- [ ] OptimalControl v1.1.9-beta registered
- [ ] Verified adapted OptimalControl works with CTParser v0.9.0-beta

---

## Invariant Summary

This migration maintains all fundamental invariants:

### ✅ Invariant 1: Non-Empty Intersection

- **Phase 1**: Widening creates resolution path for CTParser v0.8.x
- **Phase 3**: Beta versions can be installed together with widened compat

### ✅ Invariant 2: Stable Closure

- All beta versions (OptimalControl v1.1.8-beta, CTParser v0.8.2-beta/v0.9.0-beta) are marked as pre-releases
- No stable version depends on beta versions

### ✅ Invariant 3: Stability Preference

- Users installing OptimalControl get stable versions (v1.1.7-beta is latest stable)
- Beta versions only used when explicitly requested

### ✅ Property 4: Bottom-Up Stabilization

- When stabilizing (future): CTParser must be stabilized BEFORE OptimalControl
- This ensures OptimalControl stable doesn't depend on CTParser beta

---

## References

- **Setup report**: [`setup.md`](./setup.md)
- **Methodology**: [`breaking-change-rules.md`](../../breaking-change-rules.md)
- **Case study**: [`case-study-ctdirect-breaking.md`](../../case-study-ctdirect-breaking.md) (similar leaf package)
- **Issue**: [CTParser.jl#207](https://github.com/control-toolbox/CTParser.jl/issues/207)
- **PR**: [CTParser.jl#208](https://github.com/control-toolbox/CTParser.jl/pull/208)

---

## Notes

- This is a **simple migration** (leaf package, single dependent)
- The critical decision point is Phase 2 (breakage test results)
- Phase 3A (compatible) is much simpler than Phase 3B (breaking)
- All beta versions use ct-registry for faster iteration
- Users are protected throughout the migration (Invariant 3)
