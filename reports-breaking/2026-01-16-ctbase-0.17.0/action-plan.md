# Breaking Change Action Plan

**Generated**: 2026-01-17 13:17:00  
**Based on**: reports-breaking/2026-01-16-ctbase-0.17.0/setup.md  
**Package**: CTBase 0.16.2 → 0.17.0  
**Complexity**: LOW (Simple compat widening)

---

## Summary

**Excellent news!** ✅ All packages are compatible with CTBase v0.17.0.

**Migration overview**:

- **Breaking package**: CTBase v0.16.2 → v0.17.0
- **Affected packages**: 3 (CTDirect, CTFlows, OptimalControl)
- **Strategy**: Simple compat widening (no code changes needed)
- **Estimated duration**: 1-2 days

**Breakage test results**:

- CTDirect v0.17.4: ✅ Compatible
- CTFlows v0.8.9: ✅ Compatible
- CTModels v0.6.10-beta: ✅ Compatible
- CTParser v0.7.3-beta: ✅ Compatible
- OptimalControl v1.1.6: ✅ Compatible

**Beta versions** (CTModels v0.6.10-beta and CTParser v0.7.3-beta) confirmed that no packages are broken by CTBase v0.17.0.

---

## Compat Strategy: Progressive Widening

For this migration, we use **progressive widening** (`CTBase = "0.16, 0.17"`) rather than direct migration (`CTBase = "0.17"`).

### Why Progressive Widening?

**Chosen approach**: `CTBase = "0.16, 0.17"`

✅ **Advantages**:

1. **Smooth transition** - Users can migrate at their own pace
2. **SemVer compliance** - Patch releases (v0.17.4 → v0.17.5) don't break compatibility
3. **Safety net** - If CTBase v0.17 has issues, users can stay on v0.16
4. **Backward compatibility** - Existing projects using CTBase v0.16 continue to work
5. **Reduced pressure** - No forced immediate migration

❌ **Trade-offs**:

- Longer maintenance period (supporting two versions)
- Slightly more complex testing

### Alternative: Direct Migration

**Not chosen**: `CTBase = "0.17"` (would require v0.18.0, not v0.17.5)

This would:

- ✅ Force adoption of CTBase v0.17
- ✅ Simplify maintenance (one version only)
- ❌ Break SemVer (patch release becomes breaking)
- ❌ Force immediate migration for all users
- ❌ No fallback if issues arise

### Future Cleanup

After a transition period (e.g., 6 months), we can release major versions that drop CTBase v0.16 support:

- CTDirect v0.18.0 with `CTBase = "0.17"`
- CTFlows v0.9.0 with `CTBase = "0.17"`
- OptimalControl v1.2.0 with `CTBase = "0.17"`

---

## Migration Strategy: Two-Phase Approach

This migration uses a **two-phase beta-to-stable strategy** to ensure thorough testing before public release.

### Why Two Phases?

Since CTModels v0.6.10-beta and CTParser v0.7.3-beta are already in ct-registry for testing, we'll complete the beta ecosystem before releasing stable versions.

**Benefits**:

- ✅ Complete beta ecosystem for internal testing
- ✅ Time to validate all interactions
- ✅ Coordinated stable release when ready
- ✅ No premature releases in General registry

### Phase 1: Beta Ecosystem (Internal Testing)

**Goal**: Create beta versions in ct-registry for comprehensive testing

**Duration**: 1-2 weeks (testing period)

**Packages**:

1. CTDirect v0.17.5-beta (ct-registry)
2. CTFlows v0.8.10-beta (ct-registry)
3. OptimalControl v1.1.7-beta (ct-registry)

**Who can use**: Internal developers with ct-registry configured

**Purpose**: Validate entire ecosystem with CTBase v0.17.0

### Phase 2: Stable Release (Public Availability)

**Goal**: Release stable versions in General registry

**Duration**: 1 day (after Phase 1 validation)

**Packages**:

1. CTDirect v0.17.5 (General registry)
2. CTFlows v0.8.10 (General registry)
3. OptimalControl v1.1.7 (General registry)

**Who can use**: All users (public)

**Trigger**: After successful beta testing and validation

---

## Phase 1: Beta Ecosystem (ct-registry)

**Objective**: Create and test beta versions in ct-registry

**Duration**: 1-2 weeks

**Packages to create**:

1. CTDirect v0.17.4 → v0.17.5-beta (ct-registry)
2. CTFlows v0.8.9 → v0.8.10-beta (ct-registry)
3. OptimalControl v1.1.6 → v1.1.7-beta (ct-registry)

---

### Step 1.1: CTDirect v0.17.4 → v0.17.5-beta

**Type**: Beta release (ct-registry)

**Changes needed**:

- Update `Project.toml` version: `0.17.5-beta`
- Update `Project.toml` compat: `CTBase = "0.16, 0.17"`

**Steps**:

1. **Create branch**:

   ```bash
   cd CTDirect.jl
   git checkout main
   git pull
   git checkout -b beta/ctbase-0.17-compat
   ```

2. **Update Project.toml**:

   ```toml
   version = "0.17.5-beta"
   
   [compat]
   CTBase = "0.16, 0.17"  # Progressive widening - supports both versions
   # Keep other compat entries unchanged
   ```

   **Note**: We use `"0.16, 0.17"` (not just `"0.17"`) to:
   - Maintain backward compatibility with CTBase v0.16 users
   - Respect SemVer (patch release = no breaking changes)
   - Allow smooth transition period
   - Provide safety net if issues arise with v0.17

3. **Test locally**:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.test()'
   ```

4. **Commit and push**:

   ```bash
   git add Project.toml
   git commit -m "chore: add CTBase v0.17 compat (beta)"
   git push origin beta/ctbase-0.17-compat
   ```

5. **Create tag**:

   ```bash
   git tag v0.17.5-beta
   git push origin v0.17.5-beta
   ```

6. **Register in ct-registry**:

   ```julia
   using LocalRegistry
   using CTDirect
   register(CTDirect, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/CTDirect.jl.git")
   ```

   **Note**: First-time registration in ct-registry requires the `repo` parameter.

**Verification**:

- ✅ Tests pass with CTBase v0.16.x
- ✅ Tests pass with CTBase v0.17.0
- ✅ Registered in ct-registry
- ✅ No code changes needed

---

### Step 1.2: CTFlows v0.8.9 → v0.8.10-beta

**Type**: Beta release (ct-registry)

**Changes needed**:

- Update `Project.toml` version: `0.8.10-beta`
- Update `Project.toml` compat: `CTBase = "0.16, 0.17"`

**Steps**:

1. **Create branch**:

   ```bash
   cd CTFlows.jl
   git checkout main
   git pull
   git checkout -b beta/ctbase-0.17-compat
   ```

2. **Update Project.toml**:

   ```toml
   version = "0.8.10-beta"
   
   [compat]
   CTBase = "0.16, 0.17"  # Progressive widening - supports both versions
   # Keep other compat entries unchanged
   ```

   **Note**: We use `"0.16, 0.17"` (not just `"0.17"`) to:
   - Maintain backward compatibility with CTBase v0.16 users
   - Respect SemVer (patch release = no breaking changes)
   - Allow smooth transition period
   - Provide safety net if issues arise with v0.17

3. **Test locally**:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.test()'
   ```

4. **Commit and push**:

   ```bash
   git add Project.toml
   git commit -m "chore: add CTBase v0.17 compat (beta)"
   git push origin beta/ctbase-0.17-compat
   ```

5. **Create tag**:

   ```bash
   git tag v0.8.10-beta
   git push origin v0.8.10-beta
   ```

6. **Register in ct-registry**:

   ```julia
   using LocalRegistry
   using CTFlows
   register(CTFlows, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/CTFlows.jl.git")
   ```

   **Note**: First-time registration in ct-registry requires the `repo` parameter.

**Verification**:

- ✅ Tests pass with CTBase v0.16.x
- ✅ Tests pass with CTBase v0.17.0
- ✅ Registered in ct-registry
- ✅ No code changes needed

---

### Step 1.3: OptimalControl v1.1.6 → v1.1.7-beta

**Type**: Beta release (ct-registry)

**Changes needed**:

- Update `Project.toml` compat: `CTBase = "0.16, 0.17"`

**Steps**:

1. **Create branch**:

   ```bash
   cd OptimalControl.jl
   git checkout main
   git pull
   git checkout -b beta/ctbase-0.17-compat
   ```

2. **Update Project.toml**:

   ```toml
   version = "1.1.7-beta"
   
   [compat]
   CTBase = "0.16, 0.17"  # Progressive widening - supports both versions
   # Keep other compat entries unchanged
   ```

   **Note**: We use `"0.16, 0.17"` (not just `"0.17"`) to:
   - Maintain backward compatibility with CTBase v0.16 users
   - Respect SemVer (patch release = no breaking changes)
   - Allow smooth transition period
   - Provide safety net if issues arise with v0.17

3. **Test locally**:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.test()'
   ```

4. **Commit and push**:

   ```bash
   git add Project.toml
   git commit -m "chore: add CTBase v0.17 compat (beta)"
   git push origin beta/ctbase-0.17-compat
   ```

5. **Create tag**:

   ```bash
   git tag v1.1.7-beta
   git push origin v1.1.7-beta
   ```

6. **Register in ct-registry**:

   ```julia
   using LocalRegistry
   using OptimalControl
   register(OptimalControl, 
            registry = "ct-registry",
            repo = "git@github.com:control-toolbox/OptimalControl.jl.git")
   ```

   **Note**: First-time registration in ct-registry requires the `repo` parameter.

**Verification**:

- ✅ Tests pass with CTBase v0.16.x
- ✅ Tests pass with CTBase v0.17.0
- ✅ Registered in ct-registry
- ✅ No code changes needed

---

## Phase 1 Completion Checklist

- [ ] CTDirect v0.17.5-beta created and tagged
- [ ] CTDirect v0.17.5-beta registered in ct-registry
- [ ] CTFlows v0.8.10-beta created and tagged
- [ ] CTFlows v0.8.10-beta registered in ct-registry
- [ ] OptimalControl v1.1.7-beta created and tagged
- [ ] OptimalControl v1.1.7-beta registered in ct-registry
- [ ] Beta ecosystem tested successfully

---

## Phase 2: Stable Release (General Registry)

**Objective**: Release stable versions in General registry for public availability

**Duration**: 1 day

**Trigger**: After Phase 1 beta testing is complete and validated

**Packages to release**:

1. CTDirect v0.17.5 (General registry)
2. CTFlows v0.8.10 (General registry)
3. OptimalControl v1.1.7 (General registry)

### Process for Each Package

For each package (CTDirect, CTFlows, OptimalControl):

1. **Verify beta testing complete**
   - All tests passing with beta versions
   - No issues reported
   - Ecosystem validated

2. **Create stable release branch**:

   ```bash
   cd PackageName.jl
   git checkout main
   git pull
   git checkout -b release/ctbase-0.17-compat
   ```

3. **Update Project.toml** (remove `-beta`):

   ```toml
   version = "X.Y.Z"  # Remove -beta suffix
   
   [compat]
   CTBase = "0.16, 0.17"  # Keep progressive widening
   ```

4. **Test**:

   ```bash
   julia --project=. -e 'using Pkg; Pkg.test()'
   ```

5. **Create PR and merge**:
   - Title: "Release vX.Y.Z: Add CTBase v0.17 compat"
   - Description: "Stable release after beta testing. Widens compat to support CTBase v0.17.0"

6. **Register in General registry**:

   ```bash
   # Comment on merge commit
   @JuliaRegistrator register()
   ```

### Phase 2 Completion Checklist

- [ ] CTDirect v0.17.5 released in General registry
- [ ] CTFlows v0.8.10 released in General registry
- [ ] OptimalControl v1.1.7 released in General registry
- [ ] Public announcement made
- [ ] Documentation updated

---

## Beta Ecosystem Verification (Phase 1)

During Phase 1, verify the complete beta ecosystem:

```bash
mkdir -p /tmp/ctbase-migration-test
cd /tmp/ctbase-migration-test

julia --project=. -e '
using Pkg

# Add all packages (should get latest versions)
Pkg.add("CTBase")
Pkg.add("CTModels")
Pkg.add("CTParser")
Pkg.add("CTDirect")
Pkg.add("CTFlows")
Pkg.add("OptimalControl")

# Verify versions
using CTBase, CTModels, CTParser, CTDirect, CTFlows, OptimalControl

println("✅ Full ecosystem loaded successfully!")
println("\nVersions:")
Pkg.status()
'
```

**Expected versions**:

- CTBase v0.17.0 ✅
- CTModels v0.7.0 (or v0.6.10-beta from ct-registry)
- CTParser v0.8.0 (or v0.7.3-beta from ct-registry)
- CTDirect v0.17.5 ✅
- CTFlows v0.8.10 ✅
- OptimalControl v1.1.7 ✅

---

## Migration Complete! 🎉

### Summary

**Total duration**:

- Phase 1 (Beta): 1-2 weeks (testing)
- Phase 2 (Stable): 1 day (release)

**Two-phase strategy**:

**Phase 1 - Beta Ecosystem** (ct-registry):

- CTDirect v0.17.5-beta
- CTFlows v0.8.10-beta
- CTOptimalControl v1.1.7-beta
- CTModels v0.6.10-beta (already created)
- CTParser v0.7.3-beta (already created)

**Phase 2 - Stable Release** (General registry):

- CTDirect v0.17.5
- CTFlows v0.8.10
- OptimalControl v1.1.7

**Key insight**: Two-phase beta-to-stable strategy allows thorough internal testing before public release, avoiding premature releases and providing flexibility to iterate if needed.

---

## Notes on CTModels and CTParser

**Current situation**:

- CTModels v0.7.0 and CTParser v0.8.0 are already released with CTBase v0.17 support
- These versions introduced their own breaking changes (unrelated to CTBase)
- Users can choose:
  - **Stable path**: Use CTModels v0.7.0 and CTParser v0.8.0 (requires adapting to their breaking changes)
  - **Beta path**: Use CTModels v0.6.10-beta and CTParser v0.7.3-beta from ct-registry (no breaking changes)

**For this migration**: We only need to widen compat in CTDirect, CTFlows, and OptimalControl. The CTModels/CTParser breaking changes are a separate concern.

---

## Cleanup (Optional)

After migration is complete and stable:

1. **Beta versions** can remain in ct-registry for reference
2. **Beta branches** can be archived (keep for historical reference)
3. **Update documentation** with migration notes

---

**Generated by**: `/breaking-action-plan` workflow  
**Last updated**: 2026-01-17 13:17:00
