import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app/app_routes.dart';
import '../data/movie_repository.dart';
import '../providers/movie_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/movie_card.dart';
import '../widgets/responsive_shell.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late TextEditingController _searchController;
  bool _isGridView = true;
  String? _appliedRouteQuery;
  String? _appliedRouteCategory;

  @override
  void initState() {
    super.initState();
    final provider = context.read<MovieProvider>();
    _searchController = TextEditingController(text: provider.searchQuery);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final params = GoRouterState.of(context).uri.queryParameters;
    final query = params[AppRoutes.searchQuery];
    final category = params[AppRoutes.categoryQuery];

    if (query != null && query != _appliedRouteQuery) {
      _appliedRouteQuery = query;
      _searchController.text = query;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<MovieProvider>().updateSearchQuery(query);
      });
    }

    if (category != null && category != _appliedRouteCategory) {
      _appliedRouteCategory = category;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<MovieProvider>().updateCategory(category);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movieProvider = context.watch<MovieProvider>();
    final filtered = movieProvider.filteredMovies;
    final crossAxisCount = ResponsiveShell.getGridCrossAxisCount(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          title: const Text('Tous les films'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
              tooltip: _isGridView ? 'Vue liste' : 'Vue grille',
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(136),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                movieProvider.updateSearchQuery('');
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      movieProvider.updateSearchQuery(value);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieProvider.categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = movieProvider.categories[index];
                        return CategoryChip(
                          label: cat,
                          isSelected: movieProvider.selectedCategory == cat,
                          onTap: () => movieProvider.updateCategory(cat),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '${filtered.length} film${filtered.length > 1 ? 's' : ''} trouvé${filtered.length > 1 ? 's' : ''}',
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                if (movieProvider.searchQuery.isNotEmpty ||
                    movieProvider.selectedCategory !=
                        MovieRepository.allCategoryLabel)
                  TextButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      movieProvider.updateSearchQuery('');
                      movieProvider.updateCategory(
                        MovieRepository.allCategoryLabel,
                      );
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Réinitialiser'),
                  ),
              ],
            ),
          ),
        ),
        if (filtered.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: const EmptyStateView(
              icon: Icons.movie_creation_outlined,
              title: 'Aucun film trouvé',
              message: 'Essayez de modifier vos critères de recherche',
            ),
          )
        else if (_isGridView)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2 / 3.3,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return MovieCard(movie: filtered[index], useGridLayout: true);
              }, childCount: filtered.length),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList.separated(
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return MovieCard(movie: filtered[index]);
              },
            ),
          ),
      ],
    );
  }

}
