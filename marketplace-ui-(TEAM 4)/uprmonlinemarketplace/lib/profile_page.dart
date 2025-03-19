import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String profileName = 'John Doe';
  String profileEmail = 'test@uprm.edu';
  String profilePicture = ''; // Set to empty string to test silhouette
  String headerPhoto = 'assets/header_placeholder.png';

  bool messagesNotificationEnabled = false; // State for notification toggle
  bool isDarkTheme = false; // State for theme toggle

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

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Settings'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _settingsOption(
                      Icons.lock,
                      'Change Password',
                      _changePasswordDialog,
                    ),
                    SwitchListTile(
                      title: Text('Message Notifications'),
                      value: messagesNotificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          messagesNotificationEnabled = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Dark Theme'),
                      value: isDarkTheme,
                      onChanged: (value) {
                        setState(() {
                          isDarkTheme = value;
                          // Here you can implement the logic to change the app theme
                        });
                      },
                    ),
                    _settingsOption(
                      Icons.exit_to_app,
                      'Log Out',
                      _confirmLogout,
                    ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  ListTile _settingsOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(text), onTap: onTap);
  }

  void _changePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String oldPassword = '';
        String newPassword = '';
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _editableField(
                'Old Password',
                oldPassword,
                (value) => oldPassword = value,
              ),
              _editableField(
                'New Password',
                newPassword,
                (value) => newPassword = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle password change logic here
                Navigator.pop(context);
              },
              child: Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Log Out'),
            content: Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Handle logout logic here
                  Navigator.pop(context);
                  context.go('/'); // Redirect to homepage
                },
                child: Text('Yes'),
              ),
            ],
          ),
    );
  }

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
              _editableField('Name', tempName, (value) => tempName = value),
              _editableField('Email', tempEmail, (value) => tempEmail = value),
            ],
          ),
          actions: _dialogActions(() {
            setState(() {
              profileName = tempName;
              profileEmail = tempEmail;
            });
          }),
        );
      },
    );
  }

  Widget _editableField(
    String label,
    String initialValue,
    Function(String) onChanged,
  ) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: TextEditingController(text: initialValue),
      onChanged: onChanged,
    );
  }

  List<Widget> _dialogActions(VoidCallback onSave) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          onSave();
          Navigator.pop(context);
        },
        child: Text('Save'),
      ),
    ];
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
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileHeader(),
            _section('Manage Listings', listings),
            _section('Currently Rented', rentals),
            ListTile(
              leading: Icon(Icons.message, color: Colors.green[700]),
              title: Text('Messages'),
              onTap: () => _showMessageDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Column(
      children: [
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
              child: _iconButton(Icons.camera_alt, () {}),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300], // Silhouette background
                    child:
                        profilePicture.isEmpty
                            ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.green[700],
                            ) // Silhouette icon
                            : ClipOval(
                              child: Image.asset(
                                profilePicture,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                  ),
                  _iconButton(Icons.camera_alt, () {}),
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
              _iconButton(Icons.edit, _editProfileDetails),
              _iconButton(Icons.settings, () => _showSettingsDialog(context)),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _section(String title, List<Map<String, String>> items) {
    return ExpansionTile(
      leading: Icon(
        title.contains('Listing') ? Icons.list : Icons.apartment,
        color: Colors.green[700],
      ),
      title: Text(title),
      children: items.map((item) => _listingCard(item)).toList(),
    );
  }

  Widget _listingCard(Map<String, String> item) {
    return ListTile(
      leading: Image.asset(item['image']!, width: 50, height: 50),
      title: Text(item['name']!),
      subtitle: Text(item['price']!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconButton(Icons.location_on, () {}),
          _iconButton(Icons.more_horiz, () {}),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.green[700]),
      onPressed: onPressed,
    );
  }

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Messages'),
            content: Text('You have no messages yet'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'), // Changed to only "OK"
              ),
            ],
          ),
    );
  }
}
