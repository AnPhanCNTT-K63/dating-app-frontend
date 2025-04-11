import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';
import '../../token/padding_tokens.dart';
import '../../token/border_radius_tokens.dart';
import '../../theme/app_colors.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({Key? key}) : super(key: key);

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  String countryCode = '+82';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryWhite,
        padding: EdgeInsets.symmetric(horizontal: AppPaddingTokens.paddingLg),
        child: Stack(
          children: [
            Positioned(
              top: AppPaddingTokens.paddingXl,
              left: AppPaddingTokens.paddingLg,
              child: IconButton(
                icon: Text(
                  '<',
                  style: AppTheme.titleLarge20.copyWith(
                    color: AppColors.neutralGray600,
                  ),
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
                  const SizedBox(height: 60),
                  Text(
                    'My number is',
                    style: AppTheme.titleLarge20.copyWith(color: AppColors.primaryBlack),
                  ),
                  const SizedBox(height: AppPaddingTokens.paddingMd),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            countryCode = '+1';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neutral200,
                          foregroundColor: AppColors.primaryBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusSmall),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPaddingTokens.paddingMd,
                          ),
                        ),
                        child: Text(
                          countryCode,
                          style: AppTheme.bodyMedium14.copyWith(color: AppColors.primaryBlack),
                        ),
                      ),
                      const SizedBox(width: AppPaddingTokens.paddingSm),
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '00000000',
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(AppPaddingTokens.paddingSm),
                            prefix: Text(' $countryCode - '),
                          ),
                          style: AppTheme.bodyMedium14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppPaddingTokens.paddingMd),
                  Text(
                    'We will send a text with a verification code.\nMessage and data rates may apply. Learn what\nhappens when your number changes.',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodySmall12.copyWith(color: AppColors.neutralGray600),
                  ),
                  const SizedBox(height: AppPaddingTokens.paddingXl),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
                    child: InkWell(
                      onTap: () => context.push('/verification'),
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: AppDecoration.createAccountButton(),
                        alignment: Alignment.center,
                        child: Text(
                          'CONTINUE',
                          style: AppTheme.titleSmall16.copyWith(
                            color: AppColors.primaryWhite,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
