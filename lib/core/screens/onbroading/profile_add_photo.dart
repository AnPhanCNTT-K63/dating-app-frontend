import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../token/padding_tokens.dart';
import '../../token/border_radius_tokens.dart';

/// Hiển thị bottom sheet cho phép chọn ảnh từ camera hoặc gallery
/// [onImagePicked] là hàm callback trả về ảnh khi người dùng chọn thành công
Future<void> showPhotoPickerSheet(
    BuildContext context, {
      required Function(XFile file) onImagePicked,
    }) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.primaryWhite, // Nền trắng
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppBorderRadiusTokens.borderRadiusXLarge), // Bo góc trên
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPaddingTokens.paddingLg,
          horizontal: AppPaddingTokens.paddingMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Không chiếm toàn bộ chiều cao
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút Cancel
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

            // Tuỳ chọn Camera
            _PhotoPickerOption(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              onTap: () => _handleCameraPick(context, onImagePicked),
            ),

            const Divider(color: AppColors.neutralGray300),

            // Tuỳ chọn Gallery
            _PhotoPickerOption(
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
              onTap: () => _handleGalleryPick(context, onImagePicked),
            ),

            const Divider(color: AppColors.neutralGray300),
            const SizedBox(height: AppPaddingTokens.paddingSm),
          ],
        ),
      );
    },
  );
}

/// Hàm xử lý chọn ảnh bằng camera
Future<void> _handleCameraPick(BuildContext context, Function(XFile file) onImagePicked) async {
  final status = await Permission.camera.request(); // Yêu cầu quyền camera

  if (status.isGranted) {
    // Nếu được cấp quyền thì mở camera
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      onImagePicked(image); // Trả về ảnh nếu chụp thành công
    }
  } else if (status.isDenied) {
    // Nếu từ chối quyền thì hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permission denied to access camera')),
    );
  } else if (status.isPermanentlyDenied) {
    // Nếu từ chối vĩnh viễn thì mở phần cài đặt để người dùng tự cấp quyền
    openAppSettings();
  }
}

/// Hàm xử lý chọn ảnh từ thư viện
Future<void> _handleGalleryPick(BuildContext context, Function(XFile file) onImagePicked) async {
  // Android 13+ cần dùng Permission.photos, còn các bản trước cần storage
  final storageStatus = await Permission.storage.request();
  final photosStatus = await Permission.photos.request();

  if (storageStatus.isGranted || photosStatus.isGranted) {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      onImagePicked(image); // Trả về ảnh nếu chọn thành công
    }
  } else if (storageStatus.isDenied || photosStatus.isDenied) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Permission denied to access gallery')),
    );
  } else if (storageStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
    openAppSettings();
  }
}

/// Widget hiển thị một tuỳ chọn trong bottom sheet (Camera/Gallery)
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
        Navigator.of(context).pop(); // Đóng bottom sheet
        onTap(); // Gọi hàm xử lý tương ứng
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppPaddingTokens.paddingSm),
        child: Row(
          children: [
            Icon(icon, color: AppColors.neutralGray400), // Icon trái
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
