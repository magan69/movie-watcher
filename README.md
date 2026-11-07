# Movie Discovery App

A Flutter app for DevCamp 2.0 (Week 3, Project 3). It shows trending movies from TMDB. You can search movies, open details, scroll to load more, and save favourites.

## How to run

1. Get a free API key from https://www.themoviedb.org (Settings, then API).
2. Copy `lib/config.example.dart` to `lib/config.dart` and put your key in it:
   ```dart
   const String tmdbApiKey = 'YOUR_KEY_HERE';
   ```
3. Run:
   ```
   flutter pub get
   flutter run -d chrome --web-port 5000
   ```

Screenshots are in the `screenshots` folder.

Demo video:(https://drive.google.com/file/d/1PhoXXjaPcEJhiEYLg5Xp7UBDR6hn2Nly/view?usp=sharing)

This product uses the TMDB API but is not endorsed or certified by TMDB.