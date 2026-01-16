# CTBase v0.17.0 Breaking Change Migration

**Date**: 2026-01-16  
**Package**: CTBase  
**Version**: 0.16.2 → 0.17.0  
**Strategy**: Option B - Beta Versions

---

## 📋 Files in This Directory

### Core Files

1. **setup.md** - Main setup report
   - Dependency graph
   - Breakage test results
   - Package classification
   - Chosen strategy

2. **PR-comment.md** - Comment for PR #404
   - Ready to copy-paste
   - Summary of setup

### Guides

3. **GUIDE.md** - General migration guide
   - Overview of the process
   - Next steps
   - FAQ

4. **GUIDE-beta-versions.md** - Beta version creation guide
   - Step-by-step instructions for CTModels v0.6.10-beta
   - Step-by-step instructions for CTParser v0.7.3-beta
   - Testing procedures

5. **SUMMARY.md** - Executive summary
   - Quick overview
   - Key results
   - Next actions

---

## 🎯 Quick Start

1. **Read**: `SUMMARY.md` for a quick overview
2. **Review**: `setup.md` for complete details
3. **Create betas**: Follow `GUIDE-beta-versions.md`
4. **Post PR comment**: Copy `PR-comment.md` to PR #404

---

## 📊 Status

- ✅ Setup complete
- ✅ Strategy chosen (Option B)
- ⏳ Beta versions to create
- ⏳ Action plan to generate

---

## 🔗 Links

- **Issue**: [#403](https://github.com/control-toolbox/CTBase.jl/issues/403)
- **PR**: [#404](https://github.com/control-toolbox/CTBase.jl/pull/404)
- **Branch**: `breaking/ctbase-0.17`

---

## 📈 Results

| Package | Status | Action |
|---------|--------|--------|
| CTDirect v0.17.4 | ✅ Compatible | Widen compat |
| CTFlows v0.8.9 | ✅ Compatible | Widen compat |
| OptimalControl v1.1.6 | ✅ Compatible | Widen compat |
| CTModels v0.6.9 | ⚠️ Compat conflict | Create v0.6.10-beta |
| CTParser v0.7.2 | ⚠️ Compat conflict | Create v0.7.3-beta |

---

**Next step**: Create beta versions, then run `/breaking-action-plan reports-breaking/2026-01-16-ctbase-0.17.0`
