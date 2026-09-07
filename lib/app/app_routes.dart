import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';

/// Noms et chemins des routes nommées (GoRouter / Navigator 2.0).
abstract final class AppRoutes {
  static const home = 'home';
  static const movies = 'movies';
  static const addMovie = 'add-movie';
  static const favorites = 'favorites';
  static const settings = 'settings';
  static const movieDetail = 'movie-detail';
  static const notFound = 'not-found';

  static const homePath = '/';
  static const moviesPath = '/movies';
  static const addMoviePath = '/add-movie';
  static const favoritesPath = '/favorites';
  static const settingsPath = '/settings';
  static const movieDetailPath = '/movie/:id';
  static const notFoundPath = '/404';

  static const movieIdParam = 'id';
  static const searchQuery = 'q';
  static const categoryQuery = 'category';

  static void goHome(BuildContext context) => context.goNamed(home);

  static void goMovies(
    BuildContext context, {
    String? query,
    String? category,
  }) {
    context.goNamed(
      movies,
      queryParameters: {
        if (query != null && query.trim().isNotEmpty) searchQuery: query.trim(),
        if (category != null && category.trim().isNotEmpty)
          categoryQuery: category.trim(),
      },
    );
  }

  static void goFavorites(BuildContext context) => context.goNamed(favorites);

  static void goNamedRoute(BuildContext context, String name) {
    context.goNamed(name);
  }

  static Future<T?> pushMovieDetail<T>(
    BuildContext context,
    String id, {
    Movie? movie,
  }) {
    return context.pushNamed<T>(
      movieDetail,
      pathParameters: {movieIdParam: id},
      extra: movie,
    );
  }
}
