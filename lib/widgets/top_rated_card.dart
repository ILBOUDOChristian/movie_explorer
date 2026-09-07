import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../models/movie.dart';
import 'rating_stars.dart';

class TopRatedCard extends StatelessWidget {
  final Movie movie;
  final int rank;

  const TopRatedCard({super.key, required this.movie, required this.rank});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => AppRoutes.pushMovieDetail(context, movie.id, movie: movie),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.movie, size: 48),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: CircleAvatar(radius: 18, child: Text('$rank')),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  RatingStars(
                    rating: movie.rating,
                    size: 16,
                    showValue: true,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
