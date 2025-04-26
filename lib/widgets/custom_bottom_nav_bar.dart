import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart'; // Import file màu của bạn (chỉnh nếu cần)

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    this.onItemTapped,
  }) : super(key: key);

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
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '',
        ),
      ],
    );
  }
}
