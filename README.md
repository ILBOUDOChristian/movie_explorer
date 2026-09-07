# Movie Explorer

Application Flutter de découverte et de gestion de films. Elle propose une bibliothèque locale, la recherche, les catégories, les favoris, l'ajout de films et un thème clair ou sombre.

## Fonctionnalités

- Consultation des films et des mieux notés
- Recherche par titre, réalisateur ou catégorie
- Affichage en liste ou en grille
- Ajout de films personnalisés
- Gestion des favoris
- Thème clair, sombre ou système
- Interface responsive pour mobile, tablette et navigateur

## Aperçu

Les captures sont regroupées dans [docs/screenshots](docs/screenshots).

| Accueil | Bibliothèque | Détail d'un film |
| --- | --- | --- |
| ![Accueil](docs/screenshots/Accueil.png) | ![Bibliothèque](docs/screenshots/Biblioth%C3%A8que.png) | ![Détail](docs/screenshots/Detail.png) |

## Prérequis

- Flutter stable
- Dart inclus avec Flutter
- Chrome pour le lancement web ou un émulateur Android/iOS

Vérifiez l'installation avec :

```bash
flutter doctor
```

## Installation

```bash
git clone https://github.com/ILBOUDO/movie_explorer.git
cd movie_explorer
flutter pub get
```

## Lancement

Pour lancer l'application dans Chrome :

```bash
flutter run -d chrome
```

Pour afficher les appareils disponibles :

```bash
flutter devices
```

Puis lancez l'application sur l'appareil choisi :

```bash
flutter run -d <device-id>
```

## Vérification

```bash
flutter analyze
flutter test
```

L'analyse peut encore signaler des avertissements de dépréciation selon la version de Flutter utilisée; aucune erreur de compilation ne doit rester.

## Structure

```text
lib/
	app/          Navigation et composition de l'application
	data/         Données initiales des films
	models/       Modèles métier
	providers/    État des films et du thème
	screens/      Écrans principaux
	theme/        Thèmes Material
	widgets/      Composants réutilisables
```

## Licence

Projet personnel. Ajoutez une licence explicite avant publication si le dépôt doit être réutilisé.
