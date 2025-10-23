import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String title;
  final String year;
  final String imdbId;
  final String poster;

  const Movie({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] as String,
      year: json['Year'] as String,
      imdbId: json['imdbID'] as String,
      poster: json['Poster'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'Title': title, 'Year': year, 'imdbID': imdbId, 'Poster': poster};
  }

  @override
  List<Object?> get props => [title, year, imdbId, poster];
}
