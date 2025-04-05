import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/app_icons.dart'; // Import icon đã cấu hình sẵn
import '../theme/app_decoration.dart'; // Import style của button (socialButton)
import '../theme/app_theme.dart'; // Import font chữ đã cấu hình

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  // Hàm tái sử dụng để tạo các nút "Sign in with ..."
  Widget _buildSignInButton({
    required Widget icon,   // icon bên trái
    required String label,  // nội dung nút
    required VoidCallback onTap, // hành động khi nhấn
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30), // bo tròn hiệu ứng ripple
      child: InkWell(
        onTap: onTap, // xử lý khi nhấn
        child: Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: AppDecoration.socialButton(), // style nút từ AppDecoration
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon, // icon hiển thị bên trái
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTheme.bodyMedium14.copyWith(color: Colors.black), // font chữ từ AppTheme
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Nền gradient cho toàn bộ màn hình
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[900]!, Colors.pink[600]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Tinder
            AppIcons.tinderLogo(height: 100),

            const SizedBox(height: 20),

            // Tiêu đề chính
            Text(
              'It starts with\na Swipe™',
              textAlign: TextAlign.center,
              style: AppTheme.headLineLarge32.copyWith(color: Colors.white),
            ),

            const SizedBox(height: 40),

            // Văn bản chính sách
            Text(
              'By tapping "Sign in", you agree to our Terms.\n'
                  'Learn how we process your data in our Privacy\n'
                  'Policy and Cookies Policy.',
              textAlign: TextAlign.center,
              style: AppTheme.bodySmall12.copyWith(color: Colors.white70),
            ),

            const SizedBox(height: 30),

            // Nút đăng nhập bằng Google
            _buildSignInButton(
              icon: AppIcons.googleLogo(height: 24),
              label: 'Sign in with Google',
              onTap: () => context.go('/oops'),
            ),

            const SizedBox(height: 12),

            // Nút đăng nhập bằng Facebook
            _buildSignInButton(
              icon: AppIcons.facebookLogo(height: 24),
              label: 'Sign in with Facebook',
              onTap: () => context.go('/oops'),
            ),

            const SizedBox(height: 12),

            // Nút đăng nhập bằng số điện thoại
            _buildSignInButton(
              icon: const Icon(Icons.phone, size: 24, color: Colors.black),
              label: 'Sign in with phone number',
              onTap: () => context.go('/number'),
            ),

            const SizedBox(height: 20),

            // Nút trợ giúp
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
    );
  }
}
