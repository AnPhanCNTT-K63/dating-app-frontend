import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'package:app/core/icons/app_icons.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    this.onItemTapped,
  }) : super(key: key);

  Widget _buildColoredIcon(Image icon, bool isSelected) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.redRed400 : Colors.grey,
        BlendMode.srcIn,
      ),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.primaryWhite,
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.redRed400,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        // Điều hướng trang khi ấn vào các item trong BottomNavigationBar
        switch (index) {
          case 0:
            context.go('/home'); // Chuyển tới trang Home
            break;
          case 1:
            context.go('/search'); // Chuyển tới trang Search
            break;
          case 2:
            context.go('/profile'); // Chuyển tới trang Profile
            break;
          case 3:
            context.go('/settings'); // Chuyển tới trang Settings
            break;
          case 4:
            context.go('/user-profile'); // Chuyển tới trang Notifications
            break;
        }
        onItemTapped?.call(index); // Nếu có callback từ bên ngoài, gọi lại
      },

      items: [
        BottomNavigationBarItem(
          icon: _buildColoredIcon(AppIcons.tinderLogo(width: 50, height: 50), selectedIndex == 0),
          label: '',

        ),
        BottomNavigationBarItem(
          icon: _buildColoredIcon(AppIcons.Union(width: 24, height: 24), selectedIndex == 1),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildColoredIcon(AppIcons.Star(width: 24, height: 24), selectedIndex == 2),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildColoredIcon(AppIcons.Search(width: 24, height: 24), selectedIndex == 3),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildColoredIcon(AppIcons.Union_me(width: 24, height: 24), selectedIndex == 4),
          label: '',
        ),
      ],
    );
  }
}
