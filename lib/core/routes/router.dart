import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/onbroading/oops_screen.dart';
import '../screens/onbroading/number_screen.dart';
import '../screens/onbroading/verification_screen.dart';
import '../screens/onbroading/profile_screen.dart';


final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/oops',
      builder: (context, state) => const OopsScreen(),
    ),
    GoRoute(
      path: '/number',
      builder: (context, state) => const NumberScreen(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) => const VerificationScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
  ],
);

class AppRouter {
  static GoRouter get router => _router;
}