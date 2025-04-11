import 'package:flutter/material.dart';
import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../token/padding_tokens.dart';
import '../../token/border_radius_tokens.dart';

Future<void> showPhotoPickerSheet(
    BuildContext context, {
      required VoidCallback onCameraTap,
      required VoidCallback onGalleryTap,
    }) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.primaryWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppBorderRadiusTokens.borderRadiusXLarge)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPaddingTokens.paddingLg,
          horizontal: AppPaddingTokens.paddingMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodySmall12.copyWith(
                  color: AppColors.redRed500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppPaddingTokens.paddingMd),
            const Divider(color: AppColors.neutralGray300),
            _PhotoPickerOption(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              onTap: onCameraTap,
            ),
            const Divider(color: AppColors.neutralGray300),
            _PhotoPickerOption(
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
              onTap: onGalleryTap,
            ),
            const Divider(color: AppColors.neutralGray300),
            const SizedBox(height: AppPaddingTokens.paddingSm),
          ],
        ),
      );
    },
  );
}

class _PhotoPickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PhotoPickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppPaddingTokens.paddingSm),
        child: Row(
          children: [
            Icon(icon, color: AppColors.neutralGray400),
            const SizedBox(width: AppPaddingTokens.paddingMd),
            Text(
              label,
              style: AppTheme.bodyMedium14.copyWith(color: AppColors.neutralGray900),
            ),
          ],
        ),
      ),
    );
  }
}