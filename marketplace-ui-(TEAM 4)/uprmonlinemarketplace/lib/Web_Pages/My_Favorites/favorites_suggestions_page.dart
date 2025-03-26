import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesSuggestionsPage extends StatefulWidget {
  const FavoritesSuggestionsPage({super.key});

  @override
  _FavoritesSuggestionsPageState createState() =>
      _FavoritesSuggestionsPageState();
}

class _FavoritesSuggestionsPageState extends State<FavoritesSuggestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Suggestions Page'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),

      body: const Center(
        child: Text(
          'Favorites Suggestions Page - Content',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
