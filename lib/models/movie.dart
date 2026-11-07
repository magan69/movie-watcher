// One movie, with the information we show on screen
class Movie {
  int id;
  String title;
  String overview;
  String posterPath;
  String releaseDate;
  double rating;

  Movie(this.id, this.title, this.overview, this.posterPath, this.releaseDate,
      this.rating);

  // Full link of the poster image (empty if the movie has no poster)
  String getPosterUrl() {
    if (posterPath == '') {
      return '';
    }
    return 'https://image.tmdb.org/t/p/w342' + posterPath;
  }

  // Release year, for example 2024
  String getYear() {
    if (releaseDate.length >= 4) {
      return releaseDate.substring(0, 4);
    }
    return '';
  }

  // Turns the movie into a map, so we can save it in favourites
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': rating,
    };
  }
}

// Turns one movie from the API (JSON) into a Movie object
Movie movieFromJson(Map<String, dynamic> json) {
  int id = json['id'];

  String title = 'No title';
  if (json['title'] != null) {
    title = json['title'];
  }

  String overview = '';
  if (json['overview'] != null) {
    overview = json['overview'];
  }

  String posterPath = '';
  if (json['poster_path'] != null) {
    posterPath = json['poster_path'];
  }

  String releaseDate = '';
  if (json['release_date'] != null) {
    releaseDate = json['release_date'];
  }

  double rating = 0;
  if (json['vote_average'] != null) {
    rating = json['vote_average'].toDouble();
  }

  return Movie(id, title, overview, posterPath, releaseDate, rating);
}