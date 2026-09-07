import 'package:flutter/material.dart';

import '../app/app_routes.dart';

class AppDestination {
  const AppDestination({
    required this.routeName,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String routeName;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class QuickAction {
  const QuickAction({
    required this.routeName,
    required this.label,
    required this.icon,
  });

  final String routeName;
  final String label;
  final IconData icon;
}

/// Destinations et raccourcis : données hors des widgets.
class AppNavigationData {
  static const destinations = [
    AppDestination(
      routeName: AppRoutes.home,
      label: 'Accueil',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    AppDestination(
      routeName: AppRoutes.movies,
      label: 'Films',
      icon: Icons.movie_outlined,
      selectedIcon: Icons.movie,
    ),
    AppDestination(
      routeName: AppRoutes.addMovie,
      label: 'Ajouter',
      icon: Icons.add_circle_outline,
      selectedIcon: Icons.add_circle,
    ),
    AppDestination(
      routeName: AppRoutes.favorites,
      label: 'Favoris',
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
    ),
    AppDestination(
      routeName: AppRoutes.settings,
      label: 'Paramètres',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
    ),
  ];

  static const quickActions = [
    QuickAction(
      routeName: AppRoutes.movies,
      label: 'Tous les films',
      icon: Icons.movie_outlined,
    ),
    QuickAction(
      routeName: AppRoutes.favorites,
      label: 'Mes favoris',
      icon: Icons.favorite_border,
    ),
    QuickAction(
      routeName: AppRoutes.addMovie,
      label: 'Ajouter',
      icon: Icons.add_circle_outline,
    ),
    QuickAction(
      routeName: AppRoutes.settings,
      label: 'Paramètres',
      icon: Icons.settings_outlined,
    ),
  ];
}
