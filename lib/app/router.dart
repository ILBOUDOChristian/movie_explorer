import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/add_movie_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/movie_detail_screen.dart';
import '../screens/movies_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/responsive_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => _RouteErrorScreen(error: state.error),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ResponsiveShell(
          currentIndex: navigationShell.currentIndex,
          onTap: navigationShell.goBranch,
          child: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/movies',
              name: 'movies',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MoviesScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/add-movie',
              name: 'add-movie',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AddMovieScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: 'favorites',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: FavoritesScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/movie/:id',
      name: 'movie-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return MovieDetailScreen(movieId: state.pathParameters['id']!);
      },
    ),
  ],
);

class _RouteErrorScreen extends StatelessWidget {
  final GoException? error;

  const _RouteErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page introuvable')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Cette page n existe pas.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.goNamed('home'),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Retour a l accueil'),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error.toString(), textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
