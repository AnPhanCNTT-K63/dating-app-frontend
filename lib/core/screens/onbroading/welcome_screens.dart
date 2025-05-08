import 'package:app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../token/padding_tokens.dart';
import '../../token/border_radius_tokens.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryWhite,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: AppPaddingTokens.paddingLg),
        child: Stack(
          children: [
            Positioned(
              top: AppPaddingTokens.paddingLg,
              left: AppPaddingTokens.paddingXXs,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.neutralGray600,
                  size: 20,
                ),
                onPressed: () {
                  context.go('/');
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    size: 50,
                    color: AppColors.redRed400,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome to Tinder.',
                    style: appTextTheme.headlineSmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Please follow these House Rules.',
                    textAlign: TextAlign.center,
                    style: appTextTheme.labelSmall,
                  ),
                  const SizedBox(height: 30),
                  const RuleItem(
                    title: "Be yourself.",
                    description: "Make sure your photos, age, and bio are true to who you are.",
                  ),
                  const RuleItem(
                    title: "Stay safe.",
                    description: "Don't be too quick to give out personal information. ",
                    linkText: "Date Safely",
                  ),
                  const RuleItem(
                    title: "Play it cool.",
                    description: "Respect others and treat them as you would like to be treated.",
                  ),
                  const RuleItem(
                    title: "Be proactive.",
                    description: "Always report bad behavior.",
                  ),
                  const SizedBox(height: 100),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
                    child: InkWell(
                      onTap: () {
                        // TODO: Thêm logic tạo tài khoản mới tại đây
                      },
                      child: Container(
                        width: 300  ,
                        height: 63,
                        decoration: AppDecoration.createAccountButton(),
                        alignment: Alignment.center,
                        child: Text(
                          'I AGREE',
                          style: AppTheme.titleExtraSmall14.copyWith(
                            color: AppColors.primaryWhite,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppPaddingTokens.paddingLg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RuleItem extends StatelessWidget {
  final String title;
  final String description;
  final String? linkText;

  const RuleItem({Key? key, required this.title, required this.description, this.linkText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "/ ",
            style: AppTheme.bodyMedium14.copyWith(color: AppColors.redRed600),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTextTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: description,
                    style: appTextTheme.bodyMedium!.copyWith(color: Colors.black),
                    children: linkText != null
                        ? [
                      TextSpan(
                        text: linkText,
                        style: appTextTheme.bodyMedium!.copyWith(color: Colors.black,decoration: TextDecoration.underline),
                      )
                    ]
                        : [],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
