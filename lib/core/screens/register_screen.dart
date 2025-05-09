import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../apis/services/auth_service.dart';
import '../../core/icons/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_decoration.dart';
import '../theme/app_theme.dart';
import '../token/padding_tokens.dart';
import '../token/border_radius_tokens.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final response = await _authService.register(_nameController.text,_emailController.text,_passwordController.text );
      context.go('/profile');
    }
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
        return false; // Chặn hành vi mặc định để điều khiển thủ công
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryWhite,
        appBar: AppBar(
          backgroundColor: AppColors.primaryWhite,
          title: const Text('TẠO TÀI KHOẢN'),
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
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: AppPaddingTokens.paddingMd),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
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
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (value) =>
                  value == null || value.length < 6 ? 'Minimum 6 characters' : null,
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
                        'ĐĂNG KÝ',
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
      ),
    );
  }
}