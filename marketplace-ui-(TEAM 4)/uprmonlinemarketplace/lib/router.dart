import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'profile_page.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomePage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        bool isAuthenticated = false; // Replace with actual check
        return isAuthenticated ? ProfilePage() : LoginPage();
      },
    ),
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('404 Page Not Found'))),
);
