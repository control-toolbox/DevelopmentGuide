# Breaking Change Setup Report

**Date**: 2026-01-18 21:26:52
**Package**: CTModels
**Current Version**: 0.6.10-beta
**Target Version**: 0.7.0-beta
**Branch**: breaking/ctmodels-0.7
**Issue**: [#247](https://github.com/control-toolbox/CTModels.jl/issues/247)
**PR**: [#248](https://github.com/control-toolbox/CTModels.jl/pull/248)
**Report Directory**: reports-breaking/2026-01-18-ctmodels-0.7.0-beta

---

## Context

This migration manages the transition from CTModels v0.6.10-beta to v0.7.0-beta.

**Special situation**: A v0.7.0 release already exists and will be merged into the breaking branch once the breaking change migration is complete.

**Testing strategy**: Used temporary version v0.6.11 to test breakages (since dependents only accept `CTModels = "0.6"`).

---

## Dependency Graph

**Source**: OptimalControl v1.1.8-beta

```
OptimalControl v1.1.8-beta
  ├── CTDirect v0.17.5-beta
  │   └── CTModels v0.6.10-beta
  │   └── CTBase v0.17.4
  ├── CTParser v0.8.2-beta
  │   └── CTBase v0.17.4
  ├── CTFlows v0.8.10-beta
  │   └── CTModels v0.6.10-beta
  │   └── CTBase v0.17.4
  ├── CTModels v0.6.10-beta
  │   └── CTBase v0.17.4
  ├── CTBase v0.17.4
```

**Full graph**:

```
CTBase v0.17.4

CTDirect v0.17.5-beta
  → CTModels v0.6.10-beta
  → CTBase v0.17.4

CTFlows v0.8.10-beta
  → CTModels v0.6.10-beta
  → CTBase v0.17.4

CTModels v0.6.10-beta
  → CTBase v0.17.4

CTParser v0.8.2-beta
  → CTBase v0.17.4

OptimalControl v1.1.8-beta
  → CTDirect v0.17.5-beta
  → CTParser v0.8.2-beta
  → CTFlows v0.8.10-beta
  → CTModels v0.6.10-beta
  → CTBase v0.17.4
```

---

## Affected Packages

**Direct dependents of CTModels**:
- CTDirect v0.17.5-beta
- CTFlows v0.8.10-beta
- OptimalControl v1.1.8-beta

**Indirect dependents**: None (CTParser does not depend on CTModels)

---

## Breakage Test Results

**Test version**: CTModels v0.6.11 (temporary version for testing)
**Test date**: 2026-01-19

| Package | Latest | Stable | Status |
|---------|--------|--------|--------|
| CTDirect | ❌ | ❌ | Breaking |
| CTFlows | ✅ | ✅ | Compatible |
| OptimalControl | ❌ | ❌ | Breaking |

**Interpretation**:
- **CTDirect**: Code breaks with CTModels v0.7.x → Requires code adaptation
- **CTFlows**: Code works with CTModels v0.7.x → Simple compat widening sufficient
- **OptimalControl**: Code breaks with CTModels v0.7.x → Requires code adaptation

---

## Package Classification

### Breaking Packages (need code adaptation)

**CTDirect v0.17.5-beta**:
- Direct dependency on CTModels
- Tests fail with CTModels v0.7.x
- Requires code changes to adapt to new CTModels API

**OptimalControl v1.1.8-beta**:
- Direct dependency on CTModels
- Tests fail with CTModels v0.7.x
- Requires code changes to adapt to new CTModels API

### Compatible Packages (can widen compat)

**CTFlows v0.8.10-beta**:
- Direct dependency on CTModels
- Tests pass with CTModels v0.7.x
- Only needs compat widening: `CTModels = "0.6, 0.7"`

---

## Migration Complexity

**Package position**: Mid-layer (CTModels has dependents but is not foundation)

**Complexity**: Medium
- 2 breaking packages (CTDirect, OptimalControl)
- 1 compatible package (CTFlows)
- Estimated phases: 5-7

**Cascade pattern**:
```
CTModels v0.7.0-beta
  ↓
CTDirect v0.18.0-beta (breaking - needs adaptation)
CTFlows v0.8.11-beta (compatible - widening only)
  ↓
OptimalControl v2.0.0-beta (breaking - needs adaptation)
```

---

## Strategy Overview

### Phase 1: CTFlows Widening (Compatible)
- CTFlows: Simple compat widening to `"0.6, 0.7"`
- Version: 0.8.10-beta → 0.8.11-beta
- No code changes needed

### Phase 2: CTModels Beta Release
- Register CTModels v0.7.0-beta in ct-registry
- This enables breaking packages to start adaptation

### Phase 3: CTDirect Adaptation (Breaking)
- Adapt CTDirect code to work with CTModels v0.7.x
- Update compat: `CTModels = "0.6, 0.7"`
- Version: 0.17.5-beta → 0.18.0-beta

### Phase 4: OptimalControl Adaptation (Breaking)
- Adapt OptimalControl code to work with CTModels v0.7.x
- Update compat: `CTModels = "0.6, 0.7"`
- Version: 1.1.8-beta → 2.0.0-beta

### Phase 5: Stabilization (Optional)
- Once all packages work with 0.7.x
- Merge v0.7.0 final into breaking branch
- Release stable versions

---

## Next Steps

1. **Generate action plan**: Run `/breaking-action-plan reports-breaking/2026-01-18-ctmodels-0.7.0-beta`
2. **Execute phases**: Follow the detailed action plan
3. **Monitor breakage tests**: Verify each phase with CI
4. **Merge final v0.7.0**: Once migration complete

---

## References

- **Issue**: https://github.com/control-toolbox/CTModels.jl/issues/247
- **PR**: https://github.com/control-toolbox/CTModels.jl/pull/248
- **Methodology**: [breaking-change-rules.md](../../breaking-change-rules.md)
- **Invariants**: [invariants-analysis.md](../../experiments/dependency-graph/invariants-analysis.md)
