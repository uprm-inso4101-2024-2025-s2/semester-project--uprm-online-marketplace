// import 'package:flutter/material.dart';
// import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_service.dart';
// import 'package:semesterprojectuprmonlinemarketplace/components/my_button.dart';
// import 'package:semesterprojectuprmonlinemarketplace/components/my_textfield.dart';

// //In Order to keep our Code organized

// Original Login Page

// class LoginPage extends StatelessWidget {
//   // email and pw text controllers (See who logs in)
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _pwController = TextEditingController();

//   //Tap to go to register

//   final void Function()? onTap;

//   LoginPage({super.key, required this.onTap});

//   void login(BuildContext context) async {
//     //Auth Services
//     final authService = AuthService();

//     //try login
//     try {
//       await authService.signInWithEmailPassword(
//         _emailController.text,
//         _pwController.text,
//       );
//     } catch (e) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(title: Text(e.toString())),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Log in to your account"),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//       ),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Title
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Text(
//                       "Login",
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 22.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // Email field
//                 MyTextfield(
//                   hintText: "Email",
//                   obscureText: false,
//                   controller: _emailController,
//                 ),
//                 const SizedBox(height: 10),

//                 // Password field
//                 MyTextfield(
//                   hintText: "Password",
//                   obscureText: true,
//                   controller: _pwController,
//                 ),
//                 const SizedBox(height: 20),

//                 // Login button
//                 MyButton(text: "Login", onTap: () => login(context)),
//                 const SizedBox(height: 25),

//                 // Switch to Register
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Not a member? "),
//                     GestureDetector(
//                       onTap: onTap,
//                       child: const Text(
//                         "Register Now",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),

//       // Floating button (optional, kept from incoming UI)
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Placeholder action
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Floating action clicked")),
//           );
//         },
//         backgroundColor: Colors.black,
//         child: const Text("Click", style: TextStyle(color: Colors.cyan)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_service.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_button.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_textfield.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter/gestures.dart';

// Merged login with T1 Signin
class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in to your account"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Email field
                MyTextfield(
                  hintText: "Email/Username",
                  obscureText: false,
                  controller: _emailController,
                ),
                const SizedBox(height: 10),

                // Password field
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: _pwController,
                ),
                const SizedBox(height: 20),

                // Login button
                MyButton(text: "Login", onTap: () => login(context)),
                const SizedBox(height: 25),

                // Forgot Password Link
                ForgotPasswordLink(),
                const SizedBox(height: 25),

                // Switch to Register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member? "),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Floating action clicked")),
          );
        },
        backgroundColor: Colors.black,
        child: const Text("Click", style: TextStyle(color: Colors.cyan)),
      ),
    );
  }
}

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse('https://uprm.edu'),
      builder: (context, followLink) {
        return RichText(
          text: TextSpan(
            text: "Forgot Password?",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()..onTap = followLink,
          ),
        );
      },
    );
  }
}
