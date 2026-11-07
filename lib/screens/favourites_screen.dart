import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/favourites_storage.dart';
import 'details_screen.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Favourites')),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (favourites.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No favourites yet. Open a movie and tap "Add to favourites".',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: favourites.length,
      itemBuilder: (context, index) {
        return buildFavouriteRow(favourites[index]);
      },
    );
  }

  Widget buildFavouriteRow(Movie movie) {
    Widget poster;
    String posterUrl = movie.getPosterUrl();

    if (posterUrl == '') {
      poster = Icon(Icons.movie, size: 40);
    } else {
      poster = Image.network(
        posterUrl,
        width: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image, size: 40);
        },
      );
    }

    return ListTile(
      leading: poster,
      title: Text(movie.title),
      subtitle: Text('${movie.getYear()}   Rating: ${movie.rating.toStringAsFixed(1)}'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        tooltip: 'Remove from favourites',
        onPressed: () async {
          await toggleFavourite(movie);
          setState(() {});
        },
      ),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(movie)),
        );
        setState(() {});
      },
    );
  }
}