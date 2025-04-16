import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/firebase_options.dart';

void main() async {
  /* --- Initialize Firebase --- */
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebase();

  /* --- Run Application --- */
  runApp(
    MaterialApp(
      // Set SignUpPage as the first screen
      home: MyHomePage(title: "Counter"),
    ),
  );
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    // Only use emulators in debug mode
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(
        'localhost',
        8080,
      );
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      print("Firebase Emulator Error: $e");
    }
  }
  // Uncomment to see ports of the emulator
  // print(
  //   "Firebase Emulators Connected: Firestore (8080), Auth (9099)",
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      // home: HouseList(),
      // home: ProfileScreen(),
      // home: Profile(),
      debugShowCheckedModeBanner: true,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // Tells the Flutter framework something changed in this
      // state so rerun the build method so the display
      // reflects the updated values.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Layout widget: takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Layout widget: takes a list of children and
          // arranges them vertically.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many '
              'times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
