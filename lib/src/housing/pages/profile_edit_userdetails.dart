import '/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // Add this for TextInputFormatter
import '../../../services/auth_services.dart';
import 'profile.dart';
import 'dart:js_interop';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = true;

  final TextEditingController nameController = TextEditingController(text: "Nelson");
  final TextEditingController emailController = TextEditingController(text: "email@example.com");
  final TextEditingController passwordController = TextEditingController(text: "*****");
  final TextEditingController phoneController = TextEditingController(text: "787-000-0000");

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });

    if (!isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile Updated!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF47804B),
        title: Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: 4,
          separatorBuilder: (context, index) => const Divider(thickness: 1, height: 40),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildProfileItem("Name", nameController);
            } else if (index == 1) {
              return _buildProfileItem("Email", emailController);
            } else if (index == 2) {
              return _buildProfileItem("Password", passwordController, isPassword: true);
            } else {
              return _buildProfileItem("Number", phoneController);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, TextEditingController controller, {bool isEditable = true, bool isPassword = false}) {
    bool isObscured = isPassword; //this is for the Show and hide button

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: title == "Number" ? TextInputType.phone : TextInputType.text,
              inputFormatters: title == "Number" ? [FilteringTextInputFormatter.digitsOnly] : [],
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: OutlineInputBorder(),
                suffixIcon: isPassword
                    ? TextButton(
                  onPressed: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                  child: Text(isObscured ? "Show" : "Hide"),
                )
                    : null,
              ),
              obscureText: isObscured,
              enabled: isEditing && isEditable,
            ),
            if (isPassword) ...[
              const SizedBox(height: 8),
              const Text(
                "YOUR PASSWORD MUST INCLUDE AT LEAST:",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const Text("8 characters", style: TextStyle(color: Colors.grey, fontSize: 14)),
              const Text("1 number", style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                AuthService authService = AuthService();
                authService.useMock = true;

                String newValue = controller.text.trim();
                String? result;

                if (title == 'Email') {
                  bool exists = await authService.checkIfEmailExists(newValue);
                  if (!exists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("This email does not exist")),
                    );
                    return;
                  }
                  result = await authService.updateEmail(newValue);
                } else if (title == 'Password') {
                  if (newValue.length < 8 || !RegExp(r'\d').hasMatch(newValue)) {
                    if (newValue.length < 8) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid, Password must contain 8 characters or more")),
                      );
                    }
                    if (!RegExp(r'\d').hasMatch(newValue)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid, Password must contain at least 1 number")),
                      );
                    }
                    return;
                  }
                  result = await authService.updatePassword(newValue);
                } else if (title == 'Name') {
                  if (newValue.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Name cannot be an empty field")),
                    );
                    return;
                  }
                  result = await authService.updateUsername(newValue);
                } else if (title == 'Number') {
                  if (newValue.length != 10) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Phone number must be 10 digits")),
                    );
                    return;
                  }
                  result = await authService.updateNumber(newValue);
                }

                if (result == null) {
                  print("Mock User Data: ${authService.getMockUser()}");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title updated!")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF47804B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Update $title"),
            ),
          ],
        );
      },
    );
  }
}


// class ProfileScreenState extends State<ProfileScreen> {
//   late TextEditingController nameController;
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController numberController;
//   bool isEditing = true;
//   AuthService authService = AuthService();
//
//
//   @override
//   void initState() {
//     super.initState();
//     authService.useMock = true; // Ensure mock data is used
//     var mockUser = authService.getMockUser();
//
//     nameController = TextEditingController(text: mockUser['username'] ?? '');
//     emailController = TextEditingController(text: mockUser['email'] ?? '');
//     passwordController = TextEditingController(text: mockUser['password'] ?? '');
//     numberController = TextEditingController(text: mockUser['number'] ?? '');
//   }
//
//   void _updateProfile(String title, String newValue) async {
//     String? result;
//
//     if (title == 'Email') {
//       bool exists = await authService.checkIfEmailExists(newValue);
//       if (!exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("This email does not exist")),
//         );
//         return;
//       }
//       result = await authService.updateEmail(newValue);
//     } else if (title == 'Password') {
//       if (newValue.length < 8 || !RegExp(r'\d').hasMatch(newValue)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Invalid password: must be 8+ characters and include a number")),
//         );
//         return;
//       }
//       result = await authService.updatePassword(newValue);
//     } else if (title == 'Name') {
//       if (newValue.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Name cannot be empty")),
//         );
//         return;
//       }
//       result = await authService.updateUsername(newValue);
//     } else if (title == 'Number') {
//       if (newValue.length != 10) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Phone number must be 10 digits")),
//         );
//         return;
//       }
//       result = await authService.updateNumber(newValue);
//     }
//
//     if (result == null) {
//       setState(() {
//         var updatedUser = authService.getMockUser();
//         nameController.text = updatedUser['name'] ?? '';
//         emailController.text = updatedUser['email'] ?? '';
//         passwordController.text = updatedUser['password'] ?? '';
//         numberController.text = updatedUser['number'] ?? '';
//       });
//
//       print("Updated Mock User: ${authService.getMockUser()}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("$title updated!")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result)),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFF47804B),
//         title: Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => Profile()),
//             );
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.separated(
//           itemCount: 4,
//           separatorBuilder: (context, index) => const Divider(thickness: 1, height: 40),
//           itemBuilder: (context, index) {
//             if (index == 0) return _buildProfileItem("Name", nameController);
//             if (index == 1) return _buildProfileItem("Email", emailController);
//             if (index == 2) return _buildProfileItem("Password", passwordController, isPassword: true);
//             return _buildProfileItem("Number", numberController);
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileItem(String title, TextEditingController controller, {bool isPassword = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           keyboardType: title == "Number" ? TextInputType.phone : TextInputType.text,
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: title,
//             border: OutlineInputBorder(),
//           ),
//           obscureText: isPassword,
//           enabled: isEditing,
//         ),
//         const SizedBox(height: 8),
//         ElevatedButton(
//           onPressed: () {
//             _updateProfile(title, controller.text.trim());
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFF47804B),
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text("Update $title"),
//         ),
//       ],
//     );
//   }
// }






