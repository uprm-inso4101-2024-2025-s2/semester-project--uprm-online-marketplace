import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart'; // Import router.dart instead

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UPRM Marketplace',
      theme: ThemeData(primarySwatch: Colors.green),
      routerConfig: router, // Uses GoRouter for navigation
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUMHousing'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Lodging',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  LodgingItem(
                    imagePath: 'assets/image1.jpg',
                    title: 'Hospedaje Calle Bosque',
                    description: 'Acogedor apartamento compartido.',
                  ),
                  LodgingItem(
                    imagePath: 'assets/image2.jpg',
                    title: 'Hospedaje Miradero',
                    description:
                        'Se busca roomate para apartamento en miradero.',
                  ),
                  LodgingItem(
                    imagePath: 'assets/image3.jpg',
                    title: 'Hospedaje Terrace',
                    description: 'Cuarto compartido con todo incluido.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LodgingItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const LodgingItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                context.go('/details/$title/$description');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('More Info'),
            ),
          ],
        ),
      ),
    );
  }
}

class LodgingDetailsPage extends StatelessWidget {
  final String title;
  final String description;

  const LodgingDetailsPage({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Back to Listings'),
            ),
          ],
        ),
      ),
    );
  }
}
