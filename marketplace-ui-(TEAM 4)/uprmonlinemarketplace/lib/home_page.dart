import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista para gestionar los favoritos
  List<bool> _favorites = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUMHousing'),
        backgroundColor: Colors.green.shade700,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('My Favorites'),
              onTap: () {
                // Aquí puedes agregar la acción para navegar a la página de favoritos
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                // Aquí puedes agregar la acción para navegar a la página de Login
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact Us'),
              onTap: () {
                // Aquí puedes agregar la acción para el Contact Us
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Contact Us'),
                      content: const Text(
                        'Aquí puedes agregar la información de contacto.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
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
                children: [
                  LodgingItem(
                    imagePath: 'assets/images/image1.jpg',
                    title: 'Hospedaje Calle Bosque',
                    description: 'Acogedor apartamento compartido.',
                    isFavorite: _favorites[0],
                    onFavoritePressed: () {
                      setState(() {
                        _favorites[0] = !_favorites[0];
                      });
                    },
                  ),
                  LodgingItem(
                    imagePath: 'assets/images/image2.jpg',
                    title: 'Hospedaje Miradero',
                    description:
                        'Se busca roomate para apartamento en miradero.',
                    isFavorite: _favorites[1],
                    onFavoritePressed: () {
                      setState(() {
                        _favorites[1] = !_favorites[1];
                      });
                    },
                  ),
                  LodgingItem(
                    imagePath: 'assets/images/image3.jpg',
                    title: 'Hospedaje Terrace',
                    description: 'Cuarto compartido con todo incluido.',
                    isFavorite: _favorites[2],
                    onFavoritePressed: () {
                      setState(() {
                        _favorites[2] = !_favorites[2];
                      });
                    },
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
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const LodgingItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('More Info'),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: onFavoritePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
