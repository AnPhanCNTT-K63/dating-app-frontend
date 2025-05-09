import 'package:flutter/material.dart';
import 'package:app/core/token/border_radius_tokens.dart';

class ProfileCardContent extends StatelessWidget {
  final double width;
  final double height;
  final String name;
  final int age;
  final String location;
  final String distance;
  final String photoUrl;
  final bool showLikeOverlay;
  final bool showDislikeOverlay;

  const ProfileCardContent({
    Key? key,
    required this.width,
    required this.height,
    required this.name,
    required this.age,
    required this.location,
    required this.distance,
    required this.photoUrl,
    required this.showLikeOverlay,
    required this.showDislikeOverlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Profile Image
          Positioned.fill(
            child: Image.asset(photoUrl, fit: BoxFit.cover),
          ),

          // Gradient overlay for better text visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color.fromRGBO(0, 0, 0, 0.8),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),

          // Like overlay
          if (showLikeOverlay)
            _buildOverlayLabel("LIKE", Colors.green, isLeft: false),

          // Dislike overlay
          if (showDislikeOverlay)
            _buildOverlayLabel("NOPE", Colors.red, isLeft: true),

          // Profile Info at bottom of card
          _buildProfileInfo(),
        ],
      ),
    );
  }

  Widget _buildOverlayLabel(String text, Color color, {required bool isLeft}) {
    return Positioned(
      top: 20,
      left: isLeft ? 20 : null,
      right: isLeft ? null : 20,
      child: Transform.rotate(
        angle: isLeft ? 0.2 : -0.2,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name, age and info button
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "$age",
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              // Info button
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Center(
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Location info
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Distance info
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                color: Colors.white,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}