import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/house_tile.dart';

// Import the shared data and HouseList from house_listing.dart
import 'house_listing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Classes/ListingService.dart';
import '../../Classes/LodgingClass.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Lodging> favoriteListings = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteListings();
  }

  @override
  Future<void> fetchFavoriteListings() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('listings')
            .where('isFavorite', isEqualTo: true)
            .get();

    List<Lodging> fetchedListings =
        snapshot.docs.map((doc) {
          Map<String, dynamic> data =
              doc.data() as Map<String, dynamic>;
          return Lodging.fromFirestore(data);
        }).toList();

    // print(fetchedListings);
    // return fetchedListings;
    setState(() {
      favoriteListings = fetchedListings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Heading text.
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.all(20),
            child: const Text(
              "Favorite Listings",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Display filtered house listings in a horizontal ListView.
          Expanded(
            child:
                favoriteListings.isEmpty
                    ? const Center(child: Text("No houses found"))
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: favoriteListings.length,
                      // itemBuilder: (context, index) {
                      //   final lodging = favoriteListings[index];
                      //   return SingleChildScrollView(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: HouseTile(
                      //       imagePath: house.imageUrls,
                      //       title: house.title,
                      //       price: house.price.toString(),
                      //       details: house.description,
                      //       isFavorite: house.isFavorite,
                      //       isActive: house.isActive,
                      //       onToggleStatus: () {
                      //         setState(() {
                      //           house.isActive = !house.isActive;
                      //         });
                      //       },
                      //     ),
                      //   );
                      // },
                      itemBuilder: (context, index) {
                        final lodging = favoriteListings[index];
                        return HouseTile(
                          lodging: lodging,
                          onToggleStatus: () {
                            setState(() {
                              lodging.isActive =
                                  !lodging.isActive;
                              FirebaseFirestore.instance
                                  .collection('listings')
                                  .doc(lodging.id.toString())
                                  .update({
                                    'isActive': lodging.isActive,
                                  });
                            });
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
