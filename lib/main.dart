import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'housing/pages/house_listing.dart'; // Your custom page imports (assuming these exist)
import 'housing/pages/map_screen.dart'; // Your custom page imports (assuming these exist)
import 'Classes/LodgingClass.dart';

// Firebase Configuration
const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyCMjGDzcOQI1b9i8KVz87Z0qCBb9NX93_0",
    authDomain: "online-marketplace-posting.firebaseapp.com",
    projectId: "online-marketplace-posting",
    storageBucket: "online-marketplace-posting.firebasestorage.app",
    messagingSenderId: "436131107360",
    appId: "1:436131107360:web:d65c474f32ce843c55a245",
    measurementId: "G-13TKBZ7EG8"
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);  // Initialize Firebase
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  FirebaseFirestore.instance.collection("listings").get().then((QuerySnapshot querySnapshot){
    List<Lodging> lodgings = querySnapshot.docs.map((doc) {
      return LodgingFirestore.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
    for (var doc in querySnapshot.docs) {
      print(doc.data());
    }
    for(var lodging in lodgings){
      print("CONVERTED LODGING: ${lodging.title}, PRICE: ${lodging.price}, OWNER: ${lodging.owner}");
    }
  });
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: MapScreen(),  // Your home page widget
      home: HouseList(),
      debugShowCheckedModeBanner: false,
    );
  }
}



