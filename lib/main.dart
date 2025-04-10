import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'Router/router.dart';
import 'Classes/LodgingClass.dart';
import 'housing/pages/house_listing.dart';
import 'housing/pages/map_screen.dart';
import 'package:semesterprojectuprmonlinemarketplace/providers/notification_provider.dart';
import 'package:semesterprojectuprmonlinemarketplace/themes/uprm_green.dart';

// Firebase Configuration (incoming branch values)
const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyCMjGDzcOQI1b9i8KVz87Z0qCBb9NX93_0",
  authDomain: "online-marketplace-posting.firebaseapp.com",
  projectId: "online-marketplace-posting",
  storageBucket: "online-marketplace-posting.appspot.com",
  messagingSenderId: "436131107360",
  appId: "1:436131107360:web:d65c474f32ce843c55a245",
  measurementId: "G-13TKBZ7EG8",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => NotificationProvider(),
      child: const MyApp(),
    ),
  );
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
          routerConfig: router, // From router.dart
        );
      },
    );
  }
}
