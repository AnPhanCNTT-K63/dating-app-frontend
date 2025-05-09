import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/widgets/custom_bottom_nav_bar.dart';

class SearchingLoadingWidget extends StatefulWidget {
  const SearchingLoadingWidget({super.key});

  @override
  State<SearchingLoadingWidget> createState() => _SearchingLoadingWidgetState();
}

class _SearchingLoadingWidgetState extends State<SearchingLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRadarCircle(double baseSize, double opacity) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final animatedSize = baseSize + _controller.value * 30;
        return Container(
          width: animatedSize,
          height: animatedSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.redRed400.withOpacity(opacity * (1 - _controller.value)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _buildRadarCircle(220, 0.15),
                _buildRadarCircle(160, 0.2),
                _buildRadarCircle(100, 0.3),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryWhite,
                      width: 3,
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/Union.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Đang tìm kiếm những người ở gần bạn...",
              style: TextStyle(
                color: AppColors.neutralGray600,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 0),
    );
  }
}
