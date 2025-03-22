import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/login_or_register.dart';
import 'package:semesterprojectuprmonlinemarketplace/pages/home_page.dart';

//Purpose , to check if the user is logged in or not

//Constantly checking our auth state changes

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //User logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          //user is Not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
