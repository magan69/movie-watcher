import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/favourites_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadFavourites();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Discovery',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: HomeScreen(),
    );
  }
}