import 'package:flutter/material.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/widgets/custom_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0 Lượt Thích',
                    style: AppTheme.headLineMedium24.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutralGray800,
                    ),
                  ),
                  Text(
                    'Top Tuyển chọn',
                    style: AppTheme.bodyMedium16.copyWith(
                      color: AppColors.neutralGray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Text(
                'Nâng cấp lên Tinder Gold để xem ai đã tỏ ý thích bạn.',
                style: AppTheme.bodyMedium16.copyWith(
                  color: AppColors.neutralGray600,
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Icon(
                  Icons.favorite,
                  color: Colors.orange,
                  size: 60.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Xem những người tỏ ý thích bạn™',
                textAlign: TextAlign.center,
                style: AppTheme.bodyMedium16.copyWith(
                  color: AppColors.neutralGray600,
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Thêm logic để chuyển đến trang nâng cấp Tinder Gold (ví dụ: context.go('/upgrade'))
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tính năng nâng cấp chưa được triển khai')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  ),
                  child: Text(
                    'Xem Ai Thích Bạn',
                    style: AppTheme.bodyMedium16.copyWith(
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
    );
  }
}