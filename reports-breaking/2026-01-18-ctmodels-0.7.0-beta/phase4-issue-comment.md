# GitHub Issue Comment - OptimalControl v2.0.0 Migration Roadmap

Post this comment to the OptimalControl issue to explain the detailed migration plan.

---

## 🎯 Migration Roadmap - OptimalControl v2.0.0

This migration will follow a **phased beta approach** with systematic validation of all sub-packages in the control-toolbox ecosystem.

### Phase 4: OptimalControl Adaptation (3 Steps)

#### Step 1: Initial Integration → v2.0.0-beta.1

**Objective**: Minimal viable integration with CTSolvers

**Tasks**:
- Integrate `solve_api.jl` from CTSolvers ([source](https://github.com/control-toolbox/CTSolvers.jl/raw/main/src/optimalcontrol/solve_api.jl))
- Integrate associated tests ([source](https://raw.githubusercontent.com/control-toolbox/CTSolvers.jl/main/test/optimalcontrol/test_optimalcontrol_solve_api.jl))
- Temporarily comment out other tests
- Release v2.0.0-beta.1

#### Step 2: Export Macro Improvement

**Objective**: Simplify import/export management

**Current pattern** (repetitive):
```julia
import CTBase: foo, bar, baz
export foo, bar  # baz not exported
```

**New pattern** (with macro):
```julia
@reexport_from CTBase [foo, bar, baz] exclude=[baz]
```

**Benefits**: Reduces duplication, makes exclusions explicit, easier to maintain

#### Step 3: Complete Integration → v2.0.0-beta.2

**Objective**: Full test suite passing

**Tasks**:
- Re-enable all tests
- Fix any compatibility issues
- Release v2.0.0-beta.2

---

### Phase 5: Systematic Sub-Package Validation

**Strategy**: Bottom-up validation through dependency tree

Each sub-package will undergo systematic improvements using **CTBase extensions**:

1. **Coverage Improvement** (using `CoveragePostprocessing.jl`)
2. **Documentation Enhancement** (using `DocumenterReference.jl`)
3. **Test Execution Modernization** (using `TestRunner.jl`)

#### Validation Order

```
CTBase → CTModels, CTParser → CTFlows, CTSolvers → CTDirect → OptimalControl
```

#### Package-Specific Tasks

**CTModels**:
- Clarify interfaces (especially options)
- Add modeler options if needed
- Add Makie extension

**CTFlows**:
- Finalize code restructuring
- Introduce new features

**CTParser**:
- Review and determine improvements

**CTSolvers**:
- Add solver options

**CTDirect**:
- Update tests to use CTSolvers
- Rewrite Collocation discretizer
- Choose definitive discretizer name

**OptimalControl**:
- Final integration and v2.0.0 stable release

---

### Timeline Estimate

| Phase | Duration |
|-------|----------|
| 4.1 (beta.1) | 1-2 days |
| 4.2 (export macro) | 2-3 days |
| 4.3 (beta.2) | 1-2 days |
| 5 (sub-packages) | 2-3 weeks |
| **Total** | **~4 weeks** |

---

### Tools & Extensions

All from CTBase:
- [CoveragePostprocessing.jl](https://github.com/control-toolbox/CTBase.jl/blob/main/ext/CoveragePostprocessing.jl)
- [DocumenterReference.jl](https://github.com/control-toolbox/CTBase.jl/blob/main/ext/DocumenterReference.jl)
- [TestRunner.jl](https://github.com/control-toolbox/CTBase.jl/blob/main/ext/TestRunner.jl)

---

### Success Criteria

- ✅ All tests passing
- ✅ >90% code coverage for all packages
- ✅ Complete API documentation
- ✅ All sub-packages at validated beta versions

---

**Related**: control-toolbox/CTModels.jl#247

See [detailed roadmap](https://github.com/control-toolbox/dev-workflows/blob/main/reports-breaking/2026-01-18-ctmodels-0.7.0-beta/phase4-detailed-roadmap.md) for complete information.
