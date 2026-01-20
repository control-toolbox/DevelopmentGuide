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
