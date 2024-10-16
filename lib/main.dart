import 'package:flutter/material.dart';
import 'package:openstreetmap/screens/search_screen.dart';
import 'package:openstreetmap/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maps',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        SearchScreen.routeName: (context) => const SearchScreen(),
      },
    );
  }
}
