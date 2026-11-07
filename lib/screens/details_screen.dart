import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/favourites_storage.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;

  DetailsScreen(this.movie);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Movie movie = widget.movie;
    bool isFav = isFavourite(movie.id);

    Widget poster;
    String posterUrl = movie.getPosterUrl();

    if (posterUrl == '') {
      poster = Container(
        width: 200,
        height: 300,
        color: Colors.grey[300],
        child: Icon(Icons.movie, size: 60),
      );
    } else {
      poster = Image.network(
        posterUrl,
        width: 200,
        height: 300,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200,
            height: 300,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, size: 60),
          );
        },
      );
    }

    String overviewText = 'No overview available.';
    if (movie.overview != '') {
      overviewText = movie.overview;
    }

    String buttonText = 'Add to favourites';
    IconData buttonIcon = Icons.favorite_border;
    if (isFav) {
      buttonText = 'Remove from favourites';
      buttonIcon = Icons.favorite;
    }

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: poster),
            SizedBox(height: 16),
            Text(
              movie.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Release year: ${movie.getYear()}'),
            Text('Rating: ${movie.rating.toStringAsFixed(1)} / 10'),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                await toggleFavourite(movie);
                setState(() {});
              },
              icon: Icon(buttonIcon),
              label: Text(buttonText),
            ),
            SizedBox(height: 16),
            Text(
              'Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(overviewText),
          ],
        ),
      ),
    );
  }
}