import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_gate.dart';
import 'package:semesterprojectuprmonlinemarketplace/themes/uprm_green.dart';
import 'package:semesterprojectuprmonlinemarketplace/providers/notification_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => NotificationProvider(), // ✅ Provide notifications globally
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: greenMode,
    );
  }
}
