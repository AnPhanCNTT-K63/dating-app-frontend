import 'package:flutter/material.dart';

class AppIcons {
  AppIcons._(); // Prevent instantiation

  static const String _basePath = 'assets/images';

  static Image tinderLogo({double? height, double? width}) =>
      Image.asset('$_basePath/tinder_logo.png', height: height, width: width);

  static Image googleLogo({double? height, double? width}) =>
      Image.asset('$_basePath/google_logo.png', height: height, width: width);

  static Image facebookLogo({double? height, double? width}) =>
      Image.asset('$_basePath/facebook_logo.png', height: height, width: width);
}