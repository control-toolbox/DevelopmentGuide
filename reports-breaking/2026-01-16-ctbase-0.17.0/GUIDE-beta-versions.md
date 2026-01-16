# Guide : Création des Versions Beta

Ce guide vous aide à créer les versions beta de CTModels et CTParser pour isoler la migration CTBase.

## 🎯 Objectif

Créer des versions beta qui supportent CTBase v0.17 **sans** les breaking changes de CTModels v0.7.0 et CTParser v0.8.0.

---

## 📦 CTModels v0.6.10-beta

### Étape 1 : Créer la branche beta

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/CTModels.jl

# Créer une branche depuis v0.6.9
git checkout -b beta/ctbase-0.17-compat v0.6.9
```

### Étape 2 : Modifier Project.toml

Éditez `Project.toml` :

```toml
name = "CTModels"
uuid = "34c4fa32-5b1e-4c5f-9cbd-1b9c5b0a6b3e"
authors = ["control-toolbox"]
version = "0.6.10-beta"  # ← Changer ici

[deps]
# ... (garder les dépendances existantes)

[compat]
CTBase = "0.16, 0.17"  # ← Ajouter 0.17 ici
# ... (garder les autres compat)
```

### Étape 3 : Tester localement

```bash
# Tester que le package se charge
julia --project=. -e 'using Pkg; Pkg.instantiate(); using CTModels'

# Vérifier la compatibilité
julia --project=. -e 'using Pkg; Pkg.status()'
```

### Étape 4 : Register in ct-registry and tag

**Register in local registry**:

```julia
# In Julia REPL
using LocalRegistry
using CTModels
register(CTModels, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/CTModels.jl.git")
```

**Note**:

- This is the **first time** CTModels is registered in ct-registry (it's normally in General registry)
- We must specify both `registry` and `repo` for first-time registration in a new registry
- For subsequent beta versions in ct-registry, only `registry = "ct-registry"` would be needed

**Create and push tag**:

```bash
git add Project.toml
git commit -m "chore: add CTBase v0.17 compat (beta version)"

# Create the beta tag
git tag v0.6.10-beta

# Push branch and tag
git push origin beta/ctbase-0.17-compat
git push origin v0.6.10-beta
```

**Why ct-registry?**

- ✅ Faster (no General registry delays)
- ✅ Beta versions stay isolated
- ✅ Easier to test and iterate

---

## 📦 CTParser v0.7.3-beta

### Étape 1 : Créer la branche beta

```bash
cd /Users/ocots/Research/logiciels/dev/control-toolbox/CTParser.jl

# Créer une branche depuis v0.7.2
git checkout -b beta/ctbase-0.17-compat v0.7.2
```

### Étape 2 : Modifier Project.toml

Éditez `Project.toml` :

```toml
name = "CTParser"
uuid = "32681960-4c6c-4f01-9d7c-8b1b48cba1aa"
authors = ["control-toolbox"]
version = "0.7.3-beta"  # ← Changer ici

[deps]
# ... (garder les dépendances existantes)

[compat]
CTBase = "0.16, 0.17"  # ← Ajouter 0.17 ici
# ... (garder les autres compat)
```

### Étape 3 : Tester localement

```bash
# Tester que le package se charge
julia --project=. -e 'using Pkg; Pkg.instantiate(); using CTParser'

# Vérifier la compatibilité
julia --project=. -e 'using Pkg; Pkg.status()'
```

### Étape 4 : Register in ct-registry and tag

**Register in local registry**:

```julia
# In Julia REPL
using LocalRegistry
using CTParser
register(CTParser, 
         registry = "ct-registry",
         repo = "git@github.com:control-toolbox/CTParser.jl.git")
```

**Note**:

- This is the **first time** CTParser is registered in ct-registry (it's normally in General registry)
- We must specify both `registry` and `repo` for first-time registration in a new registry
- For subsequent beta versions in ct-registry, only `registry = "ct-registry"` would be needed

**Create and push tag**:

```bash
git add Project.toml
git commit -m "chore: add CTBase v0.17 compat (beta version)"

# Create the beta tag
git tag v0.7.3-beta

# Push branch and tag
git push origin beta/ctbase-0.17-compat
git push origin v0.7.3-beta
```

**Why ct-registry?**

- ✅ Faster (no General registry delays)
- ✅ Beta versions stay isolated
- ✅ Easier to test and iterate

---

## 🧪 Tester les Versions Beta

Une fois les versions beta créées, testez-les :

```bash
# Dans un environnement de test
mkdir -p /tmp/test-beta
cd /tmp/test-beta

julia --project=. -e '
using Pkg

# Ajouter les versions beta
Pkg.add(name="CTBase", version="0.17.0")
Pkg.add(name="CTModels", version="0.6.10-beta")
Pkg.add(name="CTParser", version="0.7.3-beta")

# Vérifier que tout se charge
using CTBase, CTModels, CTParser

println("✅ Beta versions loaded successfully!")
Pkg.status()
'
```

---

## ✅ Checklist

- [ ] CTModels v0.6.10-beta créé
  - [ ] Branche `beta/ctbase-0.17-compat` créée depuis v0.6.9
  - [ ] `Project.toml` modifié (version + compat)
  - [ ] Tag `v0.6.10-beta` créé et poussé
  - [ ] Testé localement

- [ ] CTParser v0.7.3-beta créé
  - [ ] Branche `beta/ctbase-0.17-compat` créée depuis v0.7.2
  - [ ] `Project.toml` modifié (version + compat)
  - [ ] Tag `v0.7.3-beta` créé et poussé
  - [ ] Testé localement

- [ ] Test d'intégration avec CTBase v0.17.0
- [ ] Relancer les breakage tests avec les versions beta

---

## 📋 Après la Création des Beta

Une fois les versions beta créées et testées :

1. **Mettre à jour le rapport** :
   - Documenter les versions beta créées
   - Ajouter les résultats des tests

2. **Relancer les breakage tests** :
   - Les tests devraient maintenant passer pour CTModels et CTParser (versions beta)

3. **Générer le plan d'action** :
   ```bash
   /breaking-action-plan reports-breaking/ctbase-0.17.0-2026-01-16-setup.md
   ```

---

## ⚠️ Notes Importantes

- Les versions beta sont enregistrées dans **ct-registry** (registre local), pas dans le registre Julia général
- Elles servent uniquement à tester la migration CTBase indépendamment
- Une fois la migration CTBase validée, on passera aux vraies versions CTModels v0.7.0 et CTParser v0.8.0
- Les versions beta peuvent être utilisées avec `Pkg.add(name="CTModels", version="0.6.10-beta")` (après avoir ajouté ct-registry)
- Pour ajouter ct-registry : `pkg> registry add git@github.com:control-toolbox/ct-registry.git`

---

**Dernière mise à jour** : 2026-01-16 21:29
