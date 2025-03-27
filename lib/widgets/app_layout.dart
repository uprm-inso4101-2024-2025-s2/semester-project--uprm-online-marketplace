import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  final Widget body;

  const AppLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    String currentRoute = GoRouterState.of(context).uri.toString();

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
            _buildNavItem(context, Icons.home, 'Home', '/', currentRoute),
            ExpansionTile(
              leading: const Icon(Icons.favorite),
              title: const Text('My Favorites'),
              children: <Widget>[
                _buildNavItem(
                  context,
                  Icons.list,
                  'Suggested Listings',
                  '/favorites/suggestions',
                  currentRoute,
                ),
                _buildNavItem(
                  context,
                  Icons.trending_up,
                  'Trending Favorites',
                  '/favorites/trending',
                  currentRoute,
                ),
                _buildNavItem(
                  context,
                  Icons.star,
                  'Recently Added',
                  '/favorites/recently-added',
                  currentRoute,
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Login / Sign Up'),
              children: <Widget>[
                _buildNavItem(
                  context,
                  Icons.login,
                  'Login',
                  '/login',
                  currentRoute,
                ),
                _buildNavItem(
                  context,
                  Icons.app_registration,
                  'Sign Up',
                  '/sign-up',
                  currentRoute,
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
                _buildNavItem(
                  context,
                  Icons.question_answer,
                  'FAQ',
                  '/faq',
                  currentRoute,
                ),
              ],
            ),
            _buildNavItem(context, Icons.chat, 'Chat', '/chat', currentRoute),
            _buildNavItem(context, Icons.map, 'Map', '/map', currentRoute),
          ],
        ),
      ),
      body: body,
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    String currentRoute,
  ) {
    bool isActive = currentRoute == route;
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Colors.green.shade700 : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.green.shade700 : Colors.black,
        ),
      ),
      tileColor: isActive ? Colors.green.shade100 : null,
      onTap: () {
        GoRouter.of(context).go(route);
      },
    );
  }
}
