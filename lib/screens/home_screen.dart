import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_api.dart';
import 'details_screen.dart';
import 'favourites_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> movies = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  String errorMessage = '';
  String searchText = '';

  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMovies();

    // When the user scrolls near the bottom, load the next page
    scrollController.addListener(() {
      bool nearBottom = scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200;
      if (nearBottom && hasMore && errorMessage == '') {
        loadMovies();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Loads one page of movies (trending, or search results if the user searched)
  Future<void> loadMovies({bool reset = false}) async {
    if (isLoading) {
      return;
    }

    if (reset) {
      movies = [];
      page = 1;
      hasMore = true;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      List<Movie> newMovies;
      if (searchText == '') {
        newMovies = await getTrendingMovies(page);
      } else {
        newMovies = await searchMovies(searchText, page);
      }

      setState(() {
        movies.addAll(newMovies);
        if (newMovies.isEmpty) {
          hasMore = false;
        } else {
          page = page + 1;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void doSearch(String text) {
    searchText = text.trim();
    loadMovies(reset: true);
  }

  void clearSearch() {
    searchController.clear();
    doSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Discovery'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            tooltip: 'My favourites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavouritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: doSearch,
              decoration: InputDecoration(
                hintText: 'Search movies by title',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: buildBody()),
        ],
      ),
    );
  }

  // Decides what to show: spinner, error, empty message or the list
  Widget buildBody() {
    // First load is running
    if (movies.isEmpty && isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // First load failed
    if (movies.isEmpty && errorMessage != '') {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(errorMessage, textAlign: TextAlign.center),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  loadMovies(reset: true);
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Nothing found
    if (movies.isEmpty) {
      return Center(child: Text('No movies found'));
    }

    // The list of movies, with one extra row at the end for the footer
    return ListView.builder(
      controller: scrollController,
      itemCount: movies.length + 1,
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return buildListFooter();
        }
        return buildMovieCard(movies[index]);
      },
    );
  }

  // The row below the last movie
  Widget buildListFooter() {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != '') {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(errorMessage, textAlign: TextAlign.center),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                loadMovies();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!hasMore) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('No more results')),
      );
    }

    return SizedBox(height: 16);
  }

  // One movie in the list
  Widget buildMovieCard(Movie movie) {
    Widget poster;
    String posterUrl = movie.getPosterUrl();

    if (posterUrl == '') {
      poster = Container(
        width: 70,
        height: 105,
        color: Colors.grey[300],
        child: Icon(Icons.movie),
      );
    } else {
      poster = Image.network(
        posterUrl,
        width: 70,
        height: 105,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 70,
            height: 105,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image),
          );
        },
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsScreen(movie)),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              poster,
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${movie.getYear()}   Rating: ${movie.rating.toStringAsFixed(1)}',
                    ),
                    SizedBox(height: 6),
                    Text(
                      movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}