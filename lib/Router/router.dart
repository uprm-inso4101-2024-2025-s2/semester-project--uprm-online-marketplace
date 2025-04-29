import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Page imports
import '../housing/pages/house_listing.dart';

// import '../housing/pages/login_page.dart';
import '../housing/pages/new_login_page.dart';
import '../housing/pages/register_page.dart';
import '../housing/pages/chat_page.dart';
import '../housing/pages/MyListings.dart';
import '../housing/pages/favorite_listings.dart';
import '../housing/pages/map_screen.dart';
import '../housing/widgets/app_layout.dart';

final GoRouter router = GoRouter(
  routes: [
    _customPageRoute('/', HouseList()),
    _customPageRoute('/login', LoginPage(onTap: () {})),
    _customPageRoute('/register', RegisterPage(onTap: () {})),
    _customPageRoute(
      '/chat',
      ChatPage(
        receiverEmail: 'correo@example.com',
        receiverID: 'id123',
      ),
      useLayout: false,
    ),

    // ✅ Added new routes
    _customPageRoute('/favorites', FavoritesPage()),
    _customPageRoute('/map', MapScreen()),
    _customPageRoute('/my-listings', MyListingsPage()),
    _customPageRoute(
      '/inactive-listings',
      InactiveListingsPage(),
    ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(child: Text('404 Page Not Found')),
      ),
);

GoRoute _customPageRoute(
  String path,
  Widget page, {
  bool useLayout = true,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      return _customTransitionPage(
        state,
        useLayout ? AppLayout(body: page) : page,
      );
    },
  );
}

List<String> navigationHistory = [];

CustomTransitionPage _customTransitionPage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      String currentRoute = state.uri.toString();
      bool isGoingBack = false;

      if (navigationHistory.isNotEmpty) {
        isGoingBack = navigationHistory.last == currentRoute;
        if (isGoingBack) {
          navigationHistory.removeLast();
        } else {
          navigationHistory.add(currentRoute);
        }
      } else {
        navigationHistory.add(currentRoute);
      }

      final beginOffset =
          isGoingBack
              ? const Offset(-1.0, 0.0)
              : const Offset(1.0, 0.0);
      const endOffset = Offset.zero;

      var tween = Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
