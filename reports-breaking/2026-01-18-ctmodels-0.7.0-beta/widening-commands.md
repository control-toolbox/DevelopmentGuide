# Widening Commands for CTModels 0.7.0-beta Migration

**Date**: 2026-01-18
**Migration**: CTModels 0.6.10-beta → 0.7.0-beta
**Issue**: control-toolbox/CTModels.jl#247
**PR**: control-toolbox/CTModels.jl#248

---

## Overview

This document contains all commands needed to widen the compat constraints in the 3 packages that depend on CTModels:

1. **CTDirect** v0.17.5-beta
2. **CTFlows** v0.8.10-beta
3. **OptimalControl** v1.1.8-beta

---

## Strategy

For each package, we will:

1. Create a widening branch: `widening/ctmodels-0.7`
2. Modify `Project.toml` to widen CTModels compat: `"0.6, 0.7"`
3. Bump the patch version (beta)
4. Commit, push, and create a PR
5. Wait for CI breakage tests to run

**Important**: Do this BEFORE registering CTModels v0.7.0-beta, so that when you register it, the CI tests will automatically run on these PRs.

---

## 1. CTDirect

### Commands

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/CTDirect.jl

# Create widening branch
git checkout main
git pull
git checkout -b widening/ctmodels-0.7

# Edit Project.toml (see below)
# Then commit and push
git add Project.toml
git commit -m "Widen CTModels compat to 0.6, 0.7 for migration"
git push -u origin widening/ctmodels-0.7

# Create PR
gh pr create --title "Widen CTModels compat to 0.6, 0.7" \
  --body "Widening compat for CTModels breaking change migration.

Related to: control-toolbox/CTModels.jl#247

This PR widens the compat constraint for CTModels to allow both 0.6 and 0.7 versions.

**Changes**:
- CTModels compat: \`0.6\` → \`0.6, 0.7\`
- Version bump: \`0.17.5-beta\` → \`0.17.6-beta\`

**Testing**:
Breakage tests will verify compatibility with CTModels 0.7.0-beta once it's registered."
```

### Project.toml Changes

**Current** (v0.17.5-beta):
```toml
version = "0.17.5-beta"

[compat]
CTModels = "0.6"
CTBase = "0.17"
```

**New** (v0.17.6-beta):
```toml
version = "0.17.6-beta"

[compat]
CTModels = "0.6, 0.7"
CTBase = "0.17"
```

---

## 2. CTFlows

### Commands

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/CTFlows.jl

# Create widening branch
git checkout main
git pull
git checkout -b widening/ctmodels-0.7

# Edit Project.toml (see below)
# Then commit and push
git add Project.toml
git commit -m "Widen CTModels compat to 0.6, 0.7 for migration"
git push -u origin widening/ctmodels-0.7

# Create PR
gh pr create --title "Widen CTModels compat to 0.6, 0.7" \
  --body "Widening compat for CTModels breaking change migration.

Related to: control-toolbox/CTModels.jl#247

This PR widens the compat constraint for CTModels to allow both 0.6 and 0.7 versions.

**Changes**:
- CTModels compat: \`0.6\` → \`0.6, 0.7\`
- Version bump: \`0.8.10-beta\` → \`0.8.11-beta\`

**Testing**:
Breakage tests will verify compatibility with CTModels 0.7.0-beta once it's registered."
```

### Project.toml Changes

**Current** (v0.8.10-beta):
```toml
version = "0.8.10-beta"

[compat]
CTModels = "0.6"
CTBase = "0.17"
```

**New** (v0.8.11-beta):
```toml
version = "0.8.11-beta"

[compat]
CTModels = "0.6, 0.7"
CTBase = "0.17"
```

---

## 3. OptimalControl

### Commands

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/OptimalControl.jl

# Create widening branch
git checkout main
git pull
git checkout -b widening/ctmodels-0.7

# Edit Project.toml (see below)
# Then commit and push
git add Project.toml
git commit -m "Widen CTModels compat to 0.6, 0.7 for migration"
git push -u origin widening/ctmodels-0.7

# Create PR
gh pr create --title "Widen CTModels compat to 0.6, 0.7" \
  --body "Widening compat for CTModels breaking change migration.

Related to: control-toolbox/CTModels.jl#247

This PR widens the compat constraint for CTModels to allow both 0.6 and 0.7 versions.

**Changes**:
- CTModels compat: \`0.6\` → \`0.6, 0.7\`
- Version bump: \`1.1.8-beta\` → \`1.1.9-beta\`

**Testing**:
Breakage tests will verify compatibility with CTModels 0.7.0-beta once it's registered."
```

### Project.toml Changes

**Current** (v1.1.8-beta):
```toml
version = "1.1.8-beta"

[compat]
CTDirect = "0.17"
CTFlows = "0.8"
CTModels = "0.6"
CTParser = "0.8"
CTBase = "0.17"
```

**New** (v1.1.9-beta):
```toml
version = "1.1.9-beta"

[compat]
CTDirect = "0.17"
CTFlows = "0.8"
CTModels = "0.6, 0.7"
CTParser = "0.8"
CTBase = "0.17"
```

---

## Summary Checklist

- [ ] CTDirect: Branch created, PR opened
- [ ] CTFlows: Branch created, PR opened
- [ ] OptimalControl: Branch created, PR opened
- [ ] All PRs link to CTModels.jl#247
- [ ] All PRs are ready for breakage testing

---

## Next Steps

Once all 3 PRs are created:

1. **Register CTModels v0.7.0-beta** in ct-registry
2. **Wait for CI breakage tests** to run on all 3 PRs
3. **Analyze results**:
   - ✅ Tests pass → Package is compatible (simple widening)
   - ❌ Tests fail → Package needs code adaptation (breaking)
4. **Continue with breaking-action-plan** based on results

---

## Notes

- All version bumps are **patch-level beta** releases
- Widening uses `"0.6, 0.7"` format (simpler than `"0.6, 0.7.0-"`)
- PRs should NOT be merged yet (wait for breakage test results)
- These PRs will be updated/closed based on the final migration strategy
