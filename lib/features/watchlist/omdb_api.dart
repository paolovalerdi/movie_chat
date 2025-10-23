import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_chat/features/watchlist/models/movie.dart';

class OMDBApi {
  static const String _baseUrl = 'https://www.omdbapi.com/';
  static final String _apiKey = dotenv.get("OMDB_API_KEY", fallback: "");

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final uri = Uri.parse('$_baseUrl?s=$query&apikey=$_apiKey');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['Response'] == 'True' && data['Search'] != null) {
          final List<dynamic> searchResults = data['Search'];
          return searchResults
              .map((movieJson) => Movie.fromJson(movieJson))
              .toList();
        }
      }

      return [];
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }
}
