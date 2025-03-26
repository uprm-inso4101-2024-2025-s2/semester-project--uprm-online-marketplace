import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesRecentlyAddedPage extends StatefulWidget {
  const FavoritesRecentlyAddedPage({super.key});

  @override
  _FavoritesRecentlyAddedPageState createState() =>
      _FavoritesRecentlyAddedPageState();
}

class _FavoritesRecentlyAddedPageState
    extends State<FavoritesRecentlyAddedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Recently Added Page'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),

      body: const Center(
        child: Text(
          'Favorites Recently Added Page - Content',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
