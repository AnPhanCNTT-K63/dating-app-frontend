import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/app_icons.dart';
import '../theme/app_decoration.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../token/padding_tokens.dart';
import '../token/border_radius_tokens.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Widget _buildSignInButton({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.redRed900, AppColors.redRed400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: AppPaddingTokens.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.tinderLogo(height: 100),
            const SizedBox(height: AppPaddingTokens.paddingMd),
            Text(
              'It starts with\na Swipe™',
              textAlign: TextAlign.center,
              style: AppTheme.headLineLarge32.copyWith(color: AppColors.primaryWhite),
            ),
            const SizedBox(height: AppPaddingTokens.paddingXl),
            Text(
              'By tapping "Sign in", you agree to our Terms.\n'
                  'Learn how we process your data in our Privacy\n'
                  'Policy and Cookies Policy.',
              textAlign: TextAlign.center,
              style: AppTheme.bodySmall12.copyWith(color: AppColors.neutralGray600),
            ),
            const SizedBox(height: AppPaddingTokens.paddingLg),
            _buildSignInButton(
              icon: AppIcons.googleLogo(height: 24),
              label: 'Sign in with Google',
              onTap: () => context.go('/oops'),
            ),
            const SizedBox(height: 12),
            _buildSignInButton(
              icon: AppIcons.facebookLogo(height: 24),
              label: 'Sign in with Facebook',
              onTap: () => context.go('/oops'),
            ),
            const SizedBox(height: 12),
            _buildSignInButton(
              icon: const Icon(Icons.phone, size: 24, color: AppColors.primaryBlack),
              label: 'Sign in with phone number',
              onTap: () => context.go('/number'),
            ),
            const SizedBox(height: AppPaddingTokens.paddingMd),
            TextButton(
              onPressed: () {},
              child: Text(
                'Trouble signing in?',
                style: AppTheme.bodySmall12.copyWith(color: AppColors.primaryWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
