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
  Timer? debounceTimer;

  // Dummy data for house listings with an added location field for filtering.
  final List<Map<String, dynamic>> allHouses = [
    {
      "imagePath": [
        'assets/images/house1.jpg',
        'assets/images/house2.jpg',
        'assets/images/house3.jpg'
      ],
      "title": "San Juan Villa",
      "price": "\$100.00",
      "details": "3 bed, 2 bath",
      "isFavorite": true,
      "location": "San Juan"
    },
    {
      "imagePath": [
        'assets/images/house1.jpg',
        'assets/images/house2.jpg',
        'assets/images/house3.jpg'
      ],
      "title": "Carolina Estate",
      "price": "\$150.00",
      "details": "4 bed, 3 bath",
      "isFavorite": false,
      "location": "Carolina"
    },
    {
      "imagePath": [
        'assets/images/house1.jpg',
        'assets/images/house2.jpg',
        'assets/images/house3.jpg'
      ],
      "title": "Downtown Apartment",
      "price": "\$120.00",
      "details": "2 bed, 1 bath",
      "isFavorite": false,
      "location": "Downtown"
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

  // Filter the house list based on the search query and selected location.
  void applyFilters() {
    filteredHouses = allHouses.where((house) {
      final titleMatch =
      house["title"].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final locationMatch =
          selectedLocation == "All" || house["location"] == selectedLocation;
      final isActive = house["isActive"] ?? true;
      return titleMatch && locationMatch && isActive;
    }).toList();
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
            size: 20, //8.sp
          ),
          onPressed: () {},
        ),
        actions:[
          CupertinoButton(
            child:Icon(
              CupertinoIcons.search,
              size: 8.sp,
              color: Colors.white,
            ),
            onPressed:(){
            }
          )
        ]
      ),
      body: Column(
        children: [
          // Search bar with a TextField that captures user input.
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          // Filtering options: Dropdown for selecting location.
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
          // Display filtered house listings in a horizontal ListView.
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
                        house["isActive"] = !(house["isActive"] ?? true);
                        applyFilters(); // refresh the UI after status change
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