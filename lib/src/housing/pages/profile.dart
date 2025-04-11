import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/services/auth/auth_service.dart';
import 'dart:js_interop';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = true;

  final TextEditingController nameController = TextEditingController(
    text: "Nelson",
  );
  final TextEditingController emailController = TextEditingController(
    text: "email@example.com",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "*****",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "787-000-0000",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF47804B),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                nameController.text,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildProfileItem("Name", nameController),
            _buildProfileItem("Email", emailController),
            _buildProfileItem("Password", passwordController, isPassword: true),
            _buildProfileItem("Number", phoneController),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Saved Properties'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF47804B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Listed Properties'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF47804B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    String title,
    TextEditingController controller, {
    bool isEditable = true,
    bool isPassword = false,
  }) {
    bool isObscured = isPassword;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                keyboardType:
                    title == "Number"
                        ? TextInputType.phone
                        : TextInputType.text,
                inputFormatters:
                    title == "Number"
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : [],
                controller: controller,
                decoration: InputDecoration(
                  labelText: title,
                  border: const OutlineInputBorder(),
                  suffixIcon:
                      isPassword
                          ? TextButton(
                            onPressed:
                                () => setState(() => isObscured = !isObscured),
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
                  style: TextStyle(color: Colors.grey),
                ),
                const Text(
                  "• 8 characters",
                  style: TextStyle(color: Colors.grey),
                ),
                const Text("• 1 number", style: TextStyle(color: Colors.grey)),
              ],
              const SizedBox(height: 8),
              // ElevatedButton(
              //   onPressed: () async {
              //     AuthService authService = AuthService();
              //     authService.useMock = true;

              //     String newValue = controller.text.trim();
              //     String? result;

              //     if (title == 'Email') {
              //       bool exists = await authService.checkIfEmailExists(
              //         newValue,
              //       );
              //       if (!exists) {
              //         _showSnack("This email does not exist");
              //         return;
              //       }
              //       result = await authService.updateEmail(newValue);
              //     } else if (title == 'Password') {
              //       if (newValue.length < 8 ||
              //           !RegExp(r'\d').hasMatch(newValue)) {
              //         if (newValue.length < 8)
              //           _showSnack(
              //             "Password must contain 8 characters or more",
              //           );
              //         if (!RegExp(r'\d').hasMatch(newValue))
              //           _showSnack("Password must contain at least 1 number");
              //         return;
              //       }
              //       result = await authService.updatePassword(newValue);
              //     } else if (title == 'Name') {
              //       if (newValue.isEmpty) {
              //         _showSnack("Name cannot be empty");
              //         return;
              //       }
              //       result = await authService.updateUsername(newValue);
              //     } else if (title == 'Number') {
              //       if (newValue.length != 10) {
              //         _showSnack("Phone number must be 10 digits");
              //         return;
              //       }
              //       result = await authService.updateNumber(newValue);
              //     }

              //     if (result == null) {
              //       _showSnack("$title updated!");
              //     } else {
              //       _showSnack(result);
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: const Color(0xFF47804B),
              //     foregroundColor: Colors.white,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 22,
              //       vertical: 12,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   child: Text("Update $title"),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
