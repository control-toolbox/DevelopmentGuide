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

**Status**: ⚠️ **Not yet available**

Breakage tests cannot run yet because:
- OptimalControl's compat constraint (`CTParser = "0.7"`) prevents installation of CTParser v0.8.x
- Widening must be done first before tests can run

**Next action**: Widen compat in OptimalControl, then run breakage tests.

## Classification

### Preliminary Classification (before breakage tests)

**Packages requiring compat widening**:
- **OptimalControl** v1.1.7-beta
  - Current compat: `CTParser = "0.7"`
  - Required compat: `CTParser = "0.7, 0.8"`
  - Action: Create beta version with widened compat

**Packages potentially compatible** (to be confirmed after tests):
- None identified yet (OptimalControl is the only direct dependent)

**Indirect dependents**: None (no other CT package depends on CTParser)

## Migration Strategy

### Phase 1: Preparation (Widening)
1. Widen compat in OptimalControl: `CTParser = "0.7, 0.8"`
2. Create OptimalControl beta version (e.g., v1.1.8-beta)
3. Register beta in ct-registry

### Phase 2: Testing
1. Run breakage tests on CTParser PR
2. Analyze results to determine:
   - If v0.8.2-beta is sufficient (minor fixes)
   - If v0.9.0-beta is needed (breaking changes detected)

### Phase 3: Migration
1. Create appropriate CTParser beta version
2. Adapt breaking packages if needed
3. Progressive compat widening in ecosystem

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
