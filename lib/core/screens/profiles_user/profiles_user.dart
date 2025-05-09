import 'package:app/widgets/profile_card_stack_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/widgets/custom_bottom_nav_bar.dart';

class TinderHomeScreen extends StatefulWidget {
  const TinderHomeScreen({Key? key}) : super(key: key);

  @override
  _TinderHomeScreenState createState() => _TinderHomeScreenState();
}

class _TinderHomeScreenState extends State<TinderHomeScreen> {
  int _selectedNavIndex = 0; // Track selected navigation item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      // Main layout with card stack and bottom navigation
      body: Column(
        children: [
          // Card stack takes most of the screen space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: ProfileCardStack(),
            ),
          ),
          // Custom bottom navigation bar
          CustomBottomNavBar(
            selectedIndex: _selectedNavIndex,
            onItemTapped: (index) => setState(() => _selectedNavIndex = index),
          ),
        ],
      ),
    );
  }
}