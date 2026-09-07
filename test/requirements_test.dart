import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_explorer/data/movie_repository.dart';
import 'package:movie_explorer/providers/movie_provider.dart';
import 'package:movie_explorer/providers/theme_provider.dart';

void main() {
  test('movie repository provides list data and categories', () {
    expect(MovieRepository.getAll(), hasLength(10));
    expect(MovieRepository.categories, contains('Science-fiction'));
    expect(MovieRepository.search('Nolan'), isNotEmpty);
    expect(MovieRepository.filterByCategory('Action'), isNotEmpty);
  });

  test('movie provider filters by query and category', () {
    final provider = MovieProvider();

    provider.updateSearchQuery('Inception');
    expect(provider.filteredMovies.single.title, 'Inception');

    provider.updateSearchQuery('');
    provider.updateCategory('Science-fiction');
    expect(
      provider.filteredMovies.every(
        (movie) => movie.category == 'Science-fiction',
      ),
      isTrue,
    );
  });

  test('theme provider supports light and dark modes', () {
    final provider = ThemeProvider();

    provider.setThemeMode(ThemeMode.dark);
    expect(provider.themeMode, ThemeMode.dark);
    provider.toggleTheme();
    expect(provider.themeMode, ThemeMode.light);
  });
}
