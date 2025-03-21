import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign In with Email & Password
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // login successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return Firebase's error message
    }
  }
  //Sign Up with Email & Password
  Future<String?> signUp(String email, String password, String username, String role) async {
  try {
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
      await saveUserProfile(user.uid, email, username, role);
    }

    return null; // Success
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in instead.';
      case 'weak-password':
        return 'Your password is too weak. Please use a stronger password.';
      default:
        return e.message; 
    }
  }
}
 //Sign in + Sign up
   Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return 'Google Sign-In canceled by user'; // User canceled


      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the authentication details
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      await _auth.signInWithCredential(credential);
      return null; // Success
    } catch (e) {
      return 'Google Sign-In failed: ${e.toString()}';
    }
  }

  // Save User Profile to Firestore
  Future<String?> saveUserProfile(String uid, String email, String username, String role) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'username': username,
        'role' : role,
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
  
  
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return Firebase's error message
    }
  }
  //tracks user status
  Stream<User?> get authStateChanges => _auth.authStateChanges();

}
