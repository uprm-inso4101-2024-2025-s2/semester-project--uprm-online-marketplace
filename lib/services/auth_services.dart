import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In with Email & Password
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // login successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return Firebase's error message
    }
  }

  Future<String?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await saveUserProfile(user.uid, email, username); // Save to Firestore
      }

      return null; // Sign-up successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return Firebase's error message
    }
  }

  // Save User Profile to Firestore
  Future<String?> saveUserProfile(String uid, String email, String username) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
