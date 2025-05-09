import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/theme/app_decoration.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/token/border_radius_tokens.dart';
import 'package:app/core/token/padding_tokens.dart';
import 'package:flutter/material.dart';

 Widget buildSignInButton({
  required Widget icon,
  required String label,
  required VoidCallback onTap,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: AppPaddingTokens.paddingMd),
        decoration: AppDecoration.socialButton(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTheme.bodyMedium14.copyWith(color: AppColors.primaryBlack),
            ),
          ],
        ),
      ),
    ),
  );
}