import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            _buildHoverableTile(
              context, 
              icon: Icons.home, 
              title: 'Home', 
              route: '/',
            ),
            ExpansionTile(
              leading: const Icon(Icons.favorite),
              title: const Text('My Favorites'),
              children: <Widget>[
                _buildHoverableTile(
                  context, 
                  icon: Icons.list, 
                  title: 'Suggested Listings', 
                  route: '/favorites/suggestions',
                ),
                _buildHoverableTile(
                  context, 
                  icon: Icons.trending_up, 
                  title: 'Trending Favorites', 
                  route: '/favorites/trending',
                ),
                _buildHoverableTile(
                  context, 
                  icon: Icons.star, 
                  title: 'Recently Added', 
                  route: '/favorites/recently-added',
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Login / Sign Up'),
              children: <Widget>[
                _buildHoverableTile(
                  context, 
                  icon: Icons.login, 
                  title: 'Login', 
                  route: '/login',
                ),
                _buildHoverableTile(
                  context, 
                  icon: Icons.app_registration, 
                  title: 'Sign Up', 
                  route: '/sign-up',
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Support'),
              children: <Widget>[
                _buildHoverableTile(
                  context, 
                  icon: Icons.contact_mail, 
                  title: 'Contact Us', 
                  route: '/contact',
                ),
                _buildHoverableTile(
                  context, 
                  icon: Icons.question_answer, 
                  title: 'FAQ', 
                  route: '/faq',
                ),
              ],
            ),
            _buildHoverableTile(
              context, 
              icon: Icons.chat, 
              title: 'Chat', 
              route: '/chat',
            ),
            _buildHoverableTile(
              context, 
              icon: Icons.map, 
              title: 'Map', 
              route: '/map',
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}

Widget _buildHoverableTile(BuildContext context, {required IconData icon, required String title, required String route}) {
  return MouseRegion(
    onEnter: (event) {},
    onExit: (event) {},
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      hoverColor: Colors.green.shade100,
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    ),
  );
}
