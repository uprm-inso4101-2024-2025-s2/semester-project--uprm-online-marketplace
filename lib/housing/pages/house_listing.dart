import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/house_tile.dart';
import 'MyListings.dart'; // Provides MyListingsPage, InactiveListingsPage, and FavoritesPage
import 'package:semesterprojectuprmonlinemarketplace/housing/pages/favorite_listings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Global dataset representing house information.
/// This data can be extended or replaced without modifying dependent logic.
List<Map<String, dynamic>> globalHouses = [
  {
    "imagePath": [
      'assets/images/house1.jpg',
      'assets/images/house2.jpg',
      'assets/images/house3.jpg'
    ],
    "title": "San Juan Villa",
    "price": "\$100.00",
    "priceValue": 100.0,
    "details": "3 bed, 2 bath",
    "isFavorite": true,
    "location": "San Juan",
    "beds": 3,
    "baths": 2,
    "isActive": true,
  },
  {
    "imagePath": [
      'assets/images/house1.jpg',
      'assets/images/house2.jpg',
      'assets/images/house3.jpg'
    ],
    "title": "Carolina Estate",
    "price": "\$150.00",
    "priceValue": 150.0,
    "details": "4 bed, 3 bath",
    "isFavorite": false,
    "location": "Carolina",
    "beds": 4,
    "baths": 3,
    "isActive": true,
  },
  {
    "imagePath": [
      'assets/images/house1.jpg',
      'assets/images/house2.jpg',
      'assets/images/house3.jpg'
    ],
    "title": "Downtown Apartment",
    "price": "\$120.00",
    "priceValue": 120.0,
    "details": "2 bed, 1 bath",
    "isFavorite": false,
    "location": "Downtown",
    "beds": 2,
    "baths": 1,
    "isActive": true,
  },
];

/// Constructs a navigation drawer widget with primary and administrative navigation options.
/// The structure is designed to allow additional sections or items to be added later without modification.
Widget buildAppDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header section featuring a centered house icon.
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Color(0xFF47804B),
          ),
          child: Center(
            child: Icon(
              Icons.house,
              size: 48.sp,
              color: Colors.white,
            ),
          ),
        ),
        // Navigation item: Home Page returns to the main listings view.
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home Page'),
          onTap: () {
            Navigator.pop(context); // Close the drawer.
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HouseList()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
        // Navigation item: My Listings.
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('My Listings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyListingsPage()),
            );
          },
        ),
        // Navigation item: Favorites.
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Favorites'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            );
          },
        ),
        const Divider(),
        // Section header for administrative navigation.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Admin Options",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        // Navigation item: Inactive Listings (administrative function).
        ListTile(
          leading: const Icon(Icons.visibility_off),
          title: const Text('Inactive Listings'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const InactiveListingsPage()),
            );
          },
        ),
      ],
    ),
  );
}

/// Main page for displaying house listings with built-in filtering options.
/// Only active listings are shown by default, and additional filters can be applied.
class HouseList extends StatefulWidget {
  const HouseList({super.key});

  @override
  HouseListState createState() => HouseListState();
}

class HouseListState extends State<HouseList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String searchQuery = "";
  String selectedLocation = "All";
  String bedsInput = "";
  String bathsInput = "";
  String minPriceInput = "";
  String maxPriceInput = "";
  Timer? debounceTimer;

  // Flags to manage loading state and error handling.
  bool isLoading = true;
  bool hasError = false;

  /// Holds the filtered list of houses based on user-defined criteria.
  List<Map<String, dynamic>> filteredHouses = [];

  @override
  void initState() {
    super.initState();
    // Retrieve the initial set of active listings.
    _fetchListings();
  }

  /// Retrieves the house listings.
  /// In this demonstration, a simulated delay represents a network call.
  /// Replace with a real Firestore or API call in production.
  Future<void> _fetchListings() async {
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulated network delay

      // Retrieve listings from an external source, if available.
      setState(() {
        filteredHouses =
            globalHouses.where((house) => house["isActive"] == true).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  /// Debounces search input and applies filtering criteria.
  void onSearchChanged(String query) {
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
        applyFilters();
      });
    });
  }

  /// Applies filtering criteria on the global house data.
  /// Ensures that only active listings are shown and refines the list based on price, beds, baths, and location.
  void applyFilters() {
    setState(() {
      double? minPrice = double.tryParse(minPriceInput);
      double? maxPrice = double.tryParse(maxPriceInput);

      filteredHouses = globalHouses.where((house) {
        final titleMatch = house["title"]
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final locationMatch = (selectedLocation == "All" ||
            house["location"] == selectedLocation);
        final isActive = house["isActive"] ?? true;
        final double housePrice = house["priceValue"];
        final priceMatch = (minPrice == null || housePrice >= minPrice) &&
            (maxPrice == null || housePrice <= maxPrice);

        bool bedsMatch = true;
        if (bedsInput.isNotEmpty) {
          int? desiredBeds = int.tryParse(bedsInput);
          bedsMatch = (desiredBeds != null && house["beds"] == desiredBeds);
        }

        bool bathsMatch = true;
        if (bathsInput.isNotEmpty) {
          int? desiredBaths = int.tryParse(bathsInput);
          bathsMatch = (desiredBaths != null && house["baths"] == desiredBaths);
        }

        return titleMatch && locationMatch && isActive && priceMatch && bedsMatch && bathsMatch;
      }).toList();
    });
  }

  /// Builds the UI for advanced filtering options including price, beds, and bathrooms.
  Widget buildAdvancedFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section for price range filtering.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Price Range (\$)"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Min Price",
                        hintText: "e.g. 50",
                      ),
                      onChanged: (value) {
                        setState(() {
                          minPriceInput = value;
                          applyFilters();
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Max Price",
                        hintText: "e.g. 200",
                      ),
                      onChanged: (value) {
                        setState(() {
                          maxPriceInput = value;
                          applyFilters();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Section for filtering by number of beds.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Beds:"),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter number of beds",
                ),
                onChanged: (value) {
                  setState(() {
                    bedsInput = value;
                    applyFilters();
                  });
                },
              ),
            ],
          ),
        ),
        // Section for filtering by number of bathrooms.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Bathrooms:"),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter number of bathrooms",
                ),
                onChanged: (value) {
                  setState(() {
                    bathsInput = value;
                    applyFilters();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: const Text(
          'House Market',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: CupertinoButton(
          child: const Icon(
            CupertinoIcons.line_horizontal_3,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          CupertinoButton(
            child: Icon(
              CupertinoIcons.search,
              size: 8.sp,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      drawer: buildAppDrawer(context),
      body: Column(
        children: [
          // Search bar for dynamic filtering of listings.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search houses...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Advanced filter options.
          buildAdvancedFilters(),
          // Dropdown for location-based filtering.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Text("Location: "),
                DropdownButton<String>(
                  value: selectedLocation,
                  items: <String>["All", "San Juan", "Carolina", "Downtown"]
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedLocation = newValue!;
                      applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),
          // Displays the list of houses that match current filters.
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : hasError
                ? Center(child: Text("Failed to load listings"))
                : filteredHouses.isEmpty
                ? Center(child: Text("No houses found"))
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredHouses.length,
              itemBuilder: (context, index) {
                var house = filteredHouses[index];
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
                        applyFilters();
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
