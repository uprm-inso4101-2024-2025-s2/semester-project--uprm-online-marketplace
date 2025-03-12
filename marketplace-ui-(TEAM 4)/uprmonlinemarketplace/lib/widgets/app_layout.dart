import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLayout extends StatelessWidget {
  final Widget body;

  const AppLayout({super.key, required this.body});

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
            ExpansionTile(
              leading: const Icon(Icons.favorite),
              title: const Text('My Favorites'),
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Suggested Listings'),
                  onTap: () {
                    context.go('/favorites/suggestions');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text('Trending Favorites'),
                  onTap: () {
                    context.go('/favorites/trending');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Recently Added'),
                  onTap: () {
                    context.go('/favorites/recently-added');
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Login / Sign Up'),
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Login'),
                  onTap: () {
                    context.go('/login');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.app_registration),
                  title: const Text('Sign Up'),
                  onTap: () {
                    context.go('/sign-up');
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Support'),
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('Contact Us'),
                  onTap: () {
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
                ListTile(
                  leading: const Icon(Icons.question_answer),
                  title: const Text('FAQ'),
                  onTap: () {
                    context.go('/faq');
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () {
                context.go('/chat');
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map'),
              onTap: () {
              Navigator.pop(context);  
              context.go('/map');  
  },
),

          ],
        ),
      ),
      body: body, // Injecting the body content here (HomePage or any other page)
    );
  }
}
