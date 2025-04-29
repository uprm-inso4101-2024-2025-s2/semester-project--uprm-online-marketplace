import 'package:flutter/gestures.dart';
import 'package:url_launcher/link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_button.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_textfield.dart';

import '../../firebase_options.dart';

/* ==== Login Page test 'main' ==== */
void main() async {
  // Initialize Firebase before starting the application
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Use Firebase Emulator if debugging
  if (kDebugMode) {
    try {
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(
        'localhost',
        8080,
      );
    } catch (error) {
      print("Firebase Emulator Error: $error");
    }
  }

  // Start the application
  runApp(MaterialApp(home: LoginPage(onTap: () {})));
}

/* ==== Login Page ==== */
class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Field Controllers
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar for Login Page -- commented out for now
      // appBar: AppBar(
      //   title: Text(cText.page_title),
      //   centerTitle: true,
      //   backgroundColor: Colors.green,
      // ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Page logo
                  Icon(
                    Icons.message,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  cSpace.box50,

                  // Page Title
                  Text(
                    cText.page_title,
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  cSpace.box20,

                  // Email Field
                  MyTextfield(
                    labelText: cText.email,
                    labelStyle: TextStyle(
                      color:
                          Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: cText.hint_email,
                    obscureText: false,
                    controller: _emailController,
                  ),
                  cSpace.box10,

                  // Password Field
                  MyTextfield(
                    labelText: cText.password,
                    labelStyle: TextStyle(
                      color:
                          Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: cText.hint_password,
                    obscureText: false,
                    controller: _passwordController,
                  ),
                  cSpace.box20,

                  // Login Button
                  MyButton(text: cText.btn_login, onTap: () {}),
                  cSpace.box20,

                  // Forgot Password
                  Link(
                    // Temporary pointing to home page
                    uri: Uri.parse('/'),
                    builder: (context, followLink) {
                      return RichText(
                        text: TextSpan(
                          text: cText.forgot_password,
                          style: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = followLink,
                        ),
                      );
                    },
                  ),
                  cSpace.box25,

                  // Register
                  Text(
                    cText.member,
                    style: TextStyle(
                      color:
                          Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Link(
                    uri: Uri.parse('/register'),
                    builder: (context, followLink) {
                      return RichText(
                        text: TextSpan(
                          text: cText.register_now,
                          style: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = followLink,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ==== Login Page Methods ==== */
}

/* ==== Login Page Constants: Strings ==== */
class cText {
  static const String page_title = "Log in to your account";

  static const String email = "Email";
  static const String hint_email = "Please enter email";

  static const String password = "Password";
  static const String hint_password = "Please enter password";
  static const String forgot_password = "Forgot Password";

  static const String btn_login = "Login";

  static const String member = "Not a member?";
  static const String register_now = "Register now";
}

/* ==== Login Page Constants: Empty Size Boxes ==== */
class cSpace {
  static const SizedBox box10 = SizedBox(height: 10);
  static const SizedBox box20 = SizedBox(height: 20);
  static const SizedBox box25 = SizedBox(height: 25);
  static const SizedBox box50 = SizedBox(height: 50);
}
