import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movie_provider.dart';
import 'rating_stars.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool useGridLayout;

  const MovieCard({super.key, required this.movie, this.useGridLayout = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFavorite = context.watch<MovieProvider>().isFavorite(movie.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            context.goNamed('movie-detail', pathParameters: {'id': movie.id}),
        child: useGridLayout
            ? _buildGridCard(context, theme, isFavorite)
            : _buildListCard(context, theme, isFavorite),
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    ThemeData theme,
    bool isFavorite,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildPoster(theme, isFavorite)),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: _buildDetails(theme),
        ),
      ],
    );
  }

  Widget _buildListCard(
    BuildContext context,
    ThemeData theme,
    bool isFavorite,
  ) {
    return SizedBox(
      height: 150,
      child: Row(
        children: [
          SizedBox(width: 100, child: _buildPoster(theme, isFavorite)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: _buildDetails(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoster(ThemeData theme, bool isFavorite) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          movie.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.movie,
              size: 42,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Consumer<MovieProvider>(
            builder: (context, provider, _) => Material(
              color: theme.colorScheme.surface.withValues(alpha: 0.85),
              shape: const CircleBorder(),
              child: IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                color: isFavorite ? theme.colorScheme.error : null,
                onPressed: () => provider.toggleFavorite(movie.id),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          movie.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${movie.year}  |  ${movie.category}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        RatingStars(rating: movie.rating, size: 16, showValue: true),
      ],
    );
  }
}
