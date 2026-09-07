import '../models/movie.dart';

class MovieRepository {
  static const List<Movie> movies = [
    Movie(
      id: '1',
      title: 'Inception',
      description:
          'Un voleur spécialisé dans l\'extraction de secrets grâce aux rêves reçoit une mission particulièrement difficile : implanter une idée dans l\'esprit d\'un dirigeant.',
      director: 'Christopher Nolan',
      year: 2010,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg',
      category: 'Science-fiction',
      rating: 8.8,
      duration: 148,
    ),
    Movie(
      id: '2',
      title: 'Interstellar',
      description:
          'Un groupe d\'explorateurs voyage à travers un trou de ver afin de trouver une nouvelle planète habitable pour l\'humanité.',
      director: 'Christopher Nolan',
      year: 2014,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
      category: 'Science-fiction',
      rating: 8.6,
      duration: 169,
    ),
    Movie(
      id: '3',
      title: 'The Dark Knight',
      description:
          'Batman affronte le Joker, un criminel imprévisible qui plonge Gotham City dans le chaos et teste les limites du héros.',
      director: 'Christopher Nolan',
      year: 2008,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      category: 'Action',
      rating: 9.0,
      duration: 152,
    ),
    Movie(
      id: '4',
      title: 'Avatar',
      description:
          'Un ancien marine découvre le monde extraordinaire de Pandora et doit choisir entre deux camps lors d\'un conflit épique.',
      director: 'James Cameron',
      year: 2009,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/kyeqWdyUXW608qlYkRqosgbbJyK.jpg',
      category: 'Aventure',
      rating: 7.9,
      duration: 162,
    ),
    Movie(
      id: '5',
      title: 'Titanic',
      description:
          'Une histoire d\'amour entre deux jeunes passagers de classes sociales différentes à bord du célèbre paquebot Titanic.',
      director: 'James Cameron',
      year: 1997,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg',
      category: 'Romance',
      rating: 7.9,
      duration: 194,
    ),
    Movie(
      id: '6',
      title: 'Pulp Fiction',
      description:
          'Les vies de deux tueurs à gages, d\'un boxeur, d\'un gangster et de sa femme s\'entrecroisent dans Los Angeles.',
      director: 'Quentin Tarantino',
      year: 1994,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      category: 'Drame',
      rating: 8.9,
      duration: 154,
    ),
    Movie(
      id: '7',
      title: 'Forrest Gump',
      description:
          'L\'histoire de Forrest Gump, un homme au QI inférieur à la moyenne, qui se retrouve impliqué dans les événements majeurs du XXe siècle.',
      director: 'Robert Zemeckis',
      year: 1994,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
      category: 'Drame',
      rating: 8.8,
      duration: 142,
    ),
    Movie(
      id: '8',
      title: 'Le Parrain',
      description:
          'L\'histoire de la famille Corleone, une famille mafieuse new-yorkaise, et du passage de témoin du patriarche à son fils.',
      director: 'Francis Ford Coppola',
      year: 1972,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      category: 'Drame',
      rating: 9.2,
      duration: 175,
    ),
    Movie(
      id: '9',
      title: 'Retour vers le futur',
      description:
          'Marty McFly est accidentellement envoyé en 1955 dans une machine à remonter le temps inventée par son ami Doc Brown.',
      director: 'Robert Zemeckis',
      year: 1985,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/fNOH9f1aA7XRTzl1sAOx9iF553Q.jpg',
      category: 'Science-fiction',
      rating: 8.5,
      duration: 116,
    ),
    Movie(
      id: '10',
      title: 'La La Land',
      description:
          'L\'histoire d\'amour entre un pianiste de jazz et une actrice débutante à Los Angeles, poursuivant leurs rêves.',
      director: 'Damien Chazelle',
      year: 2016,
      imageUrl:
          'https://image.tmdb.org/t/p/w500/5q3S5nsv5wMWSxqLdYpQJ5zY5Dc.jpg',
      category: 'Romance',
      rating: 8.0,
      duration: 128,
    ),
  ];

  static const List<String> categories = [
    'Tous',
    'Action',
    'Aventure',
    'Science-fiction',
    'Drame',
    'Romance',
    'Comédie',
    'Horreur',
  ];

  static List<Movie> getAll() {
    return movies;
  }

  static Movie? getById(String id) {
    for (final movie in movies) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }

  static List<Movie> search(String query) {
    if (query.trim().isEmpty) {
      return movies;
    }
    final normalizedQuery = query.toLowerCase().trim();
    return movies.where((movie) {
      return movie.title.toLowerCase().contains(normalizedQuery) ||
          movie.director.toLowerCase().contains(normalizedQuery) ||
          movie.category.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  static List<Movie> filterByCategory(String category) {
    if (category == 'Tous') {
      return movies;
    }
    return movies.where((movie) => movie.category == category).toList();
  }

  static List<Movie> getTopRated({int limit = 5}) {
    final sorted = [...movies]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(limit).toList();
  }

  static List<Movie> getByYear(int year) {
    return movies.where((movie) => movie.year == year).toList();
  }
}
