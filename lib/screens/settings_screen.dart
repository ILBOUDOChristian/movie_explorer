import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/movie_provider.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final movieProvider = context.watch<MovieProvider>();
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text('Paramètres'),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apparence',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.dark_mode_outlined,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thème de l\'application',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _themeLabel(themeProvider.themeMode),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(_getToggleIcon(themeProvider.themeMode)),
                              onPressed: themeProvider.toggleTheme,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        ...ThemeMode.values.map((mode) {
                          return RadioListTile<ThemeMode>(
                            value: mode,
                            groupValue: themeProvider.themeMode,
                            onChanged: (val) {
                              if (val != null) {
                                themeProvider.setThemeMode(val);
                              }
                            },
                            title: Text(_themeLabel(mode)),
                            subtitle: Text(_themeDescription(mode)),
                            secondary: Icon(_getModeIcon(mode)),
                            activeColor: theme.colorScheme.primary,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Bibliothèque',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      _buildListTile(
                        context,
                        icon: Icons.movie,
                        title: 'Total des films',
                        subtitle: '${movieProvider.allMovies.length} films dans la bibliothèque',
                        trailing: Text(
                          '${movieProvider.allMovies.length}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      _buildListTile(
                        context,
                        icon: Icons.favorite,
                        title: 'Favoris',
                        subtitle: '${movieProvider.favoriteMovies.length} films sauvegardés',
                        trailing: Text(
                          '${movieProvider.favoriteMovies.length}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      _buildListTile(
                        context,
                        icon: Icons.category,
                        title: 'Catégories disponibles',
                        subtitle: '${movieProvider.categories.length - 1} genres référencés',
                        trailing: Text(
                          '${movieProvider.categories.length - 1}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'À propos',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.movie,
                            color: theme.colorScheme.surface,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Movie Explorer',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Version 1.0.0',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Votre compagnon pour découvrir et gérer vos films préférés.',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }
  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
      case ThemeMode.system:
        return 'Système';
    }
  }
  String _themeDescription(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Toujours utiliser le thème clair';
      case ThemeMode.dark:
        return 'Toujours utiliser le thème sombre';
      case ThemeMode.system:
        return 'Synchroniser avec les paramètres du système';
    }
  }
  IconData _getModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_brightness;
    }
  }
  IconData _getToggleIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
