# Phase 4: OptimalControl - Commandes Rapides

## 1. Créer l'issue GitHub

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/dev-workflows/reports-breaking/2026-01-18-ctmodels-0.7.0-beta

gh issue create \
  --repo control-toolbox/OptimalControl.jl \
  --title "Adapt to CTModels v0.7.x and integrate CTSolvers" \
  --body-file phase4-issue-body.md \
  --label "breaking-change,migration,phase-4"
```

## 2. Créer la branche (à partir du tag v1.1.8-beta)

```bash
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

**Important**: La branche doit partir du **tag v1.1.8-beta**, pas de `main` !

## 3. Créer la PR

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/dev-workflows/reports-breaking/2026-01-18-ctmodels-0.7.0-beta

# Éditer phase4-pr-body.md pour remplacer [ISSUE_NUMBER] par le numéro de l'issue créée

gh pr create \
  --repo control-toolbox/OptimalControl.jl \
  --base main \
  --head breaking/ctmodels-0.7 \
  --title "Adapt to CTModels v0.7.x and integrate CTSolvers" \
  --body-file phase4-pr-body.md \
  --label "breaking-change,migration,phase-4"
```

## 4. Prochaines étapes

1. **Identifier les changements**: Consulter le CHANGELOG de CTModels ou PR #248
2. **Tester avec les nouvelles versions**:
   ```julia
   using Pkg
   Pkg.develop("OptimalControl")
   Pkg.add(name="CTModels", version="0.7.0-beta")
   Pkg.add(name="CTSolvers", version="0.2.0-beta")
   Pkg.test("OptimalControl")
   ```
3. **Adapter le code**: Corriger les tests qui échouent
4. **Intégrer CTSolvers**: Ajouter CTSolvers comme dépendance
5. **Mettre à jour Project.toml**: Seulement après que les tests passent
6. **Enregistrer la beta**: Utiliser LocalRegistry dans ct-registry
7. **Créer le tag**: `git tag v2.0.0-beta && git push origin v2.0.0-beta`

## Fichiers de référence

- **Instructions complètes**: `phase4-optimalcontrol-setup.md`
- **Corps de l'issue**: `phase4-issue-body.md`
- **Corps de la PR**: `phase4-pr-body.md`
- **Script automatisé**: `setup-phase4.sh`
