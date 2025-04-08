import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// //Controls the abilities of FireBase

// class AuthService {
//   //instace of auth & firestore
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   //get current  logged in user
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   //sign in (login page)

//   Future<UserCredential> signInWithEmailPassword(String email, password) async {
//     //Try to Sign in , and if their are errors catch the error
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       //save user info if it doesn't exist
//       _firestore.collection("Users").doc(userCredential.user!.uid).set({
//         'uid': userCredential.user!.uid,
//         'email': email,
//       });

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }

//   //sign  up (for register page) (FireBase requires a format of a valid email and at least 6-digit password)
//   Future<UserCredential> signUpWithEmailPassword(String email, password) async {
//     try {
//       //create user
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);

//       //save user info in another document
//       _firestore.collection("Users").doc(userCredential.user!.uid).set({
//         'uid': userCredential.user!.uid,
//         'email': email,
//       });

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }

//   //sign out
//   Future<void> signOut() async {
//     return await _auth.signOut();
//   }

//   //errors
// }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? getCurrentUser() => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String?> signInWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUpWithEmailPassword(String email, String password) async {
    try {
      // Check if the email is already used
      var existing =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .get();
      if (existing.docs.isNotEmpty) return 'Email is already taken.';

      // Create user with email and password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user info to Firestore
      await saveUserProfile(userCredential.user!.uid, email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> saveUserProfile(String uid, String email) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return 'Canceled by user';

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } catch (e) {
      return 'Google Sign-In failed: $e';
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
