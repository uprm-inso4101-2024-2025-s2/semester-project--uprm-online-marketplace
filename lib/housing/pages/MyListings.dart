import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/house_tile.dart';
import 'package:semesterprojectuprmonlinemarketplace/housing/pages/favorite_listings.dart';
// Import the shared data and HouseList from house_listing.dart
import 'house_listing.dart';
// Import the Listing Creation button and data.
import '../widgets/buttons.dart';
import  'listings_creation.dart';


/// My Listings Page: displays user-owned listings (active or inactive)
class MyListingsPage extends StatefulWidget {
  const MyListingsPage({Key? key}) : super(key: key);

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  @override
  Widget build(BuildContext context) {
    // Use the shared globalHouses from house_listing.dart.
    // For testing, assume only "San Juan Villa" belongs to the user.
    final userListings =
    globalHouses.where((house) => house["title"] == "San Juan Villa").toList();

    return Scaffold(

      // Change the ListView to horizontal.
      body: Column(
          children:[
            SizedBox(height: 15.h),
            SizedBox(
              height: 35.h,
              width: 50.w,
              child: CreateButton(
                  pressed:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>const CreateListingPage()),
                    );
                  },
              ),
            ),
            userListings.isEmpty
              ? const Center(child: Text("No listings found"))
              : Expanded(
              child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8.0),
              itemCount: userListings.length,
              itemBuilder: (context, index) {
                final house = userListings[index];
                return Padding(
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
                        // Toggling modifies the shared globalHouses.
                        house["isActive"] = !(house["isActive"] ?? true);
                      });
                    },
                  ),
                );
              },
            ),
          )
        ] // children
      )
    );
  }
}

/// Inactive Listings Page: displays all inactive listings.
class InactiveListingsPage extends StatefulWidget {
  const InactiveListingsPage({Key? key}) : super(key: key);

  @override
  State<InactiveListingsPage> createState() => _InactiveListingsPageState();
}

class _InactiveListingsPageState extends State<InactiveListingsPage> {
  @override
  Widget build(BuildContext context) {
    final inactiveListings = globalHouses.where((house) => !(house["isActive"] ?? true)).toList();

    return Scaffold(
      body: inactiveListings.isEmpty
          ? const Center(child: Text("No inactive listings"))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8.0),
        itemCount: inactiveListings.length,
        itemBuilder: (context, index) {
          final house = inactiveListings[index];
          return Padding(
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
    );
  }
}
