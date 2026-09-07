import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../widgets/home_section_widgets.dart';
import '../widgets/movie_card.dart';
import '../widgets/responsive_shell.dart';

/// Ecran d'accueil compose de sections basees sur [CustomScrollView].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movieProvider = context.watch<MovieProvider>();
    final topMovies = movieProvider.getTopRated(limit: 5);
    final allMovies = movieProvider.allMovies;

    // Retourne une liste plate de slivers (le top-rated retourne 2 slivers).
    final slivers = <Widget>[
      _buildHeroAppBar(context, theme),
      _buildQuickActionsSliver(context),
    ];
    slivers.addAll(_buildTopRatedSlivers(context, theme, topMovies));
    slivers.add(_buildRecentSliverHeader(context, theme));
    slivers.add(_buildRecentMoviesSliver(allMovies));

    return CustomScrollView(slivers: slivers);
  }

  // =====================================================================
  // SECTION 1 : AppBar etendue (Hero)
  // =====================================================================

  /// Construit l'AppBar etendue avec son arriere-plan.
  SliverAppBar _buildHeroAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: ResponsiveShell.isTablet(context) ? 280 : 220,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(background: _buildHeroBackground(theme)),
    );
  }

  Widget _buildHeroBackground(ThemeData theme) {
    const gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE), Color(0xFFD6A2E8)],
    );

    return Container(
      decoration: const BoxDecoration(gradient: gradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBrandingRow(theme),
              const SizedBox(height: 20),
              _buildSearchField(),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildBrandingRow(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.movie, size: 32, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Movie Explorer',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Decouvrez des films exceptionnels',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construit le champ de recherche decoratif qui ouvre la liste des films.
  Widget _buildSearchField() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return SizedBox(
          height: 48,
          child: Material(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => context.goNamed('movies'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Rechercher un film, realisateur, genre...',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // =====================================================================
  // SECTION 2 : Actions rapides
  // =====================================================================

  SliverToBoxAdapter _buildQuickActionsSliver(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: QuickActionsGrid(navigator: context),
      ),
    );
  }

  // =====================================================================
  // SECTION 3 : Top 5 notes (carrousel horizontal)
  // =====================================================================

  /// Construit l'entete et le carrousel des films les mieux notes.
  List<Widget> _buildTopRatedSlivers(
    BuildContext context,
    ThemeData theme,
    List<Movie> topMovies,
  ) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
          child: SectionHeader(
            icon: Icons.star_rate_rounded,
            title: 'Top notes',
            buttonLabel: 'Voir tout',
            onButtonTap: () => context.goNamed('movies'),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 340,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: topMovies.length,
            separatorBuilder: (_, _i) => const SizedBox(width: 16),
            itemBuilder: (ctx, i) => SizedBox(
              width: 200,
              child: TopRatedCard(movie: topMovies[i], rank: i + 1),
            ),
          ),
        ),
      ),
    ];
  }

  // =====================================================================
  // SECTION 4 : Liste des films recents
  // =====================================================================

  SliverToBoxAdapter _buildRecentSliverHeader(
    BuildContext context,
    ThemeData theme,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
        child: SectionHeader(
          icon: Icons.local_movies,
          title: 'Tous les films',
          buttonLabel: 'Explorer',
          onButtonTap: () => context.goNamed('movies'),
        ),
      ),
    );
  }

  SliverPadding _buildRecentMoviesSliver(List<Movie> allMovies) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      sliver: SliverList.separated(
        itemCount: allMovies.take(5).length,
        separatorBuilder: (_, _i) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) => MovieCard(movie: allMovies[i]),
      ),
    );
  }
}
