import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OopsScreen extends StatelessWidget {
  const OopsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Nút "<" ở góc trên cùng bên trái
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
                  const SizedBox(height: 60), // Để lại khoảng trống cho nút "<"
                  // Logo Tinder (hình ngọn lửa)
                  const Icon(
                    Icons.local_fire_department,
                    size: 50,
                    color: Colors.pink,
                  ),
                  const SizedBox(height: 20),
                  // Tiêu đề "Oops!"
                  const Text(
                    'Oops!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Thông báo
                  const Text(
                    'We couldn\'t find a Tinder account\nconnected to that Facebook Account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Nút "CREATE NEW ACCOUNT" với gradient text
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF28C82),
                          Color(0xFFFFD54F)
                        ], // Gradient từ hồng cam sang vàng
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Thêm logic tạo tài khoản mới tại đây
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.transparent, // Loại bỏ màu nền mặc định
                        shadowColor: Colors.transparent, // Loại bỏ shadow
                        foregroundColor:
                        Colors.white, // Màu chữ mặc định (sẽ bị ghi đè bởi ShaderMask)
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFF28C82),
                            Color(0xFFFFD54F)
                          ], // Gradient cho chữ
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Text(
                          'CREATE NEW ACCOUNT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Màu base cho gradient
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