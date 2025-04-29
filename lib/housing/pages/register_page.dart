import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_service.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_button.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_textfield.dart';
import 'package:url_launcher/link.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Field Controllers
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _pwController =
      TextEditingController();
  final TextEditingController _confirmPwController =
      TextEditingController();

  //Register Method
  void register(BuildContext context) async {
    //get auth service
    final _auth = AuthService();

    //if password match => create user

    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        //Catch Errors
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      // passwrod don't match tell user to fix
      showDialog(
        context: context,
        builder:
            (context) => const AlertDialog(
              title: Text("Passwords don't Match"),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      //Basic UI for the Login Screen
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Icon(
                  Icons.message,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 50),
                // To have space between
                Text(
                  "Let's Create an account for you",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                //Email textfield
                MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                  validator: (value) {
                    // Validate input in password field
                    if (value == null || value.isEmpty) {
                      return "Enter the password again";
                    } else if (value.length < 8) {
                      return "Password must be 8 characters or "
                          "more";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // pw textfield
                MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: _pwController,
                  validator: (value) {
                    // Validate input in password field
                    if (value == null || value.isEmpty) {
                      return "Enter the password again";
                    } else if (value.length < 8) {
                      return "Password must be 8 characters or "
                          "more";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // confirm pw textfield
                MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: _confirmPwController,
                  validator: (value) {
                    // Validate input in password field
                    if (value == null || value.isEmpty) {
                      return "Enter the password again";
                    } else if (value.length < 8) {
                      return "Password must be 8 characters or "
                          "more";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                //login
                MyButton(
                  text: "Register",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {});
                    }
                    register(context);
                  },
                ),
                const SizedBox(height: 25),

                //register now
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center, // How the text is align
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: onTap,
                    //   child: Text(
                    //     "Login Now",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       color:
                    //           Theme.of(context).colorScheme.primary,
                    //     ),
                    //   ),
                    // ),
                    Link(
                      uri: Uri.parse('/login'),
                      builder: (context, followLink) {
                        return RichText(
                          text: TextSpan(
                            text: "Login Now",
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
    );
  }

  /* ========= Register Methods (from T1-Clean) ========= */
  // Check if email is a valid email (by the criteria)
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|mac\.com|me\.com|[a-zA-Z0-9.-]+\.edu)$",
    );
    return emailRegex.hasMatch(email);
  }

  // Check if the password is a valid password (by the
  // requirements)
  bool isValidPassword(String password) {
    final RegExp passwordRegex = RegExp(
      r"^(?=.*[0-9])(?=.*[A-Z]).{8,}$",
    );
    return passwordRegex.hasMatch(password);
  }
}
