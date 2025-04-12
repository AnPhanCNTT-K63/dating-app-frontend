import 'package:flutter/material.dart';

import '../token/gradient_tokens.dart';
import '../token/border_radius_tokens.dart';
import '../theme/app_colors.dart';

// đây là nơi để chứa định dạng các deco
class AppDecoration {
  const AppDecoration._();

  // Basic container decorations
  static BoxDecoration get none => const BoxDecoration();

  static BoxDecoration roundedContainer({
    Color? color,
    double radius = 8.0,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: border,
      boxShadow: boxShadow,
      gradient: gradient,
    );
  }

  // Size-specific decorations
  static BoxDecoration small({
    Color? color,
    Gradient? gradient,
    BoxBorder? border,
  }) {
    return roundedContainer(
      color: color,
      radius: 8.0,
      border: border,
      gradient: gradient,
    );
  }

  static BoxDecoration medium({
    Color? color,
    Gradient? gradient,
    BoxBorder? border,
  }) {
    return roundedContainer(
      color: color,
      radius: 12.0,
      border: border,
      gradient: gradient,
    );
  }

  static BoxDecoration large({
    Color? color,
    Gradient? gradient,
    BoxBorder? border,
  }) {
    return roundedContainer(
      color: color,
      radius: 16.0,
      border: border,
      gradient: gradient,
    );
  }


  // Selected/active state decorations
  static ShapeDecoration selectedGradientBorder({
    required Gradient containerGradient,
    double width = 4.0,
    double radius = 16.0,
  }) {
    return ShapeDecoration(
      gradient: containerGradient,
      shape: GradientBorderWithClip(
        gradient: LinearGradient(
          colors: [Color(0xFF00EB85), Color(0xFFCDF503)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        width: width,
        radius: radius,
      ),
    );
  }


  //cái mình sài nè
  // deco button thứ đăng nhập
  static BoxDecoration createAccountButton() {
    return roundedContainer(
      radius: 30.0,
      gradient: AppGradientTokens.pinkToOrangeGradient,

      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
    );
  }
// deco màu buton màn hình ban đầu
  static BoxDecoration socialButton() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.black12),
    );
  }
  static BoxDecoration genderUnselected() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
      border: Border.all(color: AppColors.neutralGray600, width: 1),
      color: AppColors.primaryWhite,
    );
  }
  static BoxDecoration genderSelected() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
      color: AppColors.redRed400,
      border: Border.all(color: AppColors.redRed600, width: 2),
    );
  }
}

class GradientBorderWithClip extends ShapeBorder {
  final LinearGradient gradient;
  final double width;
  final double radius;

  const GradientBorderWithClip({
    required this.gradient,
    required this.width,
    required this.radius,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getRoundedRectPath(rect.deflate(width), radius - width);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getRoundedRectPath(rect, radius);
  }

  Path _getRoundedRectPath(Rect rect, double radius) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final innerRect = rect.deflate(width / 2);
    final paint = Paint()
      ..shader = gradient.createShader(innerRect)
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, Radius.circular(radius)),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}
