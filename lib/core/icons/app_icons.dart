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

  static Image backgroundImageWidget({double? height, double? width}) =>
      Image.asset('$_basePath/backgroud.png', height: height, width: width);

  static Image Union({double? height, double? width}) =>
      Image.asset('$_basePath/Union.png', height: height, width: width);

  static Image Union_me({double? height, double? width}) =>
      Image.asset('$_basePath/Union_me.png', height: height, width: width);

  static Image Star({double? height, double? width}) =>
      Image.asset('$_basePath/Star.png', height: height, width: width);

  static Image Search({double? height, double? width}) =>
      Image.asset('$_basePath/Union.png', height: height, width: width);

  //truyen vao mot anh cho khong phair  Image widget,
  static AssetImage backgroundImageProvider() =>
      const AssetImage('assets/images/backgroud.png');
}