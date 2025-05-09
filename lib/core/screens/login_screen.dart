import 'package:app/apis/services/auth_service.dart';
import 'package:app/providers/user_provicer.dart';
import 'package:app/widgets/signin_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../token/padding_tokens.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final AuthService _authService = AuthService();

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
            buildSignInButton(
              icon: AppIcons.googleLogo(height: 24),
              label: 'Sign in with Google',
              onTap: () async {
                final GoogleSignIn _googleSignIn = GoogleSignIn();
                try {
                  final GoogleSignInAccount? account = await _googleSignIn.signIn();
                  if (account == null) {
                    return;
                  }
                  final GoogleSignInAuthentication auth = await account.authentication;
                  final idToken = auth.idToken;
                  final response = await _authService.loginGoogle(idToken!);
                  final userProvider = Provider.of<UserProvider>(context, listen: false);
                  await userProvider.loadUserData();
                  context.go('/tinderUser');
                } catch (e) {
                  print('Google Sign-In error: $e');
                }
              },
            ),
            const SizedBox(height: 12),
            buildSignInButton(
              icon: AppIcons.facebookLogo(height: 24),
              label: 'Sign in with Facebook',
              onTap: () => context.go('/oops'),
            ),
            const SizedBox(height: 12),
            buildSignInButton(
              icon: const Icon(Icons.phone, size: 24, color: AppColors.primaryBlack),
              label: 'Sign in with phone number',
              onTap: () => context.go('/user-profile'),
            ),
            const SizedBox(height: AppPaddingTokens.paddingMd),
            TextButton(
              onPressed: () { context.go('/RegisterScreen');},
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