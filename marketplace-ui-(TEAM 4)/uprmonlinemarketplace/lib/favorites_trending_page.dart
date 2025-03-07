import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavoritesTrendingPage extends StatefulWidget {
  const FavoritesTrendingPage({super.key});

  @override
  _FavoritesTrendingPageState createState() => _FavoritesTrendingPageState();
}

class _FavoritesTrendingPageState extends State<FavoritesTrendingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Trending Page'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),

      body: const Center(
        child: Text(
          'Favorites Trending Page - Content',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
