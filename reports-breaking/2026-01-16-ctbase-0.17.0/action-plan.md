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

## Phase 1: Compat Widening

**Objective**: Widen compat bounds to accept CTBase v0.17.0

**Duration**: 1-2 days

**Packages to update**:

1. CTDirect v0.17.4 → v0.17.5 (patch)
2. CTFlows v0.8.9 → v0.8.10 (patch)
3. OptimalControl v1.1.6 → v1.1.7 (patch)

---

### Step 1.1: CTDirect v0.17.4 → v0.17.5

**Type**: Patch release (compat widening only)

**Changes needed**:

- Update `Project.toml` compat: `CTBase = "0.16, 0.17"`

**Steps**:

1. **Create branch**:

   ```bash
   cd CTDirect.jl
   git checkout main
   git pull
   git checkout -b compat/ctbase-0.17
   ```

2. **Update Project.toml**:

   ```toml
   version = "0.17.5"
   
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
   git commit -m "chore: add CTBase v0.17 compat"
   git push origin compat/ctbase-0.17
   ```

5. **Create PR on GitHub**:
   - Title: "Add CTBase v0.17 compat"
   - Description: "Widen compat to accept CTBase v0.17.0 (no code changes needed)"

6. **After PR merge, register**:

   ```bash
   # Comment on the merge commit or main branch
   @JuliaRegistrator register()
   ```

**Verification**:

- ✅ Tests pass with CTBase v0.16.x
- ✅ Tests pass with CTBase v0.17.0
- ✅ No code changes needed

---

### Step 1.2: CTFlows v0.8.9 → v0.8.10

**Type**: Patch release (compat widening only)

**Changes needed**:

- Update `Project.toml` compat: `CTBase = "0.16, 0.17"`

**Steps**:

1. **Create branch**:

   ```bash
   cd CTFlows.jl
   git checkout main
   git pull
   git checkout -b compat/ctbase-0.17
   ```

2. **Update Project.toml**:

   ```toml
   version = "0.8.10"
   
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
   git commit -m "chore: add CTBase v0.17 compat"
   git push origin compat/ctbase-0.17
   ```

5. **Create PR on GitHub**:
   - Title: "Add CTBase v0.17 compat"
   - Description: "Widen compat to accept CTBase v0.17.0 (no code changes needed)"

6. **After PR merge, register**:

   ```bash
   @JuliaRegistrator register()
   ```

**Verification**:

- ✅ Tests pass with CTBase v0.16.x
- ✅ Tests pass with CTBase v0.17.0
- ✅ No code changes needed

---

### Step 1.3: OptimalControl v1.1.6 → v1.1.7

**Type**: Patch release (compat widening only)

**Changes needed**:

- Update `Project.toml` compat: `CTBase = "0.16, 0.17"`

**Steps**:

1. **Create branch**:

   ```bash
   cd OptimalControl.jl
   git checkout main
   git pull
   git checkout -b compat/ctbase-0.17
   ```

2. **Update Project.toml**:

   ```toml
   version = "1.1.7"
   
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
   git commit -m "chore: add CTBase v0.17 compat"
   git push origin compat/ctbase-0.17
   ```

5. **Create PR on GitHub**:
   - Title: "Add CTBase v0.17 compat"
   - Description: "Widen compat to accept CTBase v0.17.0 (no code changes needed)"

6. **After PR merge, register**:

   ```bash
   @JuliaRegistrator register()
   ```

**Verification**:

- ✅ Tests pass with CTBase v0.16.x
- ✅ Tests pass with CTBase v0.17.0
- ✅ No code changes needed

---

## Phase 1 Completion Checklist

- [ ] CTDirect v0.17.5 PR created
- [ ] CTDirect v0.17.5 PR merged
- [ ] CTDirect v0.17.5 registered
- [ ] CTFlows v0.8.10 PR created
- [ ] CTFlows v0.8.10 PR merged
- [ ] CTFlows v0.8.10 registered
- [ ] OptimalControl v1.1.7 PR created
- [ ] OptimalControl v1.1.7 PR merged
- [ ] OptimalControl v1.1.7 registered

---

## Final Verification

After all packages are registered, verify the complete ecosystem:

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

**Total duration**: 1-2 days (much faster than initially expected!)

**Packages updated**:

- CTDirect: v0.17.4 → v0.17.5 (compat widening)
- CTFlows: v0.8.9 → v0.8.10 (compat widening)
- OptimalControl: v1.1.6 → v1.1.7 (compat widening)

**Beta versions** (for testing):

- CTModels v0.6.10-beta (in ct-registry)
- CTParser v0.7.3-beta (in ct-registry)

**Key insight**: Beta versions allowed us to test CTBase v0.17.0 independently and discover that no packages were actually broken, avoiding a complex multi-phase migration.

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
