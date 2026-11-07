import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/movie.dart';

const String baseUrl = 'https://api.themoviedb.org/3';

// Gets one page of trending movies
Future<List<Movie>> getTrendingMovies(int page) async {
  String url = '$baseUrl/trending/movie/week?api_key=$tmdbApiKey&page=$page';
  return fetchMovies(url);
}

// Gets one page of search results for a title
Future<List<Movie>> searchMovies(String query, int page) async {
  String text = Uri.encodeComponent(query);
  String url =
      '$baseUrl/search/movie?api_key=$tmdbApiKey&query=$text&page=$page';
  return fetchMovies(url);
}

// Calls the API and turns the answer into a list of Movie objects
Future<List<Movie>> fetchMovies(String url) async {
  http.Response response;

  try {
    response = await http.get(Uri.parse(url));
  } catch (e) {
    throw Exception('No internet connection. Please try again.');
  }

  if (response.statusCode == 401) {
    throw Exception('Invalid API key. Check lib/config.dart');
  }
  if (response.statusCode != 200) {
    throw Exception('Server error (${response.statusCode}). Please try again.');
  }

  Map<String, dynamic> data = jsonDecode(response.body);
  List results = data['results'];

  List<Movie> movies = [];
  for (var item in results) {
    movies.add(movieFromJson(item));
  }
  return movies;
}