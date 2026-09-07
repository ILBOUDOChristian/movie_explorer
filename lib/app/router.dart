import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import '../screens/add_movie_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/movie_detail_screen.dart';
import '../screens/movies_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/responsive_shell.dart';
import 'app_routes.dart';

/// Routage déclaratif Navigator 2.0 via GoRouter.
GoRouter createAppRouter() {
  final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'root',
  );

  return GoRouter(
    initialLocation: AppRoutes.homePath,
    navigatorKey: rootNavigatorKey,
    errorBuilder: (context, state) => RouteErrorScreen(error: state.error),
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
                path: AppRoutes.homePath,
                name: AppRoutes.home,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.moviesPath,
                name: AppRoutes.movies,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MoviesScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.addMoviePath,
                name: AppRoutes.addMovie,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: AddMovieScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favoritesPath,
                name: AppRoutes.favorites,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: FavoritesScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settingsPath,
                name: AppRoutes.settings,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.movieDetailPath,
        name: AppRoutes.movieDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final movieId = state.pathParameters[AppRoutes.movieIdParam]!;
          final extra = state.extra;
          return MovieDetailScreen(
            movieId: movieId,
            initialMovie: extra is Movie ? extra : null,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notFoundPath,
        name: AppRoutes.notFound,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RouteErrorScreen(),
      ),
    ],
  );
}

class RouteErrorScreen extends StatelessWidget {
  final GoException? error;

  const RouteErrorScreen({super.key, this.error});

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
                'Cette page n\'existe pas.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => AppRoutes.goHome(context),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Retour à l\'accueil'),
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
