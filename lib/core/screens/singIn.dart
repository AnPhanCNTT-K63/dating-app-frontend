import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../apis/services/auth_service.dart';
import '../../core/icons/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_decoration.dart';
import '../theme/app_theme.dart';
import '../token/padding_tokens.dart';
import '../token/border_radius_tokens.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService(); //

  bool _obscurePassword = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.register(
          'username_placeholder', // bạn nên thêm trường username
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (response['success'] == true) {
          context.go('/tinderUser');
        } else {
          _showError(response['message'] ?? 'Registration failed');
        }
      } catch (e) {
        _showError('Something went wrong. Please try again.');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryBlack),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusMedium),
        ),
        filled: true,
        fillColor: AppColors.primaryWhite,
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        title: const Text('SIGN UP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPaddingTokens.paddingLg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppIcons.tinderLogo(height: 80),
              const SizedBox(height: AppPaddingTokens.paddingMd),

              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppPaddingTokens.paddingMd),

              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Minimum 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppPaddingTokens.paddingXxxxxxl),

              ClipRRect(
                borderRadius: BorderRadius.circular(AppBorderRadiusTokens.borderRadiusLarge),
                child: InkWell(
                  onTap: _submit,
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: AppDecoration.createAccountButton(),
                    alignment: Alignment.center,
                    child: Text(
                      'SIGN UP',
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
      ),
    );
  }
}
