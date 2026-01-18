# Breaking Change Setup Report

**Date**: 2026-01-17 22:19:00  
**Package**: CTParser  
**Current Version**: v0.7.3-beta (installed) / v0.8.1 (latest stable)  
**Target Version**: v0.8.2-beta (provisional, may become v0.9.0-beta)  
**Branch**: `breaking/ctparser-0.8.2-beta`  
**Issue**: [#207](https://github.com/control-toolbox/CTParser.jl/issues/207)  
**PR**: [#208](https://github.com/control-toolbox/CTParser.jl/pull/208)  
**Report Directory**: `reports-breaking/2026-01-17-ctparser-0.8.2-beta/`

## Context

CTParser has evolved from v0.7.3-beta to v0.8.1 (stable release). The goal is to:
1. Create a beta version (v0.8.2-beta) to test compatibility with dependents
2. Widen compat constraints in dependents to accept CTParser v0.8.x
3. Run breakage tests to assess actual impact
4. Adjust target version (v0.8.2-beta or v0.9.0-beta) based on test results

**Note**: v0.7.3-beta was created during the CTBase v0.17.4 migration. v0.8.0 and v0.8.1 were released prematurely without full ecosystem testing.

## Dependency Graph

```
OptimalControl v1.1.7-beta
  ├── CTDirect v0.17.5-beta
  │   └── CTModels v0.6.10-beta
  │   └── CTBase v0.17.4
  ├── CTParser v0.7.3-beta  ← Target package
  │   └── CTBase v0.17.4
  ├── CTFlows v0.8.10-beta
  │   └── CTModels v0.6.10-beta
  │   └── CTBase v0.17.4
  ├── CTModels v0.6.10-beta
  │   └── CTBase v0.17.4
  ├── CTBase v0.17.4
```

### Full Graph

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

CTParser v0.7.3-beta
  → CTBase v0.17.4

OptimalControl v1.1.7-beta
  → CTDirect v0.17.5-beta
  → CTParser v0.7.3-beta
  → CTFlows v0.8.10-beta
  → CTModels v0.6.10-beta
  → CTBase v0.17.4
```

## Current Compat Constraints

### CTParser v0.7.3-beta
```toml
[compat]
CTBase = "0.16, 0.17"
```

### OptimalControl v1.1.7-beta
```toml
[compat]
CTParser = "0.7"  # ← Blocks CTParser v0.8.x
```

## Breakage Test Results

**Status**: ✅ **Tests completed - All passing**

**Date**: 2026-01-18

| Package | Latest | Stable | Status |
|---------|--------|--------|--------|
| OptimalControl | ✅ | ✅ | Compatible |

**Interpretation**: CTParser v0.8.1 is **fully compatible** with OptimalControl. No breaking changes detected.

**Conclusion**: Proceed with CTParser v0.8.2-beta (minor version, not v0.9.0-beta).

## Classification

### Final Classification (based on breakage test results)

**Compatible packages** (confirmed by tests):
- **OptimalControl** v1.1.7-beta
  - Tests: ✅ All passing
  - Status: Fully compatible with CTParser v0.8.1
  - Action: Can widen compat to `CTParser = "0.7, 0.8"`

**Breaking packages**: None

**Indirect dependents**: None (no other CT package depends on CTParser)

## Migration Strategy

### ✅ Confirmed: Compatible Migration (v0.8.2-beta)

Based on breakage test results, CTParser v0.8.1 is fully compatible with OptimalControl. The migration follows a simple 2-phase approach:

### Phase 1: Preparation (Widening)

1. Widen compat in OptimalControl: `CTParser = "0.7, 0.8"`
2. Create OptimalControl beta version (v1.1.8-beta)
3. Register beta in ct-registry

### Phase 2: CTParser Beta Release

1. Create CTParser v0.8.2-beta (minor version, not v0.9.0)
2. Register in ct-registry
3. Verify integration with OptimalControl v1.1.8-beta

## Next Steps

Ready for action plan generation. Run:
```
/breaking-action-plan reports-breaking/2026-01-17-ctparser-0.8.2-beta
```

The action plan will detail:
- Exact widening steps for OptimalControl
- Breakage test execution strategy
- Version decision criteria (v0.8.2-beta vs v0.9.0-beta)
- Full migration phases
