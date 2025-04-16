import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semesterprojectuprmonlinemarketplace/providers/notification_provider.dart';

import 'Router/router.dart';
import 'themes/uprm_green.dart';

void main() async {
  /* --- Initialize Firebase --- */
  // initializeFirebase();

  /* --- Run Application --- */
  runApp(
    ChangeNotifierProvider(
      // Provide notifications globally
      create: (_) => NotificationProvider(),
      child: const MyApp(),
    ),
    // MaterialApp(
  );
}

/* --- Method to initialize Firebase --- */
// Future<void> initializeFirebase() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   if (kDebugMode) {
//     // Only use emulators in debug mode
//     try {
//       FirebaseFirestore.instance.useFirestoreEmulator(
//         'localhost',
//         8080,
//       );
//       FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//     } catch (e) {
//       print("Firebase Emulator Error: $e");
//     }
//   }
//   // Uncomment to see ports of the emulator
//   // print(
//   //   "Firebase Emulators Connected: Firestore (8080), Auth (9099)",
//   // );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UPRM Marketplace',
      theme: greenMode,
      routerConfig: router,
    );
  }
}
