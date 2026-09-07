class Movie {
  final String id;
  final String title;
  final String description;
  final String director;
  final int year;
  final String imageUrl;
  final String category;
  final double rating;
  final int duration;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.director,
    required this.year,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.duration = 0,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? director,
    int? year,
    String? imageUrl,
    String? category,
    double? rating,
    int? duration,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      director: director ?? this.director,
      year: year ?? this.year,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      duration: duration ?? this.duration,
    );
  }
}
