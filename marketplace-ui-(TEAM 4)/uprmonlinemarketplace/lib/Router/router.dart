import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Web_Pages/Home/home_page.dart';

import '../Web_Pages/Login_SignUp/login_page.dart';
import '../Web_Pages/Login_SignUp/sign_up_page.dart';
import '../Web_Pages/Login_SignUp/Profile/profile_page.dart';
import '../Web_Pages/Map/map_page.dart';
import '../Support/support_page.dart';
import '../Support/faq_page.dart';
import '../Web_Pages/Chat/chat_page.dart';
import '../Web_Pages/My_Favorites/favorites_recently_added_page.dart';
import '../Web_Pages/My_Favorites/favorites_suggestions_page.dart';
import '../Web_Pages/My_Favorites/favorites_trending_page.dart';

import '../widgets/app_layout.dart'; // Import AppLayout

bool isAuthenticated =
    true; // Cambiar a true para propositos de testing. Al final se debe cambiar y usar la logica de autenticacion

final GoRouter router = GoRouter(
  routes: [
    _customPageRoute('/', HomePage()),
    _customPageRoute('/login', LoginPage()),
    _customPageRoute('/sign-up', SignUpPage()),
    GoRoute(
      path: '/profile',
      pageBuilder:
          (context, state) => _customTransitionPage(
            state,
            isAuthenticated ? ProfilePage() : LoginPage(),
          ),
    ),

    _customPageRoute('/support', SupportPage(), useLayout: false),
    _customPageRoute('/faq', FaqPage()),
    _customPageRoute('/favorites/suggestions', FavoritesSuggestionsPage()),
    _customPageRoute('/favorites/trending', FavoritesTrendingPage()),
    _customPageRoute('/favorites/recently-added', FavoritesRecentlyAddedPage()),
    _customPageRoute('/chat', ChatPage(), useLayout: false),
    _customPageRoute('/map', MapPage(), useLayout: false),
  ],

  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('404 Page Not Found'))),
);

GoRoute _customPageRoute(String path, Widget page, {bool useLayout = true}) {
  return GoRoute(
    path: path,
    pageBuilder:
        (context, state) => _customTransitionPage(
          state,
          useLayout ? AppLayout(body: page) : page,
        ),
  );
}

List<String> navigationHistory = []; // Track visited routes

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
          navigationHistory.removeLast(); // Ensure strict back behavior
        } else {
          navigationHistory.add(currentRoute);
        }
      } else {
        navigationHistory.add(currentRoute);
      }

      final beginOffset =
          isGoingBack ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
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
