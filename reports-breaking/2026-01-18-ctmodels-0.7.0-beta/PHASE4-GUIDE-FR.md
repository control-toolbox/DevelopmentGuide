# Phase 4 : OptimalControl - Guide de Démarrage

**Date** : 2026-01-20  
**Package** : OptimalControl  
**Version** : 1.1.8-beta → 2.0.0-beta  
**Branche** : breaking/ctmodels-0.7  

---

## 📋 Résumé

Tous les fichiers nécessaires pour démarrer la Phase 4 ont été créés dans ce dossier :

| Fichier | Description |
|---------|-------------|
| `PHASE4-QUICK-START.md` | ⭐ **Commandes essentielles** (à consulter en premier) |
| `phase4-optimalcontrol-setup.md` | Instructions complètes et détaillées |
| `phase4-issue-body.md` | Template pour l'issue GitHub |
| `phase4-pr-body.md` | Template pour la Pull Request |
| `setup-phase4.sh` | Script bash automatisé |

---

## 🚀 Démarrage Rapide

### Étape 1 : Créer l'issue GitHub

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/dev-workflows/reports-breaking/2026-01-18-ctmodels-0.7.0-beta

gh issue create \
  --repo control-toolbox/OptimalControl.jl \
  --title "Adapt to CTModels v0.7.x and integrate CTSolvers" \
  --body-file phase4-issue-body.md
```

**Note** : Notez le numéro de l'issue créée (ex: #123)

### Étape 2 : Créer la branche

⚠️ **IMPORTANT** : La branche doit partir du **tag v1.1.8-beta**, pas de `main` !

```bash
# Aller dans le dépôt OptimalControl
cd /path/to/OptimalControl.jl

# Récupérer les tags
git fetch --tags

# Partir du tag v1.1.8-beta
git checkout v1.1.8-beta

# Créer la branche breaking
git checkout -b breaking/ctmodels-0.7

# Pousser la branche
git push -u origin breaking/ctmodels-0.7
```

### Étape 3 : Créer la Pull Request

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/dev-workflows/reports-breaking/2026-01-18-ctmodels-0.7.0-beta

# 1. Éditer phase4-pr-body.md pour remplacer [ISSUE_NUMBER] par le numéro de l'issue
# 2. Créer la PR

gh pr create \
  --repo control-toolbox/OptimalControl.jl \
  --base main \
  --head breaking/ctmodels-0.7 \
  --title "Adapt to CTModels v0.7.x and integrate CTSolvers" \
  --body-file phase4-pr-body.md \
  --label "breaking-change,migration,phase-4"
```

---

## 📝 Prochaines Étapes (Après Setup)

Une fois l'issue, la branche et la PR créées :

### 1. Identifier les changements

- Consulter le CHANGELOG de CTModels
- Consulter la PR #248 de CTModels

### 2. Tester avec les nouvelles versions

```julia
using Pkg
Pkg.develop("OptimalControl")
Pkg.add(name="CTModels", version="0.7.0-beta")
Pkg.add(name="CTSolvers", version="0.2.0-beta")
Pkg.test("OptimalControl")
```

### 3. Adapter le code

- Corriger les tests qui échouent
- Adapter le code à la nouvelle API de CTModels v0.7.x
- Intégrer CTSolvers comme nouvelle dépendance

### 4. Mettre à jour Project.toml

**Seulement après que tous les tests passent !**

```toml
version = "2.0.0-beta"

[compat]
CTDirect = "0.17, 0.18"
CTFlows = "0.8"
CTModels = "0.6, 0.7"
CTParser = "0.8"
CTSolvers = "0.2"  # NOUVEAU
CTBase = "0.17"
```

### 5. Enregistrer la beta

```bash
cd /path/to/OptimalControl.jl

# Créer le tag
git tag v2.0.0-beta
git push origin v2.0.0-beta

# Enregistrer dans ct-registry
julia -e '
using LocalRegistry, OptimalControl
register(OptimalControl, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/OptimalControl.jl.git")
'
```

---

## 🎯 Points Clés à Retenir

1. ⚠️ **Partir du tag v1.1.8-beta**, pas de `main`
2. 🔢 **Version majeure** : 1.1.8-beta → 2.0.0-beta (changement important)
3. 📦 **Nouveau package** : CTSolvers doit être intégré
4. 🧪 **Tests d'abord** : Adapter le code avant de modifier Project.toml
5. 🏷️ **Beta registry** : Utiliser ct-registry pour l'enregistrement

---

## 📚 Ressources

- **Plan d'action complet** : `action-plan.md` (lignes 700-850)
- **Détails de version** : `version-update-optimalcontrol.md`
- **Méthodologie** : `../../breaking-change-rules.md`
- **Issue CTModels** : <https://github.com/control-toolbox/CTModels.jl/issues/247>

---

## ✅ Checklist

- [ ] Issue GitHub créée
- [ ] Branche `breaking/ctmodels-0.7` créée depuis tag `v1.1.8-beta`
- [ ] Pull Request créée
- [ ] Code adapté à CTModels v0.7.x
- [ ] CTSolvers intégré
- [ ] Tous les tests passent
- [ ] Project.toml mis à jour
- [ ] Version v2.0.0-beta enregistrée dans ct-registry
- [ ] Tag v2.0.0-beta créé

---

**Bon courage pour la Phase 4 ! 🚀**
