# Phase 4: OptimalControl Setup Instructions

**Date**: 2026-01-20  
**Package**: OptimalControl  
**Version**: 1.1.8-beta → 2.0.0-beta  
**Branch**: breaking/ctmodels-0.7  

---

## 1. GitHub Issue

### Title

```
Adapt to CTModels v0.7.x and integrate CTSolvers
```

### Body

```markdown
## Context

This issue tracks the adaptation of OptimalControl to work with CTModels v0.7.x as part of the breaking change migration.

**Related to**: control-toolbox/CTModels.jl#247

## Objectives

1. Adapt OptimalControl code to work with CTModels v0.7.x API
2. Integrate CTSolvers v0.2.x as a new dependency
3. Update code to use CTSolvers functionality
4. Widen compat constraints to support both CTModels 0.6 and 0.7

## Version Changes

- **Before**: OptimalControl v1.1.8-beta
- **After**: OptimalControl v2.0.0-beta (major version bump)

## Major Changes

### 1. Ecosystem Restructuring
- Integration of new CTSolvers package
- New solver architecture
- Separation of concerns (solvers moved to dedicated package)

### 2. Breaking Dependency Updates
- CTModels v0.7.x (breaking changes)
- CTDirect v0.18.x (major version bump)
- New dependency: CTSolvers v0.2.x

### 3. API Changes
- Adaptation to new CTModels API
- Integration of CTSolvers functionality
- Potential breaking changes in user-facing API

## Project.toml Changes

```toml
# Before
version = "1.1.8-beta"

[compat]
CTDirect = "0.17"
CTFlows = "0.8"
CTModels = "0.6"
CTParser = "0.8"
CTBase = "0.17"

# After
version = "2.0.0-beta"

[compat]
CTDirect = "0.17, 0.18"
CTFlows = "0.8"
CTModels = "0.6, 0.7"
CTParser = "0.8"
CTSolvers = "0.2"  # NEW
CTBase = "0.17"
```

## Tasks

- [ ] Adapt code to CTModels v0.7.x API
- [ ] Integrate CTSolvers as dependency
- [ ] Update code to use CTSolvers functionality
- [ ] Update Project.toml with new version and compat
- [ ] Run tests with CTModels v0.7.0-beta and CTSolvers v0.2.0-beta
- [ ] Verify all tests pass
- [ ] Register v2.0.0-beta in ct-registry
- [ ] Create GitHub tag v2.0.0-beta

## Migration Status

```
Phase 1: CTFlows v0.8.11-beta ✅
Phase 2: CTModels v0.7.0-beta ✅
Phase 3: CTDirect v0.18.0-beta ✅
Phase 3.5: CTSolvers v0.2.0-beta ✅
Phase 4: OptimalControl v2.0.0-beta 🔄 (this issue)
Phase 5: Stabilization ⏳
```

## References

- **Migration plan**: [action-plan.md](https://github.com/control-toolbox/dev-workflows/blob/main/reports-breaking/2026-01-18-ctmodels-0.7.0-beta/action-plan.md)
- **CTModels issue**: control-toolbox/CTModels.jl#247
- **Methodology**: [breaking-change-rules.md](https://github.com/control-toolbox/dev-workflows/blob/main/breaking-change-rules.md)

```

### Labels
```

breaking-change, migration, phase-4

```

---

## 2. Create Branch

### Commands

```bash
# Navigate to OptimalControl repository
cd /path/to/OptimalControl.jl

# Fetch tags and checkout the starting tag
git fetch --tags
git checkout v1.1.8-beta

# Create the breaking branch from this tag
git checkout -b breaking/ctmodels-0.7

# Push the branch to GitHub
git push -u origin breaking/ctmodels-0.7
```

### Starting Point

- **Base tag**: `v1.1.8-beta`
- **Important**: The branch must start from the tag, not from `main`

---

## 3. GitHub Pull Request

### Title

```
Adapt to CTModels v0.7.x and integrate CTSolvers
```

### Body

```markdown
## Summary

This PR adapts OptimalControl to work with CTModels v0.7.x and integrates the new CTSolvers package as part of the breaking change migration.

**Related to**: control-toolbox/CTModels.jl#247  
**Closes**: #[ISSUE_NUMBER]  ← Replace with the issue number created above

## Changes

### 🎯 Major Version Bump: v1.1.8-beta → v2.0.0-beta

This is a **major version bump** reflecting significant changes:

1. **Ecosystem Restructuring**
   - Integration of new CTSolvers package
   - New solver architecture
   - Separation of concerns (solvers moved to dedicated package)

2. **Breaking Dependency Updates**
   - CTModels v0.7.x (breaking changes)
   - CTDirect v0.18.x (major version bump)
   - New dependency: CTSolvers v0.2.x

3. **API Changes**
   - Adaptation to new CTModels API
   - Integration of CTSolvers functionality
   - Potential breaking changes in user-facing API

### Code Changes

- [ ] Adapted to CTModels v0.7.x API
- [ ] Integrated CTSolvers as new dependency
- [ ] Updated code to use CTSolvers functionality
- [ ] Updated Project.toml version and compat

### Project.toml Changes

```diff
- version = "1.1.8-beta"
+ version = "2.0.0-beta"

 [compat]
- CTDirect = "0.17"
+ CTDirect = "0.17, 0.18"
  CTFlows = "0.8"
- CTModels = "0.6"
+ CTModels = "0.6, 0.7"
  CTParser = "0.8"
+ CTSolvers = "0.2"
  CTBase = "0.17"
```

## Testing

All tests pass with:

- CTModels v0.7.0-beta ✅
- CTDirect v0.18.0-beta ✅
- CTSolvers v0.2.0-beta ✅

## Migration Progress

```
Phase 1: CTFlows v0.8.11-beta ✅
Phase 2: CTModels v0.7.0-beta ✅
Phase 3: CTDirect v0.18.0-beta ✅
Phase 3.5: CTSolvers v0.2.0-beta ✅
Phase 4: OptimalControl v2.0.0-beta 🔄 (this PR)
Phase 5: Stabilization ⏳
```

## Final Dependency Graph

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
  └── CTBase v0.17.4
```

## Impact on Users

### Breaking Changes

Users upgrading from OptimalControl v1.x to v2.0.0 will need to:

1. Update their code for CTModels v0.7.x API changes
2. Adapt to new CTSolvers integration (if using solver features)
3. Review any API changes in OptimalControl itself

### Benefits

- Access to new solver functionality via CTSolvers
- Improved architecture and separation of concerns
- Foundation for future enhancements
- Better maintainability

## Checklist

- [ ] Code adapted to CTModels v0.7.x
- [ ] CTSolvers integrated
- [ ] All tests pass
- [ ] Project.toml updated
- [ ] Documentation updated (if needed)
- [ ] CHANGELOG.md updated

```

### Labels
```

breaking-change, migration, phase-4

```

### Base Branch
```

main

```

### Compare Branch
```

breaking/ctmodels-0.7

```

---

## 4. Quick Commands Reference

### Create Issue (via GitHub CLI)
```bash
gh issue create \
  --repo control-toolbox/OptimalControl.jl \
  --title "Adapt to CTModels v0.7.x and integrate CTSolvers" \
  --body-file phase4-issue-body.md \
  --label "breaking-change,migration,phase-4"
```

### Create PR (via GitHub CLI)

```bash
gh pr create \
  --repo control-toolbox/OptimalControl.jl \
  --base main \
  --head breaking/ctmodels-0.7 \
  --title "Adapt to CTModels v0.7.x and integrate CTSolvers" \
  --body-file phase4-pr-body.md \
  --label "breaking-change,migration,phase-4"
```

---

## 5. Next Steps After Setup

Once the issue, branch, and PR are created:

1. **Identify breaking changes**: Check CTModels CHANGELOG or PR #248
2. **Test with new versions**:

   ```julia
   using Pkg
   Pkg.develop("OptimalControl")
   Pkg.add(name="CTModels", version="0.7.0-beta")
   Pkg.add(name="CTSolvers", version="0.2.0-beta")
   Pkg.test("OptimalControl")
   ```

3. **Fix failing tests**: Adapt code to new API
4. **Integrate CTSolvers**: Update code to use CTSolvers functionality
5. **Update Project.toml**: Only after tests pass
6. **Register beta**: Use LocalRegistry in ct-registry
7. **Create tag**: `git tag v2.0.0-beta && git push origin v2.0.0-beta`

---

## 6. Registration Commands (For Later)

```bash
# After all code changes are complete and tests pass

cd /path/to/OptimalControl.jl

# Create tag
git tag v2.0.0-beta
git push origin v2.0.0-beta

# Register in ct-registry
julia -e '
using LocalRegistry, OptimalControl
register(OptimalControl, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/OptimalControl.jl.git")
'
```

---

**Created**: 2026-01-20  
**For**: Phase 4 of CTModels v0.7.0-beta migration
