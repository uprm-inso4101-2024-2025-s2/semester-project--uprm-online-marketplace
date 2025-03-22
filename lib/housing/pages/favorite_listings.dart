import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/house_tile.dart';
// Provides access to shared house data and navigation helpers.
import 'house_listing.dart';

/// A page that displays the user's favorite house listings.
/// This widget extracts and presents listings marked as favorites.
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  /// A filtered collection of house listings marked as favorites.
  List<Map<String, dynamic>> favoriteListings = [];

  @override
  void initState() {
    super.initState();
    // Filter the global house data to retrieve only favorite listings.
    favoriteListings =
        globalHouses.where((house) => house["isFavorite"] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uses a shared navigation drawer for consistent app navigation.
      drawer: buildAppDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: const Text(
          'House Market',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        // Provides access to the drawer using a standard icon.
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              CupertinoIcons.line_horizontal_3,
              color: Colors.white,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Page header indicating the current view.
          Container(
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.all(20),
            child: const Text(
              "Favorite Listings",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
          ),
          // Displays the filtered favorites in a horizontally scrolling view.
          Expanded(
            child: favoriteListings.isEmpty
                ? const Center(child: Text("No houses found"))
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favoriteListings.length,
              itemBuilder: (context, index) {
                var house = favoriteListings[index];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: HouseTile(
                    imagePath: List<String>.from(house["imagePath"]),
                    title: house["title"],
                    price: house["price"],
                    details: house["details"],
                    isFavorite: house["isFavorite"],
                    isActive: house["isActive"] ?? true,
                    // Toggles the active state of the listing.
                    onToggleStatus: () {
                      setState(() {
                        house["isActive"] =
                        !(house["isActive"] ?? true);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
