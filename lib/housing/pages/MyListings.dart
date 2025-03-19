import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/house_tile.dart';
// Import the shared data and HouseList from house_listing.dart
import 'house_listing.dart';
// Import the Listing Creation button and data.
import '../widgets/buttons.dart';
import  'listings_creation.dart';

/// Reusable Drawer widget for navigation
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
        // Home Page -> Navigate to the real HouseList page.
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home Page'),
          onTap: () {
            Navigator.pop(context);
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
      drawer: buildAppDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: const Text(
            "My Listings",
            style: TextStyle(
              color: Colors.white,
            )
        ),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(CupertinoIcons.line_horizontal_3, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
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
      drawer: buildAppDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: const Text("Inactive Listings"),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(CupertinoIcons.line_horizontal_3, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
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

/// Placeholder Favorites Page.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildAppDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: const Text("Favorites"),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(CupertinoIcons.line_horizontal_3, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: const Center(child: Text("Favorites Content")),
    );
  }
}

