import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/firebase_options.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth_services.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  var auth = AuthService();

  // Test Sign-Up
  //var signUpResult = await auth.signUp("test@example.com", "SecurePassword123", "testuser","admin");
  //print(signUpResult ?? "✅ Sign-up successful!");

  // Test Sign-In
  //var signInResult = await auth.signIn("test@example.com", "SecurePassword123");
  //print(signInResult ?? "✅ Sign-in successful!");

  // Test Sign-Out
  //await auth.signOut();
  //print("✅ User signed out successfully!");
  
  //FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //if (user == null) {
  //  print("User is signed out.");
  //} else {
   // print("User is signed in: ${user.email}");
//  }
//});

}


Future<void> initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
}