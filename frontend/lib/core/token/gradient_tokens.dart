import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

 // lưu trữ cấu hình garadient để tái sử dụng
class AppGradientTokens {
  const AppGradientTokens._();
// Trong AppGradientTokens
  static const LinearGradient pinkToOrangeGradient = LinearGradient(
    colors: [Color(0xFFD4145A), Color(0xFFFBB03B)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );


}