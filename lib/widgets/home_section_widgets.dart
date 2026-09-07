import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import '../widgets/rating_stars.dart';

class QuickActionsGrid extends StatelessWidget {
  final BuildContext navigator;

  const QuickActionsGrid({super.key, required this.navigator});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.movie_outlined, 'Tous les films', 'movies'),
      (Icons.favorite_border, 'Mes favoris', 'favorites'),
      (Icons.add_circle_outline, 'Ajouter', 'add-movie'),
      (Icons.settings_outlined, 'Paramètres', 'settings'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => navigator.goNamed(action.$3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action.$1, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(action.$2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String buttonLabel;
  final VoidCallback onButtonTap;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.buttonLabel,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(onPressed: onButtonTap, child: Text(buttonLabel)),
      ],
    );
  }
}

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
        onTap: () =>
            context.goNamed('movie-detail', pathParameters: {'id': movie.id}),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.movie, size: 48),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
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
