import 'package:flutter/material.dart';
import '../core/routes/router.dart';

import '../core/screens/login_screen.dart';  // Import file login.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false, // Ẩn debug banner
    );
  }
}