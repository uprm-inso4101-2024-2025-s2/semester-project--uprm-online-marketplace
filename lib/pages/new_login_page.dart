import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../constants/strings.dart';

void main() {
  /*
   * Entry point to the Login Page.
   * The purpose of this main function is to test this file
   * separately from the rest of the application.
   */
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: true,
      home: LoginPage(),
    ),
  );
}

class LoginPage extends StatelessWidget {
  /*
   * To use the Login Page call this class from any file.
   */
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(loginAppBarBack),
        ),
        title: const Text(loginAppBarTitle),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: LoginBody(),
    );
  }
}

/* --------------------------------------------------------------
 * All classes below this comment shall not be called from
 * other files. ONLY the LoginPage class above can call them.
 */
class LoginBody extends StatefulWidget {
  // Start LoginBody
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  static const _space10 = const SizedBox(height: 10);
  static const _space20 = const SizedBox(height: 20);
  static const _space25 = const SizedBox(height: 25);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Page Title
              Text("Title: Login"),
              _space20,
              // Email Field
              MyTextfield(
                hintText: loginEmail,
                obscureText: false,
                controller: TextEditingController(),
              ),
              _space10,
              MyTextfield(
                hintText: loginPassword,
                obscureText: true,
                controller: TextEditingController(),
              ),
              _space20,
              TextButton(
                onPressed: () {},
                child: Text(loginForgotPassword),
              ),
              _space20,
              MyButton(text: loginButton, onTap: () {}),
              _space25,
            ],
          ),
        ),
      ),
    );
  }
} // End LoginBody
