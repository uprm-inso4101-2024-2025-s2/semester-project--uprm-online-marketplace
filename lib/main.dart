import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'Router/router.dart';
import 'Classes/LodgingClass.dart';
import 'housing/pages/house_listing.dart';
import 'housing/pages/map_screen.dart';
import 'package:semesterprojectuprmonlinemarketplace/themes/uprm_green.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyBqajpsar7nw9tlbDNRu13505v-PaeC0os",
  authDomain: "online-market-f5c9f.firebaseapp.com",
  projectId: "online-market-f5c9f",
  storageBucket: "online-market-f5c9f.firebasestorage.app",
  messagingSenderId: "771212475650",
  appId: "1:771212475650:web:b1748012b5d858873cd61b",
  measurementId: "G-WNKC1KHM1R",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(500, 500),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'UPRM Marketplace',
          theme: greenMode,
          routerConfig: router,
        );
      },
    );
  }
}