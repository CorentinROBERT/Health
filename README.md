# Health

Health est une application iOS native développée en SwiftUI et SwiftData pour centraliser le suivi personnel de santé, nutrition, activité physique et profil utilisateur.

L’application permet de :
- suivre les indicateurs de santé
- enregistrer des activités sportives
- journaliser la nutrition
- consulter un tableau de bord quotidien
- gérer des dossiers médicaux avec pièces jointes
- éditer les informations de profil

## Stack technique

- Swift
- SwiftUI
- SwiftData
- Xcode
- Quick Look pour l’aperçu des pièces jointes
- File Importer pour l’ajout de PDF et d’images

## Fonctionnalités principales

### Home
- accueil personnalisé
- synthèse quotidienne
- affichage des KPIs principaux :
  - calories du jour
  - activité hebdomadaire
  - poids actuel
  - progression d’objectif

### Santé
- ajout de métriques de santé
- ajout de dossiers médicaux
- gestion de pièces jointes :
  - images
  - PDF
  - documents
- aperçu des pièces jointes
- suppression des données par swipe
- détail d’une mesure ou d’un dossier
- suppression depuis la vue détail

### Sport
- ajout d’activités sportives via sheet
- affichage des statistiques hebdomadaires
- suivi des sessions récentes
- suppression d’une activité

### Nutrition
- ajout de repas via sheet
- suivi des calories et macronutriments
- affichage des entrées du jour
- suppression d’un log nutritionnel

### Profil
- consultation du profil utilisateur
- modification du profil
- confirmation avant déconnexion
- demande de suppression de compte
- suppression dédiée des données de santé

## Architecture du projet

Le projet est organisé de manière simple et lisible :

- `Components/` : composants UI réutilisables
- `Enum/` : enums métier et UI
- `Models/` : modèles SwiftData
- `ViewModels/` : logique de présentation
- `Views/` : écrans SwiftUI
- `MockDatas/` : seed de données de démonstration

## Persistance

L’application utilise `SwiftData` pour stocker les données localement.

Les entités principales sont :
- `User`
- `Profile`
- `HealthMetric`
- `HealthRecord`
- `Attachment`
- `SportActivity`
- `NutritionLog`
- `Goal`
- `ConnectedDevice`

Un système de seed initialise automatiquement des données de démonstration au premier lancement via `DataSeeder`.

## Lancer le projet

1. Ouvrir le projet dans Xcode
2. Sélectionner une cible iOS valide
3. Compiler et exécuter l’application

## Objectif du projet

Ce projet a pour but de proposer une base moderne d’application santé iOS, avec :
- une interface SwiftUI soignée
- une architecture simple
- une persistance locale
- des flows CRUD clairs
- une UX mobile native

## Améliorations possibles

- édition des entrées sport, nutrition et santé
- synchronisation cloud
- authentification réelle
- export et partage des documents
- graphiques avancés
- tests unitaires et UI tests
