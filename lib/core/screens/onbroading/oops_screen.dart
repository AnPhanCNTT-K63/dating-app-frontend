import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';

class OopsScreen extends StatelessWidget {
  const OopsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: [
            // Nút back "<"
            Positioned(
              top: 15,
              left: 1,
              child: IconButton(
                icon: const Text(
                  '<',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  context.go('/'); // Quay lại LoginScreen
                },
              ),
            ),
            // Nội dung chính
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // 🔥 Logo Tinder
                  const Icon(
                    Icons.local_fire_department,
                    size: 50,
                    color: Colors.pink,
                  ),
                  const SizedBox(height: 20),

                  // Tiêu đề
                  Text(
                    'Oops!',
                    style: AppTheme.headLineLarge32.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  // Nội dung thông báo
                  Text(
                    'We couldn\'t find a Tinder account\nconnected to that Facebook Account.',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyLarge16.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // ✅ Nút "CREATE NEW ACCOUNT" dùng AppDecoration + AppTheme
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        // TODO: Thêm logic tạo tài khoản mới tại đây
                      },
                      child: Container(
                        width: 250,
                        height: 63,
                        decoration: AppDecoration.createAccountButton(),
                        alignment: Alignment.center,
                        child: Text(
                          'CREATE NEW ACCOUNT',
                          style: AppTheme.titleExtraSmall14.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
