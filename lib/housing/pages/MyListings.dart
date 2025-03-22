import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/house_tile.dart';
import 'package:semesterprojectuprmonlinemarketplace/housing/pages/favorite_listings.dart';
// Provides shared data and navigation for the main listings page.
import 'house_listing.dart';
// Provides UI components for listing creation.
import '../widgets/buttons.dart';
import 'listings_creation.dart';

/// Provides a navigation drawer for app-wide use.
/// Contains links for primary views and administrative options.
Widget buildAppDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        /// Displays a header with a central icon representing the app's home.
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
        /// Navigates to the main listings page.
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
        /// Navigates to the user's own listings page.
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
        /// Navigates to the user's favorites page.
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
        /// Displays additional navigation for administrative tasks.
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
        /// Navigates to the page showing inactive listings.
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

/// Displays the listings owned by the user.
/// For testing purposes, only listings with the title "San Juan Villa" are included.
class MyListingsPage extends StatefulWidget {
  const MyListingsPage({Key? key}) : super(key: key);

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  @override
  Widget build(BuildContext context) {
    /// Filters the shared listings to those owned by the user (test filter by title).
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
          ),
        ),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(CupertinoIcons.line_horizontal_3, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      /// Displays a horizontal scrollable view of user listings.
      body: Column(
        children: [
          SizedBox(height: 15.h),
          SizedBox(
            height: 35.h,
            width: 50.w,
            child: CreateButton(
              pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateListingPage()),
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
                    /// Toggles the active status for the listing.
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

/// Displays all listings marked as inactive.
class InactiveListingsPage extends StatefulWidget {
  const InactiveListingsPage({Key? key}) : super(key: key);

  @override
  State<InactiveListingsPage> createState() => _InactiveListingsPageState();
}

class _InactiveListingsPageState extends State<InactiveListingsPage> {
  @override
  Widget build(BuildContext context) {
    /// Filters the shared listings to only include inactive ones.
    final inactiveListings =
    globalHouses.where((house) => !(house["isActive"] ?? true)).toList();

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
      /// Displays inactive listings in a horizontal scrollable view.
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
              /// Toggles the active status for the listing.
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
