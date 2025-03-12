import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_page.dart';

import 'login_page.dart';
import 'sign_up_page.dart';
import 'profile_page.dart';
import 'map_page.dart';
import 'support_page.dart';
import 'faq_page.dart';
import 'chat_page.dart';
import 'favorites_recently_added_page.dart';
import 'favorites_suggestions_page.dart';
import 'favorites_trending_page.dart';

import 'widgets/app_layout.dart'; // Import AppLayout

bool isAuthenticated =
    true; // Cambiar a true para propositos de testing. Al final se debe cambiar y usar la logica de autenticacion

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => AppLayout(body:HomePage())),

    GoRoute(path: '/login', builder: (context, state) => AppLayout(body:LoginPage())),
    GoRoute(path: '/sign-up', builder: (context, state) => AppLayout(body:SignUpPage())),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        // bool isAuthenticated = false; // Replace with actual check
        return isAuthenticated ? ProfilePage() : LoginPage();
      },
    ),

    GoRoute(path: '/support', builder: (context, state) => const SupportPage()),
    GoRoute(path: '/faq', builder: (context, state) => AppLayout(body:FaqPage())),

    GoRoute(
      path: '/favorites/suggestions',
      builder: (context, state) => AppLayout(body:FavoritesSuggestionsPage()),
      
    ),
    GoRoute(
      path: '/favorites/trending',
      builder: (context, state) => AppLayout(body:FavoritesTrendingPage()),
    ),
    GoRoute(
      path: '/favorites/recently-added',
      builder: (context, state) => AppLayout(body:FavoritesRecentlyAddedPage()),
    ),
    GoRoute(
      path: '/chat',builder: (context, state) => AppLayout(body: const ChatPage()),
    ),
    GoRoute(path: '/map', builder: (context, state) => AppLayout(body: const MapPage())),
  ],

  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('404 Page Not Found'))),
);
