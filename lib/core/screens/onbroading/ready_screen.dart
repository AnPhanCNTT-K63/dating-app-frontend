import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_decoration.dart';
import '../../token/border_radius_tokens.dart';
import 'package:app/widgets/custom_bottom_nav_bar.dart';

// Import nav bar vừa tách

class GetReadyScreen extends StatelessWidget {
  const GetReadyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/your_background.jpg'), // TODO: chỉnh đường dẫn ảnh
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.4), // Overlay đen nhẹ
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '👋',
                      style: TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Let's get you ready!",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Here's everything you need to know",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
                      child: InkWell(
                        onTap: () {
                          // TODO: Navigate đến Tutorial
                        },
                        child: Container(
                          width: 250,
                          height: 50,
                          decoration: AppDecoration.createAccountButton(), // Gradient đỏ-cam
                          alignment: Alignment.center,
                          child: const Text(
                            'START TUTORIAL',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // TODO: Skip tutorial
                      },
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CustomBottomNavBar(
              selectedIndex: 0, // tab đầu tiên đang được chọn (Fire icon)
              onItemTapped: (index) {
                // TODO: Xử lý chuyển trang khi tap vào tab khác
              },
            ),
          ),
        ],
      ),
    );
  }
}
