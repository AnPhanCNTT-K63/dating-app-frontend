import 'package:flutter/material.dart';


class UserProfileWidget extends StatelessWidget {
  final String name;
  final int age;
  final double profileCompletion;
  final String imageUrl;

  const UserProfileWidget({
    Key? key,
    required this.name,
    required this.age,
    required this.profileCompletion,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Picture and Progress
        Stack(
          alignment: Alignment.center,
          children: [
            // Circular progress
            SizedBox(
              width: 160,
              height: 160,
              child: CircularProgressIndicator(
                value: profileCompletion,
                strokeWidth: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>( Colors.pink.shade400),
              ),
            ),

            // Profile picture
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
            ),

            // Progress percentage
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade300, Colors.pink.shade400],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(profileCompletion * 100).toInt()}% COMPLETE',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Name and Age
        const SizedBox(height: 16),
        Text(
          '$name, $age',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}