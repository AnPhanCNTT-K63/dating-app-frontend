import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import go_router

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[900]!, Colors.pink[600]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/tinder_logo.png',
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'It starts with\na Swipe™',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'By tapping "Sign in", you agree to our Terms.\nLearn how we process your data in our Privacy\nPolicy and Cookies Policy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Giả lập lỗi đăng nhập, chuyển sang OopsScreen
                  context.go('/oops');
                },
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  height: 24,
                ),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(300, 50),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Giả lập lỗi đăng nhập, chuyển sang OopsScreen
                  context.go('/oops');
                },
                icon: Image.asset(
                  'assets/images/facebook_logo.png',
                  height: 24,
                ),
                label: const Text('Sign in with Facebook'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(300, 50),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Giả lập lỗi đăng nhập, chuyển sang NumberScreen
                  context.go('/number');
                },
                child: const Text('Sign in with phone number'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(300, 50),
                ),
              ),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Trouble signing in?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}