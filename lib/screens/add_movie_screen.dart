import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movie_provider.dart';
import '../data/movie_repository.dart';
import '../widgets/movie_form_header.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});
  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _directorController = TextEditingController();
  final _yearController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedCategory = 'Science-fiction';
  double _rating = 5.0;
  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movieProvider = context.read<MovieProvider>();
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text('Ajouter un film'),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MovieFormHeader(),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre du film *',
                      prefixIcon: Icon(Icons.title),
                      hintText: 'Ex: Le Seigneur des Anneaux',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le titre est obligatoire';
                      }
                      if (value.trim().length < 2) {
                        return 'Le titre doit contenir au moins 2 caractères';
                      }
                      if (value.trim().length > 100) {
                        return 'Le titre est trop long (max 100 car.)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _directorController,
                    decoration: const InputDecoration(
                      labelText: 'Réalisateur *',
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Ex: Peter Jackson',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le réalisateur est obligatoire';
                      }
                      if (value.trim().length < 2) {
                        return 'Nom de réalisateur trop court';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Année de sortie *',
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'Ex: 2001',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'L\'année est obligatoire';
                      }
                      final year = int.tryParse(value.trim());
                      if (year == null) {
                        return 'Entrez une année valide';
                      }
                      final now = DateTime.now().year;
                      if (year < 1888) {
                        return 'Année trop ancienne (1888 mini)';
                      }
                      if (year > now) {
                        return 'Année non valide (max $now)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Catégorie *',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: MovieRepository.categories
                        .where((c) => c != 'Tous')
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Sélectionnez une catégorie';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Note : ${_rating.toStringAsFixed(1)} / 10',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _rating,
                    min: 0,
                    max: 10,
                    divisions: 20,
                    label: _rating.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      hintText: 'Résumé du film...',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL de l\'image',
                      prefixIcon: Icon(Icons.image),
                      hintText: 'https://...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Durée (minutes)',
                      prefixIcon: Icon(Icons.schedule),
                      hintText: 'Ex: 142',
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final id = DateTime.now().millisecondsSinceEpoch
                              .toString();
                          final movie = Movie(
                            id: id,
                            title: _titleController.text.trim(),
                            description:
                                _descriptionController.text.trim().isEmpty
                                ? 'Aucune description fournie.'
                                : _descriptionController.text.trim(),
                            director: _directorController.text.trim(),
                            year: int.parse(_yearController.text.trim()),
                            imageUrl: _imageUrlController.text.trim().isEmpty
                                ? 'https://via.placeholder.com/300x450'
                                : _imageUrlController.text.trim(),
                            category: _selectedCategory,
                            rating: _rating,
                            duration:
                                int.tryParse(_durationController.text.trim()) ??
                                0,
                          );
                          movieProvider.addMovie(movie);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${movie.title} ajouté avec succès !',
                              ),
                              backgroundColor: theme.colorScheme.primary,
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'Voir',
                                textColor: Colors.white,
                                onPressed: () => context.pushNamed(
                                  'movie-detail',
                                  pathParameters: {'id': movie.id},
                                ),
                              ),
                            ),
                          );
                          _formKey.currentState!.reset();
                          _titleController.clear();
                          _directorController.clear();
                          _yearController.clear();
                          _descriptionController.clear();
                          _imageUrlController.clear();
                          _durationController.clear();
                          setState(() {
                            _selectedCategory = 'Science-fiction';
                            _rating = 5.0;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Veuillez corriger les erreurs du formulaire.',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Enregistrer le film'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
