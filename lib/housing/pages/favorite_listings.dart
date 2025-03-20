import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/house_tile.dart';
// Import the shared data and HouseList from house_listing.dart
import 'house_listing.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  List<Map<String, dynamic>> favoriteListings = [];

  @override
  void initState() {
    super.initState();
    favoriteListings = globalHouses.where((house) => house["isFavorite"] == true).toList();
  }
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      drawer: buildAppDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: const Text(
          'House Market',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(CupertinoIcons.line_horizontal_3, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Column(
        children: [
          // Heading text.
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.all(20),
            child: const Text(
              "Favorite Listings",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            )
          ),
          // Display filtered house listings in a horizontal ListView.
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
                    onToggleStatus: () {
                      setState(() {
                        house["isActive"] = !(house["isActive"] ?? true);
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