import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:js_interop';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool useMock = true; // Toggle this for testing without Firebase


  Map<String, String> mockUser = {
    'uid': '123456',
    'email': 'email@example.com',
    'username': 'Nelson',
    'password': '*****',
    'number': '787-000-0000',
  };

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
    // Check if username already exists in Firestore
    var querySnapshot = await _firestore.collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return 'Username is already taken. Please choose another.';
    }

    // Firebase handles duplicate emails automatically
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      await saveUserProfile(user.uid, email, username);
    }

    return null; // Success
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in instead.';
      case 'weak-password':
        return 'Your password is too weak. Please use a stronger password.';
      default:
        return e.message; // Return Firebase’s default error message
    }
  }
  }

  Future<bool> checkIfEmailExists(String email) async {
    if (useMock) return email == mockUser['email'];
    try {
      final auth = FirebaseAuth.instance;
      List<String> signInMethods = await auth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty; // email exist
    } catch (e) {
      return false; // the email is invalid
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

  Future<String?> updateUsername(String newUsername) async {
    if (useMock) {
      mockUser['username'] = newUsername;
      return null;
    }
    try {
      User? user = _auth.currentUser;
      if (user == null) return 'User not found. Please log in again.';
      await _firestore.collection('users').doc(user.uid).update({'username': newUsername});
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateNumber(String newNumber) async{
    if (useMock) {
      mockUser['number'] = newNumber;
      return null;
    }
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({'number': newNumber});
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updatePassword(String newPassword) async { //to continue working on authentication add String currentPassword to class
    if (useMock) {
      mockUser['password'] = newPassword;
      return null;
    }
    try {
      User? user = _auth.currentUser;
      if (user == null) return 'User not found. Please log in again.';
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> updateEmail(String newEmail) async { //to continue working on authentication add String currentPassword to class
    if (useMock) {
      mockUser['email'] = newEmail;
      return null;
    }
    try {
      User? user = _auth.currentUser;
      if (user == null) return 'User not found. Please log in again.';
      await user.updateEmail(newEmail);
      await _firestore.collection('users').doc(user.uid).update({'email': newEmail});
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  Map<String, String> getMockUser() {
    return useMock ? mockUser: {};
  }


  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
