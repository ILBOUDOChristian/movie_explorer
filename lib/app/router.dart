import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/add_movie_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/movie_detail_screen.dart';
import '../screens/movies_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/responsive_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        final path = state.uri.toString();
        int index = 0;
        if (path.startsWith('/movies')) {
          index = 1;
        } else if (path.startsWith('/add-movie')) {
          index = 2;
        } else if (path.startsWith('/favorites')) {
          index = 3;
        } else if (path.startsWith('/settings')) {
          index = 4;
        }
        return _ShellWrapper(
          initialIndex: index,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/movies',
          name: 'movies',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MoviesScreen(),
          ),
        ),
        GoRoute(
          path: '/add-movie',
          name: 'add-movie',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AddMovieScreen(),
          ),
        ),
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FavoritesScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/movie/:id',
      name: 'movie-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final movieId = state.pathParameters['id']!;
        return MovieDetailScreen(movieId: movieId);
      },
    ),
  ],
);

class _ShellWrapper extends StatefulWidget {
  final int initialIndex;
  final Widget child;

  const _ShellWrapper({
    required this.initialIndex,
    required this.child,
  });

  @override
  State<_ShellWrapper> createState() => _ShellWrapperState();
}

class _ShellWrapperState extends State<_ShellWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(_ShellWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _currentIndex = widget.initialIndex;
      });
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('movies');
        break;
      case 2:
        context.goNamed('add-movie');
        break;
      case 3:
        context.goNamed('favorites');
        break;
      case 4:
        context.goNamed('settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveShell(
      currentIndex: _currentIndex,
      onTap: _onTap,
      child: widget.child,
    );
  }
}
