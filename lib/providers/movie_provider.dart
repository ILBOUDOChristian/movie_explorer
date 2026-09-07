import 'package:flutter/material.dart';

import '../data/movie_repository.dart';
import '../models/movie.dart';

class MovieProvider extends ChangeNotifier {
  final List<Movie> _movies = MovieRepository.getAll();
  final Set<String> _favoriteIds = {};
  final List<Movie> _customMovies = [];
  String _searchQuery = '';
  String _selectedCategory = 'Tous';

  List<Movie> get movies => _movies;
  List<Movie> get customMovies => _customMovies;
  List<Movie> get allMovies => [..._movies, ..._customMovies];
  Set<String> get favoriteIds => _favoriteIds;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Movie> get favoriteMovies {
    return allMovies.where((m) => _favoriteIds.contains(m.id)).toList();
  }

  List<Movie> get filteredMovies {
    List<Movie> results = allMovies;

    if (_selectedCategory != 'Tous') {
      results = results.where((m) => m.category == _selectedCategory).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      results = results.where((m) {
        return m.title.toLowerCase().contains(q) ||
            m.director.toLowerCase().contains(q) ||
            m.category.toLowerCase().contains(q);
      }).toList();
    }

    return results;
  }

  List<String> get categories => MovieRepository.categories;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(String movieId) {
    if (_favoriteIds.contains(movieId)) {
      _favoriteIds.remove(movieId);
    } else {
      _favoriteIds.add(movieId);
    }
    notifyListeners();
  }

  bool isFavorite(String movieId) {
    return _favoriteIds.contains(movieId);
  }

  void addMovie(Movie movie) {
    _customMovies.add(movie);
    notifyListeners();
  }

  Movie? getById(String id) {
    for (final m in allMovies) {
      if (m.id == id) return m;
    }
    return null;
  }

  List<Movie> getTopRated({int limit = 5}) {
    final sorted = [...allMovies]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(limit).toList();
  }
}
