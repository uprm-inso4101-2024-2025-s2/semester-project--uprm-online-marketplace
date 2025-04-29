import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/house_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Classes/ListingService.dart';
import '../../Classes/LodgingClass.dart';

/// ------------------------------------------
/// Shared global houses data.
/// ------------------------------------------
///


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


/// Main Listings Page (HouseList) with advanced filters.
/// Only active listings (isActive == true) are shown here.
class HouseList extends StatefulWidget {
  const HouseList({Key? key}) : super(key: key);

  @override
  HouseListState createState() => HouseListState();
}

class HouseListState extends State<HouseList> {
  List<Lodging> allListings = [];
  List<Lodging> filteredHouses = [];
  bool isLoading = true;
  bool hasError = false;

  String searchQuery = '';
  String selectedLocation = 'All';
  String bedsInput = '';
  String bathsInput = '';
  String minPriceInput = '';
  String maxPriceInput = '';
  Timer? debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    try {
      final listings = await ListingService().fetchAllListings();
      setState(() {
        allListings = listings;
        filteredHouses = listings.where((l) => l.isActive).toList();
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
    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = query;
        applyFilters();
      });
    });
  }

  void applyFilters() {
    final minP = double.tryParse(minPriceInput);
    final maxP = double.tryParse(maxPriceInput);
    setState(() {
      filteredHouses = allListings.where((l) {
        final matchesTitle = l.title.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesLoc = selectedLocation == 'All' || l.location == selectedLocation;
        final matchesPrice = (minP == null || l.price >= minP) && (maxP == null || l.price <= maxP);
        final matchesBeds = bedsInput.isEmpty || l.bedrooms == int.tryParse(bedsInput);
        final matchesBaths = bathsInput.isEmpty || l.restrooms == int.tryParse(bathsInput);
        return matchesTitle && matchesLoc && matchesPrice && matchesBeds && matchesBaths && l.isActive;
      }).toList();
    });
  }

  Widget buildAdvancedFilters() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterCard(
            icon: Icons.attach_money,
            label: 'Min',
            value: minPriceInput,
            onChanged: (v) => setState(() { minPriceInput = v; applyFilters(); }),
            width: 80.w,
          ),
          SizedBox(width: 12.w),
          _filterCard(
            icon: Icons.money_off,
            label: 'Max',
            value: maxPriceInput,
            onChanged: (v) => setState(() { maxPriceInput = v; applyFilters(); }),
            width: 80.w,
          ),
          SizedBox(width: 12.w),
          _filterCard(
            icon: Icons.king_bed,
            label: 'Beds',
            value: bedsInput,
            onChanged: (v) => setState(() { bedsInput = v; applyFilters(); }),
            width: 70.w,
          ),
          SizedBox(width: 12.w),
          _filterCard(
            icon: Icons.bathtub,
            label: 'Baths',
            value: bathsInput,
            onChanged: (v) => setState(() { bathsInput = v; applyFilters(); }),
            width: 70.w,
          ),
          SizedBox(width: 12.w),
          Container(
            width: 120.w,
            child: InputDecorator(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.place, size: 10.sp, color: Colors.black,),
                labelText: 'Location',
                contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                isDense: true,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLocation,
                  items: ['All', 'San Juan', 'Carolina', 'Downtown']
                      .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedLocation = val!;
                      applyFilters();
                    });
                  },
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterCard({
    required IconData icon,
    required String label,
    required String value,
    required void Function(String) onChanged,
    required double width,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15.sp, color: Colors.black),
          SizedBox(width: 4.w),
          Expanded(
            child: TextFormField(
              initialValue: value,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search houses...',
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              ),
            ),
            // Improved Filters
            buildAdvancedFilters(),
            // Listings
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                  ? const Center(child: Text('Failed to load listings'))
                  : filteredHouses.isEmpty
                  ? const Center(child: Text('No houses found'))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredHouses.length,
                itemBuilder: (context, i) {
                  final l = filteredHouses[i];
                  return HouseTile(
                    lodging: l,
                    onMyListing: false,
                    onToggleStatus: () {
                      setState(() {
                        l.isActive = !l.isActive;
                        FirebaseFirestore.instance
                            .collection('listings')
                            .doc(l.id.toString())
                            .update({'isActive': l.isActive});
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
