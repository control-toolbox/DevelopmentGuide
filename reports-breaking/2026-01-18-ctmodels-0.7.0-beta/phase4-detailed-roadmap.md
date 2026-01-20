# OptimalControl v2.0.0 Migration - Detailed Roadmap

## 🎯 Migration Strategy Update

The migration to OptimalControl v2.0.0 will follow a **phased beta approach** with systematic validation of all sub-packages.

---

## Phase 4: OptimalControl Adaptation

### Step 1: Initial Integration → v2.0.0-beta.1

**Objective**: Minimal viable integration with CTSolvers

**Tasks**:
1. Integrate `solve_api.jl` from CTSolvers
   - Source: <https://github.com/control-toolbox/CTSolvers.jl/raw/main/src/optimalcontrol/solve_api.jl>
   - Copy to `src/solve_api.jl` in OptimalControl
   
2. Integrate associated tests
   - Source: <https://raw.githubusercontent.com/control-toolbox/CTSolvers.jl/main/test/optimalcontrol/test_optimalcontrol_solve_api.jl>
   - Copy to `test/test_solve_api.jl`
   
3. Temporarily comment out other tests
   - Modify `test/runtests.jl`
   - Keep only `test_solve_api.jl` active
   
4. Update `Project.toml`
   - Version: `2.0.0-beta.1`
   - Add CTSolvers dependency
   - Update compat entries

**Deliverable**: v2.0.0-beta.1 registered in ct-registry

---

### Step 2: Export Macro Improvement

**Objective**: Simplify and improve import/export management

**Current Problem**:
```julia
# Repetitive pattern in OptimalControl.jl
import CTBase: foo, bar, baz
export foo, bar  # baz imported but not exported

import CTModels: qux, quux
export qux, quux
```

**Proposed Solution**:
```julia
# New macro-based approach
@reexport_from CTBase [foo, bar, baz] exclude=[baz]
@reexport_from CTModels [qux, quux]
```

**Tasks**:
1. Create `src/export_macros.jl`
2. Implement `@reexport_from` macro
3. Refactor `src/OptimalControl.jl` to use macro
4. Test all exports work correctly

**Benefits**:
- Reduces code duplication
- Makes exclusions explicit
- Easier to maintain
- Self-documenting

---

### Step 3: Complete Integration → v2.0.0-beta.2

**Objective**: Full test suite passing

**Tasks**:
1. Re-enable all tests in `test/runtests.jl`
2. Fix any failing tests
3. Verify full compatibility with:
   - CTModels v0.7.0-beta
   - CTSolvers v0.2.0-beta
   - CTDirect v0.18.0-beta
4. Update `Project.toml` to v2.0.0-beta.2

**Deliverable**: v2.0.0-beta.2 registered in ct-registry

---

## Phase 5: Systematic Sub-Package Validation

**Strategy**: Bottom-up validation through dependency tree

Each sub-package will undergo **systematic improvements** using CTBase extensions:

### Standard Validation Process

For each package:

1. **Coverage Improvement** (using `CTBase.CoveragePostprocessing`)
   - Identify uncovered code paths
   - Add tests to improve coverage
   - Target: >90% coverage

2. **Documentation Enhancement** (using `CTBase.DocumenterReference`)
   - Improve API reference display
   - Enhance docstrings with examples
   - Add missing documentation

3. **Test Execution Modernization** (using `CTBase.TestRunner`)
   - Update test structure
   - Improve test organization
   - Add test utilities

4. **Beta Release**
   - Create final beta version
   - Register in ct-registry

---

### 5.1: CTBase Validation

**Status**: Foundation package (validate first)

**Tasks**:
- Standard validation process only
- No additional specific tasks

**Version**: v0.17.5-beta (example)

---

### 5.2: CTModels Validation

**Dependencies**: CTBase

**Specific Tasks**:
1. **Clarify interfaces** (especially options)
   - Document option structure
   - Ensure consistency across modelers
   - Add examples

2. **Add modeler options** (if needed)
   - Review current options
   - Identify missing options
   - Implement and test

3. **Add Makie extension**
   - Create `ext/MakieExt.jl`
   - Implement visualization functions
   - Add documentation and examples

**Standard Tasks**: Coverage, documentation, tests

**Version**: v0.7.1-beta (example)

---

### 5.3: CTFlows Validation

**Dependencies**: CTModels, CTBase

**Specific Tasks**:
1. **Finalize code restructuring**
   - Complete planned refactoring
   - Update documentation

2. **Introduce new features**
   - Document new features
   - Implement with tests
   - Add examples

**Standard Tasks**: Coverage, documentation, tests

**Version**: v0.8.12-beta (example)

---

### 5.4: CTParser Validation

**Dependencies**: CTBase

**Specific Tasks**:
1. **Review and determine improvements**
   - Assess current state
   - Identify enhancement opportunities
   - Plan improvements

**Standard Tasks**: Coverage, documentation, tests

**Version**: v0.8.3-beta (example)

---

### 5.5: CTSolvers Validation

**Dependencies**: CTModels, CTBase

**Specific Tasks**:
1. **Add solver options**
   - Define option structure
   - Implement for each solver
   - Document and test
   - Add examples for common use cases

**Standard Tasks**: Coverage, documentation, tests

**Version**: v0.2.1-beta (example)

---

### 5.6: CTDirect Validation

**Dependencies**: CTModels, CTBase, CTSolvers

**Specific Tasks**:
1. **Update tests to use CTSolvers**
   - Replace direct solver calls
   - Use CTSolvers API
   - Verify all tests pass

2. **Rewrite Collocation discretizer**
   - Review current implementation
   - Implement improved version
   - Maintain backward compatibility

3. **Choose definitive discretizer name**
   - Evaluate naming options
   - Update code and documentation
   - Communicate change

**Standard Tasks**: Coverage, documentation, tests

**Version**: v0.18.1-beta (example)

---

### 5.7: OptimalControl Final Release

**Dependencies**: All sub-packages validated

**Tasks**:
1. Verify all sub-packages at validated beta versions
2. Run full integration test suite
3. Review documentation completeness
4. Final quality checks
5. Create **v2.0.0 stable release**

---

## Timeline Estimate

| Phase | Duration | Description |
|-------|----------|-------------|
| 4.1 | 1-2 days | Initial integration (beta.1) |
| 4.2 | 2-3 days | Export macro improvement |
| 4.3 | 1-2 days | Complete integration (beta.2) |
| 5.1-5.6 | 2-3 weeks | Sub-package validation (6 packages) |
| 5.7 | 2-3 days | Final OptimalControl release |
| **Total** | **~4 weeks** | Complete v2.0.0 migration |

---

## Dependency Graph

```
CTBase (validate first)
  ├── CTModels
  │   ├── CTFlows
  │   ├── CTSolvers
  │   └── CTDirect (also depends on CTSolvers)
  └── CTParser

OptimalControl v2.0.0 (depends on all)
```

**Validation Order**: CTBase → CTModels, CTParser → CTFlows, CTSolvers → CTDirect → OptimalControl

---

## Tools & Extensions

All from CTBase:

1. **CoveragePostprocessing.jl**: <https://github.com/control-toolbox/CTBase.jl/blob/main/ext/CoveragePostprocessing.jl>
2. **DocumenterReference.jl**: <https://github.com/control-toolbox/CTBase.jl/blob/main/ext/DocumenterReference.jl>
3. **TestRunner.jl**: <https://github.com/control-toolbox/CTBase.jl/blob/main/ext/TestRunner.jl>

---

## Success Criteria

- ✅ All tests passing
- ✅ >90% code coverage for all packages
- ✅ Complete API documentation
- ✅ All examples working
- ✅ No breaking changes in stable APIs
- ✅ All sub-packages at validated beta versions

---

## Next Immediate Steps

1. Start with Phase 4.1: Integrate `solve_api.jl`
2. Create v2.0.0-beta.1
3. Implement export macro (Phase 4.2)
4. Complete integration (Phase 4.3)
5. Begin systematic sub-package validation (Phase 5)

---

**Related**: control-toolbox/CTModels.jl#247
