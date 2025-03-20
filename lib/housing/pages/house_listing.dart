import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/house_tile.dart';
import 'MyListings.dart'; // Provides MyListingsPage, InactiveListingsPage, and FavoritesPage
import 'package:semesterprojectuprmonlinemarketplace/housing/pages/favorite_listings.dart';

/// ------------------------------------------
/// Shared global houses data.
/// ------------------------------------------
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

/// Reusable Drawer widget with Admin Options.
Widget buildAppDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // Drawer header with a centered house icon.
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
        // Home Page: Navigates back to the main listings page.
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
        // My Listings
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
        // Favorites
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
        // Admin Options sub-section.
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
        // Inactive Listings under Admin Options.
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

/// Main Listings Page (HouseList) with advanced filters.
/// Only active listings (isActive == true) are shown here.
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

  // Add a loading state
  bool isLoading = true;
  bool hasError = false;

  /// Filtered houses (only active listings).
  List<Map<String, dynamic>> filteredHouses = [];

  @override
  void initState() {
    super.initState();
    // Initially, show only active houses.
    _fetchListings();
  }

  // Simulate fetching listings from Firestore
  Future<void> _fetchListings() async {
    try {
      // Simulate a network call delay
      await Future.delayed(Duration(seconds: 2)); // Remove this in production

      // Fetch listings from Firestore or any other source
      // Example:
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('listings').get();
      // List<Map<String, dynamic>> listings = querySnapshot.docs.map((doc) => doc.data()).toList();

      // For now, use the globalHouses as a placeholder
      setState(() {
        filteredHouses = globalHouses.where((house) => house["isActive"] == true).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void onSearchChanged(String query) {
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
        applyFilters();
      });
    });
  }

  /// Filtering now requires each house to be active.
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
        // Only show active houses on the main listing.
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

  Widget buildAdvancedFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price Range UI with two text fields.
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
        // Beds Filter
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
        // Bathrooms Filter
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
          // Search Bar
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
          // Advanced Filters
          buildAdvancedFilters(),
          // Location Filter
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
          // Horizontal List of Filtered Houses.
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : hasError
                ? Center(child: Text("Failed to load listings")) // Show error message
                : filteredHouses.isEmpty
                ? Center(child: Text("No houses found")) // Show no listings message
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
