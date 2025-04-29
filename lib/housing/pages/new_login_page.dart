import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:semesterprojectuprmonlinemarketplace/housing/pages/home_page.dart';
import 'package:url_launcher/link.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../../firebase_options.dart';
import '../../services/auth/auth_service.dart';

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
  /* ===== Private Variables ===== */
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Field Controllers
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

  bool isLoading = false;

  // Firebase Auth
  final AuthService _auth = AuthService();

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
                    validator: (value) {
                      // Validate input in email field
                      if (value == null || value.isEmpty) {
                        setState(() {
                          isLoading = false;
                        });
                        return cText.hint_email;
                      } else if (!value.contains('@')) {
                        setState(() {
                          isLoading = false;
                        });
                        return cText.enter_valid_email;
                      }
                      return null;
                    },
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
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      // Validate input in password field
                      if (value == null || value.isEmpty) {
                        setState(() {
                          isLoading = false;
                        });
                        return cText.hint_password;
                      } else if (value.length < 8) {
                        setState(() {
                          isLoading = false;
                        });
                        return cText.too_few_characters;
                      }
                      return null;
                    },
                  ),
                  cSpace.box20,

                  // Login Button
                  // isLoading
                  //     ? CircularProgressIndicator()
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _auth.signInWithEmailPassword(
                          _emailController.text,
                          _passwordController.text,
                        );

                        // Wait 1 second before sending to next page after login
                        await Future.delayed(
                          const Duration(seconds: 1),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        String message = '';
                        if (e.code == 'user-not-found') {
                          message =
                              'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          message =
                              'Wrong password provided for that user.';
                        }
                        Fluttertoast.showToast(
                          msg: message,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.SNACKBAR,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                          fontSize: 14.0,
                        );
                      } catch (e) {}
                    },
                    child: Text(cText.btn_login),
                  ),
                  // MyButton(
                  //   text: cText.btn_login,
                  //   onTap: () {
                  //     if (_formKey.currentState!.validate()) {
                  //       // setState(() {
                  //       //   isLoading = true;
                  //       // });
                  //     }
                  //     logInNow(
                  //       email: _emailController.text,
                  //       password: _passwordController.text,
                  //       context: context,
                  //     );
                  //   },
                  // ),
                  cSpace.box20,

                  // Forgot Password
                  Link(
                    /* ----- NEED TO CREATE PAGE FOR FORGOT
                    PASSWORD ----- */
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Register
                      Text(
                        cText.member,
                        style: TextStyle(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.primary,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* ==== Login Page Methods ==== */
  void logInNow({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailPassword(email, password);

      // Wait 1 second before sending to next page after login
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {}
  }

  // void logIn() async {
  //   // Start of log in to Firebase
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     // Sign in with email and password
  //     _auth
  //         .signInWithEmailPassword(
  //           _emailController.text,
  //           _passwordController.text,
  //         )
  //         .then((result) {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => HomePage()),
  //           );
  //         });
  //
  //     // String? user = _auth.getCurrentUserID();
  //
  //     // if (user != null) {}
  //   } catch (error) {}
  // }
}

/* ==== Login Page Constants: Strings ==== */
class cText {
  static const String page_title = "Log in to your account";

  static const String email = "Email";
  static const String hint_email = "Please enter email";
  static const String enter_valid_email =
      "Please enter a valid"
      " email";

  static const String password = "Password";
  static const String hint_password = "Please enter password";
  static const String forgot_password = "Forgot Password?";
  static const String too_few_characters =
      "Password must be 8 "
      "characters or more";

  static const String btn_login = "Login";

  static const String member = "Not a member? ";
  static const String register_now = "Register Now";

  static const String error = "Error";
  static const String ok = "OK";
}

/* ==== Login Page Constants: Empty Size Boxes ==== */
class cSpace {
  static const SizedBox box10 = SizedBox(height: 10);
  static const SizedBox box20 = SizedBox(height: 20);
  static const SizedBox box25 = SizedBox(height: 25);
  static const SizedBox box50 = SizedBox(height: 50);
}
