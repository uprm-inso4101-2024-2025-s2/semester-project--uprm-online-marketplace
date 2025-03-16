import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/house_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HouseList extends StatefulWidget {
  const HouseList({super.key});

  @override
  HouseListState createState() => HouseListState();
}

class HouseListState extends State<HouseList> {
  String searchQuery = "";
  String selectedLocation = "All";
  String bedsInput = "";      // Input field for number of beds.
  String bathsInput = "";     // Input field for number of bathrooms.
  String minPriceInput = "";  // Input field for minimum price.
  String maxPriceInput = "";  // Input field for maximum price.
  Timer? debounceTimer;

  // Dummy data for house listings with fields for beds and baths.
  final List<Map<String, dynamic>> allHouses = [
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

  List<Map<String, dynamic>> filteredHouses = [];

  @override
  void initState() {
    super.initState();
    // Initially, all houses are shown.
    filteredHouses = List.from(allHouses);
  }

  // Debounced search: update filters 300ms after the user stops typing.
  void onSearchChanged(String query) {
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
        applyFilters();
      });
    });
  }

  // Apply all filters including search query, location, price range, beds, and bathrooms.
  void applyFilters() {
    setState(() {
      // Parse the price range inputs.
      double? minPrice = double.tryParse(minPriceInput);
      double? maxPrice = double.tryParse(maxPriceInput);

      filteredHouses = allHouses.where((house) {
        final titleMatch = house["title"]
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        final locationMatch =
            selectedLocation == "All" || house["location"] == selectedLocation;
        final isActive = house["isActive"] ?? true;
        final double housePrice = house["priceValue"];
        final priceMatch = (minPrice == null || housePrice >= minPrice) &&
            (maxPrice == null || housePrice <= maxPrice);

        bool bedsMatch = true;
        if (bedsInput.isNotEmpty) {
          int? desiredBeds = int.tryParse(bedsInput);
          bedsMatch = desiredBeds != null && house["beds"] == desiredBeds;
        }

        bool bathsMatch = true;
        if (bathsInput.isNotEmpty) {
          int? desiredBaths = int.tryParse(bathsInput);
          bathsMatch = desiredBaths != null && house["baths"] == desiredBaths;
        }

        return titleMatch &&
            locationMatch &&
            isActive &&
            priceMatch &&
            bedsMatch &&
            bathsMatch;
      }).toList();
    });
  }

  // Builds the advanced filters UI.
  Widget buildAdvancedFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price Range UI using two input fields.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Price Range (\$)"),
              Row(
                children: [
                  // Minimum Price input.
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
                  // Maximum Price input.
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
        // Beds Filter as an input field.
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
        // Bathrooms Filter as an input field.
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
          onPressed: () {},
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
      body: Column(
        children: [
          // Search Bar.
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
          // Advanced Filters: Price, Beds, and Bathrooms.
          buildAdvancedFilters(),
          // Location Filter.
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
          // Display Filtered Listings in a horizontal ListView.
          Expanded(
            child: filteredHouses.isEmpty
                ? const Center(child: Text("No houses found"))
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
                        house["isActive"] =
                        !(house["isActive"] ?? true);
                        applyFilters(); // Refresh UI after status change.
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
