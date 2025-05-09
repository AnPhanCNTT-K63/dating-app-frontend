import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/icons/app_icons.dart';
import 'package:app/widgets/signin_widget.dart';

import 'package:go_router/go_router.dart';
import 'package:app/widgets/custom_bottom_nav_bar.dart';

import 'package:app/core/theme/app_decoration.dart';
import 'package:app/core/token/border_radius_tokens.dart';
import 'package:app/core/token/padding_tokens.dart';



class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({Key? key}) : super(key: key);

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
              'Chào mừng đến với thế Khám phá',
              textAlign: TextAlign.center,
              style: AppTheme.headLineLarge32.copyWith(color: AppColors.primaryWhite),
            ),
            const SizedBox(height: AppPaddingTokens.paddingXl),
            Text(
              'Hẹn hò nghiêm túc',
              textAlign: TextAlign.center,
              style: AppTheme.headLineLarge32.copyWith(
                color: AppColors.primaryWhite,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: AppPaddingTokens.paddingSm),
            Text(
              'Tìm kiếm những người có chung mục đích hẹn hò',
              textAlign: TextAlign.center,
              style: AppTheme.bodySmall12.copyWith(color: AppColors.neutralGray600),
            ),
            const SizedBox(height: AppPaddingTokens.paddingLg),
            buildSignInButton(
              icon: const Icon(
                Icons.nightlight_round,
                size: 24,
                color: AppColors.primaryWhite,
              ),
              label: 'Rảnh tối nay',
              onTap: () => context.go('/free-tonight'),
            ),
            const SizedBox(height: 12),
            buildSignInButton(
              icon: const Icon(
                Icons.verified_user,
                size: 24,
                color: AppColors.primaryWhite,
              ),
              label: 'Hãy Xác Minh Anh',
              onTap: () => context.go('/verify'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 1),
    );
  }
}