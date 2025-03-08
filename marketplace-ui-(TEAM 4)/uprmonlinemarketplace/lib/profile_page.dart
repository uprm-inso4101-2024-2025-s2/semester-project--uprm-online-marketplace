import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // Local state to simulate profile and listing edits
  String profileName = 'John Doe';
  String profileEmail = 'test@uprm.edu';
  String profilePicture = 'assets/profile_placeholder.png';
  String headerPhoto = 'assets/header_placeholder.png';

  List<Map<String, String>> listings = [
    {
      'name': 'Listing 1',
      'price': '\$1200',
      'image': 'assets/listing_placeholder.png',
    },
    {
      'name': 'Listing 2',
      'price': '\$1500',
      'image': 'assets/listing_placeholder.png',
    },
    {
      'name': 'Listing 3',
      'price': '\$1000',
      'image': 'assets/listing_placeholder.png',
    },
  ];

  List<Map<String, String>> rentals = [
    {
      'name': 'Rental 1',
      'price': '\$1300',
      'image': 'assets/rented_placeholder.png',
    },
    {
      'name': 'Rental 2',
      'price': '\$1700',
      'image': 'assets/rented_placeholder.png',
    },
    {
      'name': 'Rental 3',
      'price': '\$1100',
      'image': 'assets/rented_placeholder.png',
    },
  ];

  // Function to edit the profile details
  void _editProfileDetails() {
    showDialog(
      context: context,
      builder: (context) {
        String tempName = profileName;
        String tempEmail = profileEmail;
        return AlertDialog(
          title: Text('Edit Profile Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                controller: TextEditingController(text: tempName),
                onChanged: (value) {
                  tempName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: TextEditingController(text: tempEmail),
                onChanged: (value) {
                  tempEmail = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  profileName = tempName;
                  profileEmail = tempEmail;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to edit a listing
  void _editListing(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String tempName = listings[index]['name']!;
        String tempPrice = listings[index]['price']!;
        return AlertDialog(
          title: Text('Edit Listing'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Listing Name'),
                controller: TextEditingController(text: tempName),
                onChanged: (value) {
                  tempName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Price'),
                controller: TextEditingController(text: tempPrice),
                onChanged: (value) {
                  tempPrice = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  listings[index]['name'] = tempName;
                  listings[index]['price'] = tempPrice;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            context.go('/');
          },
          tooltip: 'Back to Home',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image with Edit Icon
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    image: DecorationImage(
                      image: AssetImage(headerPhoto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () {
                      // Add functionality to change the header photo
                    },
                    tooltip: 'Change Header Photo',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture with Edit Icon
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green[700],
                        backgroundImage: AssetImage(profilePicture),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () {
                            // Add functionality to change the profile picture
                          },
                          tooltip: 'Change Profile Picture',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        profileEmail,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  Spacer(),
                  // Icons for Edit Profile and Settings
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green[700]),
                    onPressed: _editProfileDetails,
                    tooltip: 'Edit Profile',
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.green[700]),
                    onPressed: () {},
                    tooltip: 'Settings',
                  ),
                ],
              ),
            ),
            Divider(),
            // Navigation Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Manage Listings Section
                  ExpansionTile(
                    leading: Icon(Icons.list, color: Colors.green[700]),
                    title: Text('Manage Listings'),
                    children: [
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: listings.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: SizedBox(
                                width:
                                    100, // Set a fixed width to prevent overflow
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      listings[index]['image']!,
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(height: 8),
                                    Text(listings[index]['name']!),
                                    Text(listings[index]['price']!),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.location_on,
                                            color: Colors.green[700],
                                          ),
                                          onPressed: () {
                                            // Simulate showing location on map
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.more_horiz,
                                            color: Colors.green[700],
                                          ),
                                          onPressed: () => _editListing(index),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Currently Rented Section
                  ExpansionTile(
                    leading: Icon(Icons.apartment, color: Colors.green[700]),
                    title: Text('Currently Rented'),
                    children: [
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: rentals.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: SizedBox(
                                width:
                                    100, // Set a fixed width to prevent overflow
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      rentals[index]['image']!,
                                      width: 80,
                                      height: 80,
                                    ),
                                    SizedBox(height: 8),
                                    Text(rentals[index]['name']!),
                                    Text(rentals[index]['price']!),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.location_on,
                                            color: Colors.green[700],
                                          ),
                                          onPressed: () {
                                            // Simulate showing location on map
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.more_horiz,
                                            color: Colors.green[700],
                                          ),
                                          onPressed: () => _editListing(index),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Messages Section
                  ListTile(
                    leading: Icon(Icons.message, color: Colors.green[700]),
                    title: Text('Messages'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Messages'),
                            content: Text('You have no messages yet'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
