import 'package:app/core/theme/app_colors.dart';
import 'package:app/widgets/profile_widget.dart';
import 'package:app/widgets/profilefooter_widget.dart';
import 'package:app/widgets/userInfo_widget.dart';
import 'package:flutter/material.dart';


class TinderProfilePage extends StatelessWidget {
  const TinderProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Tinder Logo
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.redRed600,
                    size: 32,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'tinder',
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              // Widget 1: User Profile (Avatar and Name)
              const UserProfileWidget(
                name: 'Rachel',
                age: 33,
                profileCompletion: 0.28,
                imageUrl: 'https://placeholder.pics/svg/140/DEDEDE/555555/profile',
              ),

              const SizedBox(height: 30),
              // Widget 2: Action Buttons
              const ActionsWidget(),

              const SizedBox(height: 50),
              // Widget 3: Platinum Section
              const PlatinumWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget 1: User profile with avatar and name


// Widget 2: Action buttons

// Widget 3: Platinum section
