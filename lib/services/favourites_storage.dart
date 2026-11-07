import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

// The list of favourite movies, shared by all screens
List<Movie> favourites = [];

const String storageKey = 'favourite_movies';

// Reads the saved favourites (called once when the app starts)
Future<void> loadFavourites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? saved = prefs.getString(storageKey);

  favourites = [];
  if (saved == null) {
    return;
  }

  List items = jsonDecode(saved);
  for (var item in items) {
    favourites.add(movieFromJson(item));
  }
}

// Saves the current favourites list
Future<void> saveFavourites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<Map<String, dynamic>> items = [];
  for (Movie movie in favourites) {
    items.add(movie.toMap());
  }

  await prefs.setString(storageKey, jsonEncode(items));
}

// Is this movie already a favourite?
bool isFavourite(int movieId) {
  for (Movie movie in favourites) {
    if (movie.id == movieId) {
      return true;
    }
  }
  return false;
}

// Adds the movie if it is not a favourite, removes it if it is
Future<void> toggleFavourite(Movie movie) async {
  if (isFavourite(movie.id)) {
    favourites.removeWhere((m) => m.id == movie.id);
  } else {
    favourites.add(movie);
  }
  await saveFavourites();
}