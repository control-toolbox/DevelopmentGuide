# Next Steps Guide - CTParser Migration

## Current Situation

✅ **Setup Complete**
- Branch created: `breaking/ctparser-0.8.2-beta`
- Issue created: [#207](https://github.com/control-toolbox/CTParser.jl/issues/207)
- PR created: [#208](https://github.com/control-toolbox/CTParser.jl/pull/208)
- Dependency graph extracted
- Preliminary classification done

## What's Next?

### Option 1: Generate Action Plan (Recommended)

Run the action plan workflow to get a detailed, phase-by-phase migration plan:

```bash
/breaking-action-plan reports-breaking/2026-01-17-ctparser-0.8.2-beta
```

This will generate:
- Detailed widening steps for OptimalControl
- Breakage test execution strategy
- Version decision criteria
- Complete migration phases with commands

### Option 2: Manual Execution

If you prefer to proceed manually, here's the high-level roadmap:

#### Phase 1: Widening (Preparation)

1. **Update OptimalControl compat**:
   ```toml
   # In OptimalControl/Project.toml
   CTParser = "0.7, 0.8"  # was "0.7"
   ```

2. **Bump OptimalControl version**:
   ```toml
   version = "1.1.8-beta"  # was "1.1.7-beta"
   ```

3. **Register OptimalControl beta** in ct-registry

#### Phase 2: Testing

1. **Run breakage tests** on CTParser PR #208
2. **Analyze results** to determine if changes are breaking
3. **Decide target version**:
   - v0.8.2-beta if minor/compatible
   - v0.9.0-beta if breaking changes detected

#### Phase 3: Migration

1. **Create CTParser beta version**
2. **Adapt breaking packages** if needed
3. **Progressive compat widening** in ecosystem

## Recommended Approach

**Use Option 1** (action plan workflow) for:
- ✅ Detailed step-by-step instructions
- ✅ Automated command generation
- ✅ Validation checkpoints
- ✅ Traceability and documentation

The action plan will guide you through each phase with precise commands and validation steps.

## Questions?

Refer to:
- `setup.md` for detailed analysis
- `README.md` for quick overview
- Breaking change methodology guide in `dev-workflows/breaking-change-rules.md`
