import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/responsive_shell.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movieProvider = context.watch<MovieProvider>();
    final favorites = movieProvider.favoriteMovies;
    final crossAxisCount = ResponsiveShell.getGridCrossAxisCount(context);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text('Mes Favoris'),
          centerTitle: true,
        ),
        if (favorites.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.tertiaryContainer.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 56,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucun favori pour le moment',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ajoutez des films à vos favoris en cliquant sur le cœur pour les retrouver ici.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: () => context.goNamed('movies'),
                      icon: const Icon(Icons.movie_outlined),
                      label: const Text('Explorer les films'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.tertiaryContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: theme.colorScheme.onTertiary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${favorites.length} film${favorites.length > 1 ? 's' : ''} favori${favorites.length > 1 ? 's' : ''}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Votre sélection personnelle',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: ResponsiveShell.isTablet(context)
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2 / 3.3,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => MovieCard(
                        movie: favorites[index],
                        useGridLayout: true,
                      ),
                      childCount: favorites.length,
                    ),
                  )
                : SliverList.separated(
                    itemCount: favorites.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        MovieCard(movie: favorites[index]),
                  ),
          ),
        ],
      ],
    );
  }
}
