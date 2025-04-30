import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Page imports
import '../housing/pages/house_listing.dart';
import '../housing/pages/login_page.dart';
import '../housing/pages/register_page.dart';
import '../housing/pages/chat_page.dart';
import '../housing/pages/user_list_page.dart'; // ✅ NEW: Import UserListPage
import '../housing/pages/MyListings.dart';
import '../housing/pages/favorite_listings.dart';
import '../housing/pages/map_screen.dart';
import '../housing/pages/notifications_page.dart'; // ✅ NEW: Import your NotificationsPage
import '../housing/widgets/app_layout.dart';

final GoRouter router = GoRouter(
  routes: [
    _customPageRoute('/', HouseList()),

    // Login / Register
    _customPageRoute('/login', LoginPage(onTap: () {})),
    _customPageRoute('/register', RegisterPage(onTap: () {})),

    // 🆕 When entering /chat, first show the User List
    _customPageRoute('/chat', const UserListPage()),

    // 🆕 When tapping a user, open ChatPage with receiverID and receiverEmail
    GoRoute(
      path: '/chat/:receiverID/:receiverEmail',
      pageBuilder: (context, state) {
        final receiverID = state.pathParameters['receiverID']!;
        final receiverEmail = Uri.decodeComponent(state.pathParameters['receiverEmail']!);
        return _customTransitionPage(
          state,
          AppLayout(
            body: ChatPage(
              receiverEmail: receiverEmail,
              receiverID: receiverID,
            ),
          ),
        );
      },
    ),

    // 🛎 Notifications Page (for the notification bell)
    _customPageRoute('/notifications', NotificationsPage()),

    // Other Pages
    _customPageRoute('/favorites', FavoritesPage()),
    _customPageRoute('/map', MapScreen()),
    _customPageRoute('/my-listings', MyListingsPage()),
    _customPageRoute('/inactive-listings', InactiveListingsPage()),
  ],
  errorBuilder: (context, state) => Scaffold(body: Center(child: Text('404 Page Not Found'))),
);

GoRoute _customPageRoute(String path, Widget page, {bool useLayout = true}) {
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

CustomTransitionPage _customTransitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
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

      final beginOffset = isGoingBack ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
      const endOffset = Offset.zero;

      var tween = Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}