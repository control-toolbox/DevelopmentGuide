# CTModels 0.7.0-beta Migration Report

This directory contains all files related to the CTModels breaking change migration from v0.6.10-beta to v0.7.0-beta.

---

## Files

### Core Documentation

- **`setup.md`** - Complete setup report with dependency graph, breakage results, and package classification
- **`action-plan.md`** - Detailed phase-by-phase migration plan
- **`action-plan-update-summary.md`** - Summary of action plan updates
- **`PR-comment.md`** - Summary comment to post on PR #248
- **`widening-commands.md`** - Commands for widening compat in dependent packages

### Version Update Documentation

- **`version-update-ctdirect.md`** - CTDirect version update details
- **`version-update-ctsolvers.md`** - CTSolvers version update details
- **`version-update-optimalcontrol.md`** - OptimalControl version update details

### Phase 4 Setup Files (OptimalControl)

- **`PHASE4-QUICK-START.md`** - ⭐ Quick reference with essential commands
- **`PHASE4-GUIDE-FR.md`** - ⭐ Guide complet en français
- **`phase4-optimalcontrol-setup.md`** - Complete setup instructions
- **`phase4-issue-body.md`** - GitHub issue template
- **`phase4-pr-body.md`** - GitHub PR template
- **`setup-phase4.sh`** - Automated setup script

### Phase 4 Detailed Planning

- **`phase4-detailed-roadmap.md`** - Complete migration roadmap with all phases
- **`phase4-issue-comment.md`** - Comment to post on GitHub issue

---

## Quick Reference

**Package**: CTModels  
**Versions**: 0.6.10-beta → 0.7.0-beta  
**Issue**: [#247](https://github.com/control-toolbox/CTModels.jl/issues/247)  
**PR**: [#248](https://github.com/control-toolbox/CTModels.jl/pull/248)  
**Date**: 2026-01-18

---

## Breakage Results

| Package | Status | Action |
|---------|--------|--------|
| CTDirect | ❌ Breaking | Adaptation needed |
| CTFlows | ✅ Compatible | Widening only |
| OptimalControl | ❌ Breaking | Adaptation needed |

---

## Migration Status

- [x] Setup complete
- [x] Action plan generated
- [x] Phase 1: CTFlows widening (v0.8.11-beta)
- [x] Phase 2: CTModels beta release (v0.7.0-beta)
- [x] Phase 3: CTDirect adaptation (v0.18.0-beta)
- [x] Phase 3.5: CTSolvers beta release (v0.2.0-beta)
- [ ] **Phase 4: OptimalControl adaptation (v2.0.0-beta)** ← Current phase
- [ ] Phase 5: Stabilization

---

## Phase 4: OptimalControl Setup

**Quick start**: See `PHASE4-QUICK-START.md` for essential commands

**Key points**:

- Branch must start from tag `v1.1.8-beta` (not `main`)
- Major version bump: v1.1.8-beta → v2.0.0-beta
- Integrates new CTSolvers package
- Adapts to CTModels v0.7.x API

---

## Next Steps

1. ✅ Review `setup.md` for complete analysis
2. ✅ Generate action plan
3. ✅ Execute Phases 1-3.5
4. 🔄 **Execute Phase 4**: See `PHASE4-QUICK-START.md`
5. ⏳ Execute Phase 5: Stabilization

---

## Special Notes

- **Existing v0.7.0**: A v0.7.0 release already exists and will be merged after migration
- **Testing strategy**: Used temporary v0.6.11 for breakage testing
- **Beta registry**: All beta versions registered in ct-registry (local)
- **New package**: CTSolvers introduced in Phase 3.5
