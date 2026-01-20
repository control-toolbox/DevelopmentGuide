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
