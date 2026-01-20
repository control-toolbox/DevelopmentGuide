# Phase 1: CTFlows Widening - Execution Guide

**Date**: 2026-01-19 09:29:06  
**Package**: CTFlows  
**Version**: 0.8.10-beta → 0.8.11-beta  
**Type**: Compatible (widening only, no code changes)

---

## Objective

Widen CTModels compat in CTFlows from `"0.6"` to `"0.6, 0.7"` since CTFlows tests already pass with CTModels v0.7.x.

---

## Prerequisites

- [ ] CTFlows repository cloned locally
- [ ] Git configured
- [ ] Julia with ct-registry and LocalRegistry.jl installed

---

## Step-by-Step Instructions

### Step 1: Navigate to CTFlows repository

```bash
cd /path/to/CTFlows.jl
git checkout main
git pull
```

**Replace `/path/to/CTFlows.jl` with the actual path to your CTFlows repository.**

---

### Step 2: Create widening branch

```bash
git checkout -b widening/ctmodels-0.7
```

---

### Step 3: Modify Project.toml

Open `Project.toml` and make the following changes:

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

**Changes**:
1. Bump version: `0.8.10-beta` → `0.8.11-beta`
2. Widen CTModels compat: `"0.6"` → `"0.6, 0.7"`

---

### Step 4: Verify the changes

Check that the file looks correct:

```bash
cat Project.toml | grep -A 10 "version\|compat"
```

Expected output should show:
- `version = "0.8.11-beta"`
- `CTModels = "0.6, 0.7"`

---

### Step 5: Commit changes

```bash
git add Project.toml
git commit -m "Widen CTModels compat to 0.6, 0.7"
git push -u origin widening/ctmodels-0.7
```

---

### Step 6: Register in ct-registry

Open Julia REPL in the CTFlows directory:

```bash
julia --project=.
```

Then in Julia:

```julia
using Pkg
using LocalRegistry
using CTFlows

# Register in ct-registry
register(CTFlows, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/CTFlows.jl.git")
```

**Expected output**: Should confirm registration of CTFlows v0.8.11-beta

**Note**: If CTFlows is already in ct-registry, you can omit the `repo` parameter:
```julia
register(CTFlows, registry = "ct-registry")
```

---

### Step 7: Create GitHub tag

```bash
git tag v0.8.11-beta
git push origin v0.8.11-beta
```

---

### Step 8: Create/Update PR

```bash
gh pr create --title "Widen CTModels compat to 0.6, 0.7" \
  --body "Widening compat for CTModels breaking change migration.

Related to: control-toolbox/CTModels.jl#247

This PR widens the compat constraint for CTModels to allow both 0.6 and 0.7 versions.

**Changes**:
- CTModels compat: \`0.6\` → \`0.6, 0.7\`
- Version bump: \`0.8.10-beta\` → \`0.8.11-beta\`

**Testing**:
Tests already pass with CTModels v0.7.x (verified in breakage tests on CTModels.jl#248)."
```

**Expected output**: URL to the created PR

---

## Verification

After registration, verify the package resolves correctly:

```julia
using Pkg
Pkg.add(name="CTFlows", version="0.8.11-beta")
# Expected: CTFlows 0.8.11-beta, CTModels 0.6.10-beta
# Why: CTModels 0.7.0-beta not released yet, so resolver picks 0.6.10-beta
```

---

## Checklist

- [ ] Step 1: Navigated to CTFlows repository
- [ ] Step 2: Created branch `widening/ctmodels-0.7`
- [ ] Step 3: Modified `Project.toml` (version + compat)
- [ ] Step 4: Verified changes
- [ ] Step 5: Committed and pushed
- [ ] Step 6: Registered in ct-registry
- [ ] Step 7: Created tag v0.8.11-beta
- [ ] Step 8: Created PR

---

## Troubleshooting

### Issue: "Package not found in registry"

**Solution**: Add the `repo` parameter to the `register()` call:
```julia
register(CTFlows, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/CTFlows.jl.git")
```

### Issue: "Version already registered"

**Solution**: The version might already be registered. Check:
```julia
using Pkg
Pkg.Registry.update()
Pkg.add(name="CTFlows", version="0.8.11-beta")
```

### Issue: Git conflicts

**Solution**: Make sure you're on the latest main branch:
```bash
git checkout main
git pull
git checkout -b widening/ctmodels-0.7
```

---

## Next Steps

Once Phase 1 is complete:

1. ✅ Mark Phase 1 as complete in the verification checklist
2. ➡️ Proceed to **Phase 2: CTModels Beta Release**
3. 📝 Update the migration tracking

---

## Notes

- This is a **simple widening** - no code changes needed
- Tests already pass with CTModels v0.7.x
- This phase prepares the ecosystem for CTModels v0.7.0-beta release

---

**Status**: Ready to execute  
**Estimated time**: 10-15 minutes
