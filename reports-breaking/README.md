# Breaking Change Reports

Ce répertoire contient tous les rapports et guides pour les migrations de breaking changes dans l'écosystème control-toolbox.

---

## 📁 Structure

Chaque migration est organisée dans son propre sous-répertoire au format :

```
YYYY-MM-DD-{package}-{version}/
```

Cette structure permet un **tri chronologique automatique** et une **organisation claire**.

### Migrations Actuelles

- **2026-01-16-ctbase-0.17.0/** - Migration CTBase v0.16.2 → v0.17.0
  - Status: Setup terminé, beta versions à créer
  - Stratégie: Option B (Beta versions)

### Documentation Générale

- **README.md** - Ce fichier
- **WORKFLOW-IMPROVEMENTS.md** - Améliorations des workflows
- **DIRECTORY-STRUCTURE-IMPROVEMENT.md** - Documentation de la structure
- **SESSION-SUMMARY.md** - Résumé de la session de setup

---

## 🚀 Démarrage Rapide

### Pour une Migration Existante

1. **Naviguer** : `cd 2026-01-16-ctbase-0.17.0/`
2. **Lire** : `README.md` pour une vue d'ensemble
3. **Suivre** : Les guides spécifiques

### Pour une Nouvelle Migration

1. **Lancer** : `/breaking-setup` workflow
2. Le workflow créera automatiquement : `reports-breaking/YYYY-MM-DD-{package}-{version}/`
3. Tous les fichiers seront organisés dans ce répertoire

---

## 📊 État Actuel

### CTBase v0.17.0 Migration (2026-01-16)

**Status** : Setup terminé, création des versions beta en cours

**Fichiers** :

- `setup.md` - Rapport de setup complet
- `PR-comment.md` - Commentaire pour PR #404
- `GUIDE.md` - Guide général
- `GUIDE-beta-versions.md` - Guide création betas
- `SUMMARY.md` - Résumé exécutif

**Prochaines étapes** :
1. Créer CTModels v0.6.10-beta
2. Créer CTParser v0.7.3-beta
3. Générer le plan d'action avec `/breaking-action-plan`

---

## 🔗 Liens Utiles

- **Workflows** : Voir `.agent/workflows/breaking-*.md`
- **CTBase Issue** : [#403](https://github.com/control-toolbox/CTBase.jl/issues/403)
- **CTBase PR** : [#404](https://github.com/control-toolbox/CTBase.jl/pull/404)

---

**Dernière mise à jour** : 2026-01-16 22:11
