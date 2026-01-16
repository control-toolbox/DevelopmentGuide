# Amélioration : Structure de Répertoires pour les Rapports

**Date** : 2026-01-16 22:08  
**Workflow** : `breaking-setup.md`

---

## 🎯 Objectif

Organiser les rapports de breaking changes dans des sous-répertoires datés pour un meilleur tri chronologique et une organisation plus claire.

---

## 📁 Nouvelle Structure

### Avant
```
reports-breaking/
├── ctbase-0.17.0-2026-01-16-setup.md
├── PR-404-comment.md
├── GUIDE-ctbase-0.17.0.md
├── GUIDE-beta-versions.md
└── ... (tous les fichiers mélangés)
```

**Problèmes** :
- ❌ Fichiers mélangés dans un seul répertoire
- ❌ Difficile de trouver tous les fichiers d'une migration
- ❌ Pas de tri chronologique clair
- ❌ Nom de fichier long et répétitif

### Après
```
reports-breaking/
└── 2026-01-16-ctbase-0.17.0/
    ├── setup.md
    ├── PR-comment.md
    ├── README.md
    ├── GUIDE.md
    └── ... (tous les fichiers de cette migration)
```

**Avantages** :
- ✅ Un répertoire par migration
- ✅ Tri chronologique automatique (YYYY-MM-DD)
- ✅ Noms de fichiers courts et clairs
- ✅ Facile de trouver tous les fichiers liés
- ✅ Facile d'archiver ou de supprimer une migration complète

---

## 🔧 Format du Répertoire

**Format** : `YYYY-MM-DD-{package}-{version}`

**Exemples** :
- `2026-01-16-ctbase-0.17.0`
- `2026-02-15-ctmodels-0.7.0`
- `2026-03-20-ctparser-0.8.0`

**Tri lexicographique** = Tri chronologique ! 🎉

---

## 📝 Changements dans le Workflow

### Step 1b (nouveau)

Ajout d'une étape pour créer le répertoire de rapport :

1. **Générer le nom** : `YYYY-MM-DD-{package}-{version}`
2. **Confirmer avec l'utilisateur**
3. **Créer le répertoire** : `mkdir -p reports-breaking/{dir}`
4. **Stocker le chemin** : `REPORT_DIR="reports-breaking/{dir}"`

### Step 6 - Rapport de Setup

**Avant** : `reports-breaking/{package}-{version}-{date}-setup.md`  
**Après** : `${REPORT_DIR}/setup.md`

**Avantage** : Nom de fichier court et clair

### Step 7 - PR Comment

**Avant** : `reports-breaking/PR-{pr_number}-comment.md`  
**Après** : `${REPORT_DIR}/PR-comment.md`

**Avantages** :
- Nom plus court
- Pas besoin du numéro de PR dans le nom
- Toujours dans le bon répertoire

### Step 8 - Transition

**Avant** : `/breaking-action-plan reports-breaking/ctbase-0.17.0-2026-01-16-setup.md`  
**Après** : `/breaking-action-plan reports-breaking/2026-01-16-ctbase-0.17.0`

**Avantage** : Le second workflow reçoit un répertoire, pas un fichier

---

## 📂 Fichiers dans le Répertoire

Chaque répertoire de migration contient :

1. **setup.md** - Rapport de setup principal (obligatoire)
2. **PR-comment.md** - Commentaire pour la PR (obligatoire)
3. **README.md** - Vue d'ensemble du répertoire (optionnel)
4. **GUIDE.md** - Guide des prochaines étapes (optionnel)
5. **Autres fichiers** - Selon les besoins de la migration

---

## 🔄 Impact sur le Second Workflow

Le workflow `/breaking-action-plan` devra être mis à jour pour :

1. **Accepter un répertoire** au lieu d'un fichier
2. **Lire** `${REPORT_DIR}/setup.md`
3. **Créer** les fichiers de sortie dans `${REPORT_DIR}/`

**Exemple** :
```bash
/breaking-action-plan reports-breaking/2026-01-16-ctbase-0.17.0
```

Le workflow lira :
- `reports-breaking/2026-01-16-ctbase-0.17.0/setup.md`

Et créera :
- `reports-breaking/2026-01-16-ctbase-0.17.0/action-plan.md`
- `reports-breaking/2026-01-16-ctbase-0.17.0/phase-*.md`
- etc.

---

## ✅ Avantages Globaux

1. **Organisation** : Un répertoire = une migration
2. **Chronologie** : Tri automatique par date
3. **Clarté** : Noms de fichiers courts
4. **Archivage** : Facile de déplacer/supprimer une migration
5. **Navigation** : Facile de trouver tous les fichiers liés
6. **Évolutivité** : Peut contenir autant de fichiers que nécessaire

---

## 📋 Exemple Complet

```
reports-breaking/
├── 2026-01-16-ctbase-0.17.0/
│   ├── setup.md
│   ├── PR-comment.md
│   ├── README.md
│   ├── action-plan.md
│   ├── phase-1-beta-versions.md
│   ├── phase-2-migrations.md
│   └── COMPLETE.md
│
├── 2026-02-15-ctmodels-0.7.0/
│   ├── setup.md
│   ├── PR-comment.md
│   └── action-plan.md
│
└── 2026-03-20-ctparser-0.8.0/
    ├── setup.md
    └── PR-comment.md
```

**Navigation facile** : `ls -la reports-breaking/` montre toutes les migrations par ordre chronologique !

---

## 🎯 Prochaines Étapes

1. ✅ Workflow `breaking-setup.md` mis à jour
2. ⏳ Workflow `breaking-action-plan.md` à mettre à jour
3. ⏳ Tester avec une vraie migration
4. ⏳ Documenter dans le README principal

---

**Statut** : ✅ Implémenté dans `breaking-setup.md`
