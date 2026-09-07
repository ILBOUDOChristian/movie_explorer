import 'package:flutter/material.dart';

import '../models/quick_action.dart';

class QuickActionRepository {
  static const List<QuickAction> actions = [
    QuickAction(
      icon: Icons.movie_outlined,
      label: 'Tous les films',
      routeName: 'movies',
    ),
    QuickAction(
      icon: Icons.favorite_border,
      label: 'Mes favoris',
      routeName: 'favorites',
    ),
    QuickAction(
      icon: Icons.add_circle_outline,
      label: 'Ajouter',
      routeName: 'add-movie',
    ),
    QuickAction(
      icon: Icons.settings_outlined,
      label: 'Paramètres',
      routeName: 'settings',
    ),
  ];
}
