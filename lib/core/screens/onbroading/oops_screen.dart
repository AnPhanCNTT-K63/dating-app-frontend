import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../token/padding_tokens.dart';
import '../../token/border_radius_tokens.dart';

class OopsScreen extends StatelessWidget {
  const OopsScreen({Key? key}) : super(key: key);

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
              left: AppPaddingTokens.paddingXs,
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
                  const SizedBox(height: AppPaddingTokens.paddingXl),
                  const Icon(
                    Icons.local_fire_department,
                    size: 50,
                    color: AppColors.redRed400,
                  ),
                  const SizedBox(height: AppPaddingTokens.paddingMd),
                  Text(
                    'Oops!',
                    style: AppTheme.headLineLarge32.copyWith(color: AppColors.primaryBlack),
                  ),
                  const SizedBox(height: AppPaddingTokens.paddingMd),
                  Text(
                    'We couldn\'t find a Tinder account\nconnected to that Facebook Account.',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyLarge16.copyWith(color: AppColors.neutralGray600),
                  ),
                  const SizedBox(height: AppPaddingTokens.paddingXl),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
                    child: InkWell(
                      onTap: () {
                        // TODO: Thêm logic tạo tài khoản mới tại đây
                      },
                      child: Container(
                        width: 250,
                        height: 63,
                        decoration: AppDecoration.createAccountButton(),
                        alignment: Alignment.center,
                        child: Text(
                          'CREATE NEW ACCOUNT',
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
