import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/app_routes.dart';
import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../widgets/info_chip.dart';
import '../widgets/rating_stars.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;
  final Movie? initialMovie;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
    this.initialMovie,
  });

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final movie = movieProvider.getById(movieId) ?? initialMovie;
    final isFav = movieProvider.isFavorite(movieId);

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Film introuvable'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _leaveDetail(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Ce film n\'existe pas ou a été supprimé.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _leaveDetail(context),
                  child: const Text('Retour'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final horizontalPadding = width < 600 ? 16.0 : 32.0;
          final heroHeight = width < 600
              ? 300.0
              : width < 1000
              ? 390.0
              : 460.0;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: heroHeight,
                pinned: true,
                stretch: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _leaveDetail(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? theme.colorScheme.error : null,
                    ),
                    onPressed: () => movieProvider.toggleFavorite(movieId),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        movie.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.movie,
                              size: 80,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              theme.colorScheme.surface.withValues(alpha: 0.3),
                              theme.colorScheme.surface,
                            ],
                            stops: const [0, 0.5, 0.8, 1],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style:
                                (width < 600
                                        ? theme.textTheme.headlineSmall
                                        : theme.textTheme.headlineMedium)
                                    ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          RatingStars(
                            rating: movie.rating,
                            size: 22,
                            showValue: true,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              InfoChip(
                                icon: Icons.person_outline,
                                label: movie.director,
                              ),
                              InfoChip(
                                icon: Icons.calendar_today,
                                label: '${movie.year}',
                              ),
                              if (movie.duration > 0)
                                InfoChip(
                                  icon: Icons.schedule,
                                  label: '${movie.duration} min',
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              movie.category,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Synopsis',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            movie.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  movieProvider.toggleFavorite(movieId),
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                              ),
                              label: Text(
                                isFav
                                    ? 'Retirer des favoris'
                                    : 'Ajouter aux favoris',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFav
                                    ? theme.colorScheme.errorContainer
                                    : theme.colorScheme.primary,
                                foregroundColor: isFav
                                    ? theme.colorScheme.onErrorContainer
                                    : theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _leaveDetail(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      AppRoutes.goHome(context);
    }
  }
}
