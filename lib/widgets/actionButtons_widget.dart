import 'package:flutter/material.dart';

Widget buildActionButton(
    Color color,
    IconData icon, {
      required VoidCallback onPressed,
      Color? borderColor,
      double size = 50,
    }) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.5,
      ),
    ),
  );
}

Widget buildActionButtons(
    Color dislikeButtonColor,
    Color likeButtonColor,
    bool showDislikeOverlay,
    bool showLikeOverlay,
    VoidCallback handleDislikeButtonPressed,
    VoidCallback handleLikeButtonPressed,
    VoidCallback? onChat,
    ) {
  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Rewind button (yellow)
        buildActionButton(
          Colors.amber,
          Icons.replay,
          onPressed: () {}, // Rewind functionality
          size: 48,
        ),
        // Dislike button (red)
        buildActionButton(
          dislikeButtonColor,
          Icons.close,
          onPressed: handleDislikeButtonPressed,
          size: 56,
          borderColor: showDislikeOverlay ? Colors.red : null,
        ),
        // Super like button (blue)
        buildActionButton(
          Colors.blue,
          Icons.star,
          onPressed: () {}, // Super like functionality
          size: 48,
        ),
        // Like button (green)
        buildActionButton(
          likeButtonColor,
          Icons.favorite,
          onPressed: handleLikeButtonPressed,
          size: 56,
          borderColor: showLikeOverlay ? Colors.green : null,
        ),
        // Chat button (purple)
        buildActionButton(
          Colors.purple,
          Icons.message,
          onPressed: onChat ?? () {}, // Use onChat if provided, otherwise empty function
          size: 48,
        ),
      ],
    ),
  );
}